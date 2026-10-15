import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'createcuopun_widget.dart' show CreatecuopunWidget;
import 'package:flutter/material.dart';

class CreatecuopunModel extends FlutterFlowModel<CreatecuopunWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? transref;
  // Stores action output result for [Bottom Sheet - pinverify] action in Button widget.
  bool? success;
  // Stores action output result for [Custom Action - getdeviceid] action in Button widget.
  String? deviceid;
  // Stores action output result for [Backend Call - API (gettransactiontoken)] action in Button widget.
  ApiCallResponse? tranid;
  // Stores action output result for [Backend Call - API (debitwallet)] action in Button widget.
  ApiCallResponse? debitwallet;
  // Stores action output result for [Backend Call - API (logtransaction)] action in Button widget.
  ApiCallResponse? apiResultd5g;
  // Stores action output result for [Backend Call - API (createcuponcode)] action in Button widget.
  ApiCallResponse? apiResulteyw;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
