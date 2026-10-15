import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'couponpay_widget.dart' show CouponpayWidget;
import 'package:flutter/material.dart';

class CouponpayModel extends FlutterFlowModel<CouponpayWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (checkcuponcode)] action in Button widget.
  ApiCallResponse? couponcode;

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
