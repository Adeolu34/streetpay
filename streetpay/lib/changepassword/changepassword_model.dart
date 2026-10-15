import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'changepassword_widget.dart' show ChangepasswordWidget;
import 'package:flutter/material.dart';

class ChangepasswordModel extends FlutterFlowModel<ChangepasswordWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  late bool passwordVisibility1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Enter new password is required';
    }

    if (!RegExp(r'^\d{5}$').hasMatch(val)) {
      return 'invalid character only number is allowed';
    }
    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  late bool passwordVisibility2;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Confirm new password is required';
    }

    if (val.length < 5) {
      return 'Requires at least 5 characters.';
    }
    if (val.length > 5) {
      return 'Maximum 5 characters allowed, currently ${val.length}.';
    }
    if (!RegExp(r'^\d{5}$').hasMatch(val)) {
      return 'invalid character only number is allowed';
    }
    return null;
  }

  // Stores action output result for [Backend Call - API (resetpincode)] action in Button widget.
  ApiCallResponse? passswordreset;
  // Stores action output result for [Backend Call - API (getquestion)] action in Button widget.
  ApiCallResponse? teirone;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    passwordVisibility1 = false;
    textController1Validator = _textController1Validator;
    passwordVisibility2 = false;
    textController2Validator = _textController2Validator;
  }

  @override
  void dispose() {
    columnController?.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
