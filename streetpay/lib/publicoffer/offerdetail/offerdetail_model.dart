import '/flutter_flow/flutter_flow_util.dart';
import '/publicoffer/offerdetails/offerdetails_widget.dart';
import 'offerdetail_widget.dart' show OfferdetailWidget;
import 'package:flutter/material.dart';

class OfferdetailModel extends FlutterFlowModel<OfferdetailWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for offerdetails component.
  late OfferdetailsModel offerdetailsModel;

  @override
  void initState(BuildContext context) {
    offerdetailsModel = createModel(context, () => OfferdetailsModel());
  }

  @override
  void dispose() {
    offerdetailsModel.dispose();
  }
}
