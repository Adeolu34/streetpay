import '/backend/api_requests/api_calls.dart';
import '/components/profile_header/profile_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_pager_header_model.dart';
export 'home_pager_header_model.dart';

class HomePagerHeaderWidget extends StatefulWidget {
  const HomePagerHeaderWidget({
    super.key,
    required this.phoneNumber,
    required this.name,
    this.accountno,
  });

  final String? phoneNumber;
  final String? name;
  final String? accountno;

  @override
  State<HomePagerHeaderWidget> createState() => _HomePagerHeaderWidgetState();
}

class _HomePagerHeaderWidgetState extends State<HomePagerHeaderWidget> {
  late HomePagerHeaderModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePagerHeaderModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().accountno = widget.accountno!;
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

    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
        ),
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                    child: wrapWithModel(
                      model: _model.profileHeaderModel,
                      updateCallback: () => safeSetState(() {}),
                      child: ProfileHeaderWidget(
                        name: FFAppState().accountname,
                        phone: FFAppState().phonenumber,
                        tier: FFAppState().tier,
                      ),
                    ),
                  ),
                ].divide(SizedBox(height: 20.0)),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '9PSB StreetPay Account',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    fontSize: 17.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  FFAppState().accountno,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await Clipboard.setData(ClipboardData(
                                        text: FFAppState().accountno));
                                  },
                                  child: Icon(
                                    Icons.content_copy_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    size: 15.0,
                                  ),
                                ),
                              ].divide(SizedBox(width: 7.0)),
                            ),
                          ].divide(SizedBox(height: 5.0)),
                        ),
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            fillColor: FlutterFlowTheme.of(context).primary,
                            icon: Icon(
                              Icons.refresh_sharp,
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              size: 24.0,
                            ),
                            showLoadingIndicator: true,
                            onPressed: () async {
                              _model.wallet = await WalletAsAServiceGroup
                                  .walletEnquiryCall
                                  .call(
                                accountNo: widget.accountno,
                                authToken: FFAppState().bsptoken,
                              );

                              FFAppState().avalbal =
                                  WalletAsAServiceGroup.walletEnquiryCall
                                      .availablebalance(
                                        (_model.wallet?.jsonBody ?? ''),
                                      )!
                                      .toString();
                              safeSetState(() {});

                              context.pushNamed(NewhomeWidget.routeName);

                              safeSetState(() {});
                            },
                          ),
                          if (!FFAppState().hidebal)
                            Text(
                              '₦ ${FFAppState().avalbal}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    fontSize: 30.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          if (FFAppState().hidebal)
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 15.0, 0.0, 0.0),
                                child: Text(
                                  '****',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w800,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        fontSize: 30.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ),
                          ToggleIcon(
                            onPressed: () async {
                              safeSetState(() =>
                                  FFAppState().hidebal = !FFAppState().hidebal);
                            },
                            value: FFAppState().hidebal,
                            onIcon: FaIcon(
                              FontAwesomeIcons.eyeSlash,
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              size: 24.0,
                            ),
                            offIcon: Icon(
                              Icons.remove_red_eye,
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              size: 24.0,
                            ),
                          ),
                        ].divide(SizedBox(width: 15.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
