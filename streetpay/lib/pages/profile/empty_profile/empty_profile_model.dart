import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'empty_profile_widget.dart' show EmptyProfileWidget;
import 'package:flutter/material.dart';

class EmptyProfileModel extends FlutterFlowModel<EmptyProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (streetauth)] action in EmptyProfile widget.
  ApiCallResponse? apiResultala;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // Stores action output result for [Custom Action - isValidSingleWord] action in TextField widget.
  bool? isvaliad;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Stores action output result for [Backend Call - API (streetauth)] action in Button widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (bvnlookup)] action in Button widget.
  ApiCallResponse? bvnlook;
  // Stores action output result for [Backend Call - API (wassopen)] action in Button widget.
  ApiCallResponse? waasopen;
  // Stores action output result for [Backend Call - API (insertintotierone)] action in Button widget.
  ApiCallResponse? insertintotierone1;
  // Stores action output result for [Backend Call - API (createNewId)] action in Button widget.
  ApiCallResponse? createid1;
  // Stores action output result for [Backend Call - API (GetNINDetails)] action in Button widget.
  ApiCallResponse? nindetails;
  // Stores action output result for [Backend Call - API (openwallet)] action in Button widget.
  ApiCallResponse? openwallet;
  // Stores action output result for [Backend Call - API (insertintotierone)] action in Button widget.
  ApiCallResponse? insertintotierone;
  // Stores action output result for [Backend Call - API (createNewId)] action in Button widget.
  ApiCallResponse? createid;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
