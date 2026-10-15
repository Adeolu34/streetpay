import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'faceverify_widget.dart' show FaceverifyWidget;
import 'package:flutter/material.dart';

class FaceverifyModel extends FlutterFlowModel<FaceverifyWidget> {
  ///  Local state fields for this page.

  bool hasupload = false;

  FFUploadedFile? images;

  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadDataH933 = false;
  FFUploadedFile uploadedLocalFile_uploadDataH933 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_uploadDataH93 = false;
  FFUploadedFile uploadedLocalFile_uploadDataH93 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Backend Call - API (faceverify)] action in Button widget.
  ApiCallResponse? facelook;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
