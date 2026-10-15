import '/flutter_flow/flutter_flow_util.dart';
import 'jobvideo_widget.dart' show JobvideoWidget;
import 'package:flutter/material.dart';

class JobvideoModel extends FlutterFlowModel<JobvideoWidget> {
  ///  State fields for stateful widgets in this component.

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
