import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'lottoguess_widget.dart' show LottoguessWidget;
import 'package:flutter/material.dart';

class LottoguessModel extends FlutterFlowModel<LottoguessWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (streetauth)] action in lottoguess widget.
  ApiCallResponse? streetaut;
  // Stores action output result for [Backend Call - API (getlottocode)] action in lottoguess widget.
  ApiCallResponse? lottocode;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  List<String>? get choiceChipsValues => choiceChipsValueController?.value;
  set choiceChipsValues(List<String>? val) =>
      choiceChipsValueController?.value = val;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // Stores action output result for [Backend Call - API (lottopay)] action in Button widget.
  ApiCallResponse? apiResult334;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
  }
}
