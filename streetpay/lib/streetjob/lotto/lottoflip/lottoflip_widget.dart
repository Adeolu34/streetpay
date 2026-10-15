import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'lottoflip_model.dart';
export 'lottoflip_model.dart';

class LottoflipWidget extends StatefulWidget {
  const LottoflipWidget({
    super.key,
    required this.selectedplan,
    required this.paymentref,
  });

  final String? selectedplan;
  final String? paymentref;

  static String routeName = 'lottoflip';
  static String routePath = '/lottoflip';

  @override
  State<LottoflipWidget> createState() => _LottoflipWidgetState();
}

class _LottoflipWidgetState extends State<LottoflipWidget>
    with TickerProviderStateMixin {
  late LottoflipModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LottoflipModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.streetauth = await StreetauthCall.call();

      FFAppState().lottonumbers = [];
      safeSetState(() {});
    });

    animationsMap.addAll({
      'buttonOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 600.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(1.2, 1.2),
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 600.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(1.2, 1.2),
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 600.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(1.2, 1.2),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () async {
                context.pushNamed(LottohomeWidget.routeName);
              },
            ),
            title: Text(
              'Lucky Flip',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 2.0,
          ),
          body: SafeArea(
            top: true,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  child: SingleChildScrollView(
                    controller: _model.columnController,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x10000000),
                                  offset: Offset(
                                    0.0,
                                    2.0,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Flip a card to reveal your lucky number!',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    'Flip the 3 or 2 or just 1, odd numbers will subtract, even numbers will add.',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FFButtonWidget(
                                        onPressed: (_model.randddd != null)
                                            ? null
                                            : () async {
                                                _model.number =
                                                    await GetlottonumberCall
                                                        .call(
                                                  playedamount: '1000',
                                                  accessToken: StreetauthCall
                                                      .streettoken(
                                                    (_model.streetauth
                                                            ?.jsonBody ??
                                                        ''),
                                                  ),
                                                );

                                                _model.randddd =
                                                    await actions.buttondisable(
                                                  GetlottonumberCall.number(
                                                    (_model.number?.jsonBody ??
                                                        ''),
                                                  ),
                                                );
                                                if (animationsMap[
                                                        'buttonOnActionTriggerAnimation1'] !=
                                                    null) {
                                                  await animationsMap[
                                                          'buttonOnActionTriggerAnimation1']!
                                                      .controller
                                                      .forward(from: 0.0);
                                                }
                                                FFAppState().addToLottonumbers(
                                                    _model.randddd!);
                                                safeSetState(() {});

                                                safeSetState(() {});
                                              },
                                        text: _model.randddd == null
                                            ? 'Press'
                                            : _model.randddd!.toString(),
                                        options: FFButtonOptions(
                                          height: 70.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          disabledColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                          disabledTextColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                        ),
                                      ).animateOnActionTrigger(
                                        animationsMap[
                                            'buttonOnActionTriggerAnimation1']!,
                                      ),
                                      FFButtonWidget(
                                        onPressed: (_model.randddd1 != null)
                                            ? null
                                            : () async {
                                                _model.number1 =
                                                    await GetlottonumberCall
                                                        .call(
                                                  playedamount: '1000',
                                                  accessToken: StreetauthCall
                                                      .streettoken(
                                                    (_model.streetauth
                                                            ?.jsonBody ??
                                                        ''),
                                                  ),
                                                );

                                                _model.randddd1 =
                                                    await actions.buttondisable(
                                                  GetlottonumberCall.number(
                                                    (_model.number1?.jsonBody ??
                                                        ''),
                                                  ),
                                                );
                                                if (animationsMap[
                                                        'buttonOnActionTriggerAnimation2'] !=
                                                    null) {
                                                  await animationsMap[
                                                          'buttonOnActionTriggerAnimation2']!
                                                      .controller
                                                      .forward(from: 0.0);
                                                }
                                                FFAppState().addToLottonumbers(
                                                    GetlottonumberCall.number(
                                                  (_model.number1?.jsonBody ??
                                                      ''),
                                                )!);
                                                safeSetState(() {});

                                                safeSetState(() {});
                                              },
                                        text: _model.randddd1 == null
                                            ? 'Press'
                                            : _model.randddd1!.toString(),
                                        options: FFButtonOptions(
                                          height: 70.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          disabledColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                          disabledTextColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                        ),
                                      ).animateOnActionTrigger(
                                        animationsMap[
                                            'buttonOnActionTriggerAnimation2']!,
                                      ),
                                      FFButtonWidget(
                                        onPressed: (_model.randddd2 != null)
                                            ? null
                                            : () async {
                                                _model.number2 =
                                                    await GetlottonumberCall
                                                        .call(
                                                  playedamount: '1000',
                                                  accessToken: StreetauthCall
                                                      .streettoken(
                                                    (_model.streetauth
                                                            ?.jsonBody ??
                                                        ''),
                                                  ),
                                                );

                                                _model.randddd2 =
                                                    await actions.buttondisable(
                                                  GetlottonumberCall.number(
                                                    (_model.number2?.jsonBody ??
                                                        ''),
                                                  ),
                                                );
                                                if (animationsMap[
                                                        'buttonOnActionTriggerAnimation3'] !=
                                                    null) {
                                                  await animationsMap[
                                                          'buttonOnActionTriggerAnimation3']!
                                                      .controller
                                                      .forward(from: 0.0);
                                                }
                                                FFAppState().addToLottonumbers(
                                                    _model.randddd2!);
                                                safeSetState(() {});

                                                safeSetState(() {});
                                              },
                                        text: _model.randddd2 == null
                                            ? 'Press'
                                            : _model.randddd2!.toString(),
                                        options: FFButtonOptions(
                                          height: 70.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          disabledColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                          disabledTextColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                        ),
                                      ).animateOnActionTrigger(
                                        animationsMap[
                                            'buttonOnActionTriggerAnimation3']!,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Your Result',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          Text(
                                            valueOrDefault<String>(
                                              functions
                                                  .sumguess(FFAppState()
                                                      .lottonumbers
                                                      .toList())
                                                  .toString(),
                                              '0',
                                            ),
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .headlineLarge
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineLarge
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineLarge
                                                          .fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () async {
                                      _model.apiResult4z3 =
                                          await PlaysumCall.call(
                                        userphone: FFAppState().phonenumber,
                                        no1: FFAppState()
                                            .lottonumbers
                                            .firstOrNull
                                            ?.toString(),
                                        accessToken: StreetauthCall.streettoken(
                                          (_model.streetauth?.jsonBody ?? ''),
                                        ),
                                        sessionref: random_data.randomString(
                                          10,
                                          18,
                                          true,
                                          false,
                                          false,
                                        ),
                                        paymentref: random_data.randomString(
                                          10,
                                          18,
                                          true,
                                          false,
                                          false,
                                        ),
                                        planamount: widget.selectedplan,
                                        no2: FFAppState()
                                            .lottonumbers
                                            .elementAtOrNull(1)
                                            ?.toString(),
                                        no3: FFAppState()
                                            .lottonumbers
                                            .lastOrNull
                                            ?.toString(),
                                      );

                                      context.pushNamed(
                                          HistoryflipWidget.routeName);

                                      safeSetState(() {});
                                    },
                                    text: 'Submit',
                                    options: FFButtonOptions(
                                      width: 200.0,
                                      height: 50.0,
                                      padding: EdgeInsets.all(8.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 2.0,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 24.0)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 32.0, 0.0, 0.0),
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Game Rules:',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Text(
                                    '• Each card reveals a random number',
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                Text(
                                  '• Once a card is flipped, it cannot be selected again',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(height: 8.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
