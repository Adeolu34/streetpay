import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'streetjob2_widget.dart' show Streetjob2Widget;
import 'package:flutter/material.dart';

class Streetjob2Model extends FlutterFlowModel<Streetjob2Widget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (searchbycategory)] action in streetjob2 widget.
  ApiCallResponse? category;
  // Stores action output result for [Backend Call - API (retrievejobprofile)] action in streetjob2 widget.
  ApiCallResponse? allprofile;
  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for TextField widget.
  final textFieldKey = GlobalKey();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? textFieldSelectedOption;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // Model for BottomAppBar component.
  late BottomAppBarModel bottomAppBarModel;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    bottomAppBarModel = createModel(context, () => BottomAppBarModel());
  }

  @override
  void dispose() {
    columnController1?.dispose();
    textFieldFocusNode?.dispose();

    columnController2?.dispose();
    bottomAppBarModel.dispose();
  }
}
