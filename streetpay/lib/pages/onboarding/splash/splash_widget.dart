import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:new_version_plus/new_version_plus.dart';
import '/custom_code/actions/getupdatestatus.dart';
import '/custom_code/widgets/force_update_overlay.dart';
import 'splash_model.dart';
export 'splash_model.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  static String routeName = 'Splash';
  static String routePath = '/splash_screen';

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget>
    with TickerProviderStateMixin {
  late SplashModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};
  VersionStatus? _updateStatus;

  void _proceedToApp() {
    if (!mounted) return;
    if (FFAppState().isRegistered == true &&
        FFAppState().phonenumber.isNotEmpty) {
      context.goNamed(LoginbiometricWidget.routeName);
    } else {
      context.goNamed(Login1Widget.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SplashModel());

    // Navigation timer and Play Store update check
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final splashDelay = Future.delayed(const Duration(milliseconds: 2400));
      VersionStatus? status;
      try {
        status = await checkAppVersionStatus(timeout: const Duration(seconds: 3));
      } catch (e) {
        debugPrint('[Splash] Version check error: $e');
      }

      await splashDelay;
      if (!mounted) return;

      if (status != null && status.canUpdate) {
        setState(() {
          _updateStatus = status;
        });
        return;
      }

      _proceedToApp();
    });

    animationsMap.addAll({
      'splashImageOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeIn,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 800.0.ms,
            begin: const Offset(1.04, 1.04),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    // Set immersive status bar style for splash
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF00A651),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/splash_screen.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ).animateOnPageLoad(animationsMap['splashImageOnPageLoadAnimation']!),
          ),
          if (_updateStatus != null)
            ForceUpdateOverlay(
              status: _updateStatus,
              isForceUpdate: false,
              onDismiss: () {
                setState(() => _updateStatus = null);
                _proceedToApp();
              },
            ),
        ],
      ),
    );
  }
}
