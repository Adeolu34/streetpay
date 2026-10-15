import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/overview_card/overview_card_widget.dart';
import '/components/overview_carddebit/overview_carddebit_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'transaction_history_widget.dart' show TransactionHistoryWidget;
import 'package:flutter/material.dart';

class TransactionHistoryModel
    extends FlutterFlowModel<TransactionHistoryWidget> {
  ///  Local state fields for this page.

  bool istrue = false;

  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Backend Call - API (wallethistory)] action in TransactionHistory widget.
  ApiCallResponse? wallethistory22;
  // Stores action output result for [Backend Call - API (wallethistory)] action in TransactionHistory widget.
  ApiCallResponse? wallethistory3;
  // State field(s) for Column widget.
  ScrollController? columnController1;
  DateTime? datePicked1;
  DateTime? datePicked2;
  // Model for OverviewCard component.
  late OverviewCardModel overviewCardModel1;
  // Model for OverviewCarddebit component.
  late OverviewCarddebitModel overviewCarddebitModel1;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // Model for OverviewCard component.
  late OverviewCardModel overviewCardModel2;
  // Model for OverviewCarddebit component.
  late OverviewCarddebitModel overviewCarddebitModel2;
  // State field(s) for Column widget.
  ScrollController? columnController3;
  // Model for BottomAppBar component.
  late BottomAppBarModel bottomAppBarModel;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    overviewCardModel1 = createModel(context, () => OverviewCardModel());
    overviewCarddebitModel1 =
        createModel(context, () => OverviewCarddebitModel());
    columnController2 = ScrollController();
    overviewCardModel2 = createModel(context, () => OverviewCardModel());
    overviewCarddebitModel2 =
        createModel(context, () => OverviewCarddebitModel());
    columnController3 = ScrollController();
    bottomAppBarModel = createModel(context, () => BottomAppBarModel());
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    columnController1?.dispose();
    overviewCardModel1.dispose();
    overviewCarddebitModel1.dispose();
    columnController2?.dispose();
    overviewCardModel2.dispose();
    overviewCarddebitModel2.dispose();
    columnController3?.dispose();
    bottomAppBarModel.dispose();
  }
}
