import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'settingpage_widget.dart' show SettingpageWidget;
import 'package:flutter/material.dart';

class SettingpageModel extends FlutterFlowModel<SettingpageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for Switch widget.
  bool? switchValue;
  bool biometric = false;
  // Stores action output result for [Backend Call - API (getCONTACT)] action in Row widget.
  ApiCallResponse? contact;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
  }
}
