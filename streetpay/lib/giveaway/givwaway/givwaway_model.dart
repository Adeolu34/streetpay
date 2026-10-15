import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'givwaway_widget.dart' show GivwawayWidget;
import 'package:flutter/material.dart';

class GivwawayModel extends FlutterFlowModel<GivwawayWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for storerrr widget.
  ScrollController? storerrrScrollController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // Stores action output result for [Custom Action - getdeviceid] action in Button widget.
  String? deviceid;
  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? transref;
  // Stores action output result for [Backend Call - API (gettransactiontoken)] action in Button widget.
  ApiCallResponse? transtoken;
  // Stores action output result for [Backend Call - API (debitwallet)] action in Button widget.
  ApiCallResponse? debitwallet;
  // Stores action output result for [Backend Call - API (StoreGift)] action in Button widget.
  ApiCallResponse? apiResult3v0;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    storerrrScrollController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
    storerrrScrollController?.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}
