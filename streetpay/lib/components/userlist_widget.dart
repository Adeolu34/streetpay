import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'userlist_model.dart';
export 'userlist_model.dart';

class UserlistWidget extends StatefulWidget {
  const UserlistWidget({
    super.key,
    this.parameter1,
  });

  final List<String>? parameter1;

  @override
  State<UserlistWidget> createState() => _UserlistWidgetState();
}

class _UserlistWidgetState extends State<UserlistWidget>
    with TickerProviderStateMixin {
  late UserlistModel _model;

  final animationsMap = <String, AnimationInfo>{};


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserlistModel());

    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final names = widget.parameter1?.toList() ?? [];

        return Column(
          mainAxisSize: MainAxisSize.max,
          children: List.generate(names.length, (namesIndex) {
            final namesItem = names[namesIndex];
            return Text(
              namesItem,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation']!);
          }),
        ).animateOnPageLoad(animationsMap['columnOnPageLoadAnimation']!);
      },
    );
  }
}
