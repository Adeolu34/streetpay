import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'pinverify_widget.dart' show PinverifyWidget;
import 'package:flutter/material.dart';

class PinverifyModel extends FlutterFlowModel<PinverifyWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // Stores action output result for [Backend Call - API (streetauth)] action in Button widget.
  ApiCallResponse? strretauth;
  // Stores action output result for [Custom Action - getdeviceid] action in Button widget.
  String? deviceid;
  // Stores action output result for [Backend Call - API (ispincodevalid)] action in Button widget.
  ApiCallResponse? pincode;

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
