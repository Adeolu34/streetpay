import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FFButtonOptions {
  const FFButtonOptions({
    this.textAlign,
    this.textStyle,
    this.elevation,
    this.height,
    this.width,
    this.padding,
    this.color,
    this.disabledColor,
    this.disabledTextColor,
    this.splashColor,
    this.iconSize,
    this.iconColor,
    this.iconAlignment,
    this.iconPadding,
    this.borderRadius,
    this.borderSide,
    this.hoverColor,
    this.hoverBorderSide,
    this.hoverTextColor,
    this.hoverElevation,
    this.maxLines,
  });

  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final double? elevation;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final int? maxLines;
  final Color? splashColor;
  final double? iconSize;
  final Color? iconColor;
  final IconAlignment? iconAlignment;
  final EdgeInsetsGeometry? iconPadding;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final Color? hoverColor;
  final BorderSide? hoverBorderSide;
  final Color? hoverTextColor;
  final double? hoverElevation;
}

class FFButtonWidget extends StatefulWidget {
  const FFButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconData,
    required this.options,
    this.showLoadingIndicator = true,
    this.loading,
    this.loadingText,
    this.focusNode,
  });

  final String text;
  final Widget? icon;
  final IconData? iconData;
  final Function()? onPressed;
  final FFButtonOptions options;
  final bool showLoadingIndicator;
  final bool? loading;
  final String? loadingText;
  final FocusNode? focusNode;

  @override
  State<FFButtonWidget> createState() => _FFButtonWidgetState();
}

class _FFButtonWidgetState extends State<FFButtonWidget> {
  bool _internalLoading = false;
  bool _tapLocked = false;
  late FocusNode _internalFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  int get maxLines => widget.options.maxLines ?? 1;
  String? get text =>
      widget.options.textStyle?.fontSize == 0 ? null : widget.text;

  bool get _isProcessing => (widget.loading == true) || _internalLoading;
  bool get isBusy => _isProcessing;

  String _getProcessingText(String? original) {
    if (original == null || original.trim().isEmpty) return 'Processing...';
    final trimmed = original.trim();
    final lower = trimmed.toLowerCase();
    if (trimmed.endsWith('...') || lower.endsWith('ing')) {
      return trimmed;
    }
    if (lower == 'sign in' || lower == 'signin' || lower == 'log in' || lower == 'login') {
      return 'Signing in...';
    }
    if (lower == 'sign up' || lower == 'signup' || lower == 'create account' || lower == 'create your wallet') {
      return 'Creating account...';
    }
    if (lower == 'continue' || lower == 'yes continue' || lower == 'next' || lower.contains('proceed')) {
      return 'Processing...';
    }
    if (lower.contains('pay') || lower.contains('buy') || lower.contains('recharge') || lower.contains('send')) {
      return 'Processing...';
    }
    if (lower.contains('verify') || lower.contains('otp')) {
      return 'Verifying...';
    }
    if (lower.contains('save') || lower.contains('update')) {
      return 'Saving...';
    }
    if (lower.contains('reset')) {
      return 'Resetting...';
    }
    if (lower.contains('confirm')) {
      return 'Confirming...';
    }
    if (lower.contains('withdraw')) {
      return 'Withdrawing...';
    }
    return 'Processing...';
  }

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _internalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color effectiveFgColor =
        widget.options.textStyle?.color ?? Colors.white;

    Widget textWidget = isBusy
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.8,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveFgColor),
                ),
              ),
              if (text != null && text!.trim().isNotEmpty) ...[
                const SizedBox(width: 10),
                Flexible(
                  child: AutoSizeText(
                    widget.loadingText ?? _getProcessingText(text),
                    style: (widget.options.textStyle ??
                            const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ))
                        .copyWith(
                          color: effectiveFgColor,
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: widget.options.textAlign ?? TextAlign.center,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          )
        : AutoSizeText(
            text ?? '',
            style:
                text == null ? null : widget.options.textStyle?.withoutColor(),
            textAlign: widget.options.textAlign,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          );

    final onPressed = (isBusy || widget.onPressed == null)
        ? null
        : () async {
            if (_internalLoading || _tapLocked || (widget.loading ?? false)) {
              return;
            }
            _tapLocked = true;
            if (mounted) {
              setState(() => _internalLoading = true);
            }
            try {
              final dynamic result = widget.onPressed!();
              if (result is Future) {
                await result;
              } else {
                // Ensure debounce to prevent rapid multi-taps from registering duplicate requests
                await Future.delayed(const Duration(milliseconds: 350));
              }
            } finally {
              if (mounted) {
                setState(() => _internalLoading = false);
              }
              _tapLocked = false;
            }
          };

    ButtonStyle style = ButtonStyle(
      shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
        if (states.contains(WidgetState.hovered) &&
            widget.options.hoverBorderSide != null) {
          return RoundedRectangleBorder(
            borderRadius:
                widget.options.borderRadius ?? BorderRadius.circular(8),
            side: widget.options.hoverBorderSide!,
          );
        }
        return RoundedRectangleBorder(
          borderRadius: widget.options.borderRadius ?? BorderRadius.circular(8),
          side: widget.options.borderSide ?? BorderSide.none,
        );
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (isBusy) {
          return effectiveFgColor;
        }
        if (states.contains(WidgetState.disabled)) {
          if (widget.options.disabledTextColor != null) {
            return widget.options.disabledTextColor;
          }
          return effectiveFgColor.withValues(alpha: 0.6);
        }
        if (states.contains(WidgetState.hovered) &&
            widget.options.hoverTextColor != null) {
          return widget.options.hoverTextColor;
        }
        return effectiveFgColor;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (isBusy) {
          return (widget.options.color ?? const Color(0xFF56B84B)).withValues(alpha: 0.85);
        }
        if (states.contains(WidgetState.disabled)) {
          if (widget.options.disabledColor != null) {
            return widget.options.disabledColor;
          }
          return (widget.options.color ?? const Color(0xFF56B84B)).withValues(alpha: 0.45);
        }
        if (states.contains(WidgetState.hovered) &&
            widget.options.hoverColor != null) {
          return widget.options.hoverColor;
        }
        return widget.options.color;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return widget.options.splashColor;
        }
        return widget.options.hoverColor == null ? null : Colors.transparent;
      }),
      padding: WidgetStateProperty.all(
        widget.options.padding ??
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      ),
      elevation: WidgetStateProperty.resolveWith<double?>((states) {
        if (states.contains(WidgetState.hovered) &&
            widget.options.hoverElevation != null) {
          return widget.options.hoverElevation!;
        }
        return widget.options.elevation ?? 2.0;
      }),
      iconColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          if (widget.options.disabledTextColor != null) {
            return widget.options.disabledTextColor;
          }
          return widget.options.iconColor;
        }
        if (states.contains(WidgetState.hovered) &&
            widget.options.hoverTextColor != null) {
          return widget.options.hoverTextColor;
        }
        return widget.options.iconColor;
      }),
    );

    if ((widget.icon != null || widget.iconData != null) && !isBusy) {
      Widget icon = widget.icon ??
          FaIcon(
            widget.iconData!,
            size: widget.options.iconSize,
            color: widget.options.iconColor,
          );

      if (text == null) {
        return Container(
          height: widget.options.height,
          width: widget.options.width,
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
              widget.options.borderSide ?? BorderSide.none,
            ),
            borderRadius:
                widget.options.borderRadius ?? BorderRadius.circular(8),
          ),
          child: IconButton(
            splashRadius: 1.0,
            icon: Padding(
              padding: widget.options.iconPadding ?? EdgeInsets.zero,
              child: icon,
            ),
            onPressed: onPressed,
            style: style,
            focusNode: _focusNode,
          ),
        );
      }
      return SizedBox(
        height: widget.options.height,
        width: widget.options.width,
        child: ElevatedButton.icon(
          icon: Padding(
            padding: widget.options.iconPadding ?? EdgeInsets.zero,
            child: icon,
          ),
          label: textWidget,
          onPressed: onPressed,
          style: style,
          iconAlignment: widget.options.iconAlignment ?? IconAlignment.start,
          focusNode: _focusNode,
        ),
      );
    }

    final button = SizedBox(
      height: widget.options.height,
      width: widget.options.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        focusNode: _focusNode,
        child: textWidget,
      ),
    );

    if (isBusy) {
      return IgnorePointer(
        ignoring: true,
        child: button,
      );
    }
    return button;
  }
}

extension _WithoutColorExtension on TextStyle {
  TextStyle withoutColor() => TextStyle(
        inherit: inherit,
        color: null,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        leadingDistribution: leadingDistribution,
        locale: locale,
        foreground: foreground,
        background: background,
        shadows: shadows,
        fontFeatures: fontFeatures,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        debugLabel: debugLabel,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        // The _package field is private so unfortunately we can't set it here,
        // but it's almost always unset anyway.
        // package: _package,
        overflow: overflow,
      );
}

// ignore: unused_element
double? _getTextWidth(String? text, TextStyle? style, int maxLines) =>
    text != null
        ? (TextPainter(
            text: TextSpan(text: text, style: style),
            textDirection: TextDirection.ltr,
            maxLines: maxLines,
          )..layout())
            .size
            .width
        : null;

class FFFocusIndicator extends StatefulWidget {
  final Widget Function(FocusNode focusNode)? builder;
  final Widget? child;
  final Border? border;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? onDoubleTap;

  const FFFocusIndicator({
    super.key,
    this.builder,
    this.child,
    this.border,
    this.borderRadius,
    this.padding,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
  }) : assert(
          builder != null || child != null,
          'Either builder or child must be provided',
        );

  @override
  State<FFFocusIndicator> createState() => _FFFocusIndicatorState();
}

class _FFFocusIndicatorState extends State<FFFocusIndicator> {
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      if (_focusNode.hasFocus) {
        // No single ScrollPositionAlignmentPolicy scrolls in both directions.
        // keepVisibleAtEnd scrolls DOWN (handles Shift+Tab wrap first → last).
        // keepVisibleAtStart scrolls UP (handles Tab wrap last → first).
        // Each is a no-op when the widget is already visible. We call
        // keepVisibleAtEnd first so that keepVisibleAtStart gets the final
        // say — ensuring the top of the widget is shown when it's taller
        // than the viewport.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _focusNode.hasFocus) {
            Scrollable.ensureVisible(
              context,
              alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
            );
            Scrollable.ensureVisible(
              context,
              alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
            );
          }
        });
      }
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasInteractions = widget.onTap != null ||
        widget.onLongPress != null ||
        widget.onDoubleTap != null;

    Widget childWidget;
    if (widget.builder != null) {
      // Builder mode: pass focus node to builder
      childWidget = widget.builder!(_focusNode);
    } else if (hasInteractions) {
      // Child mode with interactions: wrap in InkWell
      childWidget = InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        focusNode: _focusNode,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onDoubleTap: widget.onDoubleTap,
        child: widget.child!,
      );
    } else {
      // Child mode without interactions: just use child
      childWidget = widget.child!;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: _hasFocus ? widget.padding : null,
      decoration: BoxDecoration(
        border: _hasFocus ? widget.border : null,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
      ),
      child: childWidget,
    );
  }
}
