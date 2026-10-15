import 'package:flutter/services.dart';

class ClipboardDetectionService {
  static final Set<String> _suppressedNumbers = {};
  static String? _lastCheckedRawText;

  /// Check clipboard content for a valid 10-digit Nigerian NUBAN account number.
  /// Returns the 10-digit string if detected and not suppressed, or null otherwise.
  static Future<String?> checkClipboardForAccountNumber({
    String? currentAccountNo,
    String? testTextOverride,
  }) async {
    try {
      final rawText = testTextOverride?.trim() ??
          (await Clipboard.getData(Clipboard.kTextPlain))?.text?.trim();

      if (rawText == null || rawText.isEmpty) {
        return null;
      }

      // If clipboard text hasn't changed since last evaluation, avoid re-evaluating
      if (rawText == _lastCheckedRawText) {
        // Still check if the extracted number was suppressed
        final digitsMatch = RegExp(r'\b\d{10}\b').firstMatch(rawText);
        if (digitsMatch != null && _suppressedNumbers.contains(digitsMatch.group(0))) {
          return null;
        }
      }
      _lastCheckedRawText = rawText;

      // Match exact 10 consecutive digits
      final match = RegExp(r'\b\d{10}\b').firstMatch(rawText);
      if (match == null) {
        return null;
      }

      final candidate = match.group(0)!;

      // Do not prompt if the number is the user's own StreetPay account
      if (currentAccountNo != null &&
          currentAccountNo.isNotEmpty &&
          candidate == currentAccountNo.trim()) {
        return null;
      }

      // Do not prompt if already dismissed or handled in this session
      if (_suppressedNumbers.contains(candidate)) {
        return null;
      }

      return candidate;
    } catch (_) {
      return null;
    }
  }

  /// Mark an account number as suppressed so the user is not prompted again
  static void suppress(String accountNumber) {
    _suppressedNumbers.add(accountNumber.trim());
  }

  /// Clear suppression cache
  static void clearSuppression() {
    _suppressedNumbers.clear();
    _lastCheckedRawText = null;
  }
}
