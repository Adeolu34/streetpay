// Central secrets registry — one place to rotate any credential.
//
// IMPORTANT: These keys are compiled into the binary and CAN be extracted
// from the APK/IPA via decompilation. For production hardening, route all
// third-party AI calls through your own backend so keys never leave the server.
//
// Rotation: update the value here and rebuild — no need to hunt across files.

class AppSecrets {
  AppSecrets._();

  // Active models: gemini-3.5-flash-lite (fast, stable, audio supported) with fallbacks
  static const String geminiApiKey =
      'AIzaSyAv3xR13kEetVt3tkYSJnCGd-HY19k-Z0Y';
  static const String geminiModel = 'gemini-3.5-flash-lite';
  static const List<String> geminiCandidateModels = [
    'gemini-3.5-flash-lite',
    'gemini-flash-lite-latest',
    'gemini-3.1-flash-lite',
    'gemini-flash-latest',
    'gemini-3.6-flash',
  ];

  // OpenAI API — used for Whisper audio transcription and GPT evaluations
  static const String openAiApiKey =
      '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';

  // OpenRouter API — used for payment extraction (fallback) and speaking game scoring
  static const String openRouterApiKey =
      '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';

  // StreetPay backend service account — used by StreetauthCall
  static const String streetauthUserId = r'Paysp1010$i.i';
  static const String streetauthSecretKey =
      r'$2a$10$3JK3bVeSVXW0xrVzqmvUmu/tX.XLoUqbwPxTYqZdDz1QHMB2jhDxm';

  // SendBaba MyYarns live chat widget key
  // Found in your SendBaba Dashboard -> Widgets (e.g. 'sb_chat_xxxx')
  static const String sendBabaWidgetKey = 'sb_chat_24bff3b51c10e89ebcb52837';
}
