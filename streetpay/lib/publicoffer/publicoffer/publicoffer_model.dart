import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'publicoffer_widget.dart' show PublicofferWidget;
import 'package:flutter/material.dart';

class PublicofferModel extends FlutterFlowModel<PublicofferWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // Stores action output result for [Backend Call - API (getoffercharges)] action in Container widget.
  ApiCallResponse? publicofferfess;
  // Stores action output result for [Custom Action - getdeviceid] action in Container widget.
  String? deviceid;
  // Stores action output result for [Custom Action - generatetransref] action in Container widget.
  String? transref;
  // Stores action output result for [Backend Call - API (gettransactiontoken)] action in Container widget.
  ApiCallResponse? transtoken;
  // Stores action output result for [Backend Call - API (debitwallet)] action in Container widget.
  ApiCallResponse? debitwalet;
  // Stores action output result for [Backend Call - API (getoffercharges)] action in Container widget.
  ApiCallResponse? publicofferfesss;
  // Stores action output result for [Custom Action - getdeviceid] action in Container widget.
  String? deviceid2;
  // Stores action output result for [Custom Action - generatetransref] action in Container widget.
  String? transref2;
  // Stores action output result for [Backend Call - API (gettransactiontoken)] action in Container widget.
  ApiCallResponse? transtoken2;
  // Stores action output result for [Backend Call - API (debitwallet)] action in Container widget.
  ApiCallResponse? debitwalet2;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (enableoffer)] action in switchss widget.
  ApiCallResponse? apiResultb31;

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
