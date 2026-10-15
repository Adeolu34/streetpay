import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'paymentpinverifyairtime_widget.dart' show PaymentpinverifyairtimeWidget;
import 'package:flutter/material.dart';

class PaymentpinverifyairtimeModel
    extends FlutterFlowModel<PaymentpinverifyairtimeWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - generatetransref] action in paymentpinverifyairtime widget.
  String? transreff;
  // Stores action output result for [Custom Action - generateseesionid] action in paymentpinverifyairtime widget.
  String? sessionref;
  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // Stores action output result for [Backend Call - API (streetauth)] action in Button widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Custom Action - getdeviceid] action in Button widget.
  String? deviceid;
  // Stores action output result for [Backend Call - API (ispincodevalid)] action in Button widget.
  ApiCallResponse? pincode;
  // Stores action output result for [Backend Call - API (gettransactiontoken)] action in Button widget.
  ApiCallResponse? transtoken;
  // Stores action output result for [Backend Call - API (buyairtime)] action in Button widget.
  ApiCallResponse? buyairtime;
  // Stores action output result for [Backend Call - API (logtransaction)] action in Button widget.
  ApiCallResponse? apiResultgg0;

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
