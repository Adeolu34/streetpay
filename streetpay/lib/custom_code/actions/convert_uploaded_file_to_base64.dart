// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

Future<String> convertUploadedFileToBase64(FFUploadedFile? uploadedFile) async {
  if (uploadedFile == null || uploadedFile.bytes == null) {
    return '';
  }

  // Convert the file bytes to base64 string
  String base64Image = base64Encode(uploadedFile.bytes!);
  return base64Image;
}
