import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'sendconnect_widget.dart' show SendconnectWidget;
import 'package:flutter/material.dart';

class SendconnectModel extends FlutterFlowModel<SendconnectWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (streetauth)] action in sendconnect widget.
  ApiCallResponse? streetauth;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (requestconnect)] action in Button widget.
  ApiCallResponse? apiResultaww;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
