import '/flutter_flow/flutter_flow_util.dart';
import 'streetjob_widget.dart' show StreetjobWidget;
import 'package:flutter/material.dart';

class StreetjobModel extends FlutterFlowModel<StreetjobWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for Row widget.
  ScrollController? rowController;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    rowController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    rowController?.dispose();
  }
}
