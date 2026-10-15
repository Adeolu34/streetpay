import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'switchss_model.dart';
export 'switchss_model.dart';

class SwitchssWidget extends StatefulWidget {
  const SwitchssWidget({
    super.key,
    required this.id,
    required this.userstatus,
  });

  final String? id;
  final String? userstatus;

  @override
  State<SwitchssWidget> createState() => _SwitchssWidgetState();
}

class _SwitchssWidgetState extends State<SwitchssWidget> {
  late SwitchssModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SwitchssModel());

    _model.switchValue = widget.userstatus == '1' ? true : false;
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Switch.adaptive(
          value: _model.switchValue!,
          onChanged: (newValue) async {
            safeSetState(() => _model.switchValue = newValue);
          },
          activeColor: FlutterFlowTheme.of(context).primaryBackground,
          activeTrackColor: FlutterFlowTheme.of(context).primary,
          inactiveTrackColor: FlutterFlowTheme.of(context).primary,
          inactiveThumbColor: FlutterFlowTheme.of(context).secondary,
        ),
      ],
    );
  }
}
