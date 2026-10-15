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

Future<bool> isValidSingleWord(String? text, String? text2) async {
  // Check if the text or text2 is null or empty
  if ((text == null || text.isEmpty) || (text2 == null || text2.isEmpty)) {
    return false;
  }

  // Split the text and text2 by spaces and check the length
  List<String> words1 = text.trim().split(RegExp(r'\s+'));
  List<String> words2 = text2.trim().split(RegExp(r'\s+'));
  return words1.length == 1 && words2.length == 1;
}
