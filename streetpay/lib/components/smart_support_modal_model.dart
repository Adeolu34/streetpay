import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'smart_support_modal_widget.dart' show SmartSupportModalWidget;

class SmartSupportModalModel extends FlutterFlowModel<SmartSupportModalWidget> {
  // State field(s) for search TextField.
  FocusNode? searchFocusNode;
  TextEditingController? searchTextController;
  String? Function(BuildContext, String?)? searchTextControllerValidator;

  // Selected category index (0: All, 1: Registration, 2: Login, 3: Transfers)
  int selectedCategoryIndex = 0;

  // Expanded FAQ item index (-1: none expanded)
  int expandedIndex = -1;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchTextController?.dispose();
  }
}
