import 'package:flutter_tts/flutter_tts.dart';
import '/app_state.dart';

class TtsService {
  static final TtsService instance = TtsService._();
  TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  // Prevents the home greeting from replaying every time the user navigates home
  static bool _homeGreetingDone = false;
  static void resetGreeting() => _homeGreetingDone = false;

  Future<void> _init() async {
    if (_initialized) return;
    try {
      final langs = await _tts.getLanguages as List?;
      final hasNg = langs?.any((l) => l.toString().startsWith('en-NG')) ?? false;
      await _tts.setLanguage(hasNg ? 'en-NG' : 'en-US');
    } catch (_) {
      await _tts.setLanguage('en-US');
    }
    await _tts.setSpeechRate(0.48);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.05);
    _initialized = true;
  }

  Future<void> speak(String text, {bool force = false}) async {
    if (!force && FFAppState().disableVoiceBalance) return;
    try {
      await _init();
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      // TTS is non-critical — fail silently
    }
  }

  Future<void> greetHome({required String name, required String balance}) async {
    if (_homeGreetingDone) return;
    _homeGreetingDone = true;

    final firstName = name.trim().split(' ').first;
    final shouldReadBalance =
        !FFAppState().disableVoiceBalance && !FFAppState().hidebal;
    final cleanBal =
        balance.replaceAll('₦', '').replaceAll(',', '').trim();
    final display = (cleanBal.isEmpty || !shouldReadBalance) ? '' : '$cleanBal naira';

    final text = display.isNotEmpty
        ? 'Welcome back, $firstName! Your StreetPay balance is $display. Have a great banking day!'
        : 'Welcome back, $firstName! Have a great banking day!';

    await speak(text);
  }

  Future<void> walkthroughNewUser({
    required String name,
    required String accountNo,
  }) async {
    final firstName = name.trim().split(' ').first;
    // Spell out each digit so TTS reads them individually
    final spokenAcct = accountNo.trim().split('').join(', ');

    final script = 'Congratulations, $firstName! '
        'Your StreetPay wallet is now live. '
        'Your account number is $spokenAcct. '
        'Share this number with anyone who wants to send you money. '
        'With StreetPay you can send money to any bank in Nigeria, '
        'pay for electricity, cable TV, airtime, and data. '
        'You can also play games and win exciting prizes. '
        'Tap Get Started to explore everything StreetPay has to offer. '
        'Welcome aboard!';

    await speak(script);
  }

  Future<void> introSmartDiscoveryShow({bool force = false}) async {
    const script =
        'Welcome to the Smart Discovery Show! Record your answers and have the chance to win big prizes.';
    await speak(script, force: force);
  }

  void stop() {
    _tts.stop();
  }

  void dispose() {
    _tts.stop();
  }
}
