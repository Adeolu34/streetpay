import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'retrivedetails_widget.dart' show RetrivedetailsWidget;
import 'package:flutter/material.dart';

class RetrivedetailsModel extends FlutterFlowModel<RetrivedetailsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
