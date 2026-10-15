import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'teirpage_widget.dart' show TeirpageWidget;
import 'package:flutter/material.dart';

class TeirpageModel extends FlutterFlowModel<TeirpageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (wallet enquiry)] action in teirpage widget.
  ApiCallResponse? accountdetails;
  // Stores action output result for [Backend Call - API (upgradestatus)] action in teirpage widget.
  ApiCallResponse? upgradestatus1;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // Stores action output result for [Backend Call - API (upgradestatus)] action in Button widget.
  ApiCallResponse? upgradestatus1Copy;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
  }
}
