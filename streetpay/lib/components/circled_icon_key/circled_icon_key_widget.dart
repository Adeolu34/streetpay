import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'circled_icon_key_model.dart';
export 'circled_icon_key_model.dart';

class CircledIconKeyWidget extends StatefulWidget {
  const CircledIconKeyWidget({
    super.key,
    required this.icon,
  });

  final Widget? icon;

  @override
  State<CircledIconKeyWidget> createState() => _CircledIconKeyWidgetState();
}

class _CircledIconKeyWidgetState extends State<CircledIconKeyWidget> {
  late CircledIconKeyModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CircledIconKeyModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58.0,
      height: 58.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryText,
        ),
      ),
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: widget.icon!,
      ),
    );
  }
}
