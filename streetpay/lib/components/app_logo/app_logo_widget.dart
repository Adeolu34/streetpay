import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'app_logo_model.dart';
export 'app_logo_model.dart';

class AppLogoWidget extends StatefulWidget {
  const AppLogoWidget({super.key});

  @override
  State<AppLogoWidget> createState() => _AppLogoWidgetState();
}

class _AppLogoWidgetState extends State<AppLogoWidget> {
  late AppLogoModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppLogoModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84.0,
      height: 84.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).silver,
        borderRadius: BorderRadius.circular(48.0),
      ),
      child: Icon(
        FFIcons.klogoFilled,
        color: FlutterFlowTheme.of(context).primary,
        size: 34.0,
      ),
    );
  }
}
