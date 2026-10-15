// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom actions

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import '/app_state.dart';
import '/custom_code/inactivity_service.dart';

bool _started = false;
bool _pointerHookInstalled = false;
bool _keyboardHandlerAdded = false;

/// Every pointer packet from the engine (touch/mouse/stylus), before widgets.
/// This catches taps/scrolls even when a route or WebView sat above our Overlay.
void _installGlobalPointerHook() {
  if (_pointerHookInstalled) return;
  _pointerHookInstalled = true;
  final dispatcher = ui.PlatformDispatcher.instance;
  final previous = dispatcher.onPointerDataPacket;
  dispatcher.onPointerDataPacket = (ui.PointerDataPacket packet) {
    previous?.call(packet);
    InactivityService().handleUserActivity(FFAppState());
  };
}

void _attachKeyboardHandlerOnce() {
  if (_keyboardHandlerAdded) return;
  _keyboardHandlerAdded = true;
  HardwareKeyboard.instance.addHandler((event) {
    InactivityService().handleUserActivity(FFAppState());
    return false;
  });
}

Future<void> startInactivityMonitor() async {
  if (_started) return;
  _started = true;

  WidgetsBinding.instance.addObserver(_LifecycleObserver());
  _installGlobalPointerHook();
  _attachKeyboardHandlerOnce();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    Future(() async {
      for (int i = 0; i < 10; i++) {
        final appState = FFAppState();
        InactivityService().handleUserActivity(appState);
        if (appState.sessionid.isNotEmpty) break;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    });
  });
}

class _LifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App returned to foreground (e.g. after file picker, camera, home button).
      // Reset the inactivity timer fresh — don't penalise time spent outside Flutter.
      InactivityService().handleUserActivity(FFAppState());
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // App left foreground (native dialog, file picker, home button, etc.).
      // Freeze the timer so it doesn't expire while the user can't interact.
      InactivityService().pauseTimer();
    }
  }
}
