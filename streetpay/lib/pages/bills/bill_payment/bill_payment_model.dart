import '/backend/api_requests/api_calls.dart';
import '/components/account_card/account_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'bill_payment_widget.dart' show BillPaymentWidget;
import 'package:flutter/material.dart';

class BillPaymentModel extends FlutterFlowModel<BillPaymentWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (streetauth)] action in BillPayment widget.
  ApiCallResponse? streetaut;
  // Stores action output result for [Backend Call - API (getaccountno)] action in BillPayment widget.
  ApiCallResponse? getphoneno;
  // Stores action output result for [Backend Call - API (wallet enquiry)] action in BillPayment widget.
  ApiCallResponse? apiResultsou;
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
  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? transref;
  // Stores action output result for [Custom Action - generateseesionid] action in Button widget.
  String? sessionid;
  // Stores action output result for [Backend Call - API (ignorebill)] action in Button widget.
  ApiCallResponse? ignorebill;

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
  }
}
