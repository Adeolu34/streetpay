import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'airtimeform_widget.dart' show AirtimeformWidget;
import 'package:flutter/material.dart';

class AirtimeformModel extends FlutterFlowModel<AirtimeformWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // Stores action output result for [Backend Call - API (streetauth)] action in TextField widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (getnetwork)] action in TextField widget.
  ApiCallResponse? apiResultn64;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Model for BottomAppBar component.
  late BottomAppBarModel bottomAppBarModel;

  @override
  void initState(BuildContext context) {
    bottomAppBarModel = createModel(context, () => BottomAppBarModel());
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    bottomAppBarModel.dispose();
  }
}
