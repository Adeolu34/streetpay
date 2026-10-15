import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'verifyemailinstruction_widget.dart' show VerifyemailinstructionWidget;
import 'package:flutter/material.dart';

class VerifyemailinstructionModel
    extends FlutterFlowModel<VerifyemailinstructionWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (verifyemailcode)] action in Button widget.
  ApiCallResponse? verifyemail;
  // Stores action output result for [Backend Call - API (getemailcode)] action in Text widget.
  ApiCallResponse? apiResultqlp;
  bool isResending = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
