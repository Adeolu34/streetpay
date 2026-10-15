import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'referallcard_model.dart';
export 'referallcard_model.dart';

/// Create a component Design a modern mobile referral card for StreetPay
/// using a clean green and white theme.
///
/// The card should have rounded corners, soft shadow, and a professional
/// fintech look.
///
/// Headline: “Earn Points As You Refer Friends!” in bold dark green.
/// Subtext: “Invite your friends to StreetPay and earn 100 points for every
/// referral.”
///
/// Add a section labeled “Share your code:” with a rounded white input-style
/// container showing “STREET987” and a green “Copy” button attached on the
/// right.
///
/// Include a large rounded green primary button labeled “Invite Friends”.
///
/// Below it, add four circular green social icons: WhatsApp, Facebook,
/// Telegram, Email.
///
/// Footer text: “Get 100 points for every friend you refer.”
///
/// Flat UI, minimal gradients, clean typography, white background with green
/// accents, modern mobile app layout, high-resolution UI mockup.
class ReferallcardWidget extends StatefulWidget {
  const ReferallcardWidget({super.key});

  @override
  State<ReferallcardWidget> createState() => _ReferallcardWidgetState();
}

class _ReferallcardWidgetState extends State<ReferallcardWidget> {
  late ReferallcardModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReferallcardModel());
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
      height: 500.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 12.0,
                color: Color(0x1A4B39EF),
                offset: Offset(
                  0.0,
                  4.0,
                ),
                spreadRadius: 0.0,
              )
            ],
            gradient: LinearGradient(
              colors: [Color(0x64048002), FlutterFlowTheme.of(context).primary],
              stops: [0.0, 0.5],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0, 1.0),
            ),
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
                    Text(
                      'Earn Points As You Refer Friends!',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontStyle,
                            ),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontStyle,
                          ),
                    ),
                    Text(
                      'Invite your friends to StreetPay and earn 100 points for every referral.',
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
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share your code:',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .fontStyle,
                            ),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelLarge
                                .fontStyle,
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: Color(0xFFF8FFFE),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                              ),
                              border: Border.all(
                                color: Color(0xFFE0F2E7),
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 12.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    valueOrDefault<String>(
                                      functions
                                          .addcode(FFAppState().phonenumber),
                                      '0000000',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontStyle,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 0.0)),
                    ),
                  ].divide(SizedBox(height: 12.0)),
                ),
                Builder(
                  builder: (context) => FFButtonWidget(
                    onPressed: () async {
                      _model.apiResulte5s = await GeturlCall.call(
                        phone: functions.removecode(FFAppState().phonenumber),
                        accessToken: FFAppState().bsptoken,
                      );

                      await Share.share(
                        GeturlCall.message(
                          (_model.apiResulte5s?.jsonBody ?? ''),
                        )!,
                        sharePositionOrigin: getWidgetBoundingBox(context),
                      );

                      safeSetState(() {});
                    },
                    text: 'Invite Friends',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 52.0,
                      padding: EdgeInsets.all(8.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      textStyle:
                          FlutterFlowTheme.of(context).titleMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontStyle,
                              ),
                      elevation: 0.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF2D5A3D),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Icon(
                        Icons.message,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF2D5A3D),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Icon(
                        Icons.facebook,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF2D5A3D),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Icon(
                        Icons.telegram,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF2D5A3D),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Icon(
                        Icons.email,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Get 100 points for every friend you refer.',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodySmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodySmall.fontStyle,
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
