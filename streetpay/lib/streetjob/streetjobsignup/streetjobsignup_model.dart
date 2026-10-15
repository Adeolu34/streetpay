import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'streetjobsignup_widget.dart' show StreetjobsignupWidget;
import 'package:flutter/material.dart';

class StreetjobsignupModel extends FlutterFlowModel<StreetjobsignupWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (searchbycategory)] action in streetjobsignup widget.
  ApiCallResponse? categories;
  // State field(s) for Column widget.
  ScrollController? columnController;
  bool isDataUploading_uploadDataOl5 = false;
  FFUploadedFile uploadedLocalFile_uploadDataOl5 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
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
  // Stores action output result for [Backend Call - API (updatestreetjob)] action in Button widget.
  ApiCallResponse? apiResult030;
  // Stores action output result for [Backend Call - API (joinstreetjobmultipart)] action in Button widget.
  ApiCallResponse? result;

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
