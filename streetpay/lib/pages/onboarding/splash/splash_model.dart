import '/components/app_logo/app_logo_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'splash_widget.dart' show SplashWidget;
import 'package:flutter/material.dart';

class SplashModel extends FlutterFlowModel<SplashWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AppLogo component.
  late AppLogoModel appLogoModel;

  @override
  void initState(BuildContext context) {
    appLogoModel = createModel(context, () => AppLogoModel());
  }

  @override
  void dispose() {
    appLogoModel.dispose();
  }
}
