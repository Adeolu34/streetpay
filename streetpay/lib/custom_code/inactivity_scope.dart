import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/app_state.dart';
import 'inactivity_service.dart';

/// Root wrapper: forwards pointer/scroll/lifecycle to [InactivityService].
class InactivityScope extends StatefulWidget {
  const InactivityScope({super.key, required this.child});

  final Widget? child;

  @override
  State<InactivityScope> createState() => _InactivityScopeState();
}

class _InactivityScopeState extends State<InactivityScope>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onActivity());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    InactivityService().dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onActivity();
    }
  }

  void _onActivity() {
    if (!mounted) return;
    final appState = context.read<FFAppState>();
    InactivityService().setContext(context);
    InactivityService().handleUserActivity(appState);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _onActivity(),
      onPointerSignal: (signal) {
        if (signal is PointerScrollEvent) {
          _onActivity();
        }
      },
      child: widget.child ?? const SizedBox.shrink(),
    );
  }
}
