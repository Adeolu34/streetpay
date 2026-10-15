import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/list_item_card/list_item_card_widget.dart';
import '/components/profile_header/profile_header_widget.dart';
import '/components/switch_item_card/switch_item_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'app_settings_widget.dart' show AppSettingsWidget;
import 'package:flutter/material.dart';

class AppSettingsModel extends FlutterFlowModel<AppSettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (wallet enquiry)] action in AppSettings widget.
  ApiCallResponse? apiResultu2s;
  // Model for ProfileHeader component.
  late ProfileHeaderModel profileHeaderModel;
  // Model for ListItemCard component.
  late ListItemCardModel listItemCardModel1;
  // Model for ListItemCard component.
  late ListItemCardModel listItemCardModel2;
  // Model for SwitchItemCard component.
  late SwitchItemCardModel switchItemCardModel;
  // Model for BottomAppBar component.
  late BottomAppBarModel bottomAppBarModel;

  @override
  void initState(BuildContext context) {
    profileHeaderModel = createModel(context, () => ProfileHeaderModel());
    listItemCardModel1 = createModel(context, () => ListItemCardModel());
    listItemCardModel2 = createModel(context, () => ListItemCardModel());
    switchItemCardModel = createModel(context, () => SwitchItemCardModel());
    bottomAppBarModel = createModel(context, () => BottomAppBarModel());
  }

  @override
  void dispose() {
    profileHeaderModel.dispose();
    listItemCardModel1.dispose();
    listItemCardModel2.dispose();
    switchItemCardModel.dispose();
    bottomAppBarModel.dispose();
  }
}
