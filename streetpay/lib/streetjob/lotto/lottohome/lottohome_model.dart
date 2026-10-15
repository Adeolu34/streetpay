import '/flutter_flow/flutter_flow_util.dart';
import '/streetjob/lotto/lottonav/lottonav_widget.dart';
import '/index.dart';
import 'lottohome_widget.dart' show LottohomeWidget;
import 'package:flutter/material.dart';

class LottohomeModel extends FlutterFlowModel<LottohomeWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
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
