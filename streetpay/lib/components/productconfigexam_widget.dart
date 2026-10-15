import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'productconfigexam_model.dart';
export 'productconfigexam_model.dart';

class ProductconfigexamWidget extends StatefulWidget {
  const ProductconfigexamWidget({super.key});

  @override
  State<ProductconfigexamWidget> createState() =>
      _ProductconfigexamWidgetState();
}

class _ProductconfigexamWidgetState extends State<ProductconfigexamWidget> {
  late ProductconfigexamModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductconfigexamModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.waec = await VasCollectionGroup.getbillerinputCall.call(
        id: 'CW-P06N',
        accessToken: FFAppState().bsptoken,
      );

      FFAppState().weacinput = VasCollectionGroup.getbillerinputCall
          .fieldname(
            (_model.waec?.jsonBody ?? ''),
          )!
          .toList()
          .cast<String>();
      FFAppState().examprogress = FFAppState().examprogress + 0.1667;
      safeSetState(() {});
      FFAppState().waecdescription = VasCollectionGroup.getbillerinputCall
          .fielddescription(
            (_model.waec?.jsonBody ?? ''),
          )!
          .toList()
          .cast<String>();
      FFAppState().examprogress = FFAppState().examprogress + 0.1667;
      safeSetState(() {});
      FFAppState().weacitems = VasCollectionGroup.getbillerinputCall
          .itemname(
            (_model.waec?.jsonBody ?? ''),
          )!
          .toList()
          .cast<String>();
      FFAppState().examprogress = FFAppState().examprogress + 0.1667;
      safeSetState(() {});
      _model.jamb = await VasCollectionGroup.getbillerinputCall.call(
        id: 'CW-P07N',
        accessToken: FFAppState().bsptoken,
      );

      FFAppState().jambinput = VasCollectionGroup.getbillerinputCall
          .fieldname(
            (_model.jamb?.jsonBody ?? ''),
          )!
          .toList()
          .cast<String>();
      FFAppState().examprogress = FFAppState().examprogress + 0.1667;
      safeSetState(() {});
      FFAppState().jambdescription = VasCollectionGroup.getbillerinputCall
          .fielddescription(
            (_model.jamb?.jsonBody ?? ''),
          )!
          .toList()
          .cast<String>();
      FFAppState().examprogress = FFAppState().examprogress + 0.1667;
      safeSetState(() {});
      FFAppState().jambitems = VasCollectionGroup.getbillerinputCall
          .itemname(
            (_model.jamb?.jsonBody ?? ''),
          )!
          .toList()
          .cast<String>();
      FFAppState().examprogress = 1.0;
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
                    color: const Color(0xFF56B84B).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF56B84B).withValues(alpha: 0.25),
                      width: 2.0,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 64.0,
                      height: 64.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF56B84B),
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
                      progressColor: const Color(0xFF56B84B),
                      backgroundColor: FlutterFlowTheme.of(context).alternate,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'This may take a few minutes',
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
                    text: 'Close now',
                    options: FFButtonOptions(
                      width: 220.0,
                      height: 48.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding: EdgeInsets.zero,
                      color: const Color(0xFF56B84B),
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
