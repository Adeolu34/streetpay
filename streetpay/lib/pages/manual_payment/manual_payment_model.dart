import '/backend/api_requests/api_calls.dart';
import '/components/account_card/account_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import 'manual_payment_widget.dart' show ManualPaymentWidget;
import 'package:flutter/material.dart';

class ManualPaymentModel extends FlutterFlowModel<ManualPaymentWidget> {
  ///  Local state fields for this page.

  bool retry = false;

  String? accountname;

  Color? bottoncolor = Color(4294967295);

  int? index;

  String? bankcode;

  bool manuel = false;

  bool isResolvingAccount = false;

  bool isSearchingBanks = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (get bank list)] action in ManualPayment widget.
  ApiCallResponse? banklist;
  InstantTimer? instantTimer;
  // Stores action output result for [Backend Call - API (getaccountbalance)] action in ManualPayment widget.
  ApiCallResponse? wallatbalance;
  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // Model for AccountCard component.
  late AccountCardModel accountCardModel;
  // State field(s) for TextField widget.
  final textFieldKey1 = GlobalKey();
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? textFieldSelectedOption1;
  String? Function(BuildContext, String?)? textController1Validator;
  // Stores action output result for [Custom Action - smartBankEnquiry] action in TextField widget.
  List<dynamic>? smart;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // Stores action output result for [Backend Call - API (getreceipent)] action in ChoiceChips widget.
  ApiCallResponse? receipent2;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Backend Call - API (getreceipent)] action in DropDown widget.
  ApiCallResponse? receipent;
  // Stores action output result for [Backend Call - API (getreceipent)] action in IconButton widget.
  ApiCallResponse? receipentCopy;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? transref;
  // Stores action output result for [Custom Action - generateseesionid] action in Button widget.
  String? sessionid;
  // Stores action output result for [Backend Call - API (returntierprofile)] action in Button widget.
  ApiCallResponse? tierone;
  // Stores action output result for [Bottom Sheet - paymentpinverify] action in Button widget.
  bool? payrecipt;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    accountCardModel = createModel(context, () => AccountCardModel());
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    columnController1?.dispose();
    columnController2?.dispose();
    accountCardModel.dispose();
    textFieldFocusNode1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();
  }
}
