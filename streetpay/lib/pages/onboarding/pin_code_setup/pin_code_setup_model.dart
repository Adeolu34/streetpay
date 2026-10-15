import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'pin_code_setup_widget.dart' show PinCodeSetupWidget;
import 'package:flutter/material.dart';

class PinCodeSetupModel extends FlutterFlowModel<PinCodeSetupWidget> {
  ///  Local state fields for this page.

  dynamic profileOpeningRequest;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // Stores action output result for [Backend Call - API (setpincode)] action in PinCode widget.
  ApiCallResponse? apiResultx7t;

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();
  }
}
