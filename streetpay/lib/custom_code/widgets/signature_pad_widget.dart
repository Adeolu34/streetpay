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

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:signature/signature.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app_state.dart';

class SignaturePadWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final Function(String?)? onSigned;

  const SignaturePadWidget({
    super.key,
    this.width,
    this.height,
    this.onSigned,
  });

  @override
  State<SignaturePadWidget> createState() => _SignaturePadWidgetState();
}

class _SignaturePadWidgetState extends State<SignaturePadWidget> {
  late final SignatureController _controller;
  Timer? _debounce;
  bool _hasSigned = false;
  bool _isSaving = false;

  static const _green = Color(0xFF56B84B);
  static const _darkGreen = Color(0xFF0B2018);
  static const _borderIdle = Color(0xFFD6DDD8);

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 2.5,
      penColor: _darkGreen,
      exportBackgroundColor: Colors.white,
      onDrawEnd: () {
        _autoSave();
      },
    );
    _controller.addListener(_onDraw);
    _hasSigned = FFAppState().signature.isNotEmpty;
  }

  void _onDraw() {
    if (_controller.isEmpty) return;
    if (!_hasSigned) setState(() => _hasSigned = true);
  }

  Future<void> _autoSave() async {
    if (!mounted || _controller.isEmpty) return;
    setState(() => _isSaving = true);
    try {
      final Uint8List? bytes = await _controller.toPngBytes();
      if (bytes != null && mounted) {
        final base64 = base64Encode(bytes);
        FFAppState().signature = base64;
        widget.onSigned?.call(base64);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    FFAppState().signature = '';
    widget.onSigned?.call(null);
    setState(() {
      _hasSigned = false;
      _isSaving = false;
    });
  }

  @override
  void dispose() {
    if (_controller.isNotEmpty) {
      _controller.toPngBytes().then((bytes) {
        if (bytes != null) {
          FFAppState().signature = base64Encode(bytes);
        }
      });
    }
    _debounce?.cancel();
    _controller.removeListener(_onDraw);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canvasHeight = (widget.height ?? 180) - 36;

    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.draw_outlined, size: 15, color: Color(0xFF6E7A72)),
                  const SizedBox(width: 6),
                  Text(
                    'Draw your signature',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6E7A72),
                    ),
                  ),
                ],
              ),
              // Status badge
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isSaving
                    ? const SizedBox(
                        key: ValueKey('saving'),
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(_green),
                        ),
                      )
                    : _hasSigned
                        ? Row(
                            key: const ValueKey('saved'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  size: 13, color: _green),
                              const SizedBox(width: 4),
                              Text(
                                'Captured',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: _green,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Signature canvas
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: canvasHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _hasSigned ? _green : _borderIdle,
                width: _hasSigned ? 1.5 : 1.0,
              ),
              boxShadow: _hasSigned
                  ? [
                      BoxShadow(
                        color: _green.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Signature area
                Signature(
                  controller: _controller,
                  backgroundColor: Colors.white,
                  width: double.infinity,
                  height: canvasHeight,
                ),

                // Existing saved signature preview when controller is empty
                if (_controller.isEmpty && FFAppState().signature.isNotEmpty)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.memory(
                            base64Decode(FFAppState().signature.contains(',')
                                ? FFAppState().signature.split(',').last
                                : FFAppState().signature),
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                  ),

                // "Sign here" hint — only when empty
                if (!_hasSigned)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: const Color(0xFFD6DDD8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Sign above this line',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: const Color(0xFFBBCCC4),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),

                // Clear button — top-right, only when signed
                if (_hasSigned)
                  Positioned(
                    top: 6,
                    right: 8,
                    child: GestureDetector(
                      onTap: _clear,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F8F6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFFE6EAE7), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.refresh_rounded,
                                size: 13, color: Color(0xFF6E7A72)),
                            const SizedBox(width: 4),
                            Text(
                              'Redo',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF6E7A72),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
