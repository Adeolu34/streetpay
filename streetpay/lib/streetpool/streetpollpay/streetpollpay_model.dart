import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'streetpollpay_widget.dart' show StreetpollpayWidget;
import 'package:flutter/material.dart';

class StreetpollpayModel extends FlutterFlowModel<StreetpollpayWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // Stores action output result for [Bottom Sheet - pinverify] action in Button widget.
  bool? pinverify;
  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? transref;
  // Stores action output result for [Custom Action - getdeviceid] action in Button widget.
  String? deviceid;
  // Stores action output result for [Backend Call - API (gettransactiontoken)] action in Button widget.
  ApiCallResponse? transtoken;
  // Stores action output result for [Backend Call - API (debitwallet)] action in Button widget.
  ApiCallResponse? apiResultbn4;
  // Stores action output result for [Backend Call - API (StreetSHStore)] action in Button widget.
  ApiCallResponse? streetshare;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
  }
}
