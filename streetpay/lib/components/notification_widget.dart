import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notification_model.dart';
export 'notification_model.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({
    super.key,
    required this.count,
  });

  final int? count;

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late NotificationModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Container(
        width: 40.0,
        height: 40.0,
        child: Stack(
          children: [
            Icon(
              Icons.security,
              color: FlutterFlowTheme.of(context).primary,
              size: 30.0,
            ),
            Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).error,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3.0,
                        color: Color(0x33000000),
                        offset: Offset(
                          0.0,
                          1.0,
                        ),
                        spreadRadius: 0.0,
                      )
                    ],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    valueOrDefault<String>(
                      widget.count?.toString(),
                      '0',
                    ),
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).labelSmall.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelSmall
                                .fontStyle,
                          ),
                          color: Colors.white,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).labelSmall.fontStyle,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
