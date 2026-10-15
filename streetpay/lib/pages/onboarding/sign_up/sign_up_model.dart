import '/components/app_logo/app_logo_widget.dart';
import '/components/phone_number_field/phone_number_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'sign_up_widget.dart' show SignUpWidget;
import 'package:flutter/material.dart';

class SignUpModel extends FlutterFlowModel<SignUpWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // Model for AppLogo component.
  late AppLogoModel appLogoModel;
  // Model for PhoneNumberField component.
  late PhoneNumberFieldModel phoneNumberFieldModel;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for RadioButton widget.
  FormFieldController<String>? radioButtonValueController;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    appLogoModel = createModel(context, () => AppLogoModel());
    phoneNumberFieldModel = createModel(context, () => PhoneNumberFieldModel());
  }

  @override
  void dispose() {
    columnController?.dispose();
    appLogoModel.dispose();
    phoneNumberFieldModel.dispose();
  }

  /// Additional helper methods.
  String? get radioButtonValue => radioButtonValueController?.value;
}
