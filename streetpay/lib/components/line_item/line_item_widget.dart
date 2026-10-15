import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'line_item_model.dart';
export 'line_item_model.dart';

class LineItemWidget extends StatefulWidget {
  const LineItemWidget({
    super.key,
    String? title,
    String? subtitle,
  })  : this.title = title ?? '[title]',
        this.subtitle = subtitle ?? '[subtitle]';

  final String title;
  final String subtitle;

  @override
  State<LineItemWidget> createState() => _LineItemWidgetState();
}

class _LineItemWidgetState extends State<LineItemWidget> {
  late LineItemModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LineItemModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          textAlign: TextAlign.start,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                fontSize: 12.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
        ),
        Text(
          widget.subtitle,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).primary,
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
        ),
      ],
    );
  }
}
