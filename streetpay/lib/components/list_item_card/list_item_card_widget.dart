import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'list_item_card_model.dart';
export 'list_item_card_model.dart';

class ListItemCardWidget extends StatefulWidget {
  const ListItemCardWidget({
    super.key,
    String? text,
    required this.icon,
  }) : this.text = text ?? '[text]';

  final String text;
  final Widget? icon;

  @override
  State<ListItemCardWidget> createState() => _ListItemCardWidgetState();
}

class _ListItemCardWidgetState extends State<ListItemCardWidget> {
  late ListItemCardModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListItemCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 336.0,
      height: 54.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Padding(
          padding: EdgeInsets.all(14.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.icon!,
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                child: Text(
                  widget.text,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ),
              Spacer(),
              FaIcon(
                FontAwesomeIcons.angleRight,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
