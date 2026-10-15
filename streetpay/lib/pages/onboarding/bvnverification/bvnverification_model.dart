import '/flutter_flow/flutter_flow_util.dart';
import 'bvnverification_widget.dart' show BvnverificationWidget;
import 'package:flutter/material.dart';

class BvnverificationModel extends FlutterFlowModel<BvnverificationWidget> {
  ///  Local state fields for this page.

  String? error;
  bool isResending = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;

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
