import '/flutter_flow/flutter_flow_util.dart';
import 'pin_pad_widget.dart' show PinPadWidget;
import 'package:flutter/material.dart';

class PinPadModel extends FlutterFlowModel<PinPadWidget> {
  ///  State fields for stateful widgets in this component.

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
