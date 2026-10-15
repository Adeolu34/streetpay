import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'transerconfirm_widget.dart' show TranserconfirmWidget;
import 'package:flutter/material.dart';

class TranserconfirmModel extends FlutterFlowModel<TranserconfirmWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (streetauth)] action in transerconfirm widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (getphonen)] action in transerconfirm widget.
  ApiCallResponse? receiverphone;
  // Stores action output result for [Backend Call - API (getpinnedphones)] action in transerconfirm widget.
  ApiCallResponse? pinnedlist;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // Stores action output result for [Backend Call - API (streetauth)] action in Checkbox widget.
  ApiCallResponse? streetaut;
  // Stores action output result for [Backend Call - API (getphonen)] action in Checkbox widget.
  ApiCallResponse? getreceiverphonenumber;
  // Stores action output result for [Backend Call - API (insertpindata)] action in Checkbox widget.
  ApiCallResponse? apiResult33o;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
