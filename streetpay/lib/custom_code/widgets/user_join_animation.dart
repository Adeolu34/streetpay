// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:ui' as ui;

/// TV news–style horizontal crawl: solid bar, bold white caps, continuous
/// smooth scroll.
class UserJoinAnimation extends StatefulWidget {
  /// Sample winner lines used when [useDemoWhenEmpty] / [forceDemoData] is on.
  static const List<String> demoWinnerLines = [
    'Umar wins 95720',
    'Adaeze wins 88441',
    'Chukwuemeka wins 88107',
    'Kabiru wins 75594',
    'Amina wins 25277',
  ];

  final List<String> users;
  final double? width;
  final double? height;

  /// If the passed [users] list is empty (or only blanks), show [demoWinnerLines] instead.
  /// Set to `false` in FlutterFlow when `FFAppState().winners` is reliably filled.
  final bool useDemoWhenEmpty;

  /// If `true`, always shows [demoWinnerLines] and ignores [users] (for layout / API debugging).
  final bool forceDemoData;

  /// Classic TV crawl: uppercase, bold, solid bar, no icon. Set `false` for mixed case + trophy icon.
  final bool tvNewsStyle;

  const UserJoinAnimation({
    super.key,
    required this.users,
    this.width,
    this.height,
    this.useDemoWhenEmpty = true,
    this.forceDemoData = false,
    this.tvNewsStyle = true,
  });

  @override
  State<UserJoinAnimation> createState() => _UserJoinAnimationState();
}

class _UserJoinAnimationState extends State<UserJoinAnimation>
    with SingleTickerProviderStateMixin {
  /// Steady crawl speed (pixels per second), like a news ticker.
  static const double _scrollSpeedPxPerSec = 32.0;

  /// Gap between repeated segments for a seamless loop.
  static const double _segmentGap = 64.0;

  late final AnimationController _scrollController;

  List<String> _usersSnapshot = const [];
  String? _lastTickerSignature;

  List<String> get _effectiveUsers {
    if (widget.forceDemoData) {
      return List<String>.of(UserJoinAnimation.demoWinnerLines);
    }
    final parsed = widget.users
        .map((e) => e.toString().trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (parsed.isNotEmpty) return parsed;
    if (widget.useDemoWhenEmpty) {
      return List<String>.of(UserJoinAnimation.demoWinnerLines);
    }
    return const [];
  }

  @override
  void initState() {
    super.initState();
    _scrollController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30))
          ..repeat();
    _usersSnapshot = List<String>.of(_effectiveUsers);
  }

  @override
  void didUpdateWidget(covariant UserJoinAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    final next = _effectiveUsers;
    final flagsChanged = oldWidget.forceDemoData != widget.forceDemoData ||
        oldWidget.useDemoWhenEmpty != widget.useDemoWhenEmpty ||
        oldWidget.tvNewsStyle != widget.tvNewsStyle;
    if (flagsChanged || !listEquals(_usersSnapshot, next)) {
      _usersSnapshot = List<String>.of(next);
      _lastTickerSignature = null;
      _scrollController.reset();
      _scrollController.repeat();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _measureTextWidth(String text, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: ui.TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: double.infinity);
    return tp.width;
  }

  TextStyle _tickerStyle(FlutterFlowTheme theme, double fontSize,
      {required bool tv}) {
    const textOnBar = Colors.white;
    return theme.bodyMedium.override(
      font: GoogleFonts.readexPro(
        fontWeight: tv ? FontWeight.w800 : FontWeight.w600,
        fontStyle: theme.bodyMedium.fontStyle,
      ),
      color: textOnBar,
      fontSize: fontSize,
      letterSpacing: tv ? 0.85 : 0.2,
      lineHeight: 1.1,
      shadows: tv
          ? [
              Shadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ]
          : [
              Shadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
    );
  }

  void _ensureScrollDuration(double segmentWidthPx) {
    if (segmentWidthPx <= 0) return;
    final ms = (segmentWidthPx / _scrollSpeedPxPerSec * 1000)
        .round()
        .clamp(10000, 240000);
    final d = Duration(milliseconds: ms);
    if (_scrollController.duration != d) {
      _scrollController.duration = d;
      _scrollController.reset();
      _scrollController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final h = widget.height ?? 100;
    final w = widget.width ?? double.infinity;
    final tv = widget.tvNewsStyle;
    final fontSize =
        tv ? (h * 0.36).clamp(11.0, 18.0) : (h * 0.38).clamp(11.0, 20.0);
    final padH = tv ? (h * 0.18).clamp(8.0, 20.0) : (h * 0.12).clamp(4.0, 12.0);
    final padV = tv ? (h * 0.12).clamp(4.0, 10.0) : (h * 0.08).clamp(2.0, 8.0);

    final primary = theme.primary;
    const textOnBar = Colors.white;
    final lineStyle = _tickerStyle(theme, fontSize, tv: tv);

    final users = _effectiveUsers;
    if (users.isEmpty) {
      return SizedBox(
        width: w,
        height: h,
        child: const Text('', key: ValueKey('user_join_msg')),
      );
    }

    final raw = users.join(tv ? '     •     ' : '   •   ');
    final tickerText = tv ? raw.toUpperCase() : raw;
    final signature = '${users.length}|$tickerText|${tv ? 1 : 0}';

    final textW = _measureTextWidth(tickerText, lineStyle);
    final segmentWidth = textW + _segmentGap;

    if (signature != _lastTickerSignature) {
      _lastTickerSignature = signature;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _ensureScrollDuration(segmentWidth);
      });
    }

    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, _) {
        final t = _scrollController.value;
        final offset = -t * segmentWidth;

        final bar = Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            // Solid strip like TV news (no gradient pulse).
            color: primary,
            borderRadius: BorderRadius.circular(tv ? 2 : h * 0.35),
            boxShadow: tv
                ? null
                : [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.28),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
            child: tv
                ? _tvTickerRow(
                    offset: offset,
                    tickerText: tickerText,
                    lineStyle: lineStyle,
                  )
                : _legacyTickerRow(
                    h: h,
                    padH: padH,
                    textOnBar: textOnBar,
                    offset: offset,
                    tickerText: tickerText,
                    lineStyle: lineStyle,
                  ),
          ),
        );

        return bar;
      },
    );
  }

  /// Full-width crawl — no icon, like broadcast news lower-third tickers.
  Widget _tvTickerRow({
    required double offset,
    required String tickerText,
    required TextStyle lineStyle,
  }) {
    return ClipRect(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: Offset(offset, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tickerText,
                key: const ValueKey('user_join_msg'),
                maxLines: 1,
                softWrap: false,
                style: lineStyle,
              ),
              SizedBox(width: _segmentGap),
              Text(
                tickerText,
                maxLines: 1,
                softWrap: false,
                style: lineStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legacyTickerRow({
    required double h,
    required double padH,
    required Color textOnBar,
    required double offset,
    required String tickerText,
    required TextStyle lineStyle,
  }) {
    return Row(
      children: [
        Icon(
          Icons.emoji_events_rounded,
          size: (h * 0.55).clamp(14.0, 22.0),
          color: textOnBar.withValues(alpha: 0.95),
        ),
        SizedBox(width: padH * 0.75),
        Expanded(
          child: ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                offset: Offset(offset, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tickerText,
                      key: const ValueKey('user_join_msg'),
                      maxLines: 1,
                      softWrap: false,
                      style: lineStyle,
                    ),
                    SizedBox(width: _segmentGap),
                    Text(
                      tickerText,
                      maxLines: 1,
                      softWrap: false,
                      style: lineStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
