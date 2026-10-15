import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'no_icon_bottom_bar_item_model.dart';
export 'no_icon_bottom_bar_item_model.dart';

class NoIconBottomBarItemWidget extends StatefulWidget {
  const NoIconBottomBarItemWidget({
    super.key,
    String? text,
  }) : this.text = text ?? '[text]';

  final String text;

  @override
  State<NoIconBottomBarItemWidget> createState() =>
      _NoIconBottomBarItemWidgetState();
}

class _NoIconBottomBarItemWidgetState extends State<NoIconBottomBarItemWidget> {
  late NoIconBottomBarItemModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NoIconBottomBarItemModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Container(
        width: 56.0,
        height: 56.0,
        decoration: BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
