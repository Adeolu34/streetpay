import '/flutter_flow/flutter_flow_util.dart';
import 'uplooaaad_widget.dart' show UplooaaadWidget;
import 'package:flutter/material.dart';

class UplooaaadModel extends FlutterFlowModel<UplooaaadWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  bool isDataUploading_proofaddresss = false;
  FFUploadedFile uploadedLocalFile_proofaddresss =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
  }
}
