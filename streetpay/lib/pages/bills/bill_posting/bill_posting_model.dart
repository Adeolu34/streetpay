import '/backend/api_requests/api_calls.dart';
import '/components/account_card/account_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'bill_posting_widget.dart' show BillPostingWidget;
import 'package:flutter/material.dart';

class BillPostingModel extends FlutterFlowModel<BillPostingWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AccountCard component.
  late AccountCardModel accountCardModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // Stores action output result for [Backend Call - API (streetauth)] action in Button widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (postbill)] action in Button widget.
  ApiCallResponse? apiResult6qn;

  @override
  void initState(BuildContext context) {
    accountCardModel = createModel(context, () => AccountCardModel());
  }

  @override
  void dispose() {
    accountCardModel.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}
