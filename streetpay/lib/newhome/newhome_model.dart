import '/backend/api_requests/api_calls.dart';
import '/components/account_card/account_card_widget.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/discoveryinfo_widget.dart';
import '/components/home_pager_header/home_pager_header_widget.dart';
import '/components/mycurrenttier_widget.dart';
import '/components/noresultfound_widget.dart';
import '/components/notification_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'newhome_widget.dart' show NewhomeWidget;
import 'package:flutter/material.dart';

class NewhomeModel extends FlutterFlowModel<NewhomeWidget> {
  ///  Local state fields for this page.

  String rebuild = 'load';

  String locations = 'Load';

  String? balance;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getlocationpermission] action in newhome widget.
  bool? location;
  // Stores action output result for [Backend Call - API (getaccountbalance)] action in newhome widget.
  ApiCallResponse? getbalance;
  // Stores action output result for [Backend Call - API (getwinners)] action in newhome widget.
  ApiCallResponse? winner;
  // Stores action output result for [Backend Call - API (getnew)] action in newhome widget.
  ApiCallResponse? news;
  InstantTimer? instantTimer;
  // Stores action output result for [Backend Call - API (getaccountbalance)] action in newhome widget.
  ApiCallResponse? getbalance2;
  // Stores action output result for [Backend Call - API (locationdetect)] action in newhome widget.
  ApiCallResponse? nearby;
  // Stores action output result for [Backend Call - API (wallethistory)] for recent activity on home page.
  ApiCallResponse? recentActivityResponse;
  // State field(s) for Column widget.
  ScrollController? columnController1;
  // Model for HomePagerHeader component.
  late HomePagerHeaderModel homePagerHeaderModel;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for mycurrenttier component.
  late MycurrenttierModel mycurrenttierModel;
  // Model for notification component.
  late NotificationModel notificationModel;
  // Stores action output result for [Custom Action - getlocationpermission] action in IconButton widget.
  bool? location2;
  // Stores action output result for [Backend Call - API (locationdetect)] action in IconButton widget.
  ApiCallResponse? locationdetect2;
  // Stores action output result for [Backend Call - API (locationdetect)] action in Button widget.
  ApiCallResponse? getlocatio;
  // Stores action output result for [Backend Call - API (locationdetect)] action in Button widget.
  ApiCallResponse? nodetect;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Column widget.
  ScrollController? columnController2;
  // State field(s) for Column widget.
  ScrollController? columnController3;
  // State field(s) for Column widget.
  ScrollController? columnController4;
  // Stores action output result for [Backend Call - API (getaccountbalance)] action in Column widget.
  ApiCallResponse? getaccountreload;
  // Model for discoveryinfo component.
  late DiscoveryinfoModel discoveryinfoModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (retriveaccountfromwalletid)] action in TextField widget.
  ApiCallResponse? retrievewallet;
  // Model for AccountCard component.
  late AccountCardModel accountCardModel2;
  // Model for noresultfound component.
  late NoresultfoundModel noresultfoundModel;
  // Model for BottomAppBar component.
  late BottomAppBarModel bottomAppBarModel;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    homePagerHeaderModel = createModel(context, () => HomePagerHeaderModel());
    mycurrenttierModel = createModel(context, () => MycurrenttierModel());
    notificationModel = createModel(context, () => NotificationModel());
    columnController2 = ScrollController();
    columnController3 = ScrollController();
    columnController4 = ScrollController();
    discoveryinfoModel = createModel(context, () => DiscoveryinfoModel());
    accountCardModel2 = createModel(context, () => AccountCardModel());
    noresultfoundModel = createModel(context, () => NoresultfoundModel());
    bottomAppBarModel = createModel(context, () => BottomAppBarModel());
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    columnController1?.dispose();
    homePagerHeaderModel.dispose();
    mycurrenttierModel.dispose();
    notificationModel.dispose();
    tabBarController?.dispose();
    columnController2?.dispose();
    columnController3?.dispose();
    columnController4?.dispose();
    discoveryinfoModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    accountCardModel2.dispose();
    noresultfoundModel.dispose();
    bottomAppBarModel.dispose();
  }
}
