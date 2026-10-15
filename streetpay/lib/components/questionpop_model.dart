import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'questionpop_widget.dart' show QuestionpopWidget;
import 'package:flutter/material.dart';

class QuestionpopModel extends FlutterFlowModel<QuestionpopWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (streetauth)] action in questionpop widget.
  ApiCallResponse? streetauth;
  // Stores action output result for [Backend Call - API (playquiz)] action in questionpop widget.
  ApiCallResponse? playquiz;
  // Stores action output result for [Backend Call - API (getlottoquestion)] action in questionpop widget.
  ApiCallResponse? question2;
  // Stores action output result for [Backend Call - API (playquiz)] action in Button widget.
  ApiCallResponse? playquiz1;
  // Stores action output result for [Backend Call - API (getlottoquestion)] action in Button widget.
  ApiCallResponse? question22;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
