import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/overview_card/overview_card_widget.dart';
import '/components/overview_carddebit/overview_carddebit_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'transaction_historybatches_widget.dart'
    show TransactionHistorybatchesWidget;
import 'package:flutter/material.dart';

class TransactionHistorybatchesModel
    extends FlutterFlowModel<TransactionHistorybatchesWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (wallethistory)] action in TransactionHistorybatches widget.
  ApiCallResponse? wallethistory;
  // State field(s) for Column widget.
  ScrollController? columnController1;
  // Model for OverviewCard component.
  late OverviewCardModel overviewCardModel;
  // Model for OverviewCarddebit component.
  late OverviewCarddebitModel overviewCarddebitModel;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // Model for BottomAppBar component.
  late BottomAppBarModel bottomAppBarModel;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    overviewCardModel = createModel(context, () => OverviewCardModel());
    overviewCarddebitModel =
        createModel(context, () => OverviewCarddebitModel());
    columnController2 = ScrollController();
    bottomAppBarModel = createModel(context, () => BottomAppBarModel());
  }

  @override
  void dispose() {
    columnController1?.dispose();
    overviewCardModel.dispose();
    overviewCarddebitModel.dispose();
    columnController2?.dispose();
    bottomAppBarModel.dispose();
  }
}
