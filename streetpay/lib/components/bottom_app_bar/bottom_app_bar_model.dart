import '/backend/api_requests/api_calls.dart';
import '/components/bottom_bar_item/bottom_bar_item_widget.dart';
import '/components/no_icon_bottom_bar_item/no_icon_bottom_bar_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'bottom_app_bar_widget.dart' show BottomAppBarWidget;
import 'package:flutter/material.dart';

class BottomAppBarModel extends FlutterFlowModel<BottomAppBarWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for BottomBarItem component.
  late BottomBarItemModel bottomBarItemModel1;
  // Stores action output result for [Backend Call - API (streetauth)] action in BottomBarItem widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (getphonen)] action in BottomBarItem widget.
  ApiCallResponse? phoneno;
  // Model for BottomBarItem component.
  late BottomBarItemModel bottomBarItemModel2;
  // Model for NoIconBottomBarItem component.
  late NoIconBottomBarItemModel noIconBottomBarItemModel;
  // Model for BottomBarItem component.
  late BottomBarItemModel bottomBarItemModel3;
  // Model for BottomBarItem component.
  late BottomBarItemModel bottomBarItemModel4;

  @override
  void initState(BuildContext context) {
    bottomBarItemModel1 = createModel(context, () => BottomBarItemModel());
    bottomBarItemModel2 = createModel(context, () => BottomBarItemModel());
    noIconBottomBarItemModel =
        createModel(context, () => NoIconBottomBarItemModel());
    bottomBarItemModel3 = createModel(context, () => BottomBarItemModel());
    bottomBarItemModel4 = createModel(context, () => BottomBarItemModel());
  }

  @override
  void dispose() {
    bottomBarItemModel1.dispose();
    bottomBarItemModel2.dispose();
    noIconBottomBarItemModel.dispose();
    bottomBarItemModel3.dispose();
    bottomBarItemModel4.dispose();
  }
}
