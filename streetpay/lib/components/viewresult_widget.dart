import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'viewresult_model.dart';
export 'viewresult_model.dart';

class ViewresultWidget extends StatefulWidget {
  const ViewresultWidget({super.key});

  @override
  State<ViewresultWidget> createState() => _ViewresultWidgetState();
}

class _ViewresultWidgetState extends State<ViewresultWidget> {
  late ViewresultModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewresultModel());
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
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 4.0,
                color: Color(0x33000000),
                offset: Offset(
                  0.0,
                  2.0,
                ),
                spreadRadius: 0.0,
              )
            ],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Awaiting Results',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontStyle,
                        ),
                        color: Color(0xFF1E8449),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                ),
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8.0,
                        color: Color(0x331E8449),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                        spreadRadius: 0.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.network(
                      'https://plus.unsplash.com/premium_photo-1723759401659-7984c69b1b18?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8aW4lMjBwcm9ncmVzc3xlbnwwfHwwfHx8MA%3D%3D',
                      width: 120.0,
                      height: 120.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  'Your ticket has been registered!',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: GoogleFonts.inter(
                          fontWeight:
                              FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF1E8449),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x331E8449),
                            offset: Offset(
                              0.0,
                              2.0,
                            ),
                            spreadRadius: 0.0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '12',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF1E8449),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x331E8449),
                            offset: Offset(
                              0.0,
                              2.0,
                            ),
                            spreadRadius: 0.0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '24',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ].divide(SizedBox(width: 16.0)),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    context.pushNamed(
                      LotteryWidget.routeName,
                      queryParameters: {
                        'gametype': serializeParam(
                          'quiz',
                          ParamType.String,
                        ),
                      }.withoutNulls,
                    );
                  },
                  text: 'Notify Me When Results Are In',
                  icon: Icon(
                    Icons.notifications_active,
                    size: 15.0,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    padding: EdgeInsets.all(8.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconColor: Colors.white,
                    color: Color(0xFF1E8449),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ].divide(SizedBox(height: 24.0)),
            ),
          ),
        ),
      ),
    );
  }
}
