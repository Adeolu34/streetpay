import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_bar_item_model.dart';
export 'bottom_bar_item_model.dart';

class BottomBarItemWidget extends StatefulWidget {
  const BottomBarItemWidget({
    super.key,
    required this.text,
    required this.icon,
  });

  final String? text;
  final Widget? icon;

  @override
  State<BottomBarItemWidget> createState() => _BottomBarItemWidgetState();
}

class _BottomBarItemWidgetState extends State<BottomBarItemWidget> {
  late BottomBarItemModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BottomBarItemModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.0,
      height: 56.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget.icon!,
          Text(
            valueOrDefault<String>(
              widget.text,
              '[text]',
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
          ),
        ],
      ),
    );
  }
}
