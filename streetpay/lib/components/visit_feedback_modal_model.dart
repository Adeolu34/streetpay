import '/flutter_flow/flutter_flow_util.dart';
import 'visit_feedback_modal_widget.dart' show VisitFeedbackModalWidget;
import 'package:flutter/material.dart';
import 'dart:typed_data';

class VisitFeedbackModalModel extends FlutterFlowModel<VisitFeedbackModalWidget> {
  FFUploadedFile? generatedJpeg;
  FFUploadedFile? generatedPdfFile;
  Uint8List? generatedPdfBytes;
  bool isGenerating = false;

  TextEditingController? descController;
  FocusNode? descFocusNode;
  TextEditingController? landmarkController;
  FocusNode? landmarkFocusNode;

  // Discrete address points for 9PSB compliance
  TextEditingController? busStopController;
  FocusNode? busStopFocusNode;
  TextEditingController? fillingStationController;
  FocusNode? fillingStationFocusNode;
  TextEditingController? nearestBuildingController;
  FocusNode? nearestBuildingFocusNode;
  TextEditingController? houseNoController;
  FocusNode? houseNoFocusNode;
  TextEditingController? houseColorController;
  FocusNode? houseColorFocusNode;
  TextEditingController? routeController;
  FocusNode? routeFocusNode;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    descController?.dispose();
    descFocusNode?.dispose();
    landmarkController?.dispose();
    landmarkFocusNode?.dispose();
    busStopController?.dispose();
    busStopFocusNode?.dispose();
    fillingStationController?.dispose();
    fillingStationFocusNode?.dispose();
    nearestBuildingController?.dispose();
    nearestBuildingFocusNode?.dispose();
    houseNoController?.dispose();
    houseNoFocusNode?.dispose();
    houseColorController?.dispose();
    houseColorFocusNode?.dispose();
    routeController?.dispose();
    routeFocusNode?.dispose();
  }
}
