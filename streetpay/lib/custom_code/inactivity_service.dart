import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app_state.dart';
import '/pages/onboarding/loginbiometric/loginbiometric_widget.dart';
import '/flutter_flow/nav/nav.dart';

class InactivityService {
  static final InactivityService _instance = InactivityService._internal();
  factory InactivityService() => _instance;
  InactivityService._internal();

  static const Duration _inactivityTimeout = Duration(minutes: 2, seconds: 30);

  /// Coalesce high-frequency pointer packets into one timer reschedule.
  static const Duration _resetDebounce = Duration(milliseconds: 80);
  Timer? _inactivityTimer;
  Timer? _resetDebounceTimer;
  bool _trackingInactivity = false;
  bool _isNavigatingToLockScreen = false;

  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  BuildContext? _effectiveContext() =>
      _context ?? appNavigatorKey.currentContext;

  void startTracking() {
    if (_trackingInactivity) return;
    _trackingInactivity = true;
    _resetDebounceTimer?.cancel();
    _resetDebounceTimer = null;
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_inactivityTimeout, _handleInactivityTimeout);
  }

  void stopTracking() {
    _trackingInactivity = false;
    _cancelInactivityTimer();
  }

  // Cancels the running timer without resetting the tracking flag.
  // Use this when the user leaves the app (file picker, home button, etc.)
  // so the countdown doesn't advance while Flutter can't receive input.
  // The timer restarts automatically when the app resumes via handleUserActivity.
  void pauseTimer() {
    _cancelInactivityTimer();
  }

  void handleUserActivity(FFAppState appState) {
    if (!_shouldTrackInactivity(appState)) {
      stopTracking();
      return;
    }
    if (!_trackingInactivity) {
      startTracking();
    } else {
      _resetInactivityTimer();
    }
  }

  bool _shouldTrackInactivity(FFAppState appState) {
    if (appState.sessionid.isEmpty) return false;
    return !_isLoginBiometricRouteActive();
  }

  bool _isLoginBiometricRouteActive() {
    final ctx = _effectiveContext();
    if (ctx == null) return false;
    try {
      final route =
          GoRouter.of(ctx).routerDelegate.currentConfiguration.uri.toString();
      return route == LoginbiometricWidget.routePath ||
          route.contains(LoginbiometricWidget.routePath);
    } catch (e) {
      return false;
    }
  }

  void _resetInactivityTimer() {
    if (!_trackingInactivity) return;
    _resetDebounceTimer?.cancel();
    _resetDebounceTimer = Timer(_resetDebounce, () {
      _resetDebounceTimer = null;
      if (!_trackingInactivity) return;
      _inactivityTimer?.cancel();
      _inactivityTimer = Timer(_inactivityTimeout, _handleInactivityTimeout);
    });
  }

  void _cancelInactivityTimer() {
    _resetDebounceTimer?.cancel();
    _resetDebounceTimer = null;
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
  }

  void _handleInactivityTimeout() {
    if (!_trackingInactivity) return;
    _cancelInactivityTimer();
    _navigateToBiometricLock();
  }

  void _navigateToBiometricLock() {
    if (_isNavigatingToLockScreen || _isLoginBiometricRouteActive()) return;
    final ctx = _effectiveContext();
    if (ctx == null) return;

    // Ensure the login biometric screen shows the authentication flow.
    // `loginbiometric_widget.dart` prompts biometric auth when
    // `FFAppState().updatereq == true` and `FFAppState().biometric == true`.
    // We preserve user preference rather than forcing biometric on devices/users without it.
    final appState = FFAppState();
    appState.updatereq = true;

    _isNavigatingToLockScreen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (ctx.mounted) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text('Session has expired'),
              duration: Duration(seconds: 2),
            ),
          );
          Future.delayed(const Duration(milliseconds: 300), () {
            if (ctx.mounted) {
              ctx.pushNamed(LoginbiometricWidget.routeName);
            }
          });
        }
      } finally {
        _isNavigatingToLockScreen = false;
      }
    });
  }

  void dispose() {
    stopTracking();
    _context = null;
  }
}
