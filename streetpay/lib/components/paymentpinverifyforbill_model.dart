import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'paymentpinverifyforbill_widget.dart' show PaymentpinverifyforbillWidget;
import 'package:flutter/material.dart';

class PaymentpinverifyforbillModel
    extends FlutterFlowModel<PaymentpinverifyforbillWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // Stores action output result for [Backend Call - API (streetauth)] action in Button widget.
  ApiCallResponse? strretauth;
  // Stores action output result for [Backend Call - API (wallet enquiry)] action in Button widget.
  ApiCallResponse? wallet;
  // Stores action output result for [Custom Action - getdeviceid] action in Button widget.
  String? deviceid;
  // Stores action output result for [Backend Call - API (ispincodevalid)] action in Button widget.
  ApiCallResponse? pincode;
  // Stores action output result for [Backend Call - API (gettransactiontoken)] action in Button widget.
  ApiCallResponse? transtoken;
  // Stores action output result for [Backend Call - API (other bank transfer)] action in Button widget.
  ApiCallResponse? othertrans;
  // Stores action output result for [Backend Call - API (paidbill)] action in Button widget.
  ApiCallResponse? paidbill;

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
