import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'login1_widget.dart' show Login1Widget;
import 'package:flutter/material.dart';

class Login1Model extends FlutterFlowModel<Login1Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for scrollingContainer widget.
  ScrollController? scrollingContainerScrollController;
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // Stores action output result for [Backend Call - API (streetauth)] action in Button widget.
  ApiCallResponse? streetaut;
  // Stores action output result for [Custom Action - getdeviceid] action in Button widget.
  String? deviceid;
  // Stores action output result for [Backend Call - API (ispincodevalid)] action in Button widget.
  ApiCallResponse? pincodevalid;
  // Stores action output result for [Backend Call - API (gettempid)] action in Button widget.
  ApiCallResponse? tempid;

  @override
  void initState(BuildContext context) {
    scrollingContainerScrollController = ScrollController();
    passwordVisibility = false;
  }

  @override
  void dispose() {
    scrollingContainerScrollController?.dispose();
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
