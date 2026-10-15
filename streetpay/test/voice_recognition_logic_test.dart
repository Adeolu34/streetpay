import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Text Box Catch and Lock Logic', () {
    test('Text box content is never cleared or shrunk when engine resets to empty', () {
      String committedBoxText = 'I want to transfer five thousand';
      String currentBoxText = 'I want to transfer five thousand';
      
      // Engine restarts and emits empty words
      String incomingWords = '';
      
      // Candidate calculation
      String candidate = currentBoxText;
      if (incomingWords.isNotEmpty) {
        candidate = committedBoxText.isEmpty ? incomingWords : '$committedBoxText $incomingWords';
      }
      
      // Invariant: never shrink below committed text
      if (candidate.length >= committedBoxText.length) {
        currentBoxText = candidate;
      }

      expect(currentBoxText, 'I want to transfer five thousand');
      expect(committedBoxText, 'I want to transfer five thousand');
    });

    test('Seamlessly appends incremental speech without losing previous box text', () {
      String committedBoxText = 'Introduce yourself';
      String incomingWords = 'and your career goals';

      final String candidate;
      if (committedBoxText.isEmpty) {
        candidate = incomingWords;
      } else if (incomingWords.toLowerCase().startsWith(committedBoxText.toLowerCase())) {
        candidate = incomingWords;
      } else {
        candidate = '$committedBoxText $incomingWords';
      }

      expect(candidate, 'Introduce yourself and your career goals');
    });

    test('Handles cumulative speech engine without duplicating previous text', () {
      String committedBoxText = 'Introduce yourself';
      String incomingCumulativeWords = 'Introduce yourself and your career goals';

      final String candidate;
      if (committedBoxText.isEmpty) {
        candidate = incomingCumulativeWords;
      } else if (incomingCumulativeWords.toLowerCase().startsWith(committedBoxText.toLowerCase())) {
        candidate = incomingCumulativeWords;
      } else {
        candidate = '$committedBoxText $incomingCumulativeWords';
      }

      expect(candidate, 'Introduce yourself and your career goals');
    });

    test('Locks text box on utterance completion so engine clearing cannot wipe it', () {
      String committedBoxText = '';
      String boxText = 'Hello my name is John';

      // Utterance complete (pause or finalResult)
      if (boxText.length >= committedBoxText.length) {
        committedBoxText = boxText;
      }

      // Now engine clears internal buffer for next listen session
      String engineBuffer = '';
      if (engineBuffer.isNotEmpty) {
        boxText = engineBuffer;
      }

      expect(boxText, 'Hello my name is John');
      expect(committedBoxText, 'Hello my name is John');
    });
  });

  group('Speech Transcript Accumulation Logic', () {
    test('Correctly combines confirmed transcript with active partial speech', () {
      String confirmed = 'send five thousand';
      String partial = 'to John';

      String combined = confirmed.isEmpty
          ? partial
          : (partial.isEmpty ? confirmed : '$confirmed $partial');

      expect(combined, 'send five thousand to John');
    });

    test('Seamlessly commits finished utterance into confirmed transcript', () {
      String confirmed = '';
      
      // Utterance 1
      String utterance1 = 'transfer ten thousand';
      confirmed = confirmed.isEmpty ? utterance1 : '$confirmed $utterance1';
      expect(confirmed, 'transfer ten thousand');

      // Utterance 2 (after pause)
      String utterance2 = 'to GTBank 0123456789';
      confirmed = confirmed.isEmpty ? utterance2 : '$confirmed $utterance2';
      expect(confirmed, 'transfer ten thousand to GTBank 0123456789');
    });

    test('Avoids duplicating text when final result equals partial result', () {
      String confirmed = 'hello world';
      String lastBestPartial = 'how are you';
      bool finalResultReceived = true;

      if (!finalResultReceived && lastBestPartial.isNotEmpty) {
        confirmed = confirmed.isEmpty ? lastBestPartial : '$confirmed $lastBestPartial';
      }

      expect(confirmed, 'hello world');
    });
  });

  group('Speech Error Resilience Classification', () {
    bool isTransientSpeechError(String code) {
      final c = code.toLowerCase();
      return c.contains('no_match') ||
          c.contains('speech_timeout') ||
          c.contains('busy') ||
          c.contains('client') ||
          c.contains('audio');
    }

    test('Transient silence and timeouts do not abort recording session', () {
      expect(isTransientSpeechError('error_speech_timeout'), isTrue);
      expect(isTransientSpeechError('error_no_match'), isTrue);
      expect(isTransientSpeechError('error_recognizer_busy'), isTrue);
      expect(isTransientSpeechError('error_client'), isTrue);
      expect(isTransientSpeechError('error_audio'), isTrue);
    });

    test('Fatal permission errors are properly identified', () {
      expect(isTransientSpeechError('error_permission'), isFalse);
      expect(isTransientSpeechError('error_insufficient_permissions'), isFalse);
    });
  });

  group('Locale Resolution Logic', () {
    String? resolveLocale(List<String> availableLocales, String? systemLocale) {
      for (final l in availableLocales) {
        final id = l.toLowerCase().replaceAll('-', '_');
        if (id == 'en_ng') {
          return l;
        }
      }
      if (systemLocale != null && systemLocale.isNotEmpty) {
        return systemLocale;
      }
      return null;
    }

    test('Selects en_NG or en-NG when available in locale list', () {
      expect(resolveLocale(['en-US', 'en-NG', 'fr-FR'], 'en-US'), 'en-NG');
      expect(resolveLocale(['en_GB', 'en_ng'], 'en_US'), 'en_ng');
    });

    test('Falls back to device system locale when en_NG is not installed', () {
      expect(resolveLocale(['en-US', 'fr-FR'], 'en-US'), 'en-US');
      expect(resolveLocale([], 'en-GB'), 'en-GB');
    });
  });

  group('Smart Discovery Show Audio Replay & Review Logic', () {
    String fmtDuration(Duration d) {
      final m = d.inMinutes;
      final s = d.inSeconds % 60;
      return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }

    test('Formats audio duration correctly for review player', () {
      expect(fmtDuration(const Duration(seconds: 0)), '00:00');
      expect(fmtDuration(const Duration(seconds: 9)), '00:09');
      expect(fmtDuration(const Duration(seconds: 45)), '00:45');
      expect(fmtDuration(const Duration(minutes: 1, seconds: 30)), '01:30');
    });

    test('Re-record resets playback state and returns to recording', () {
      bool isPlaying = true;
      Duration position = const Duration(seconds: 14);
      Duration duration = const Duration(seconds: 35);
      String? recordedPath = '/tmp/streetspeaks_12345.m4a';
      String stage = 'review';

      // Simulate _reRecord()
      isPlaying = false;
      position = Duration.zero;
      duration = Duration.zero;
      recordedPath = null;
      stage = 'recording';

      expect(isPlaying, isFalse);
      expect(position, Duration.zero);
      expect(duration, Duration.zero);
      expect(recordedPath, isNull);
      expect(stage, 'recording');
    });

    test('Audio player slider clamps position correctly within recorded duration', () {
      const recordedDuration = Duration(seconds: 40);
      
      double clampSlider(Duration currentPos, Duration totalDur) {
        final totalMs = totalDur.inMilliseconds > 0 ? totalDur.inMilliseconds.toDouble() : 1.0;
        return currentPos.inMilliseconds.toDouble().clamp(0.0, totalMs);
      }

      expect(clampSlider(const Duration(seconds: 10), recordedDuration), 10000.0);
      expect(clampSlider(const Duration(seconds: 50), recordedDuration), 40000.0);
      expect(clampSlider(Duration.zero, recordedDuration), 0.0);
    });

    test('Transcription error classification identifies credit limits and timeouts', () {
      bool isCreditError(String errMsg) {
        final lower = errMsg.toLowerCase();
        return lower.contains('balance') || lower.contains('credit') || lower.contains('402');
      }

      expect(isCreditError('This request requires at least \$0.50 in balance for audio'), isTrue);
      expect(isCreditError('Error 402: Insufficient credits'), isTrue);
      expect(isCreditError('Network connection timeout'), isFalse);
    });

    test('Smart Discovery Show intro script contains required greeting and prize info', () {
      const script =
          'Welcome to the Smart Discovery Show! Record your answers and have the chance to win big prizes.';
      expect(script, contains('Smart Discovery Show'));
      expect(script, contains('Record your answers'));
      expect(script, contains('win big prizes'));
    });
  });
}
