import '/backend/api_requests/api_calls.dart';
import '/components/account_card/account_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'payment_widget.dart' show PaymentWidget;
import 'package:flutter/material.dart';

class PaymentModel extends FlutterFlowModel<PaymentWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // Model for AccountCard component.
  late AccountCardModel accountCardModel1;
  // Model for AccountCard component.
  late AccountCardModel accountCardModel2;
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
  // Stores action output result for [Backend Call - API (streetauth)] action in Button widget.
  ApiCallResponse? authstreet;
  // Stores action output result for [Backend Call - API (returntierprofile)] action in Button widget.
  ApiCallResponse? tierone;
  // Stores action output result for [Bottom Sheet - paymentpinverify] action in Button widget.
  bool? payrecipt;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    accountCardModel1 = createModel(context, () => AccountCardModel());
    accountCardModel2 = createModel(context, () => AccountCardModel());
  }

  @override
  void dispose() {
    columnController?.dispose();
    accountCardModel1.dispose();
    accountCardModel2.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
