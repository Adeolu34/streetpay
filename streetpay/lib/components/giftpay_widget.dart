import '/backend/api_requests/api_calls.dart';
import '/components/errorcomp_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/giveaway/giveawayresult/giveawayresult_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'giftpay_model.dart';
export 'giftpay_model.dart';

/// Create a componentcreate a simple payment componet to enter amount and
/// them pay with a title enter amount to lock your gift
class GiftpayWidget extends StatefulWidget {
  const GiftpayWidget({
    super.key,
    required this.id,
    required this.amounttoclaim,
    required this.brandname,
  });

  final String? id;
  final String? amounttoclaim;
  final String? brandname;

  @override
  State<GiftpayWidget> createState() => _GiftpayWidgetState();
}

class _GiftpayWidgetState extends State<GiftpayWidget> {
  late GiftpayModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GiftpayModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
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
        color: FlutterFlowTheme.of(context).primaryBackground,
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
                Text(
                  'Enter Amount to Lock Your Gift',
                  textAlign: TextAlign.center,
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                    ),
                    TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Enter a minimum of 100',
                        hintStyle:
                            FlutterFlowTheme.of(context).bodyLarge.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .fontStyle,
                                ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        contentPadding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 20.0, 16.0, 20.0),
                      ),
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontStyle,
                          ),
                      keyboardType: TextInputType.number,
                      validator:
                          _model.textControllerValidator.asValidator(context),
                    ),
                  ].divide(SizedBox(height: 8.0)),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    if (functions.stringtodouble(_model.textController.text) >=
                        100.0) {
                      _model.deviceid = await actions.getdeviceid();
                      _model.transref = await actions.generatetransref();
                      _model.transtoken = await GettransactiontokenCall.call(
                        accessToken: FFAppState().bsptoken,
                        accountno: FFAppState().accountno,
                        deviceid: valueOrDefault<String>(
                          _model.deviceid,
                          'testing',
                        ),
                        sessionid: FFAppState().sessionid,
                      );

                      _model.debitwallet =
                          await WalletAsAServiceGroup.debitwalletCall.call(
                        narration: 'giveaway ${getCurrentTimestamp.toString()}',
                        amount: _model.textController.text,
                        transactionid: _model.transref,
                        accountno: FFAppState().accountno,
                        refid: GettransactiontokenCall.transtoken(
                          (_model.transtoken?.jsonBody ?? ''),
                        ),
                        authToken: FFAppState().bsptoken,
                      );

                      if (WalletAsAServiceGroup.debitwalletCall.success(
                            (_model.debitwallet?.jsonBody ?? ''),
                          ) ==
                          true) {
                        _model.storegift = await StoreGiftCall.call(
                          phone: FFAppState().phonenumber,
                          accessToken: FFAppState().bsptoken,
                          amount: _model.textController.text,
                          brandname: FFAppState().accountname,
                          state: 'testing',
                          payref: _model.transref,
                        );

                        _model.lockgift = await LockGiftCall.call(
                          phone: FFAppState().phonenumber,
                          accessToken: FFAppState().bsptoken,
                          id: widget.id,
                        );

                        _model.transtoken2 = await GettransactiontokenCall.call(
                          accessToken: FFAppState().bsptoken,
                          accountno: FFAppState().accountno,
                          deviceid: valueOrDefault<String>(
                            _model.deviceid,
                            'testing',
                          ),
                          sessionid: FFAppState().sessionid,
                        );

                        _model.transref2 = await actions.generatetransref();
                        _model.creditwallet =
                            await WalletAsAServiceGroup.creditwalletCall.call(
                          narration:
                              'givewayclaim ${getCurrentTimestamp.toString()}',
                          amount: widget.amounttoclaim,
                          transactionid: _model.transref2,
                          accountno: FFAppState().accountno,
                          refid: GettransactiontokenCall.transtoken(
                            (_model.transtoken2?.jsonBody ?? ''),
                          ),
                          authToken: FFAppState().bsptoken,
                        );

                        if (WalletAsAServiceGroup.creditwalletCall.success(
                              (_model.creditwallet?.jsonBody ?? ''),
                            ) ==
                            true) {
                          _model.apiResultunf = await ClaimByLockIdCall.call(
                            phone: FFAppState().phonenumber,
                            accessToken: FFAppState().bsptoken,
                            id: widget.id,
                          );

                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            isDismissible: false,
                            enableDrag: false,
                            context: context,
                            builder: (context) {
                              return WebViewAware(
                                child: Padding(
                                  padding: MediaQuery.viewInsetsOf(context),
                                  child: GiveawayresultWidget(
                                    brandname: widget.brandname!,
                                    amount: widget.amounttoclaim!,
                                  ),
                                ),
                              );
                            },
                          ).then((value) => safeSetState(() {}));

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Your gift has been claimed successfully, sponsored by  ${widget.brandname}',
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
                        }
                      } else {
                        Navigator.pop(context);
                        final errorMsg = _model.debitwallet?.responseMessage.isNotEmpty == true
                            ? _model.debitwallet!.responseMessage
                            : 'Transaction failed. Please check your balance and try again.';
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
                                message: 'Enter an amount greater than 100',
                              ),
                            ),
                          );
                        },
                      ).then((value) => safeSetState(() {}));
                    }

                    safeSetState(() {});
                  },
                  text: 'Pay Now',
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
