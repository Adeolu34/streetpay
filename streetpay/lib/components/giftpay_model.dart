import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'giftpay_widget.dart' show GiftpayWidget;
import 'package:flutter/material.dart';

class GiftpayModel extends FlutterFlowModel<GiftpayWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Custom Action - getdeviceid] action in Button widget.
  String? deviceid;
  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? transref;
  // Stores action output result for [Backend Call - API (gettransactiontoken)] action in Button widget.
  ApiCallResponse? transtoken;
  // Stores action output result for [Backend Call - API (debitwallet)] action in Button widget.
  ApiCallResponse? debitwallet;
  // Stores action output result for [Backend Call - API (StoreGift)] action in Button widget.
  ApiCallResponse? storegift;
  // Stores action output result for [Backend Call - API (LockGift)] action in Button widget.
  ApiCallResponse? lockgift;
  // Stores action output result for [Backend Call - API (gettransactiontoken)] action in Button widget.
  ApiCallResponse? transtoken2;
  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? transref2;
  // Stores action output result for [Backend Call - API (creditwallet)] action in Button widget.
  ApiCallResponse? creditwallet;
  // Stores action output result for [Backend Call - API (ClaimByLockId)] action in Button widget.
  ApiCallResponse? apiResultunf;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
