import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentGuardService {
  // In-flight global lock: only one transaction can be submitted at a time across the app
  static bool _isProcessingPayment = false;

  // Track recent payments: key is "$cleanAccount:$amountFormatted" -> timestamp in ms
  static final Map<String, int> _recentPayments = {};
  static const String _prefsKey = 'sp_recent_payments_guard_v1';
  static bool _prefsLoaded = false;

  // Global debounce for fast button taps
  static int _lastTapTimestamp = 0;

  // Default duplicate cooldown in seconds
  static const int duplicateCooldownSeconds = 30;

  /// Fast synchronous debounce check. Returns true if tap is allowed, false if tapped too quickly.
  static bool canTapButton([int thresholdMs = 700]) {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastTapTimestamp < thresholdMs) {
      return false;
    }
    _lastTapTimestamp = now;
    return true;
  }

  /// Initialize and load saved cooldown records from persistent storage
  static Future<void> _ensurePrefsLoaded() async {
    if (_prefsLoaded) return;
    _prefsLoaded = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw != null && raw.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(raw);
        final now = DateTime.now().millisecondsSinceEpoch;
        decoded.forEach((k, v) {
          if (v is int && (now - v) < 300000) {
            _recentPayments[k] = v;
          }
        });
      }
    } catch (_) {}
  }

  static void _persistToPrefs() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_prefsKey, jsonEncode(_recentPayments));
    }).catchError((_) {});
  }

  /// Acquire global in-flight lock. Returns true if acquired, false if another payment is already in flight.
  static bool acquireLock() {
    if (_isProcessingPayment) {
      return false;
    }
    _isProcessingPayment = true;
    return true;
  }

  /// Release global in-flight lock.
  static void releaseLock() {
    _isProcessingPayment = false;
  }

  /// Check if a transfer is currently processing
  static bool get isProcessing => _isProcessingPayment;

  /// Check if a duplicate transfer (same account and same amount) was made within the last 30 seconds.
  /// Returns the number of seconds remaining in the cooldown window, or 0 if allowed.
  static int getRemainingCooldown({
    required String accountNumber,
    required double amount,
    int cooldownWindow = duplicateCooldownSeconds,
  }) {
    _ensurePrefsLoaded();
    final cleanAcc = accountNumber.replaceAll(RegExp(r'\s+'), '').trim();
    if (cleanAcc.isEmpty || amount <= 0) return 0;

    final key = '$cleanAcc:${amount.toStringAsFixed(2)}';
    final now = DateTime.now().millisecondsSinceEpoch;
    final lastTime = _recentPayments[key];

    if (lastTime != null) {
      final elapsedSec = (now - lastTime) ~/ 1000;
      if (elapsedSec < cooldownWindow) {
        return cooldownWindow - elapsedSec;
      }
    }

    return 0;
  }

  /// Record an initiated payment attempt so subsequent duplicate attempts are blocked for 30s.
  static void recordPaymentAttempt({
    required String accountNumber,
    required double amount,
  }) {
    final cleanAcc = accountNumber.replaceAll(RegExp(r'\s+'), '').trim();
    if (cleanAcc.isEmpty || amount <= 0) return;

    final key = '$cleanAcc:${amount.toStringAsFixed(2)}';
    _recentPayments[key] = DateTime.now().millisecondsSinceEpoch;

    // Prune entries older than 5 minutes
    _purgeOldRecords();
    _persistToPrefs();
  }

  /// Clear a specific payment record (e.g. if payment immediately failed validation before hitting backend)
  static void clearPaymentAttempt({
    required String accountNumber,
    required double amount,
  }) {
    final cleanAcc = accountNumber.replaceAll(RegExp(r'\s+'), '').trim();
    final key = '$cleanAcc:${amount.toStringAsFixed(2)}';
    _recentPayments.remove(key);
    _persistToPrefs();
  }

  static void _purgeOldRecords() {
    final now = DateTime.now().millisecondsSinceEpoch;
    _recentPayments.removeWhere((_, time) => (now - time) > 300000); // 5 minutes
  }

  /// Show a user-friendly modal warning when a duplicate payment is blocked
  static void showDuplicateWarningDialog({
    required BuildContext context,
    required String recipientName,
    required String accountNumber,
    required double amount,
    required int remainingSeconds,
    String serviceType = 'Transfer',
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                width: 36.0,
                height: 36.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Color(0xFFD97706),
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  'Duplicate $serviceType Guard',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A $serviceType of ₦${amount.toStringAsFixed(2)} to $recipientName ($accountNumber) was just submitted.',
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF374151),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12.0),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 18.0,
                      color: Color(0xFFD97706),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'To prevent duplicate charges, please wait $remainingSeconds seconds before trying again.',
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Got It',
                style: TextStyle(
                  color: Color(0xFF00A651),
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
