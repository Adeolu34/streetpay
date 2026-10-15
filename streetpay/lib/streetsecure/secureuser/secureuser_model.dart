import '/backend/api_requests/api_calls.dart';
import '/components/noresultfound_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/streetsecure/sendconnectcomp/sendconnectcomp_widget.dart';
import 'secureuser_widget.dart' show SecureuserWidget;
import 'package:flutter/material.dart';

class SecureuserModel extends FlutterFlowModel<SecureuserWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (streetauth)] action in secureuser widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (getrequestlist)] action in secureuser widget.
  ApiCallResponse? apiResultiq8;
  // Stores action output result for [Backend Call - API (getsecurehistory)] action in secureuser widget.
  ApiCallResponse? history;
  // Stores action output result for [Custom Action - getlocationpermission] action in FloatingActionButton widget.
  bool? location2;
  // Stores action output result for [Backend Call - API (locationdetect)] action in FloatingActionButton widget.
  ApiCallResponse? locationdetect2;
  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Column widget.
  ScrollController? columnController3;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (retriveaccountfromwalletid)] action in TextField widget.
  ApiCallResponse? retrievewallet;
  // Model for sendconnectcomp component.
  late SendconnectcompModel sendconnectcompModel;
  // Model for noresultfound component.
  late NoresultfoundModel noresultfoundModel;
  // Stores action output result for [Custom Action - checkJsonList] action in Container widget.
  bool? istrue;
  // State field(s) for Column widget.
  ScrollController? columnController4;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    columnController3 = ScrollController();
    sendconnectcompModel = createModel(context, () => SendconnectcompModel());
    noresultfoundModel = createModel(context, () => NoresultfoundModel());
    columnController4 = ScrollController();
  }

  @override
  void dispose() {
    columnController1?.dispose();
    columnController2?.dispose();
    tabBarController?.dispose();
    columnController3?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    sendconnectcompModel.dispose();
    noresultfoundModel.dispose();
    columnController4?.dispose();
  }
}
