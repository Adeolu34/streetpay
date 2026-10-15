import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'accountdetails_widget.dart' show AccountdetailsWidget;
import 'package:flutter/material.dart';

class AccountdetailsModel extends FlutterFlowModel<AccountdetailsWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (wallet enquiry)] action in accountdetails widget.
  ApiCallResponse? apiResulta2u;
  // State field(s) for Column widget.
  ScrollController? columnController;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
  }
}
