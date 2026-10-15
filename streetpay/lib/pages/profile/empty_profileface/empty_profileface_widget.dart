import '/backend/api_requests/api_calls.dart';
import '/components/errorcomp_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'empty_profileface_model.dart';
export 'empty_profileface_model.dart';

class EmptyProfilefaceWidget extends StatefulWidget {
  const EmptyProfilefaceWidget({
    super.key,
    required this.phoneno,
    this.registerwith,
    this.photos,
  });

  final String? phoneno;
  final String? registerwith;
  final FFUploadedFile? photos;

  static String routeName = 'EmptyProfileface';
  static String routePath = '/emptyProfileface';

  @override
  State<EmptyProfilefaceWidget> createState() => _EmptyProfilefaceWidgetState();
}

class _EmptyProfilefaceWidgetState extends State<EmptyProfilefaceWidget> {
  late EmptyProfilefaceModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmptyProfilefaceModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.apiResultala = await StreetauthCall.call();

      if ((_model.apiResultala?.succeeded ?? true)) {
        FFAppState().bsptoken = StreetauthCall.streettoken(
          (_model.apiResultala?.jsonBody ?? ''),
        )!;
        safeSetState(() {});
      }
    });

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
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
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(18.0, 0.0, 0.0, 0.0),
              child: FlutterFlowIconButton(
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
                  context.pop();
                },
              ),
            ),
            actions: [],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(70.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 48.0, 0.0),
                            child: Container(
                              width: 70.0,
                              height: 34.0,
                              decoration: BoxDecoration(
                                color: Color(0xFF7FC014),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'Tier 0',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.phoneno!,
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            elevation: 2.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                primary: false,
                controller: _model.columnController,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 30.0),
                      child: Text(
                        'Personal Details',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.textController1,
                          focusNode: _model.textFieldFocusNode1,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.textController1',
                            Duration(milliseconds: 2000),
                            () async {
                              _model.isvaliad = await actions.isValidSingleWord(
                                _model.textController1.text,
                                _model.textController1.text,
                              );
                              if (!_model.isvaliad!) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Only one word is allowed',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                );
                              }

                              safeSetState(() {});
                            },
                          ),
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                            hintText: 'Enter your ${widget.registerwith}',
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFFC4C4C4),
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context)
                                .primaryBackground,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    lineHeight: 2.0,
                                  ),
                          keyboardType: TextInputType.number,
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          validator: _model.textController1Validator
                              .asValidator(context),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.textController2,
                          focusNode: _model.textFieldFocusNode2,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                            hintText: 'Enter your email',
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFFC4C4C4),
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context)
                                .primaryBackground,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    lineHeight: 2.0,
                                  ),
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          validator: _model.textController2Validator
                              .asValidator(context),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          _model.streetauth = await StreetauthCall.call();

                          _model.compressed = await actions.newCustomAction2(
                            widget.photos,
                          );
                          if (widget.registerwith == 'BVN') {
                            _model.facelook = await FaceverifyCall.call(
                              accessToken: FFAppState().bsptoken,
                              selfie: _model.compressed,
                              idtype: widget.registerwith,
                              idNumber: _model.textController1.text,
                            );

                            if (FaceverifyCall.match(
                                  (_model.facelook?.jsonBody ?? ''),
                                ) ==
                                true) {
                              _model.waasopen = await WassopenCall.call(
                                accessToken: StreetauthCall.streettoken(
                                  (_model.streetauth?.jsonBody ?? ''),
                                ),
                                bvn: _model.textController1.text,
                                dob: functions.formatdob(
                                    (_model.facelook?.jsonBody ?? '')),
                                gender: () {
                                  if (FaceverifyCall.gender(
                                        (_model.facelook?.jsonBody ?? ''),
                                      ) ==
                                      'Male') {
                                    return 1;
                                  } else if (FaceverifyCall.gender(
                                        (_model.facelook?.jsonBody ?? ''),
                                      ) ==
                                      'Famale') {
                                    return 2;
                                  } else {
                                    return 0;
                                  }
                                }(),
                                lastname: FaceverifyCall.lastname(
                                  (_model.facelook?.jsonBody ?? ''),
                                ),
                                phone: FaceverifyCall.phoneno(
                                  (_model.facelook?.jsonBody ?? ''),
                                ),
                                othername: FaceverifyCall.middlename(
                                  (_model.facelook?.jsonBody ?? ''),
                                ),
                                tracking: random_data.randomString(
                                  15,
                                  18,
                                  true,
                                  false,
                                  false,
                                ),
                                email: _model.textController2.text,
                              );

                              if (WassopenCall.status(
                                    (_model.waasopen?.jsonBody ?? ''),
                                  ) ==
                                  'SUCCESS') {
                                _model.insertintotierone1 =
                                    await InsertintotieroneCall.call(
                                  phoneno: functions
                                      .removecode(FaceverifyCall.phoneno(
                                    (_model.facelook?.jsonBody ?? ''),
                                  )!),
                                  surname: FaceverifyCall.lastname(
                                    (_model.facelook?.jsonBody ?? ''),
                                  ),
                                  othernames: FaceverifyCall.middlename(
                                    (_model.facelook?.jsonBody ?? ''),
                                  ),
                                  dob: FaceverifyCall.dob(
                                    (_model.facelook?.jsonBody ?? ''),
                                  ).toString(),
                                  gender: FaceverifyCall.gender(
                                    (_model.facelook?.jsonBody ?? ''),
                                  ),
                                  accessToken: FFAppState().bsptoken,
                                  useremail: _model.textController2.text,
                                  bvn: _model.textController1.text,
                                );

                                if (InsertintotieroneCall.status(
                                  (_model.insertintotierone1?.jsonBody ?? ''),
                                )!) {
                                  _model.createid1 = await CreateNewIdCall.call(
                                    accessToken: FFAppState().bsptoken,
                                    phoneno: functions
                                        .removecode(FaceverifyCall.phoneno(
                                      (_model.facelook?.jsonBody ?? ''),
                                    )!),
                                    accountno: WassopenCall.accountno(
                                      (_model.waasopen?.jsonBody ?? ''),
                                    ),
                                    customerno: WassopenCall.custormerid(
                                      (_model.waasopen?.jsonBody ?? ''),
                                    ),
                                  );

                                  if (CreateNewIdCall.status(
                                        (_model.createid1?.jsonBody ?? ''),
                                      ) ==
                                      true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          WassopenCall.message(
                                            (_model.waasopen?.jsonBody ?? ''),
                                          )!,
                                          style: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                      ),
                                    );

                                    context.pushNamed(
                                      QuestionaireWidget.routeName,
                                      queryParameters: {
                                        'phone': serializeParam(
                                          functions
                                              .removecode(widget.phoneno!),
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );

                                    FFAppState().accountno =
                                        WassopenCall.accountno(
                                      (_model.waasopen?.jsonBody ?? ''),
                                    )!;
                                    FFAppState().tier = '1';
                                    FFAppState().phonenumber =
                                        functions.removecode(widget.phoneno!)!;
                                    FFAppState().walletid =
                                        CreateNewIdCall.message(
                                      (_model.createid1?.jsonBody ?? ''),
                                    )!;
                                    FFAppState().bvn =
                                        _model.textController1.text;
                                    FFAppState().accountname =
                                        WassopenCall.accountname(
                                      (_model.waasopen?.jsonBody ?? ''),
                                    )!;
                                    FFAppState().email =
                                        _model.textController2.text;
                                    FFAppState().avalbal = '0.00';
                                    safeSetState(() {});
                                  } else {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: false,
                                      context: context,
                                      builder: (context) {
                                        return WebViewAware(
                                          child: GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: ErrorcompWidget(
                                                message: WassopenCall.message(
                                                  (_model.waasopen?.jsonBody ??
                                                      ''),
                                                )!,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((value) => safeSetState(() {}));
                                  }
                                } else {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return WebViewAware(
                                        child: GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: ErrorcompWidget(
                                              message:
                                                  InsertintotieroneCall.message(
                                                (_model.insertintotierone1
                                                        ?.jsonBody ??
                                                    ''),
                                              )!,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));
                                }
                              } else {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return WebViewAware(
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: ErrorcompWidget(
                                            message: WassopenCall.message(
                                              (_model.waasopen?.jsonBody ?? ''),
                                            )!,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              }
                            } else {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                enableDrag: false,
                                context: context,
                                builder: (context) {
                                  return WebViewAware(
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: ErrorcompWidget(
                                          message: FaceverifyCall.message(
                                            (_model.facelook?.jsonBody ?? ''),
                                          )!,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));

                              context.pushNamed(SignUpWidget.routeName);
                            }
                          } else {
                            if (widget.registerwith == 'NIN') {
                              _model.facelook2 = await FaceverifyCall.call(
                                accessToken: FFAppState().bsptoken,
                                selfie: _model.compressed,
                                idtype: widget.registerwith,
                                idNumber: _model.textController1.text,
                              );

                              if (FaceverifyCall.match(
                                    (_model.facelook2?.jsonBody ?? ''),
                                  ) ==
                                  true) {
                                _model.openwallet = await WalletAsAServiceGroup
                                    .openwalletCall
                                    .call(
                                  dob: functions.formatdob(
                                      (_model.facelook2?.jsonBody ?? '')),
                                  gender: () {
                                    if (FaceverifyCall.gender(
                                          (_model.facelook2?.jsonBody ?? ''),
                                        ) ==
                                        'Male') {
                                      return 1;
                                    } else if (FaceverifyCall.gender(
                                          (_model.facelook2?.jsonBody ?? ''),
                                        ) ==
                                        'Female') {
                                      return 2;
                                    } else {
                                      return 0;
                                    }
                                  }(),
                                  lastName: FaceverifyCall.lastname(
                                    (_model.facelook2?.jsonBody ?? ''),
                                  ),
                                  otherName: FaceverifyCall.middlename(
                                    (_model.facelook2?.jsonBody ?? ''),
                                  ),
                                  phoneNo:
                                      functions.addcode(FaceverifyCall.phoneno(
                                    (_model.facelook2?.jsonBody ?? ''),
                                  )),
                                  transactionTrackingRef:
                                      random_data.randomString(
                                    6,
                                    12,
                                    true,
                                    false,
                                    false,
                                  ),
                                  accountName: '${FaceverifyCall.lastname(
                                    (_model.facelook2?.jsonBody ?? ''),
                                  )} ${FaceverifyCall.middlename(
                                    (_model.facelook2?.jsonBody ?? ''),
                                  )} ${FaceverifyCall.lastname(
                                    (_model.facelook2?.jsonBody ?? ''),
                                  )}',
                                  email: _model.textController2.text,
                                  authToken: StreetauthCall.streettoken(
                                    (_model.streetauth?.jsonBody ?? ''),
                                  ),
                                  ninUserId: 'ABSSEF-0123',
                                  nationalIdentityNo:
                                      _model.textController1.text,
                                );

                                if (WalletAsAServiceGroup.openwalletCall.status(
                                      (_model.openwallet?.jsonBody ?? ''),
                                    ) ==
                                    'SUCCESS') {
                                  _model.insertintotierone =
                                      await InsertintotieroneCall.call(
                                    phoneno: widget.phoneno,
                                    surname: FaceverifyCall.lastname(
                                      (_model.facelook2?.jsonBody ?? ''),
                                    ),
                                    othernames: FaceverifyCall.middlename(
                                      (_model.facelook2?.jsonBody ?? ''),
                                    ),
                                    dob: FaceverifyCall.dob(
                                      (_model.facelook2?.jsonBody ?? ''),
                                    ).toString(),
                                    gender: FaceverifyCall.gender(
                                      (_model.facelook2?.jsonBody ?? ''),
                                    ),
                                    accessToken: FFAppState().bsptoken,
                                    useremail: _model.textController2.text,
                                  );

                                  if (InsertintotieroneCall.status(
                                        (_model.insertintotierone?.jsonBody ??
                                            ''),
                                      ) ==
                                      true) {
                                    _model.createid =
                                        await CreateNewIdCall.call(
                                      phoneno: widget.phoneno,
                                      accountno: WalletAsAServiceGroup
                                          .openwalletCall
                                          .accountno(
                                        (_model.openwallet?.jsonBody ?? ''),
                                      ),
                                      customerno: WalletAsAServiceGroup
                                          .openwalletCall
                                          .customerid(
                                        (_model.openwallet?.jsonBody ?? ''),
                                      ),
                                      accessToken: FFAppState().bsptoken,
                                    );

                                    if (CreateNewIdCall.status(
                                          (_model.createid?.jsonBody ?? ''),
                                        ) ==
                                        true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            WalletAsAServiceGroup.openwalletCall
                                                .message(
                                              (_model.openwallet?.jsonBody ??
                                                  ''),
                                            )!,
                                            style: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                        ),
                                      );

                                      context.pushNamed(
                                        QuestionaireWidget.routeName,
                                        queryParameters: {
                                          'phone': serializeParam(
                                            functions
                                                .removecode(widget.phoneno!),
                                            ParamType.String,
                                          ),
                                        }.withoutNulls,
                                      );

                                      FFAppState().accountno =
                                          WalletAsAServiceGroup.openwalletCall
                                              .accountno(
                                        (_model.openwallet?.jsonBody ?? ''),
                                      )!;
                                      FFAppState().tier = '';
                                      FFAppState().phonenumber = functions
                                          .removecode(widget.phoneno!)!;
                                      FFAppState().accountname =
                                          WalletAsAServiceGroup.openwalletCall
                                              .fullname(
                                        (_model.openwallet?.jsonBody ?? ''),
                                      )!;
                                      FFAppState().email =
                                          _model.textController2.text;
                                      FFAppState().walletid =
                                          CreateNewIdCall.message(
                                        (_model.createid?.jsonBody ?? ''),
                                      )!;
                                      FFAppState().avalbal = '0.00';
                                      safeSetState(() {});
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            CreateNewIdCall.message(
                                              (_model.createid?.jsonBody ?? ''),
                                            )!,
                                            style: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          InsertintotieroneCall.message(
                                            (_model.insertintotierone
                                                    ?.jsonBody ??
                                                ''),
                                          )!,
                                          style: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .secondary,
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        WalletAsAServiceGroup.openwalletCall
                                            .message(
                                          (_model.openwallet?.jsonBody ?? ''),
                                        )!,
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 4000),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondary,
                                    ),
                                  );
                                }
                              } else {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return WebViewAware(
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: ErrorcompWidget(
                                            message: FaceverifyCall.message(
                                              (_model.facelook2?.jsonBody ??
                                                  ''),
                                            )!,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              }
                            }
                          }

                          safeSetState(() {});
                        },
                        text: 'Open a Wallet Account',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: Color(0xFFFF2455),
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
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
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
