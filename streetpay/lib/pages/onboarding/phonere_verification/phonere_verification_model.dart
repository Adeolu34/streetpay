import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'phonere_verification_widget.dart' show PhonereVerificationWidget;
import 'package:flutter/material.dart';

class PhonereVerificationModel
    extends FlutterFlowModel<PhonereVerificationWidget> {
  ///  Local state fields for this page.

  String? error;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // Stores action output result for [Backend Call - API (streetauth)] action in PinCode widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (reverifyotp)] action in PinCode widget.
  ApiCallResponse? apiResult11q;
  // Stores action output result for [Backend Call - API (returntierprofile)] action in PinCode widget.
  ApiCallResponse? teirprofile;
  // State field(s) for Timer widget.
  final timerInitialTimeMs = 0;
  int timerMilliseconds = 0;
  String timerValue = StopWatchTimer.getDisplayTime(
    0,
    hours: false,
    minute: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countUp));

  // Stores action output result for [Backend Call - API (getotpfromphone)] action in Text widget.
  ApiCallResponse? apiResultkbz;
  bool isResending = false;

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();

    timerController.dispose();
  }
}
