import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'datapayment_widget.dart' show DatapaymentWidget;
import 'package:flutter/material.dart';

class DatapaymentModel extends FlutterFlowModel<DatapaymentWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (streetauth)] action in datapayment widget.
  ApiCallResponse? streetauth;
  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (getdataplan)] action in TextField widget.
  ApiCallResponse? getplans;
  // Stores action output result for [Backend Call - API (getnetwork)] action in TextField widget.
  ApiCallResponse? getnetwork;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Column widget.
  ScrollController? columnController3;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    columnController3 = ScrollController();
  }

  @override
  void dispose() {
    columnController1?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    columnController2?.dispose();
    tabBarController?.dispose();
    columnController3?.dispose();
  }
}
