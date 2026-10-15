import '/backend/api_requests/api_calls.dart';
import '/components/account_card/account_card_widget.dart';
import '/components/noresultfound_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'autodiscover_widget.dart' show AutodiscoverWidget;
import 'package:flutter/material.dart';

class AutodiscoverModel extends FlutterFlowModel<AutodiscoverWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (locationdetect)] action in IconButton widget.
  ApiCallResponse? getlocation;
  // Stores action output result for [Custom Action - getlocationpermission] action in IconButton widget.
  bool? location2;
  // Stores action output result for [Backend Call - API (locationdetect)] action in IconButton widget.
  ApiCallResponse? locationdetect2;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Stores action output result for [Custom Action - checkJsonList] action in Container widget.
  bool? istrue;
  // Stores action output result for [Backend Call - API (getaccountbalance)] action in ListView widget.
  ApiCallResponse? getaccountreload;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (streetauth)] action in TextField widget.
  ApiCallResponse? streetaut;
  // Stores action output result for [Backend Call - API (retriveaccountfromwalletid)] action in TextField widget.
  ApiCallResponse? retrievewallet;
  // Stores action output result for account number lookup via walletEnquiry.
  ApiCallResponse? walletEnquiryResult;
  // Model for AccountCard component.
  late AccountCardModel accountCardModel2;
  // Model for noresultfound component.
  late NoresultfoundModel noresultfoundModel;

  @override
  void initState(BuildContext context) {
    accountCardModel2 = createModel(context, () => AccountCardModel());
    noresultfoundModel = createModel(context, () => NoresultfoundModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    accountCardModel2.dispose();
    noresultfoundModel.dispose();
  }
}
