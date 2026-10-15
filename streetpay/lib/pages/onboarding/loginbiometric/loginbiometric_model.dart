import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'loginbiometric_widget.dart' show LoginbiometricWidget;
import 'package:flutter/material.dart';

class LoginbiometricModel extends FlutterFlowModel<LoginbiometricWidget> {
  ///  State fields for stateful widgets in this page.

  bool biometric = false;
  // Stores action output result for [Backend Call - API (returntierprofile)] action in Loginbiometric widget.
  ApiCallResponse? tierone;
  // State field(s) for scrollingContainer widget.
  ScrollController? scrollingContainerScrollController;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // Stores action output result for [Custom Action - getdeviceid] action in Button widget.
  String? deviceid;
  // Stores action output result for [Backend Call - API (ispincodevalid)] action in Button widget.
  ApiCallResponse? ispincode;
  // Stores action output result for [Backend Call - API (locationdetect)] action in Button widget.
  ApiCallResponse? apiResultzm3;
  // Stores action output result for [Backend Call - API (locationdetect)] action in Button widget.
  ApiCallResponse? apiResultzm4;

  @override
  void initState(BuildContext context) {
    scrollingContainerScrollController = ScrollController();
    passwordVisibility = false;
  }

  @override
  void dispose() {
    scrollingContainerScrollController?.dispose();
    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
