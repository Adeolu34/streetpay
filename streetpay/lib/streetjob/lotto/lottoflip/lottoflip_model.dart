import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'lottoflip_widget.dart' show LottoflipWidget;
import 'package:flutter/material.dart';

class LottoflipModel extends FlutterFlowModel<LottoflipWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (streetauth)] action in lottoflip widget.
  ApiCallResponse? streetauth;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // Stores action output result for [Backend Call - API (getlottonumber)] action in Button widget.
  ApiCallResponse? number;
  // Stores action output result for [Custom Action - buttondisable] action in Button widget.
  int? randddd;
  // Stores action output result for [Backend Call - API (getlottonumber)] action in Button widget.
  ApiCallResponse? number1;
  // Stores action output result for [Custom Action - buttondisable] action in Button widget.
  int? randddd1;
  // Stores action output result for [Backend Call - API (getlottonumber)] action in Button widget.
  ApiCallResponse? number2;
  // Stores action output result for [Custom Action - buttondisable] action in Button widget.
  int? randddd2;
  // Stores action output result for [Backend Call - API (playsum)] action in Button widget.
  ApiCallResponse? apiResult4z3;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
  }
}
