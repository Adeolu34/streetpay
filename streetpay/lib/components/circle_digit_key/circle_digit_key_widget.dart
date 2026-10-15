import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'circle_digit_key_model.dart';
export 'circle_digit_key_model.dart';

class CircleDigitKeyWidget extends StatefulWidget {
  const CircleDigitKeyWidget({
    super.key,
    int? digit,
  }) : this.digit = digit ?? 1;

  final int digit;

  @override
  State<CircleDigitKeyWidget> createState() => _CircleDigitKeyWidgetState();
}

class _CircleDigitKeyWidgetState extends State<CircleDigitKeyWidget> {
  late CircleDigitKeyModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CircleDigitKeyModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58.0,
      height: 58.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryText,
        ),
      ),
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Text(
          valueOrDefault<String>(
            widget.digit.toString(),
            '1',
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                fontSize: 20.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
        ),
      ),
    );
  }
}
