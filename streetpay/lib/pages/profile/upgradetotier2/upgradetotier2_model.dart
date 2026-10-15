import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'upgradetotier2_widget.dart' show Upgradetotier2Widget;
import 'package:flutter/material.dart';

class Upgradetotier2Model extends FlutterFlowModel<Upgradetotier2Widget> {
  ApiCallResponse? apiResult564;
  ApiCallResponse? apiResultala;
  ScrollController? columnController;

  // ID Type dropdown
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;

  // NIN
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;

  // Email
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  // BVN
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  DateTime? datePicked;

  bool isDataUploading_userphoto = false;
  FFUploadedFile uploadedLocalFile_userphoto =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_utilitybill = false;
  FFUploadedFile uploadedLocalFile_utilitybill =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_nincardyy = false;
  FFUploadedFile uploadedLocalFile_nincardyy =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_proofaddress = false;
  FFUploadedFile uploadedLocalFile_proofaddress =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Gender (optional, kept for compatibility)
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;

  // State
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;

  // Local Government Area
  FocusNode? textFieldFocusNode5;
  TextEditingController? textController5;
  String? Function(BuildContext, String?)? textController5Validator;

  // City
  FocusNode? textFieldFocusNode6;
  TextEditingController? textController6;
  String? Function(BuildContext, String?)? textController6Validator;

  // Street Name
  FocusNode? textFieldFocusNode7;
  TextEditingController? textController7;
  String? Function(BuildContext, String?)? textController7Validator;

  // House Number
  FocusNode? textFieldFocusNode8;
  TextEditingController? textController8;
  String? Function(BuildContext, String?)? textController8Validator;

  // Nearest Landmark (optional) / Residential Description
  FocusNode? textFieldFocusNode9;
  TextEditingController? textController9;

  // Landmark Description
  FocusNode? textFieldFocusNode10;
  TextEditingController? textController10;

  // PEP Status
  String? dropDownValue3;
  FormFieldController<String>? dropDownValueController3;

  ApiCallResponse? walletenquiry;
  ApiCallResponse? tierone1;
  FFUploadedFile? userphoto;
  FFUploadedFile? proofaddress;
  FFUploadedFile? utilitybill;
  FFUploadedFile? nincard;
  ApiCallResponse? upgradetwo;
  ApiCallResponse? apiResultblu;

  late BottomAppBarModel bottomAppBarModel;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    bottomAppBarModel = createModel(context, () => BottomAppBarModel());
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
    textFieldFocusNode4?.dispose();
    textController4?.dispose();
    textFieldFocusNode5?.dispose();
    textController5?.dispose();
    textFieldFocusNode6?.dispose();
    textController6?.dispose();
    textFieldFocusNode7?.dispose();
    textController7?.dispose();
    textFieldFocusNode8?.dispose();
    textController8?.dispose();
    textFieldFocusNode9?.dispose();
    textController9?.dispose();
    textFieldFocusNode10?.dispose();
    textController10?.dispose();
    bottomAppBarModel.dispose();
  }
}
