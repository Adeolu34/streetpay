import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'openwallet_widget.dart' show OpenwalletWidget;
import 'package:flutter/material.dart';

class OpenwalletModel extends FlutterFlowModel<OpenwalletWidget> {
  /// State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  ScrollController? columnController;

  // First Name
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'First Name is required';
    }
    return null;
  }

  // Last Name
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Last Name is required';
    }
    return null;
  }

  // NIN (National Identity Number - 11 digits)
  FocusNode? textFieldFocusNodeNIN;
  TextEditingController? textControllerNIN;
  String? Function(BuildContext, String?)? textControllerNINValidator;
  String? _textControllerNINValidator(BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'NIN is required';
    }
    if (!RegExp(r'^\d{11}$').hasMatch(val.trim())) {
      return 'NIN must be exactly 11 digits';
    }
    return null;
  }

  // BVN (Bank Verification Number - 11 digits)
  FocusNode? textFieldFocusNodeBVN;
  TextEditingController? textControllerBVN;
  String? Function(BuildContext, String?)? textControllerBVNValidator;
  String? _textControllerBVNValidator(BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'BVN is required';
    }
    if (!RegExp(r'^\d{11}$').hasMatch(val.trim())) {
      return 'BVN must be exactly 11 digits';
    }
    return null;
  }

  // Legacy field for backwards compatibility
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  // Email
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  String? _textController4Validator(BuildContext context, String? val) {
    if (val != null && val.trim().isNotEmpty) {
      if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(val.trim())) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  // Phone Number
  FocusNode? textFieldFocusNode5;
  TextEditingController? textController5;
  String? Function(BuildContext, String?)? textController5Validator;
  String? _textController5Validator(BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Phone Number is required';
    }
    final cleaned = val.trim().replaceAll(' ', '').replaceAll('-', '');
    if (!RegExp(r'^(0|\+?234)(7[0-9]|8[0-9]|9[0-1])\d{8}$').hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // Gender: DropDown 1
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;

  // Date of Birth: Day (DropDown 2), Month (DropDown 3), Year (DropDown 4)
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  String? dropDownValue3;
  FormFieldController<String>? dropDownValueController3;
  String? dropDownValue4;
  FormFieldController<String>? dropDownValueController4;

  // API Call results
  ApiCallResponse? streetauth;
  ApiCallResponse? waasopen;
  ApiCallResponse? insertintotierone1;
  ApiCallResponse? createid1;
  ApiCallResponse? openwallet;
  ApiCallResponse? insertintotierone;
  ApiCallResponse? createid;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    textController1Validator = _textController1Validator;
    textController2Validator = _textController2Validator;
    textControllerNINValidator = _textControllerNINValidator;
    textControllerBVNValidator = _textControllerBVNValidator;
    textController3Validator = _textControllerBVNValidator;
    textController4Validator = _textController4Validator;
    textController5Validator = _textController5Validator;
  }

  @override
  void dispose() {
    columnController?.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNodeNIN?.dispose();
    textControllerNIN?.dispose();

    textFieldFocusNodeBVN?.dispose();
    textControllerBVN?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();

    textFieldFocusNode5?.dispose();
    textController5?.dispose();
  }
}
