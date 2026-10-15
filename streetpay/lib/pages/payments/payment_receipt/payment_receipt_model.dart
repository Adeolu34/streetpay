import '/components/text_line_item/text_line_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'payment_receipt_widget.dart' show PaymentReceiptWidget;
import 'package:flutter/material.dart';

class PaymentReceiptModel extends FlutterFlowModel<PaymentReceiptWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextLineItem component.
  late TextLineItemModel textLineItemModel1;
  // Model for TextLineItem component.
  late TextLineItemModel textLineItemModel2;
  // Model for TextLineItem component.
  late TextLineItemModel textLineItemModel3;
  // Model for TextLineItem component.
  late TextLineItemModel textLineItemModel4;
  // Model for TextLineItem component.
  late TextLineItemModel textLineItemModel5;
  // Model for TextLineItem component.
  late TextLineItemModel textLineItemModel6;
  // Model for TextLineItem component.
  late TextLineItemModel textLineItemModel7;

  @override
  void initState(BuildContext context) {
    textLineItemModel1 = createModel(context, () => TextLineItemModel());
    textLineItemModel2 = createModel(context, () => TextLineItemModel());
    textLineItemModel3 = createModel(context, () => TextLineItemModel());
    textLineItemModel4 = createModel(context, () => TextLineItemModel());
    textLineItemModel5 = createModel(context, () => TextLineItemModel());
    textLineItemModel6 = createModel(context, () => TextLineItemModel());
    textLineItemModel7 = createModel(context, () => TextLineItemModel());
  }

  @override
  void dispose() {
    textLineItemModel1.dispose();
    textLineItemModel2.dispose();
    textLineItemModel3.dispose();
    textLineItemModel4.dispose();
    textLineItemModel5.dispose();
    textLineItemModel6.dispose();
    textLineItemModel7.dispose();
  }
}
