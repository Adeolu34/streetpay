import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'lottospin_widget.dart' show LottospinWidget;
import 'package:flutter/material.dart';

class LottospinModel extends FlutterFlowModel<LottospinWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (streetauth)] action in lottospin widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (getangles)] action in lottospin widget.
  ApiCallResponse? angles;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // Stores action output result for [Backend Call - API (playangle)] action in Button widget.
  ApiCallResponse? apiResultqzb;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
  }
}
