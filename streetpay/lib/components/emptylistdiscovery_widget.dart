import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'emptylistdiscovery_model.dart';
export 'emptylistdiscovery_model.dart';

class EmptylistdiscoveryWidget extends StatefulWidget {
  const EmptylistdiscoveryWidget({super.key});

  @override
  State<EmptylistdiscoveryWidget> createState() =>
      _EmptylistdiscoveryWidgetState();
}

class _EmptylistdiscoveryWidgetState extends State<EmptylistdiscoveryWidget> {
  late EmptylistdiscoveryModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmptylistdiscoveryModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.list_alt,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 64.0,
              ),
              Text(
                'No device discovered',
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
                      fontWeight:
                          FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                    ),
              ),
            ].divide(SizedBox(height: 16.0)),
          ),
        ),
      ),
    );
  }
}
