import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'upgradetotier3_widget.dart' show Upgradetotier3Widget;
import 'package:flutter/material.dart';

class Upgradetotier3Model extends FlutterFlowModel<Upgradetotier3Widget> {
  ApiCallResponse? apiResultala;
  ScrollController? columnController;

  // BVN
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;

  // NIN
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  // Street / House Address
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;

  // City
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;

  // State
  FocusNode? textFieldFocusNode5;
  TextEditingController? textController5;

  // Local Government Area
  FocusNode? textFieldFocusNode6;
  TextEditingController? textController6;

  // Residential Description
  FocusNode? textFieldFocusNode7;
  TextEditingController? textController7;

  // Landmark Description
  FocusNode? textFieldFocusNode8;
  TextEditingController? textController8;

  bool isDataUploading_uploadData63 = false;
  FFUploadedFile uploadedLocalFile_uploadData63 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_utilitybill = false;
  FFUploadedFile uploadedLocalFile_utilitybill =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  FFUploadedFile? utilitybill;

  ApiCallResponse? tierone;
  FFUploadedFile? addressroff;
  ApiCallResponse? apiResultblu;

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
  }
}
