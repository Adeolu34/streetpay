import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'kycpaggge_widget.dart' show KycpagggeWidget;
import 'package:flutter/material.dart';

class KycpagggeModel extends FlutterFlowModel<KycpagggeWidget> {
  ///  Local state fields for this page.

  bool ispep = false;

  bool uploadtoggle = false;

  bool personaltoggle = false;

  bool residentialtoggle = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getallstates)] action in kycpaggge widget.
  ApiCallResponse? statelist;
  // State field(s) for Column widget.
  ScrollController? columnController;
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
  DateTime? datePicked;
  // State field(s) for gender widget.
  String? genderValue;
  FormFieldController<String>? genderValueController;
  // State field(s) for state widget.
  String? stateValue;
  FormFieldController<String>? stateValueController;
  // State field(s) for localgovernment widget.
  String? localgovernmentValue;
  FormFieldController<String>? localgovernmentValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode5;
  TextEditingController? textController5;
  String? Function(BuildContext, String?)? textController5Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode6;
  TextEditingController? textController6;
  String? Function(BuildContext, String?)? textController6Validator;
  // State field(s) for Description of Address TextField widget.
  FocusNode? textFieldFocusNode7;
  TextEditingController? textController7;
  String? Function(BuildContext, String?)? textController7Validator;
  // State field(s) for Closest Landmark TextField widget.
  FocusNode? textFieldFocusNode8;
  TextEditingController? textController8;
  String? Function(BuildContext, String?)? textController8Validator;

  // Discrete address points for 9PSB regulatory compliance
  FocusNode? textFieldFocusNodeFillingStation;
  TextEditingController? textControllerFillingStation;
  String? Function(BuildContext, String?)? textControllerFillingStationValidator;

  FocusNode? textFieldFocusNodeNearestBuilding;
  TextEditingController? textControllerNearestBuilding;
  String? Function(BuildContext, String?)? textControllerNearestBuildingValidator;

  FocusNode? textFieldFocusNodeHouseColor;
  TextEditingController? textControllerHouseColor;
  String? Function(BuildContext, String?)? textControllerHouseColorValidator;

  bool isDataUploading_nincard = false;
  FFUploadedFile uploadedLocalFile_nincard =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_proofaddresss = false;
  FFUploadedFile uploadedLocalFile_proofaddresss =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Separate field for the uploaded utility bill (distinct from the generated POA)
  bool isDataUploading_utilitybill = false;
  FFUploadedFile uploadedLocalFile_utilitybill =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_selfie = false;
  FFUploadedFile uploadedLocalFile_selfie =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Backend Call - API (wallet enquiry)] action in Button widget.
  ApiCallResponse? walletenquiry;
  // Stores action output result for [Backend Call - API (returntierprofile)] action in Button widget.
  ApiCallResponse? tierone1;
  // Stores action output result for [Custom Action - newCustomAction2] action in Button widget.
  FFUploadedFile? userphoto;
  // Stores action output result for [Custom Action - newCustomAction2] action in Button widget.
  FFUploadedFile? proofaddress;
  // Stores action output result for [Custom Action - newCustomAction2] action in Button widget.
  FFUploadedFile? utilitybill;
  // Stores action output result for [Custom Action - newCustomAction2] action in Button widget.
  FFUploadedFile? nincard;
  // Stores action output result for [Backend Call - API (upgradetoteirtwo)] action in Button widget.
  ApiCallResponse? upgradetwo;
  // Stores action output result for [Custom Action - newCustomAction2] action in Button widget.
  FFUploadedFile? proofadress;
  // Stores action output result for [Backend Call - API (upgradetotierthree)] action in Button widget.
  ApiCallResponse? upgradethreeCopy;

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

    textFieldFocusNodeFillingStation?.dispose();
    textControllerFillingStation?.dispose();

    textFieldFocusNodeNearestBuilding?.dispose();
    textControllerNearestBuilding?.dispose();

    textFieldFocusNodeHouseColor?.dispose();
    textControllerHouseColor?.dispose();
  }
}
