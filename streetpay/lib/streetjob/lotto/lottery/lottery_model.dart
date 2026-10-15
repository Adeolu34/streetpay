import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/streetjob/lotto/lottonav/lottonav_widget.dart';
import '/index.dart';
import 'lottery_widget.dart' show LotteryWidget;
import 'package:flutter/material.dart';

class LotteryModel extends FlutterFlowModel<LotteryWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (streetauth)] action in lottery widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (getwinners)] action in lottery widget.
  ApiCallResponse? winners;
  // Stores action output result for [Backend Call - API (getlottoplans)] action in lottery widget.
  ApiCallResponse? plan;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? transactionref;
  // Stores action output result for [Bottom Sheet - paymentpinverifygame] action in Button widget.
  bool? receipt;
  // Stores action output result for [Backend Call - API (debitwallet)] action in Button widget.
  ApiCallResponse? debitewallet;
  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? transactionref2;
  // Stores action output result for [Bottom Sheet - paymentpinverifygame] action in Button widget.
  bool? receipt2;
  // Stores action output result for [Backend Call - API (debitwallet)] action in Button widget.
  ApiCallResponse? debitwallet2;
  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? transactionref3;
  // Stores action output result for [Bottom Sheet - paymentpinverifygame] action in Button widget.
  bool? receipt3;
  // Stores action output result for [Backend Call - API (debitwallet)] action in Button widget.
  ApiCallResponse? walletdebit3;
  // Stores action output result for [Custom Action - generatetransref] action in Button widget.
  String? transactionref4;
  // Stores action output result for [Bottom Sheet - paymentpinverifygame] action in Button widget.
  bool? receipt4;
  // Stores action output result for [Backend Call - API (debitwallet)] action in Button widget.
  ApiCallResponse? debitwallet4;
  // Model for lottonav component.
  late LottonavModel lottonavModel;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    lottonavModel = createModel(context, () => LottonavModel());
  }

  @override
  void dispose() {
    columnController?.dispose();
    lottonavModel.dispose();
  }
}
