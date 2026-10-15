import '/components/link_account_card/link_account_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'account_settings_widget.dart' show AccountSettingsWidget;
import 'package:flutter/material.dart';

class AccountSettingsModel extends FlutterFlowModel<AccountSettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for LinkAccountCard component.
  late LinkAccountCardModel linkAccountCardModel;

  @override
  void initState(BuildContext context) {
    linkAccountCardModel = createModel(context, () => LinkAccountCardModel());
  }

  @override
  void dispose() {
    linkAccountCardModel.dispose();
  }
}
