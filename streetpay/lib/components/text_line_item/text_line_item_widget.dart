import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'text_line_item_model.dart';
export 'text_line_item_model.dart';

class TextLineItemWidget extends StatefulWidget {
  const TextLineItemWidget({
    super.key,
    String? label,
    String? value,
  })  : this.label = label ?? '[label]',
        this.value = value ?? '[value]';

  final String label;
  final String value;

  @override
  State<TextLineItemWidget> createState() => _TextLineItemWidgetState();
}

class _TextLineItemWidgetState extends State<TextLineItemWidget> {
  late TextLineItemModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TextLineItemModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.normal,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                color: Color(0xFFC4C4C4),
                fontSize: 12.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.normal,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
        ),
        Flexible(
          child: Text(
            widget.value,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
          ),
        ),
      ],
    );
  }
}
