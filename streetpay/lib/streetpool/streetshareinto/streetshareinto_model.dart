import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'streetshareinto_widget.dart' show StreetshareintoWidget;
import 'package:flutter/material.dart';

class StreetshareintoModel extends FlutterFlowModel<StreetshareintoWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
  }
}
