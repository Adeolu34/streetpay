import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'fundsharing_widget.dart' show FundsharingWidget;
import 'package:flutter/material.dart';

class FundsharingModel extends FlutterFlowModel<FundsharingWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for Column widget.
  ScrollController? columnController2;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
  }

  @override
  void dispose() {
    columnController1?.dispose();
    columnController2?.dispose();
  }
}
