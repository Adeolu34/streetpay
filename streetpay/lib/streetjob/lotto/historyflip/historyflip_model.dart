import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/streetjob/lotto/lottonav/lottonav_widget.dart';
import '/index.dart';
import 'historyflip_widget.dart' show HistoryflipWidget;
import 'package:flutter/material.dart';

class HistoryflipModel extends FlutterFlowModel<HistoryflipWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (streetauth)] action in historyflip widget.
  ApiCallResponse? streetautg;
  // Stores action output result for [Backend Call - API (gethistoryflip)] action in historyflip widget.
  ApiCallResponse? history;
  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // Model for lottonav component.
  late LottonavModel lottonavModel;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    lottonavModel = createModel(context, () => LottonavModel());
  }

  @override
  void dispose() {
    columnController1?.dispose();
    columnController2?.dispose();
    lottonavModel.dispose();
  }
}
