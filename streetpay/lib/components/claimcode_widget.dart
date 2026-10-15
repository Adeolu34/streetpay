import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'claimcode_model.dart';
export 'claimcode_model.dart';

/// I have a code claiming page, i need a component to view the amount of the
/// code and also a button to claim the code
///
class ClaimcodeWidget extends StatefulWidget {
  const ClaimcodeWidget({
    super.key,
    required this.amount,
    required this.code,
    required this.createdby,
  });

  final String? amount;
  final String? code;
  final String? createdby;

  @override
  State<ClaimcodeWidget> createState() => _ClaimcodeWidgetState();
}

class _ClaimcodeWidgetState extends State<ClaimcodeWidget> {
  late ClaimcodeModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ClaimcodeModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 8.0,
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
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Icon(
                          Icons.card_giftcard,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          size: 40.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Text(
                        'Money Code Value',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'N${widget.amount}',
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .displaySmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .displaySmall
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ].divide(SizedBox(height: 12.0)),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Congratulations! You\'ve earned a reward from ${widget.createdby}',
                      textAlign: TextAlign.center,
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
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Text(
                      'Click Claim Code to Receive Fund',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                    ),
                  ].divide(SizedBox(height: 8.0)),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    _model.tranref = await actions.generatetransref();
                    _model.claimcode = await ClaimcodCall.call(
                      accessToken: FFAppState().bsptoken,
                      phone: FFAppState().phonenumber,
                      code: widget.code,
                    );

                    if (ClaimcodCall.success(
                          (_model.claimcode?.jsonBody ?? ''),
                        ) ==
                        true) {
                      _model.deviceid = await actions.getdeviceid();
                      _model.transtoken = await GettransactiontokenCall.call(
                        accessToken: FFAppState().bsptoken,
                        accountno: FFAppState().accountno,
                        deviceid: _model.deviceid,
                        sessionid: FFAppState().sessionid,
                      );

                      _model.apiResult3ya =
                          await WalletAsAServiceGroup.creditwalletCall.call(
                        narration: 'Moneycode',
                        amount: widget.amount,
                        transactionid: _model.tranref,
                        accountno: FFAppState().accountno,
                        authToken: FFAppState().bsptoken,
                        refid: GettransactiontokenCall.transtoken(
                          (_model.transtoken?.jsonBody ?? ''),
                        ),
                      );

                      Navigator.pop(context);
                      await LogtransactionCall.call(
                        phoneno: FFAppState().phonenumber,
                        accountId: FFAppState().accountno,
                        reqtype: 'MoneyCode',
                        sSid: _model.tranref,
                        passorfail: 'Pass',
                        balBefore: FFAppState().avalbal,
                        balafter: (functions.stringtodouble(widget.amount) +
                                functions.stringtodouble(FFAppState().avalbal))
                            .toString(),
                        beneficiary: FFAppState().accountname,
                        tammt: widget.amount,
                        extra: widget.code,
                        transREF: _model.tranref,
                        accessToken: FFAppState().bsptoken,
                        ttype: 'Credit',
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'claimed successfully.',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          duration: Duration(milliseconds: 4000),
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                      final errorMsg = _model.claimcode?.responseMessage.isNotEmpty == true
                          ? _model.claimcode!.responseMessage
                          : 'Unable to claim code. Please try again.';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            errorMsg,
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
                  text: 'Claim Code',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 52.0,
                    padding: EdgeInsets.all(8.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context)
                        .titleMedium
                        .override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                    elevation: 2.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                ),
              ].divide(SizedBox(height: 20.0)),
            ),
          ),
        ),
      ),
    );
  }
}
