import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'viewmyacces_widget.dart' show ViewmyaccesWidget;
import 'package:flutter/material.dart';

class ViewmyaccesModel extends FlutterFlowModel<ViewmyaccesWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (listhostprofile)] action in viewmyacces widget.
  ApiCallResponse? listhost;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController = FlutterFlowDataTableController<String>();
  // Stores action output result for [Backend Call - API (returntierprofile)] action in Text widget.
  ApiCallResponse? returnprofile;
  // Model for BottomAppBar component.
  late BottomAppBarModel bottomAppBarModel;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    bottomAppBarModel = createModel(context, () => BottomAppBarModel());
  }

  @override
  void dispose() {
    columnController?.dispose();
    paginatedDataTableController.dispose();
    bottomAppBarModel.dispose();
  }
}
