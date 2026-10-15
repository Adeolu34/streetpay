import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'productconfig_model.dart';
export 'productconfig_model.dart';

class ProductconfigWidget extends StatefulWidget {
  const ProductconfigWidget({super.key});

  @override
  State<ProductconfigWidget> createState() => _ProductconfigWidgetState();
}

class _ProductconfigWidgetState extends State<ProductconfigWidget> {
  late ProductconfigModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductconfigModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          _model.electricity = await VasCollectionGroup.billercategoryCall.call(
            id: '1',
            accessToken: FFAppState().bsptoken,
          );

          FFAppState().electricbillerid = VasCollectionGroup.billercategoryCall
              .name(
                (_model.electricity?.jsonBody ?? ''),
              )!
              .toList()
              .cast<String>();
          FFAppState().progressvalue = FFAppState().progressvalue + 0.08334;
          safeSetState(() {});
        }),
        Future(() async {
          _model.cabletv = await VasCollectionGroup.billercategoryCall.call(
            id: '4',
            accessToken: FFAppState().bsptoken,
          );

          FFAppState().cablebillerid = VasCollectionGroup.billercategoryCall
              .name(
                (_model.cabletv?.jsonBody ?? ''),
              )!
              .toList()
              .cast<String>();
          FFAppState().progressvalue = FFAppState().progressvalue + 0.08334;
          safeSetState(() {});
        }),
        Future(() async {
          _model.betting = await VasCollectionGroup.billercategoryCall.call(
            id: '2',
            accessToken: FFAppState().bsptoken,
          );

          FFAppState().bettingbillerid = VasCollectionGroup.billercategoryCall
              .name(
                (_model.betting?.jsonBody ?? ''),
              )!
              .toList()
              .cast<String>();
          FFAppState().progressvalue = FFAppState().progressvalue + 0.08334;
          safeSetState(() {});
        }),
        Future(() async {
          _model.internet = await VasCollectionGroup.billercategoryCall.call(
            id: '7',
            accessToken: FFAppState().bsptoken,
          );

          FFAppState().internetbillerid = VasCollectionGroup.billercategoryCall
              .name(
                (_model.internet?.jsonBody ?? ''),
              )!
              .toList()
              .cast<String>();
          FFAppState().progressvalue = FFAppState().progressvalue + 0.08334;
          safeSetState(() {});
        }),
        Future(() async {
          _model.mtn = await VasCollectionGroup.getdataplanCall.call(
            phoneNumber: '08160568803',
            accessToken: FFAppState().bsptoken,
          );

          FFAppState().mtndataplans = VasCollectionGroup.getdataplanCall
              .dataplans(
                (_model.mtn?.jsonBody ?? ''),
              )!
              .toList()
              .cast<dynamic>();
          FFAppState().progressvalue = FFAppState().progressvalue + 0.08334;
          safeSetState(() {});
        }),
        Future(() async {
          _model.glo = await VasCollectionGroup.getdataplanCall.call(
            phoneNumber: '09154180805',
            accessToken: FFAppState().bsptoken,
          );

          FFAppState().glodataplans = VasCollectionGroup.getdataplanCall
              .dataplans(
                (_model.glo?.jsonBody ?? ''),
              )!
              .toList()
              .cast<dynamic>();
          FFAppState().progressvalue = FFAppState().progressvalue + 0.08334;
          safeSetState(() {});
        }),
        Future(() async {
          _model.airtel = await VasCollectionGroup.getdataplanCall.call(
            phoneNumber: '09024706049',
            accessToken: FFAppState().bsptoken,
          );

          FFAppState().airtel = VasCollectionGroup.getdataplanCall.productid(
            (_model.airtel?.jsonBody ?? ''),
          );
          FFAppState().airteldataplans = VasCollectionGroup.getdataplanCall
              .dataplans(
                (_model.airtel?.jsonBody ?? ''),
              )!
              .toList()
              .cast<dynamic>();
          FFAppState().progressvalue = FFAppState().progressvalue + 0.08334;
          safeSetState(() {});
        }),
        Future(() async {
          _model.dstv = await VasCollectionGroup.getbillerinputCall.call(
            id: 'CW-DSTV',
            accessToken: FFAppState().bsptoken,
          );

          FFAppState().dstvitemlist = VasCollectionGroup.getbillerinputCall
              .itemname(
                (_model.dstv?.jsonBody ?? ''),
              )!
              .toList()
              .cast<String>();
          FFAppState().progressvalue = FFAppState().progressvalue + 0.08334;
          safeSetState(() {});
        }),
        Future(() async {
          _model.gotv = await VasCollectionGroup.getbillerinputCall.call(
            id: 'CW-GOTV',
            accessToken: FFAppState().bsptoken,
          );

          FFAppState().gotvitemlist = VasCollectionGroup.getbillerinputCall
              .itemname(
                (_model.gotv?.jsonBody ?? ''),
              )!
              .toList()
              .cast<String>();
          FFAppState().progressvalue = FFAppState().progressvalue + 0.08334;
          safeSetState(() {});
        }),
        Future(() async {
          _model.startimes = await VasCollectionGroup.getbillerinputCall.call(
            id: 'CW-STARTIMES',
            accessToken: FFAppState().bsptoken,
          );

          FFAppState().startimes = VasCollectionGroup.getbillerinputCall
              .itemname(
                (_model.startimes?.jsonBody ?? ''),
              )!
              .toList()
              .cast<String>();
          FFAppState().progressvalue = FFAppState().progressvalue + 0.08334;
          safeSetState(() {});
        }),
        Future(() async {
          _model.showmax = await VasCollectionGroup.getbillerinputCall.call(
            id: 'CW-SOMX',
            accessToken: FFAppState().bsptoken,
          );

          FFAppState().showmaxitemlist = VasCollectionGroup.getbillerinputCall
              .itemname(
                (_model.showmax?.jsonBody ?? ''),
              )!
              .toList()
              .cast<String>();
          FFAppState().progressvalue = FFAppState().progressvalue + 0.08334;
          safeSetState(() {});
        }),
        Future(() async {
          _model.banklist = await WalletAsAServiceGroup.getBankListCall.call(
            authToken: FFAppState().bsptoken,
          );

          FFAppState().bankname = WalletAsAServiceGroup.getBankListCall
              .bankname(
                (_model.banklist?.jsonBody ?? ''),
              )!
              .toList()
              .cast<String>();
          FFAppState().progressvalue = FFAppState().progressvalue + 0.083;
          safeSetState(() {});
        }),
      ]);
      FFAppState().progressvalue = 1.0;
      safeSetState(() {});
    });
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
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: const [
              BoxShadow(
                blurRadius: 20.0,
                color: Color(0x1A000000),
                offset: Offset(0.0, 8.0),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96.0,
                  height: 96.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.25),
                      width: 2.0,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 64.0,
                      height: 64.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.settings_rounded,
                        color: Colors.white,
                        size: 32.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'We are configuring your product...',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                            ),
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: -0.3,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Checking system requirements...',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w500,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                Container(
                  width: double.infinity,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: LinearPercentIndicator(
                      percent: FFAppState().progressvalue.clamp(0.0, 1.0),
                      lineHeight: 10.0,
                      animation: true,
                      animateFromLastPercent: true,
                      progressColor: FlutterFlowTheme.of(context).primary,
                      backgroundColor: FlutterFlowTheme.of(context).alternate,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Wait for the continue button',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        font: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w500,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
                if (FFAppState().progressvalue >= 0.99) ...[
                  const SizedBox(height: 24.0),
                  FFButtonWidget(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    text: 'Click here to continue',
                    options: FFButtonOptions(
                      width: 220.0,
                      height: 48.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding: EdgeInsets.zero,
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                            ),
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
