import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/grantaccess/grantaccess_widget.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'grant_access_widget.dart' show GrantAccessWidget;
import 'package:flutter/material.dart';

class GrantAccessModel extends FlutterFlowModel<GrantAccessWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (streetauth)] action in grant_access widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (listguestprofile)] action in grant_access widget.
  ApiCallResponse? guestprofile;
  // Stores action output result for [Backend Call - API (listhostprofile)] action in grant_access widget.
  ApiCallResponse? hostprofile;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // Model for grantaccess component.
  late GrantaccessModel grantaccessModel;
  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController = FlutterFlowDataTableController<String>();
  // Stores action output result for [Backend Call - API (revokeguest)] action in Icon widget.
  ApiCallResponse? apiResultcde;
  // Model for BottomAppBar component.
  late BottomAppBarModel bottomAppBarModel;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    grantaccessModel = createModel(context, () => GrantaccessModel());
    bottomAppBarModel = createModel(context, () => BottomAppBarModel());
  }

  @override
  void dispose() {
    columnController?.dispose();
    grantaccessModel.dispose();
    paginatedDataTableController.dispose();
    bottomAppBarModel.dispose();
  }
}
