import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

import '/app_state.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_model.dart';
import '/services/tts_service.dart';
import '/config/secrets.dart';
import 'speaking_game_model.dart';
export 'speaking_game_model.dart';

class SpeakingGameWidget extends StatefulWidget {
  static const routeName = 'streetspeaks';
  static const routePath = '/streetspeaks';

  const SpeakingGameWidget({super.key});

  @override
  State<SpeakingGameWidget> createState() => _SpeakingGameWidgetState();
}

enum _Stage { loading, home, recording, review, transcribing, scoring, result }

class _SpeakingGameWidgetState extends State<SpeakingGameWidget>
    with TickerProviderStateMixin {

  static const _openRouterKey = AppSecrets.openRouterApiKey;
  static const _openAiKey = AppSecrets.openAiApiKey;
  static const _geminiApiKey = AppSecrets.geminiApiKey;
  static const _apiUrl = 'https://api.mypingapi.com/sp/myhandler';
  static const _whatsappPhone = '2349024706049';
  static const _maxPlaysPerDay = 2;
  static const _maxRecordSecs = 60;

  // Fallback questions if key 229 is unreachable
  static const _fallbackQuestions = [
    'Introduce yourself and describe your career goals for the next five years.',
    'Explain the importance of saving money and describe how you personally save.',
    'Describe a challenge you have faced in life and explain how you overcame it.',
    'What do you think is the biggest opportunity in Nigeria\'s economy right now?',
    'Explain what digital payments mean for small businesses in Nigeria.',
    'Describe a time you had to make an important financial decision.',
    'How would you convince a friend or family member to start using mobile banking?',
    'What is your understanding of financial inclusion and why does it matter?',
    'Describe the role of technology in improving everyday life in Africa.',
    'Explain how you would manage a monthly budget of ₦50,000 effectively.',
  ];

  late SpeakingGameModel _model;
  _Stage _stage = _Stage.loading;

  int _playsToday = 0;

  String _currentQuestion = '';

  // Audio recording & playback
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _recordedAudioPath;
  bool _isRecording = false;
  int _recordSecs = 0;
  Timer? _recordTimer;

  // Playback state
  bool _isPlaying = false;
  Duration _playbackPosition = Duration.zero;
  Duration _playbackDuration = Duration.zero;
  StreamSubscription? _playerStateSub;
  StreamSubscription? _playerDurationSub;
  StreamSubscription? _playerPositionSub;
  StreamSubscription? _playerCompleteSub;

  // Whisper transcribed text
  String _transcribedText = '';

  Map<String, dynamic> _scores = {};
  String _feedback = '';
  int _overallScore = 0;

  final _scoreKey = GlobalKey();

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SpeakingGameModel());
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.20).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Audio player event listeners
    _playerStateSub = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
    _playerDurationSub = _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _playbackDuration = dur);
    });
    _playerPositionSub = _audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) setState(() => _playbackPosition = pos);
    });
    _playerCompleteSub = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _playbackPosition = Duration.zero;
        });
      }
    });

    _loadEligibility();
    TtsService.instance.introSmartDiscoveryShow();
  }

  @override
  void dispose() {
    TtsService.instance.stop();
    _model.maybeDispose();
    _pulseCtrl.dispose();
    _recordTimer?.cancel();
    _playerStateSub?.cancel();
    _playerDurationSub?.cancel();
    _playerPositionSub?.cancel();
    _playerCompleteSub?.cancel();
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  // ── Eligibility ─────────────────────────────────────────────────────────────
  Future<void> _loadEligibility() async {
    setState(() => _stage = _Stage.loading);

    try {
      final msgResp = await GetmessageCall.call(
        accessToken: FFAppState().streetauth,
        tempid: 'SPKGAME_${FFAppState().phonenumber}',
      );
      final msgs = GetmessageCall.messages(msgResp.jsonBody) ?? [];
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _playsToday = msgs.where((m) {
        try {
          final raw = m is Map
              ? (m['MessageText'] ?? m['message_text'] ?? m['messagetext'] ?? '')
                  .toString()
              : m.toString();
          final data = jsonDecode(raw) as Map<String, dynamic>;
          return data['date'] == today;
        } catch (_) {
          return false;
        }
      }).length;
    } catch (_) {
      _playsToday = 0;
    }

    if (mounted) setState(() => _stage = _Stage.home);
  }

  // ── Game flow ───────────────────────────────────────────────────────────────
  Future<void> _startGame() async {
    TtsService.instance.stop();
    HapticFeedback.lightImpact();
    setState(() {
      _stage = _Stage.loading;
      _isRecording = false;
      _recordSecs = 0;
      _recordedAudioPath = null;
      _playbackPosition = Duration.zero;
      _playbackDuration = Duration.zero;
      _isPlaying = false;
      _transcribedText = '';
    });

    // Fetch question from key 229
    String question = '';
    try {
      final authResp = await StreetauthCall.call();
      final freshToken = StreetauthCall.streettoken(authResp.jsonBody) ?? FFAppState().streetauth;

      final resp = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {
              'Authorization': 'Bearer $freshToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'theKey': '229',
              'UserPhone': FFAppState().phonenumber,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        if (body['success'] == true) {
          final q = body['question'];
          if (q is Map<String, dynamic>) {
            question = ((q['QText'] ?? q['qtext'] ?? '') as String).trim();
            // Strip leading "Discuss " instruction prefix if present
            if (question.toLowerCase().startsWith('discuss ')) {
              question = question.substring('discuss '.length).trim();
            }
          }
        }
        // Fallback to top-level string fields for older API formats
        if (question.isEmpty) {
          question = (body['Question'] ??
                  body['data'] ??
                  body['Text'] ??
                  body['text'] ??
                  '')
              .toString()
              .trim();
        }
      }
    } catch (_) {}

    // Fallback to local bank if API fails or returns empty
    if (question.isEmpty) {
      final idx = DateTime.now().millisecondsSinceEpoch % _fallbackQuestions.length;
      question = _fallbackQuestions[idx];
    }

    if (mounted) {
      setState(() {
        _currentQuestion = question;
        _stage = _Stage.recording;
      });
    }
  }

  Future<void> _startRecording() async {
    try {
      TtsService.instance.stop();
      await _audioPlayer.stop();
      if (await _audioRecorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path =
            '${dir.path}/smart_discovery_show_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: path,
        );

        setState(() {
          _isRecording = true;
          _recordSecs = 0;
          _recordedAudioPath = null;
          _playbackPosition = Duration.zero;
          _playbackDuration = Duration.zero;
          _isPlaying = false;
        });

        if (!_pulseCtrl.isAnimating) _pulseCtrl.repeat(reverse: true);

        _recordTimer?.cancel();
        _recordTimer = Timer.periodic(const Duration(seconds: 1), (t) {
          if (!mounted) {
            t.cancel();
            return;
          }
          setState(() => _recordSecs++);
          if (_recordSecs >= _maxRecordSecs) _stopRecording();
        });
      } else {
        _showSnack('Microphone permission is required to record your response.',
            isError: true);
      }
    } catch (e) {
      _showSnack('Could not start recording: $e', isError: true);
    }
  }

  Future<void> _stopRecording() async {
    _recordTimer?.cancel();
    _pulseCtrl.stop();
    if (!_isRecording) return;

    try {
      final path = await _audioRecorder.stop();
      if (!mounted) return;

      if (path == null || !File(path).existsSync()) {
        _showSnack('Recording failed. Please try again.', isError: true);
        setState(() {
          _isRecording = false;
          _stage = _Stage.recording;
        });
        return;
      }

      if (_recordSecs < 2) {
        _showSnack('Recording was too short. Speak for at least 3 seconds.',
            isError: true);
        setState(() {
          _isRecording = false;
          _stage = _Stage.recording;
        });
        return;
      }

      setState(() {
        _isRecording = false;
        _recordedAudioPath = path;
        _playbackPosition = Duration.zero;
        _playbackDuration = Duration(seconds: _recordSecs);
        _stage = _Stage.review;
      });
    } catch (e) {
      _showSnack('Error saving recording: $e', isError: true);
      setState(() {
        _isRecording = false;
        _stage = _Stage.recording;
      });
    }
  }

  Future<void> _playPauseAudio() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else if (_recordedAudioPath != null) {
        if (_playbackPosition >= _playbackDuration &&
            _playbackDuration > Duration.zero) {
          await _audioPlayer.seek(Duration.zero);
        }
        await _audioPlayer.play(DeviceFileSource(_recordedAudioPath!));
      }
    } catch (e) {
      _showSnack('Audio playback error: $e', isError: true);
    }
  }

  Future<void> _seekAudio(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (_) {}
  }

  Future<void> _reRecord() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _playbackPosition = Duration.zero;
      _playbackDuration = Duration.zero;
      _recordedAudioPath = null;
      _stage = _Stage.recording;
    });
  }

  Future<void> _transcribeAndScore() async {
    if (_recordedAudioPath == null || !File(_recordedAudioPath!).existsSync()) {
      _showSnack('No recorded audio found. Please record your answer first.',
          isError: true);
      return;
    }

    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _stage = _Stage.transcribing;
    });

    try {
      final transcript = await _transcribeAudio(_recordedAudioPath!);
      if (!mounted) return;

      setState(() {
        _transcribedText = transcript;
        _stage = _Stage.scoring;
      });

      await _processTranscript(transcript);
    } catch (e) {
      if (!mounted) return;
      setState(() => _stage = _Stage.review);
      final msg = e.toString().replaceAll('Exception: ', '');
      _showSnack('Submission notice: $msg', isError: true);
    }
  }

  Future<String> _transcribeAudio(String audioPath) async {
    final file = File(audioPath);
    if (!await file.exists()) {
      throw Exception('Audio file not found.');
    }

    String? lastError;

    // 1. Try OpenAI Whisper first if key is present (dedicated, fast, highly reliable)
    if (_openAiKey.isNotEmpty) {
      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://api.openai.com/v1/audio/transcriptions'),
        );
        request.headers['Authorization'] = 'Bearer $_openAiKey';
        request.fields['model'] = 'whisper-1';
        request.files.add(await http.MultipartFile.fromPath('file', audioPath));

        final streamed = await request.send().timeout(const Duration(seconds: 35));
        final resp = await http.Response.fromStream(streamed);

        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body) as Map<String, dynamic>;
          final text = (data['text'] ?? '').toString().trim();
          if (text.isNotEmpty) return text;
        } else {
          lastError = 'OpenAI Whisper error (${resp.statusCode})';
        }
      } catch (e) {
        lastError = e.toString().replaceAll('Exception: ', '');
      }
    }

    // 2. Fallback to Gemini candidate models
    final bytes = await file.readAsBytes();
    final base64Audio = base64Encode(bytes);

    final payload = {
      'contents': [
        {
          'parts': [
            {
              'text': 'Provide an accurate, verbatim transcription of this speech audio. '
                  'Return ONLY the spoken text with no introductory phrases, explanations, or quotes.'
            },
            {
              'inlineData': {
                'mimeType': 'audio/mp4',
                'data': base64Audio,
              }
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.0,
      }
    };

    for (final model in AppSecrets.geminiCandidateModels) {
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_geminiApiKey',
      );

      try {
        final resp = await http
            .post(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(payload),
            )
            .timeout(const Duration(seconds: 30));

        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body) as Map<String, dynamic>;
          final candidates = data['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final parts = candidates[0]['content']?['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final text = (parts[0]['text'] ?? '').toString().trim();
              if (text.isNotEmpty) return text;
            }
          }
          continue;
        }

        // Check if Gemini error body exists
        try {
          final errJson = jsonDecode(resp.body) as Map<String, dynamic>;
          if (errJson.containsKey('error') && errJson['error'] is Map) {
            final msg = errJson['error']['message']?.toString();
            if (msg != null && msg.isNotEmpty) {
              lastError = msg;
            }
          }
        } catch (_) {}
        lastError ??= 'Transcription service error (${resp.statusCode})';
      } catch (e) {
        lastError = e.toString().replaceAll('Exception: ', '');
      }
    }

    throw Exception(lastError ?? 'Could not process audio. Please try again.');
  }

  Future<void> _processTranscript(String transcript) async {
    final result = await _scoreResponse(_currentQuestion, transcript);

    // Show result immediately — don't block on the save API calls
    if (mounted) {
      setState(() {
        _scores = result;
        _overallScore = (result['overall'] ?? 0).toInt();
        _feedback = result['feedback']?.toString() ?? 'Great effort! Keep practising.';
        _playsToday++;
        _stage = _Stage.result;
      });
    }

    // Save in the background
    _savePlayRecord(result);
  }

  // Strips markdown code fences so jsonDecode always gets raw JSON
  String _extractJson(String text) {
    final fence = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```').firstMatch(text);
    if (fence != null) return fence.group(1)!;
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start != -1 && end > start) return text.substring(start, end + 1);
    return text;
  }

  Future<Map<String, dynamic>> _scoreResponse(
      String question, String transcript) async {
    const criteria =
        '1. fluency: natural flow, grammar, minimal fillers\n'
        '2. relevance: how directly the answer addresses the question\n'
        '3. completeness: depth and thoroughness\n'
        '4. confidence: assertiveness and decisiveness in word choice\n'
        '5. clarity: organisation, coherence, ease of understanding';

    // 1. Try OpenAI GPT-4o-mini first if key is present (fast, highly intelligent, consistent JSON)
    if (_openAiKey.isNotEmpty) {
      try {
        final prompt =
            'You are StreetPay Robot, an expert speech evaluator.\n'
            'Score the user\'s spoken response on 5 criteria (each 0-100):\n$criteria.\n'
            'Be encouraging and fair with scoring so participants enjoy playing, while reserving 90+ for strong answers.\n'
            'Compute "overall" as the integer average of all 5.\n'
            'Write 2-3 sentences of constructive feedback in "feedback".\n'
            'Return ONLY a JSON object with keys: '
            'fluency, relevance, completeness, confidence, clarity, overall, feedback.';

        final resp = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Authorization': 'Bearer $_openAiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'model': 'gpt-4o-mini',
            'messages': [
              {'role': 'system', 'content': prompt},
              {
                'role': 'user',
                'content': 'Question: "$question"\n\nSpoken response: "$transcript"'
              }
            ],
            'response_format': {'type': 'json_object'},
            'temperature': 0.2,
          }),
        ).timeout(const Duration(seconds: 20));

        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body) as Map<String, dynamic>;
          final content = data['choices']?[0]?['message']?['content'] as String?;
          if (content != null && content.isNotEmpty) {
            final scoreData = jsonDecode(_extractJson(content)) as Map<String, dynamic>;
            if (!scoreData.containsKey('overall')) {
              final vals = ['fluency', 'relevance', 'completeness', 'confidence', 'clarity']
                  .map((k) => (scoreData[k] as num? ?? 0).toDouble())
                  .toList();
              scoreData['overall'] = (vals.reduce((a, b) => a + b) / vals.length).round();
            }
            return scoreData;
          }
        }
      } catch (_) {}
    }

    // 2. Try Gemini evaluation if key is present (fast & accurate)
    if (_geminiApiKey.isNotEmpty) {
      final prompt =
          'You are StreetPay Robot, an expert speech evaluator.\n'
          'Score the user\'s spoken response on 5 criteria (each 0-100):\n$criteria.\n'
          'Be encouraging and fair with scoring so participants enjoy playing, while reserving 90+ for strong answers.\n'
          'Compute "overall" as the integer average of all 5.\n'
          'Write 2-3 sentences of constructive feedback in "feedback".\n'
          'Return ONLY a JSON object with keys: '
          'fluency, relevance, completeness, confidence, clarity, overall, feedback.\n\n'
          'Question: "$question"\n\nSpoken response: "$transcript"';

      for (final model in AppSecrets.geminiCandidateModels) {
        try {
          final geminiUri = Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_geminiApiKey',
          );

          final geminiResp = await http
              .post(
                geminiUri,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'contents': [
                    {
                      'parts': [{'text': prompt}]
                    }
                  ],
                  'generationConfig': {
                    'temperature': 0.2,
                    'responseMimeType': 'application/json',
                  }
                }),
              )
              .timeout(const Duration(seconds: 25));

          if (geminiResp.statusCode == 200) {
            final data = jsonDecode(geminiResp.body) as Map<String, dynamic>;
            final raw = data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
            if (raw != null && raw.isNotEmpty) {
              final scoreData = jsonDecode(_extractJson(raw)) as Map<String, dynamic>;
              if (!scoreData.containsKey('overall')) {
                final vals = ['fluency', 'relevance', 'completeness', 'confidence', 'clarity']
                    .map((k) => (scoreData[k] as num? ?? 0).toDouble())
                    .toList();
                scoreData['overall'] = (vals.reduce((a, b) => a + b) / vals.length).round();
              }
              return scoreData;
            }
          }
        } catch (_) {}
      }
    }

    for (final model in [
      'google/gemma-4-31b-it:free',
      'thinkingmachines/inkling:free',
      'nvidia/nemotron-3-ultra:free',
    ]) {
      try {
        final resp = await http
            .post(
              Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
              headers: {
                'Authorization': 'Bearer $_openRouterKey',
                'Content-Type': 'application/json',
                'HTTP-Referer': 'https://streetpay.app',
                'X-Title': 'StreetPay',
              },
              body: jsonEncode({
                'model': model,
                'messages': [
                  {
                    'role': 'system',
                    'content':
                        'You are StreetPay Robot, an expert speech evaluator. '
                        'Score the user\'s spoken response on 5 criteria (each 0-100): '
                        '$criteria. '
                        'Be encouraging and fair with scoring. '
                        'Compute "overall" as the integer average of all 5. '
                        'Write 2-3 sentences of constructive feedback in "feedback". '
                        'Return ONLY a JSON object with keys: '
                        'fluency, relevance, completeness, confidence, clarity, overall, feedback. '
                        'No markdown, no extra text.',
                  },
                  {
                    'role': 'user',
                    'content':
                        'Question: "$question"\n\nSpoken response: "$transcript"',
                  },
                ],
                'temperature': 0.3,
              }),
            )
            .timeout(const Duration(seconds: 30));

        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body) as Map<String, dynamic>;
          final raw = data['choices'][0]['message']['content'] as String;
          final scoreData = jsonDecode(_extractJson(raw)) as Map<String, dynamic>;
          if (!scoreData.containsKey('overall')) {
            final vals = ['fluency', 'relevance', 'completeness', 'confidence', 'clarity']
                .map((k) => (scoreData[k] as num? ?? 0).toDouble())
                .toList();
            scoreData['overall'] = (vals.reduce((a, b) => a + b) / vals.length).round();
          }
          return scoreData;
        }
      } catch (_) {}
    }

    // Local scoring fallback when all API attempts fail
    return _scoreLocally(question, transcript);
  }

  Map<String, dynamic> _scoreLocally(String question, String transcript) {
    final words = transcript
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    final wordCount = words.length;

    if (wordCount < 5) {
      return {
        'fluency': 10,
        'relevance': 10,
        'completeness': 10,
        'confidence': 10,
        'clarity': 10,
        'overall': 10,
        'feedback':
            'Your response was too short. Try to speak for at least 30 seconds using complete sentences.',
      };
    }

    // Completeness: scales with word count (60 words ≈ 65, 100+ ≈ 85+)
    final completeness = (wordCount >= 100
            ? (85 + ((wordCount - 100) / 20).clamp(0, 10))
            : wordCount >= 60
                ? (65 + (wordCount - 60) / 40 * 20)
                : wordCount >= 30
                    ? (40 + (wordCount - 30) / 30 * 25)
                    : (10 + wordCount / 30 * 30))
        .round()
        .clamp(10, 95);

    // Relevance: keyword overlap between question and transcript
    final qWords = question
        .toLowerCase()
        .split(RegExp(r'\W+'))
        .where((w) => w.length > 3)
        .toSet();
    final aWords = words.where((w) => w.length > 3).toSet();
    final overlap =
        qWords.isEmpty ? 0.4 : qWords.intersection(aWords).length / qWords.length;
    final relevance = (30 + overlap * 65).round().clamp(10, 95);

    // Fluency: lexical diversity + reasonable average word length
    final uniqueCount = words.toSet().length;
    final lexDiv = (uniqueCount / wordCount).clamp(0.0, 1.0);
    final avgWordLen =
        words.map((w) => w.length).reduce((a, b) => a + b) / wordCount;
    final fluency =
        (40 + lexDiv * 40 + (avgWordLen >= 4 && avgWordLen <= 9 ? 12 : 0))
            .round()
            .clamp(20, 92);

    // Clarity: sentence count and average sentence length
    final sentences = transcript
        .split(RegExp(r'[.!?]+'))
        .where((s) => s.trim().isNotEmpty)
        .length;
    final avgSentLen = wordCount / (sentences > 0 ? sentences : 1);
    final clarity = (sentences >= 3 && avgSentLen >= 8 && avgSentLen <= 25
            ? 72
            : sentences >= 2
                ? 56
                : 38)
        .clamp(25, 88);

    // Confidence: vocabulary richness + response length
    final confidence =
        ((lexDiv * 50) + (wordCount >= 50 ? 25 : wordCount / 50 * 25) + 18)
            .round()
            .clamp(20, 88);

    final overall =
        ((fluency + relevance + completeness + confidence + clarity) / 5)
            .round();

    final feedback = overall >= 90
        ? 'Outstanding performance! You qualified for a gift with your excellent response.'
        : overall >= 70
            ? 'Well done! Your response was thorough and on-topic. Aim for 90+ to qualify for a gift.'
            : overall >= 50
                ? 'Good effort! Expand your answer with more detail and examples.'
                : 'Keep practising! Speak in full sentences, stay on topic, and try to say more.';

    return {
      'fluency': fluency,
      'relevance': relevance,
      'completeness': completeness,
      'confidence': confidence,
      'clarity': clarity,
      'overall': overall,
      'feedback': feedback,
    };
  }

  Future<void> _savePlayRecord(Map<String, dynamic> result) async {
    final fluency = (result['fluency'] as num? ?? 0).toInt();
    final relevance = (result['relevance'] as num? ?? 0).toInt();
    final completeness = (result['completeness'] as num? ?? 0).toInt();
    final confidence = (result['confidence'] as num? ?? 0).toInt();
    final clarity = (result['clarity'] as num? ?? 0).toInt();
    final overall = (result['overall'] as num? ?? 0).toInt();

    // Key 230: store scores
    try {
      await http
          .post(
            Uri.parse(_apiUrl),
            headers: {
              'Authorization': 'Bearer ${FFAppState().streetauth}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'theKey': '230',
              'UserPhone': FFAppState().phonenumber,
              'QIDS': '$relevance,$fluency,$completeness,$confidence,$clarity',
              'TotalScore': '$overall',
            }),
          )
          .timeout(const Duration(seconds: 10));
    } catch (_) {}

    // Also keep the DM-based play-count record so daily limit still works
    try {
      final record = jsonEncode({
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'score': overall,
        'question': _currentQuestion.length > 80
            ? _currentQuestion.substring(0, 80)
            : _currentQuestion,
      });
      await SendmessageCall.call(
        accessToken: FFAppState().streetauth,
        tempid: 'SPKGAME_${FFAppState().phonenumber}',
        sender: FFAppState().phonenumber,
        messagetext: record,
        messagetype: 'GAME_SCORE',
        regphone: FFAppState().phonenumber,
      );
    } catch (_) {}
  }

  // ── Screenshot & share ──────────────────────────────────────────────────────
  Future<void> _shareScore() async {
    try {
      final boundary = _scoreKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('Screenshot capture failed.');
      final bytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/smart_discovery_show_score.png');
      await file.writeAsBytes(bytes);
      final playStoreUrl = 'https://play.google.com/store/search?q=streetpay&c=apps';
      final appStoreUrl = 'https://apps.apple.com/app/streetpay/id6749464806';

      final giftText = _overallScore >= 90
          ? 'I scored $_overallScore/100 on Smart Discovery Show and qualified for a gift! 🎁🎤🔥\n\n'
          : 'I scored $_overallScore/100 on Smart Discovery Show! 🎤🔥\n\n';

      await Share.shareXFiles(
        [XFile(file.path)],
        text: '${giftText}Scored by StreetPay Robot.\n'
            'Join the game, practice speaking, and earn more with StreetPay!\n\n'
            '📲 Download StreetPay:\n'
            'Google Play: $playStoreUrl\n'
            'App Store: $appStoreUrl',
      );
    } catch (e) {
      _showSnack('Could not share: $e', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: GoogleFonts.plusJakartaSans(
              color: Colors.white, fontWeight: FontWeight.w600)),
      backgroundColor:
          isError ? const Color(0xFFB53434) : const Color(0xFF56B84B),
      behavior: SnackBarBehavior.floating,
    ));
  }

  int _score(String key) =>
      (_scores[key] is num) ? (_scores[key] as num).toInt() : 0;

  bool get _hasEnoughBalance {
    final raw = FFAppState().avalbal.replaceAll(',', '').replaceAll('₦', '').trim();
    return (double.tryParse(raw) ?? 0.0) >= 0.5;
  }

  bool get _canPlay => _hasEnoughBalance && _playsToday < _maxPlaysPerDay;
  int get _playsLeft => _maxPlaysPerDay - _playsToday;

  String _fmtDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B2018),
      body: SafeArea(
        child: switch (_stage) {
          _Stage.loading => _buildLoading(),
          _Stage.home => _buildHome(),
          _Stage.recording => _buildRecording(),
          _Stage.review => _buildReview(),
          _Stage.transcribing => _buildTranscribing(),
          _Stage.scoring => _buildScoring(),
          _Stage.result => _buildResult(),
        },
      ),
    );
  }

  Widget _buildLoading() => const Center(
        child: CircularProgressIndicator(
            color: Color(0xFF56B84B), strokeWidth: 2.5),
      );

  Widget _buildHome() => Column(
        children: [
          _topBar(
            'Smart Discovery Show',
            onBack: () => Navigator.pop(context),
            trailing: GestureDetector(
              onTap: () => TtsService.instance.introSmartDiscoveryShow(force: true),
              child: _iconBtn(Icons.volume_up_rounded),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF56B84B).withValues(alpha: 0.08),
                          ),
                        ),
                        Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF56B84B).withValues(alpha: 0.14),
                          ),
                        ),
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1E4230),
                            border: Border.all(
                              color: const Color(0xFF56B84B).withValues(alpha: 0.45),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(Icons.mic_rounded,
                              color: Color(0xFF56B84B), size: 30),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text('Speak & Get Scored',
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4)),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      'Answer a question verbally. StreetPay Robot scores your English '
                      'speaking skills across 5 criteria.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF8FA596),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _card(
                    child: Column(
                      children: [
                        _eligibilityRow(
                          icon: Icons.account_balance_wallet_rounded,
                          label: 'Wallet balance',
                          ok: _hasEnoughBalance,
                          okText: 'Balance verified — ₦0.50 minimum met',
                          failText: 'Top up your wallet to at least ₦0.50 to play',
                        ),
                        const SizedBox(height: 12),
                        _eligibilityRow(
                          icon: Icons.today_rounded,
                          label: 'Daily plays',
                          ok: _playsToday < _maxPlaysPerDay,
                          okText: '$_playsLeft of $_maxPlaysPerDay remaining today',
                          failText: 'Daily limit reached — come back tomorrow',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _card(
                    child: Column(
                      children: [
                        _ruleRow(Icons.quiz_rounded,
                            'A random question is fetched from our server'),
                        _ruleDivider(),
                        _ruleRow(Icons.mic_rounded,
                            'Tap the mic and speak your answer clearly'),
                        _ruleDivider(),
                        _ruleRow(Icons.smart_toy_rounded,
                            'StreetPay Robot scores Fluency, Relevance, Completeness, Confidence & Clarity'),
                        _ruleDivider(),
                        _ruleRow(Icons.card_giftcard_rounded,
                            'Score 90 and above to ask for a gift! Share your screenshot to WhatsApp'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _canPlay ? _startGame : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF56B84B),
                        foregroundColor: const Color(0xFF06210F),
                        disabledBackgroundColor: const Color(0xFF1E4230),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow_rounded,
                              size: 22,
                              color: _canPlay
                                  ? const Color(0xFF06210F)
                                  : const Color(0xFF4A7A5E)),
                          const SizedBox(width: 8),
                          Text(
                            'Start Game',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: _canPlay
                                    ? const Color(0xFF06210F)
                                    : const Color(0xFF4A7A5E)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _buildRecording() => Column(
        children: [
          _topBar(
            'Smart Discovery Show',
            leading: GestureDetector(
              onTap: () {
                if (_isRecording) {
                  _audioRecorder.stop();
                }
                _recordTimer?.cancel();
                _pulseCtrl.stop();
                setState(() {
                  _isRecording = false;
                  _stage = _Stage.home;
                });
              },
              child: _iconBtn(Icons.close_rounded),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  if (_isRecording)
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFF56B84B).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('QUESTION',
                                style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF56B84B),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.4)),
                          ),
                          const SizedBox(height: 12),
                          Text(_currentQuestion,
                              style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.55)),
                        ],
                      ),
                    )
                  else
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFF56B84B).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('READY TO SPEAK',
                                style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF56B84B),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.4)),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Your question will appear once you tap the microphone button below to start.',
                            style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF8FA596),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                height: 1.5),
                          ),
                        ],
                      ),
                    ),

                  const Spacer(),

                  if (_isRecording) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF5252),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'RECORDING YOUR VOICE',
                          style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFFFF5252),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${_maxRecordSecs - _recordSecs}',
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 52,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1),
                          ),
                          TextSpan(
                            text: 's',
                            style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF8FA596),
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _recordSecs / _maxRecordSecs,
                        backgroundColor: const Color(0xFF1E4230),
                        valueColor:
                            const AlwaysStoppedAnimation(Color(0xFF56B84B)),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ] else ...[
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF56B84B).withValues(alpha: 0.1),
                        border: Border.all(
                            color:
                                const Color(0xFF56B84B).withValues(alpha: 0.25)),
                      ),
                      child: const Icon(Icons.smart_toy_rounded,
                          color: Color(0xFF56B84B), size: 34),
                    ),
                    const SizedBox(height: 18),
                    Text('Ready when you are!',
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      'Tap the mic button below to reveal the question and start recording.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF8FA596),
                          fontSize: 13,
                          height: 1.4),
                    ),
                  ],

                  const SizedBox(height: 36),

                  GestureDetector(
                    onTap: _isRecording ? _stopRecording : _startRecording,
                    child: AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (_, __) => Transform.scale(
                        scale: _isRecording ? _pulseAnim.value : 1.0,
                        child: Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isRecording
                                ? const Color(0xFFFF5252)
                                : const Color(0xFF56B84B),
                            boxShadow: [
                              BoxShadow(
                                color: (_isRecording
                                        ? const Color(0xFFFF5252)
                                        : const Color(0xFF56B84B))
                                    .withValues(alpha: 0.40),
                                blurRadius: 20,
                                spreadRadius: 4,
                              )
                            ],
                          ),
                          child: Icon(
                            _isRecording
                                ? Icons.stop_rounded
                                : Icons.mic_rounded,
                            color: _isRecording
                                ? Colors.white
                                : const Color(0xFF06210F),
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),
                  Text(
                    _isRecording
                        ? 'Tap to stop & review audio'
                        : 'Tap to start recording',
                    style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF8FA596),
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _buildReview() => Column(
        children: [
          _topBar(
            'Review Recording',
            leading: GestureDetector(
              onTap: _reRecord,
              child: _iconBtn(Icons.arrow_back_ios_new_rounded),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF56B84B).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('QUESTION',
                              style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF56B84B),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.4)),
                        ),
                        const SizedBox(height: 12),
                        Text(_currentQuestion,
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.55)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // In-app Audio Player Card
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF56B84B)
                                    .withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.graphic_eq_rounded,
                                  color: Color(0xFF56B84B), size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Audio Recording',
                                    style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Play and listen before scoring',
                                    style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF8FA596),
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0B2018),
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(color: const Color(0xFF1E4230)),
                              ),
                              child: Text(
                                _fmtDuration(_playbackDuration),
                                style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF56B84B),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Play/Pause button + slider
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _playPauseAudio,
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF56B84B),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF56B84B)
                                          .withValues(alpha: 0.35),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: const Color(0xFF06210F),
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor:
                                          const Color(0xFF56B84B),
                                      inactiveTrackColor:
                                          const Color(0xFF1E4230),
                                      thumbColor: const Color(0xFF56B84B),
                                      trackHeight: 4,
                                      thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 6),
                                      overlayShape:
                                          const RoundSliderOverlayShape(
                                              overlayRadius: 12),
                                    ),
                                    child: Slider(
                                      value: _playbackPosition.inMilliseconds
                                          .toDouble()
                                          .clamp(
                                              0.0,
                                              _playbackDuration
                                                          .inMilliseconds >
                                                      0
                                                  ? _playbackDuration
                                                      .inMilliseconds
                                                      .toDouble()
                                                  : 1.0),
                                      max: _playbackDuration.inMilliseconds > 0
                                          ? _playbackDuration.inMilliseconds
                                              .toDouble()
                                          : 1.0,
                                      onChanged: (val) {
                                        _seekAudio(Duration(
                                            milliseconds: val.toInt()));
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _fmtDuration(_playbackPosition),
                                          style: GoogleFonts.plusJakartaSans(
                                              color: const Color(0xFF8FA596),
                                              fontSize: 11),
                                        ),
                                        Text(
                                          _fmtDuration(_playbackDuration),
                                          style: GoogleFonts.plusJakartaSans(
                                              color: const Color(0xFF8FA596),
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons: Re-record vs Transcribe & Score
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: _reRecord,
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: Text(
                              'Re-record',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Color(0xFF1E4230)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _transcribeAndScore,
                            icon: const Icon(Icons.auto_awesome_rounded,
                                size: 18, color: Color(0xFF06210F)),
                            label: Text(
                              'Submit & Score',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF06210F)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF56B84B),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _buildTranscribing() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF56B84B).withValues(alpha: 0.12),
              ),
              child: const Center(
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: CircularProgressIndicator(
                    color: Color(0xFF56B84B),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Processing your submission…',
              style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'StreetPay Robot is evaluating your answer',
              style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF8FA596), fontSize: 13),
            ),
          ],
        ),
      );

  Widget _buildScoring() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
                color: Color(0xFF56B84B), strokeWidth: 3),
            const SizedBox(height: 24),
            Text('Processing your submission…',
                style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('StreetPay Robot is scoring your response',
                style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF8FA596), fontSize: 13)),
          ],
        ),
      );

  void _exitToLottoHome() {
    // Pop the MaterialPageRoute pushed by LottoHome, landing back there
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go('/lottohome');
    }
  }

  Widget _buildResult() => Column(
        children: [
          _topBar('Your Score', onBack: _exitToLottoHome),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                children: [
                  RepaintBoundary(
                    key: _scoreKey,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D2419),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF1E4230)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                            decoration: const BoxDecoration(
                              color: Color(0xFF112B20),
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            child: Column(
                              children: [
                                Text('Smart Discovery Show',
                                    style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF56B84B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.6)),
                                const SizedBox(height: 14),
                                _scoreCircle(_overallScore),
                                const SizedBox(height: 12),
                                Text(
                                  _overallScore >= 90
                                      ? 'Outstanding! You qualify for a gift! 🎁'
                                      : _overallScore >= 70
                                          ? 'Great job! Score 90+ to get a gift.'
                                          : _overallScore >= 50
                                              ? 'Good effort, keep it up!'
                                              : 'Keep practising — you\'ll improve!',
                                  style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                _criteriaBar('Fluency', _score('fluency')),
                                const SizedBox(height: 12),
                                _criteriaBar('Relevance', _score('relevance')),
                                const SizedBox(height: 12),
                                _criteriaBar('Completeness', _score('completeness')),
                                const SizedBox(height: 12),
                                _criteriaBar('Confidence', _score('confidence')),
                                const SizedBox(height: 12),
                                _criteriaBar('Clarity', _score('clarity')),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF112B20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(_feedback,
                                style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF8FA596),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    height: 1.55)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_transcribedText.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF56B84B)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                    Icons.record_voice_over_rounded,
                                    size: 14,
                                    color: Color(0xFF56B84B)),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'What StreetPay Robot Heard',
                                style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF56B84B),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _transcribedText,
                            style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFFE8F5E9),
                                fontSize: 13,
                                height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF062210),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFF25D366).withValues(alpha: 0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _overallScore >= 90
                                  ? Icons.card_giftcard_rounded
                                  : Icons.share_rounded,
                              color: _overallScore >= 90
                                  ? const Color(0xFFFFD700)
                                  : const Color(0xFF25D366),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _overallScore >= 90
                                  ? 'Score 90+! Ask for your gift!'
                                  : 'Score 90+ to qualify for a gift',
                              style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _overallScore >= 90
                              ? 'Congratulations! You scored 90 or above. Send your screenshot to our WhatsApp to claim your gift.'
                              : 'You can only ask for a gift if you score 90 and above. Challenge yourself and try again!',
                          style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF8FA596),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton.icon(
                            onPressed: _shareScore,
                            icon: Icon(
                              _overallScore >= 90
                                  ? Icons.card_giftcard_rounded
                                  : Icons.share_rounded,
                              size: 18,
                            ),
                            label: Text(
                              _overallScore >= 90
                                  ? 'Claim Gift on WhatsApp'
                                  : 'Share Score Screenshot',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _exitToLottoHome,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFF1E4230)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text('Done',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                      if (_playsLeft > 0) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _startGame,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF56B84B),
                                foregroundColor: const Color(0xFF06210F),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: Text(
                                'Play Again ($_playsLeft left)',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF06210F)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  // ── Reusable UI ─────────────────────────────────────────────────────────────
  Widget _topBar(String title,
          {VoidCallback? onBack, Widget? leading, Widget? trailing}) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(
          children: [
            leading ??
                GestureDetector(
                    onTap: () {
                      TtsService.instance.stop();
                      if (onBack != null) onBack();
                    },
                    child: _iconBtn(Icons.arrow_back_ios_new_rounded)),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800),
              ),
            ),
            trailing ?? const SizedBox(width: 40),
          ],
        ),
      );

  Widget _iconBtn(IconData icon) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: const Color(0xFF112B20),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.white, size: 18),
      );

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF112B20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E4230)),
        ),
        child: child,
      );

  Widget _eligibilityRow({
    required IconData icon,
    required String label,
    required bool ok,
    required String okText,
    required String failText,
  }) =>
      Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: ok
                  ? const Color(0xFF56B84B).withValues(alpha: 0.15)
                  : const Color(0xFFFF5252).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              ok ? Icons.check_rounded : Icons.close_rounded,
              color: ok ? const Color(0xFF56B84B) : const Color(0xFFFF5252),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF8FA596),
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                Text(ok ? okText : failText,
                    style: GoogleFonts.plusJakartaSans(
                        color: ok ? Colors.white : const Color(0xFFFF8A80),
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      );

  Widget _ruleRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF56B84B), size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text,
                  style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF8FA596),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.4)),
            ),
          ],
        ),
      );

  Widget _ruleDivider() => Container(
        height: 1,
        margin: const EdgeInsets.only(left: 30),
        color: const Color(0xFF1E4230),
      );

  Widget _scoreCircle(int score) {
    final color = score >= 70
        ? const Color(0xFF56B84B)
        : score >= 50
            ? const Color(0xFFFFA726)
            : const Color(0xFFEF5350);
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 8,
            backgroundColor: const Color(0xFF1E4230),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$score',
                style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900)),
            Text('/100',
                style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF8FA596),
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _criteriaBar(String label, int score) {
    final color = score >= 70
        ? const Color(0xFF56B84B)
        : score >= 50
            ? const Color(0xFFFFA726)
            : const Color(0xFFEF5350);
    return Row(
      children: [
        SizedBox(
          width: 104,
          child: Text(label,
              style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF8FA596),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: const Color(0xFF1E4230),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 32,
          child: Text('$score',
              textAlign: TextAlign.right,
              style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
