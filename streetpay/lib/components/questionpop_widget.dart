import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'questionpop_model.dart';
export 'questionpop_model.dart';

class QuestionpopWidget extends StatefulWidget {
  const QuestionpopWidget({
    super.key,
    this.timer,
    required this.playamount,
  });

  final int? timer;
  final String? playamount;

  @override
  State<QuestionpopWidget> createState() => _QuestionpopWidgetState();
}

class _QuestionpopWidgetState extends State<QuestionpopWidget> {
  late QuestionpopModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QuestionpopModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.streetauth = await StreetauthCall.call();
    });
  }

  @override
  void dispose() {
    // On component dispose action.
    () async {
      if (FFAppState().questionid.length == 5) {
        _model.playquiz = await PlayquizCall.call(
          userphone: FFAppState().phonenumber,
          accessToken: StreetauthCall.streettoken(
            (_model.streetauth?.jsonBody ?? ''),
          ),
          sessionID: random_data.randomString(
            10,
            18,
            true,
            false,
            false,
          ),
          playamount: widget.playamount,
          paymentref: random_data.randomString(
            10,
            18,
            true,
            false,
            false,
          ),
          qidList: FFAppState().questionid,
          useroptionList: FFAppState().answerspicked,
          correctoptionsList: FFAppState().correctanswer,
          totalscore: FFAppState().totalcorrect,
          duration: widget.timer?.toDouble(),
        );

        Navigator.pop(context);

        context.pushNamed(
          ResultsummaryWidget.routeName,
          queryParameters: {
            'timer': serializeParam(
              widget.timer?.toString(),
              ParamType.String,
            ),
            'totalcorrect': serializeParam(
              FFAppState().totalcorrect,
              ParamType.int,
            ),
            'useroption': serializeParam(
              functions.stringtolist(PlayquizCall.useroption(
                (_model.playquiz?.jsonBody ?? ''),
              )!),
              ParamType.String,
              isList: true,
            ),
            'correctoption': serializeParam(
              functions.stringtolist(PlayquizCall.correctoption(
                (_model.playquiz?.jsonBody ?? ''),
              )!),
              ParamType.String,
              isList: true,
            ),
            'position': serializeParam(
              PlayquizCall.finalposition(
                (_model.playquiz?.jsonBody ?? ''),
              )?.toString(),
              ParamType.String,
            ),
          }.withoutNulls,
        );
      } else {
        _model.question2 = await GetlottoquestionCall.call(
          phoneno: FFAppState().phonenumber,
          accessToken: StreetauthCall.streettoken(
            (_model.streetauth?.jsonBody ?? ''),
          ),
        );

        FFAppState().questionjson = GetlottoquestionCall.questionjson(
          (_model.question22?.jsonBody ?? ''),
        );
        FFAppState().correctans = GetlottoquestionCall.correct(
          (_model.question22?.jsonBody ?? ''),
        )!;
        FFAppState().addToCorrectanswer(GetlottoquestionCall.correct(
          (_model.question22?.jsonBody ?? ''),
        )!);
        safeSetState(() {});
        FFAppState().isselect = false;
        safeSetState(() {});
        FFAppState().addToListofquestion(GetlottoquestionCall.question(
          (_model.question22?.jsonBody ?? ''),
        )!);
        FFAppState().addToQuestionid(GetlottoquestionCall.questionid(
          (_model.question22?.jsonBody ?? ''),
        )!);
        safeSetState(() {});
        if (FFAppState().correctanswer.lastOrNull ==
            FFAppState().answerspicked.lastOrNull) {
          FFAppState().totalcorrect = FFAppState().totalcorrect + 1;
          safeSetState(() {});
        }
        Navigator.pop(context);
      }
    }();

    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x1A000000),
              offset: Offset(
                0.0,
                2.0,
              ),
              spreadRadius: 0.0,
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Color(0xFFE0E3E7),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Answer',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(6.0, 12.0, 6.0, 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE6F4EA),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          FFAppState().correctanswer.lastOrNull ==
                                  FFAppState().answerspicked.lastOrNull
                              ? 'Correct'
                              : 'Incorrect',
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .fontStyle,
                                ),
                                color: FFAppState().correctanswer.lastOrNull ==
                                        FFAppState().answerspicked.lastOrNull
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).secondary,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            FFAppState().answerspicked.lastOrNull,
                            '- - -',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .fontStyle,
                              ),
                        ),
                        Text(
                          'Your selected answer',
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.check_circle,
                    color: FFAppState().correctanswer.lastOrNull ==
                            FFAppState().answerspicked.lastOrNull
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).secondary,
                    size: 28.0,
                  ),
                ].divide(SizedBox(width: 12.0)),
              ),
              Container(
                width: double.infinity,
                height: 1.0,
                decoration: BoxDecoration(
                  color: Color(0xFFE0E3E7),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            FFAppState().correctanswer.lastOrNull,
                            '- - -',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .fontStyle,
                              ),
                        ),
                        Text(
                          'Correct answer',
                          style:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF34A853),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.check_circle,
                    color: Color(0xFF34A853),
                    size: 28.0,
                  ),
                ].divide(SizedBox(width: 12.0)),
              ),
              FFButtonWidget(
                onPressed: () async {
                  if (FFAppState().questionid.length == 5) {
                    _model.playquiz1 = await PlayquizCall.call(
                      userphone: FFAppState().phonenumber,
                      accessToken: StreetauthCall.streettoken(
                        (_model.streetauth?.jsonBody ?? ''),
                      ),
                      sessionID: random_data.randomString(
                        10,
                        18,
                        true,
                        false,
                        false,
                      ),
                      playamount: widget.playamount,
                      paymentref: random_data.randomString(
                        10,
                        18,
                        true,
                        false,
                        false,
                      ),
                      qidList: FFAppState().questionid,
                      useroptionList: FFAppState().answerspicked,
                      correctoptionsList: FFAppState().correctanswer,
                      totalscore: FFAppState().totalcorrect,
                      duration: widget.timer?.toDouble(),
                    );

                    Navigator.pop(context);

                    context.pushNamed(
                      ResultsummaryWidget.routeName,
                      queryParameters: {
                        'timer': serializeParam(
                          widget.timer?.toString(),
                          ParamType.String,
                        ),
                        'totalcorrect': serializeParam(
                          FFAppState().totalcorrect,
                          ParamType.int,
                        ),
                        'useroption': serializeParam(
                          functions.stringtolist(PlayquizCall.useroption(
                            (_model.playquiz1?.jsonBody ?? ''),
                          )!),
                          ParamType.String,
                          isList: true,
                        ),
                        'correctoption': serializeParam(
                          functions.stringtolist(PlayquizCall.correctoption(
                            (_model.playquiz1?.jsonBody ?? ''),
                          )!),
                          ParamType.String,
                          isList: true,
                        ),
                        'position': serializeParam(
                          PlayquizCall.finalposition(
                            (_model.playquiz1?.jsonBody ?? ''),
                          )?.toString(),
                          ParamType.String,
                        ),
                      }.withoutNulls,
                    );
                  } else {
                    _model.question22 = await GetlottoquestionCall.call(
                      phoneno: FFAppState().phonenumber,
                      accessToken: StreetauthCall.streettoken(
                        (_model.streetauth?.jsonBody ?? ''),
                      ),
                    );

                    FFAppState().questionjson =
                        GetlottoquestionCall.questionjson(
                      (_model.question22?.jsonBody ?? ''),
                    );
                    FFAppState().correctans = GetlottoquestionCall.correct(
                      (_model.question22?.jsonBody ?? ''),
                    )!;
                    FFAppState()
                        .addToCorrectanswer(GetlottoquestionCall.correct(
                      (_model.question22?.jsonBody ?? ''),
                    )!);
                    safeSetState(() {});
                    FFAppState().isselect = false;
                    safeSetState(() {});
                    FFAppState()
                        .addToListofquestion(GetlottoquestionCall.question(
                      (_model.question22?.jsonBody ?? ''),
                    )!);
                    FFAppState()
                        .addToQuestionid(GetlottoquestionCall.questionid(
                      (_model.question22?.jsonBody ?? ''),
                    )!);
                    safeSetState(() {});
                    if (FFAppState().correctanswer.lastOrNull ==
                        FFAppState().answerspicked.lastOrNull) {
                      FFAppState().totalcorrect = FFAppState().totalcorrect + 1;
                      safeSetState(() {});
                    }
                    Navigator.pop(context);
                  }

                  safeSetState(() {});
                },
                text: 'Next',
                options: FFButtonOptions(
                  width: 350.0,
                  height: 40.0,
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: Colors.white,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ].divide(SizedBox(height: 12.0)),
          ),
        ),
      ),
    );
  }
}
