import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'resultsummary_widget.dart' show ResultsummaryWidget;
import 'package:flutter/material.dart';

class ResultsummaryModel extends FlutterFlowModel<ResultsummaryWidget> {
  ///  State fields for stateful widgets in this page.

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
