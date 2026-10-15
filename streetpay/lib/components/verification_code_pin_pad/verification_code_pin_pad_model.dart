import '/components/circle_digit_key/circle_digit_key_widget.dart';
import '/components/circled_icon_key/circled_icon_key_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'verification_code_pin_pad_widget.dart'
    show VerificationCodePinPadWidget;
import 'package:flutter/material.dart';

class VerificationCodePinPadModel
    extends FlutterFlowModel<VerificationCodePinPadWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // Model for CircleDigitKey component.
  late CircleDigitKeyModel circleDigitKeyModel1;
  // Model for CircleDigitKey component.
  late CircleDigitKeyModel circleDigitKeyModel2;
  // Model for CircleDigitKey component.
  late CircleDigitKeyModel circleDigitKeyModel3;
  // Model for CircleDigitKey component.
  late CircleDigitKeyModel circleDigitKeyModel4;
  // Model for CircleDigitKey component.
  late CircleDigitKeyModel circleDigitKeyModel5;
  // Model for CircleDigitKey component.
  late CircleDigitKeyModel circleDigitKeyModel6;
  // Model for CircleDigitKey component.
  late CircleDigitKeyModel circleDigitKeyModel7;
  // Model for CircleDigitKey component.
  late CircleDigitKeyModel circleDigitKeyModel8;
  // Model for CircleDigitKey component.
  late CircleDigitKeyModel circleDigitKeyModel9;
  // Model for CircledIconKey component.
  late CircledIconKeyModel circledIconKeyModel1;
  // Model for CircleDigitKey component.
  late CircleDigitKeyModel circleDigitKeyModel10;
  // Model for CircledIconKey component.
  late CircledIconKeyModel circledIconKeyModel2;

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
    circleDigitKeyModel1 = createModel(context, () => CircleDigitKeyModel());
    circleDigitKeyModel2 = createModel(context, () => CircleDigitKeyModel());
    circleDigitKeyModel3 = createModel(context, () => CircleDigitKeyModel());
    circleDigitKeyModel4 = createModel(context, () => CircleDigitKeyModel());
    circleDigitKeyModel5 = createModel(context, () => CircleDigitKeyModel());
    circleDigitKeyModel6 = createModel(context, () => CircleDigitKeyModel());
    circleDigitKeyModel7 = createModel(context, () => CircleDigitKeyModel());
    circleDigitKeyModel8 = createModel(context, () => CircleDigitKeyModel());
    circleDigitKeyModel9 = createModel(context, () => CircleDigitKeyModel());
    circledIconKeyModel1 = createModel(context, () => CircledIconKeyModel());
    circleDigitKeyModel10 = createModel(context, () => CircleDigitKeyModel());
    circledIconKeyModel2 = createModel(context, () => CircledIconKeyModel());
  }

  @override
  void dispose() {
    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();

    circleDigitKeyModel1.dispose();
    circleDigitKeyModel2.dispose();
    circleDigitKeyModel3.dispose();
    circleDigitKeyModel4.dispose();
    circleDigitKeyModel5.dispose();
    circleDigitKeyModel6.dispose();
    circleDigitKeyModel7.dispose();
    circleDigitKeyModel8.dispose();
    circleDigitKeyModel9.dispose();
    circledIconKeyModel1.dispose();
    circleDigitKeyModel10.dispose();
    circledIconKeyModel2.dispose();
  }
}
