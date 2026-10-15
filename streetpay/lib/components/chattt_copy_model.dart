import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chattt_copy_widget.dart' show ChatttCopyWidget;
import 'package:flutter/material.dart';

class ChatttCopyModel extends FlutterFlowModel<ChatttCopyWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (sendmessage)] action in Button widget.
  ApiCallResponse? apiResult9zh;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
