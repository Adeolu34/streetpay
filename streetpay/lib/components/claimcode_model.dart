import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'claimcode_widget.dart' show ClaimcodeWidget;
import 'package:flutter/material.dart';

class ClaimcodeModel extends FlutterFlowModel<ClaimcodeWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? tranref;
  // Stores action output result for [Backend Call - API (claimcod)] action in Button widget.
  ApiCallResponse? claimcode;
  // Stores action output result for [Custom Action - getdeviceid] action in Button widget.
  String? deviceid;
  // Stores action output result for [Backend Call - API (gettransactiontoken)] action in Button widget.
  ApiCallResponse? transtoken;
  // Stores action output result for [Backend Call - API (creditwallet)] action in Button widget.
  ApiCallResponse? apiResult3ya;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
