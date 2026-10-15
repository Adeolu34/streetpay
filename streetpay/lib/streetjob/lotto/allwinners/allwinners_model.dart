import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/streetjob/lotto/lottonav/lottonav_widget.dart';
import 'allwinners_widget.dart' show AllwinnersWidget;
import 'package:flutter/material.dart';

class AllwinnersModel extends FlutterFlowModel<AllwinnersWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (streetauth)] action in allwinners widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (getallwinners)] action in allwinners widget.
  ApiCallResponse? getwinner;
  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // State field(s) for Column widget.
  ScrollController? columnController3;
  // Model for lottonav component.
  late LottonavModel lottonavModel;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    columnController3 = ScrollController();
    lottonavModel = createModel(context, () => LottonavModel());
  }

  @override
  void dispose() {
    columnController1?.dispose();
    columnController2?.dispose();
    columnController3?.dispose();
    lottonavModel.dispose();
  }
}
