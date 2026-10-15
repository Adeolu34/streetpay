import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/line_item/line_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'payment_confirmation_widget.dart' show PaymentConfirmationWidget;
import 'package:flutter/material.dart';

class PaymentConfirmationModel
    extends FlutterFlowModel<PaymentConfirmationWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (streetauth)] action in PaymentConfirmation widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (getphonen)] action in PaymentConfirmation widget.
  ApiCallResponse? belong;
  // Stores action output result for [Backend Call - API (getphonen)] action in PaymentConfirmation widget.
  ApiCallResponse? hostnumber;
  // Stores action output result for [Backend Call - API (getpinnedphones)] action in PaymentConfirmation widget.
  ApiCallResponse? pinnedlist;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // Model for LineItem component.
  late LineItemModel lineItemModel1;
  // Model for LineItem component.
  late LineItemModel lineItemModel2;
  // Model for LineItem component.
  late LineItemModel lineItemModel3;
  // Model for LineItem component.
  late LineItemModel lineItemModel4;
  // Model for LineItem component.
  late LineItemModel lineItemModel5;
  // Model for LineItem component.
  late LineItemModel lineItemModel6;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // Stores action output result for [Backend Call - API (streetauth)] action in Checkbox widget.
  ApiCallResponse? streetaut;
  // Stores action output result for [Backend Call - API (getphonen)] action in Checkbox widget.
  ApiCallResponse? getreceiverphonenumber;
  // Stores action output result for [Backend Call - API (getphonen)] action in Checkbox widget.
  ApiCallResponse? getsenderphonenumber;
  // Stores action output result for [Backend Call - API (insertpindata)] action in Checkbox widget.
  ApiCallResponse? apiResult33o;
  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? transref;
  // Stores action output result for [Custom Action - generateseesionid] action in Button widget.
  String? sessionid;
  // Stores action output result for [Backend Call - API (returntierprofile)] action in Button widget.
  ApiCallResponse? tierone;
  // Stores action output result for [Backend Call - API (wallet enquiry)] action in Button widget.
  ApiCallResponse? walletenquiry;
  // Stores action output result for [Backend Call - API (other bank transfer)] action in Button widget.
  ApiCallResponse? othertrans;
  // Stores action output result for [Backend Call - API (sendmail)] action in Button widget.
  ApiCallResponse? apiResultrkz;
  // Model for BottomAppBar component.
  late BottomAppBarModel bottomAppBarModel;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    lineItemModel1 = createModel(context, () => LineItemModel());
    lineItemModel2 = createModel(context, () => LineItemModel());
    lineItemModel3 = createModel(context, () => LineItemModel());
    lineItemModel4 = createModel(context, () => LineItemModel());
    lineItemModel5 = createModel(context, () => LineItemModel());
    lineItemModel6 = createModel(context, () => LineItemModel());
    bottomAppBarModel = createModel(context, () => BottomAppBarModel());
  }

  @override
  void dispose() {
    columnController?.dispose();
    lineItemModel1.dispose();
    lineItemModel2.dispose();
    lineItemModel3.dispose();
    lineItemModel4.dispose();
    lineItemModel5.dispose();
    lineItemModel6.dispose();
    bottomAppBarModel.dispose();
  }
}
