import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'autodicover_model.dart';
export 'autodicover_model.dart';

/// Create a page that looks exactly like this
///
class AutodicoverWidget extends StatefulWidget {
  const AutodicoverWidget({super.key});

  static String routeName = 'autodicover';
  static String routePath = '/autodicover';

  @override
  State<AutodicoverWidget> createState() => _AutodicoverWidgetState();
}

class _AutodicoverWidgetState extends State<AutodicoverWidget> {
  late AutodicoverModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AutodicoverModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
