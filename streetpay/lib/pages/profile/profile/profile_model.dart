import '/backend/api_requests/api_calls.dart';
import '/components/line_item/line_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (wallet enquiry)] action in Profile widget.
  ApiCallResponse? accountdetails;
  // Stores action output result for [Backend Call - API (upgradestatus)] action in Profile widget.
  ApiCallResponse? upgradestatus1;
  // Model for LineItem component.
  late LineItemModel lineItemModel1;
  // Model for LineItem component.
  late LineItemModel lineItemModel2;
  // Model for LineItem component.
  late LineItemModel lineItemModel3;
  // Model for LineItem component.
  late LineItemModel lineItemModel4;

  @override
  void initState(BuildContext context) {
    lineItemModel1 = createModel(context, () => LineItemModel());
    lineItemModel2 = createModel(context, () => LineItemModel());
    lineItemModel3 = createModel(context, () => LineItemModel());
    lineItemModel4 = createModel(context, () => LineItemModel());
  }

  @override
  void dispose() {
    lineItemModel1.dispose();
    lineItemModel2.dispose();
    lineItemModel3.dispose();
    lineItemModel4.dispose();
  }
}
