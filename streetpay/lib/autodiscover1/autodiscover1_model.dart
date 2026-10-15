import '/components/autodiscover_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'autodiscover1_widget.dart' show Autodiscover1Widget;
import 'package:flutter/material.dart';

class Autodiscover1Model extends FlutterFlowModel<Autodiscover1Widget> {
  ///  State fields for stateful widgets in this page.

  // Model for autodiscover component.
  late AutodiscoverModel autodiscoverModel;

  @override
  void initState(BuildContext context) {
    autodiscoverModel = createModel(context, () => AutodiscoverModel());
  }

  @override
  void dispose() {
    autodiscoverModel.dispose();
  }
}
