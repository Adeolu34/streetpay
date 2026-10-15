import '/backend/api_requests/api_calls.dart';
import '/components/profile_header/profile_header_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_pager_header_widget.dart' show HomePagerHeaderWidget;
import 'package:flutter/material.dart';

class HomePagerHeaderModel extends FlutterFlowModel<HomePagerHeaderWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for ProfileHeader component.
  late ProfileHeaderModel profileHeaderModel;
  // Stores action output result for [Backend Call - API (wallet enquiry)] action in IconButton widget.
  ApiCallResponse? wallet;

  @override
  void initState(BuildContext context) {
    profileHeaderModel = createModel(context, () => ProfileHeaderModel());
  }

  @override
  void dispose() {
    profileHeaderModel.dispose();
  }
}
