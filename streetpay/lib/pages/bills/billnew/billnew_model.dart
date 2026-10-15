import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'billnew_widget.dart' show BillnewWidget;
import 'package:flutter/material.dart';

class BillnewModel extends FlutterFlowModel<BillnewWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (streetauth)] action in billnew widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (getpinlist)] action in billnew widget.
  ApiCallResponse? getpinphones;
  // Stores action output result for [Backend Call - API (getreceivedbill)] action in billnew widget.
  ApiCallResponse? getreceivedbill;
  // Stores action output result for [Backend Call - API (getsentbills)] action in billnew widget.
  ApiCallResponse? sentbill;
  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // State field(s) for Column widget.
  ScrollController? columnController3;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Column widget.
  ScrollController? columnController4;
  // Stores action output result for [Backend Call - API (getaccountno)] action in BillCard widget.
  ApiCallResponse? getphoneno;
  // State field(s) for Column widget.
  ScrollController? columnController5;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    columnController3 = ScrollController();
    columnController4 = ScrollController();
    columnController5 = ScrollController();
  }

  @override
  void dispose() {
    columnController1?.dispose();
    columnController2?.dispose();
    columnController3?.dispose();
    tabBarController?.dispose();
    columnController4?.dispose();
    columnController5?.dispose();
  }
}
