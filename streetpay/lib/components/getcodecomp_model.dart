import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'getcodecomp_widget.dart' show GetcodecompWidget;
import 'package:flutter/material.dart';

class GetcodecompModel extends FlutterFlowModel<GetcodecompWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (streetauth)] action in getcodecomp widget.
  ApiCallResponse? auth;
  // Stores action output result for [Backend Call - API (getwalletnew)] action in getcodecomp widget.
  ApiCallResponse? wallet;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
