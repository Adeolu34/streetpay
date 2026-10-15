import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'billlbetting_widget.dart' show BilllbettingWidget;
import 'package:flutter/material.dart';

class BilllbettingModel extends FlutterFlowModel<BilllbettingWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (billercategory)] action in billlbetting widget.
  ApiCallResponse? billarcategory;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Backend Call - API (getbillerinput)] action in DropDown widget.
  ApiCallResponse? input;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Stores action output result for [Backend Call - API (validateddatainput)] action in TextField widget.
  ApiCallResponse? validateinputCopy;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // Stores action output result for [Backend Call - API (validateddatainput)] action in Button widget.
  ApiCallResponse? validateinput;
  // Stores action output result for [Backend Call - API (wallet enquiry)] action in Button widget.
  ApiCallResponse? walletenquiry;
  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? tranref;
  // Stores action output result for [Bottom Sheet - paymentpinverifybill] action in Button widget.
  bool? payrecipet;
  // Stores action output result for [Custom Action - getdeviceid] action in Button widget.
  String? deviceid;
  // Stores action output result for [Backend Call - API (gettransactiontoken)] action in Button widget.
  ApiCallResponse? tranrefe;
  // Stores action output result for [Backend Call - API (initaitebillpayment)] action in Button widget.
  ApiCallResponse? apiResultuj1;
  // Stores action output result for [Backend Call - API (logtransaction)] action in Button widget.
  ApiCallResponse? apiResult1bj;
  // Stores action output result for [Backend Call - API (logtransaction)] action in Button widget.
  ApiCallResponse? apiResult1bj2;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}
