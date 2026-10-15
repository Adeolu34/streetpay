import '/backend/api_requests/api_calls.dart';
import '/components/errorcomp_widget.dart';
import '/components/pinverify_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'createcuopun_model.dart';
export 'createcuopun_model.dart';

class CreatecuopunWidget extends StatefulWidget {
  const CreatecuopunWidget({super.key});

  @override
  State<CreatecuopunWidget> createState() => _CreatecuopunWidgetState();
}

class _CreatecuopunWidgetState extends State<CreatecuopunWidget> {
  late CreatecuopunModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreatecuopunModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
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
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create Money code',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontStyle,
                        ),
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 8.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).secondary,
                    icon: Icon(
                      Icons.close,
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unit',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  TextFormField(
                    controller: _model.textController1,
                    focusNode: _model.textFieldFocusNode1,
                    autofocus: false,
                    textInputAction: TextInputAction.next,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Enter the number of unit to purchase',
                      hintStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 16.0, 16.0, 16.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    validator:
                        _model.textController1Validator.asValidator(context),
                  ),
                ].divide(SizedBox(height: 8.0)),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  TextFormField(
                    controller: _model.textController2,
                    focusNode: _model.textFieldFocusNode2,
                    autofocus: false,
                    textInputAction: TextInputAction.next,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Enter amount (e.g. 2500)',
                      hintStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 16.0, 16.0, 16.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    keyboardType: TextInputType.number,
                    validator:
                        _model.textController2Validator.asValidator(context),
                  ),
                ].divide(SizedBox(height: 8.0)),
              ),
              FFButtonWidget(
                onPressed: () async {
                  final rawCount = _model.textController1.text.trim();
                  final rawAmount = _model.textController2.text.trim();
                  if (rawCount.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter number of beneficiaries (max 2)'),
                        backgroundColor: Color(0xFFC93B2B),
                      ),
                    );
                    return;
                  }
                  if (rawAmount.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter an amount of ₦100 or more'),
                        backgroundColor: Color(0xFFC93B2B),
                      ),
                    );
                    return;
                  }
                  final parsedCount = functions.stringtoint(rawCount);
                  if (parsedCount != null && parsedCount <= 2) {
                    final parsedAmt = functions.stringtoint(rawAmount);
                    if (parsedAmt != null && parsedAmt >= 100) {
                      _model.transref = await actions.generatetransref();
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        isDismissible: false,
                        enableDrag: false,
                        useSafeArea: true,
                        context: context,
                        builder: (context) {
                          return WebViewAware(
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: PinverifyWidget(),
                            ),
                          );
                        },
                      ).then((value) =>
                          safeSetState(() => _model.success = value));

                      if (_model.success!) {
                        _model.deviceid = await actions.getdeviceid();
                        _model.tranid = await GettransactiontokenCall.call(
                          accessToken: FFAppState().bsptoken,
                          accountno: FFAppState().accountno,
                          deviceid: _model.deviceid,
                          sessionid: FFAppState().sessionid,
                        );

                        _model.debitwallet =
                            await WalletAsAServiceGroup.debitwalletCall.call(
                          narration:
                              'coupon_create_${_model.textController1.text}_ ${_model.textController2.text}',
                          amount: (int.parse(_model.textController1.text) *
                                  double.parse(_model.textController2.text))
                              .toString(),
                          transactionid: _model.transref,
                          accountno: FFAppState().accountno,
                          authToken: FFAppState().bsptoken,
                          refid: GettransactiontokenCall.transtoken(
                            (_model.tranid?.jsonBody ?? ''),
                          ),
                        );

                        if (WalletAsAServiceGroup.debitwalletCall.success(
                              (_model.debitwallet?.jsonBody ?? ''),
                            ) ==
                            true) {
                          _model.apiResultd5g = await LogtransactionCall.call(
                            phoneno: FFAppState().phonenumber,
                            accountId: FFAppState().accountno,
                            reqtype: 'MoneyCode',
                            sSid: _model.transref,
                            passorfail: 'Pass',
                            balBefore: FFAppState().avalbal,
                            balafter: (functions
                                        .stringtodouble(FFAppState().avalbal) -
                                    (int.parse(_model.textController1.text) *
                                        double.parse(
                                            _model.textController2.text)))
                                .toString(),
                            tammt: (int.parse(_model.textController1.text) *
                                    double.parse(_model.textController2.text))
                                .toString(),
                            accessToken: FFAppState().bsptoken,
                            transREF: _model.transref,
                          );

                          _model.apiResulteyw = await CreatecuponcodeCall.call(
                            accessToken: FFAppState().bsptoken,
                            phone: FFAppState().phonenumber,
                            refid: _model.transref,
                            unit: _model.textController1.text,
                            amount: _model.textController2.text,
                            total: (int.parse(_model.textController1.text) *
                                    double.parse(_model.textController2.text))
                                .toString(),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'successfully created',
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Transaction not successful',
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
                          Navigator.pop(context);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Incorrect Pin try again',
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
                    } else {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return WebViewAware(
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: ErrorcompWidget(
                                message: 'Enter amount greater than 100',
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
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: ErrorcompWidget(
                              message:
                                  'Maximum unit exceeded, enter unit less than or equal to 2',
                            ),
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  }

                  safeSetState(() {});
                },
                text: 'Create Money Code',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50.0,
                  padding: EdgeInsets.all(8.0),
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
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ].divide(SizedBox(height: 16.0)),
          ),
        ),
      ),
    );
  }
}
