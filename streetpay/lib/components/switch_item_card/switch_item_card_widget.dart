import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'switch_item_card_model.dart';
export 'switch_item_card_model.dart';

class SwitchItemCardWidget extends StatefulWidget {
  const SwitchItemCardWidget({
    super.key,
    String? text,
    required this.icon,
  }) : this.text = text ?? '[text]';

  final String text;
  final Widget? icon;

  @override
  State<SwitchItemCardWidget> createState() => _SwitchItemCardWidgetState();
}

class _SwitchItemCardWidgetState extends State<SwitchItemCardWidget> {
  late SwitchItemCardModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SwitchItemCardModel());

    _model.switchValue = true;
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
              Switch.adaptive(
                value: _model.switchValue!,
                onChanged: (newValue) async {
                  safeSetState(() => _model.switchValue = newValue);
                },
                activeColor: FlutterFlowTheme.of(context).primary,
                activeTrackColor: FlutterFlowTheme.of(context).primary,
                inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
                inactiveThumbColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
