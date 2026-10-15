import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'resetpassword_widget.dart' show ResetpasswordWidget;
import 'package:flutter/material.dart';

class ResetpasswordModel extends FlutterFlowModel<ResetpasswordWidget> {
  ///  Local state fields for this page.

  bool optuse = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - API (streetauth)] action in resetpassword widget.
  ApiCallResponse? strretauth;
  // Stores action output result for [Backend Call - API (getsecretquestions)] action in resetpassword widget.
  ApiCallResponse? questions;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for phoneno widget.
  FocusNode? phonenoFocusNode;
  TextEditingController? phonenoTextController;
  String? Function(BuildContext, String?)? phonenoTextControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  // State field(s) for DropDown widget.
  String? dropDownValue3;
  FormFieldController<String>? dropDownValueController3;
  // Stores action output result for [Backend Call - API (returntierprofile)] action in Button widget.
  ApiCallResponse? tierone;
  // State field(s) for DropDown widget.
  String? dropDownValue4;
  FormFieldController<String>? dropDownValueController4;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // Stores action output result for [Backend Call - API (verifysecretquestion)] action in Button widget.
  ApiCallResponse? validquestion;
  // Stores action output result for [Backend Call - API (getotpfromphone)] action in RichText widget.
  ApiCallResponse? otpget;
  bool isOtpLoading = false;
  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // Stores action output result for [Backend Call - API (reverifyotp)] action in PinCode widget.
  ApiCallResponse? verifyotp;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController4;
  late bool passwordVisibility1;
  String? Function(BuildContext, String?)? textController4Validator;
  String? _textController4Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Password cannot be empty';
    }

    if (val.length < 5) {
      return 'Requires at least 5 characters.';
    }
    if (val.length > 5) {
      return 'Maximum 5 characters allowed, currently ${val.length}.';
    }
    if (!RegExp(r'^\d{5}$').hasMatch(val)) {
      return 'Enter a valid 5 digit number';
    }
    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController5;
  late bool passwordVisibility2;
  String? Function(BuildContext, String?)? textController5Validator;
  String? _textController5Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'This field is required';
    }

    if (val.length < 5) {
      return 'Require 5 digits';
    }
    if (val.length > 5) {
      return 'Require 5 digits';
    }
    if (!RegExp(r'^\d{5}$').hasMatch(val)) {
      return 'Enter a valid 5 digit number';
    }
    return null;
  }

  // Stores action output result for [Backend Call - API (resetpincode)] action in Button widget.
  ApiCallResponse? apiResultb59;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    pinCodeController = TextEditingController();
    passwordVisibility1 = false;
    textController4Validator = _textController4Validator;
    passwordVisibility2 = false;
    textController5Validator = _textController5Validator;
  }

  @override
  void dispose() {
    columnController?.dispose();
    phonenoFocusNode?.dispose();
    phonenoTextController?.dispose();

    textFieldFocusNode1?.dispose();
    textController2?.dispose();

    textFieldFocusNode2?.dispose();
    textController3?.dispose();

    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();

    textFieldFocusNode3?.dispose();
    textController4?.dispose();

    textFieldFocusNode4?.dispose();
    textController5?.dispose();
  }
}
