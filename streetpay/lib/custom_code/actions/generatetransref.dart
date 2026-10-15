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

import 'dart:math'; // Import for Random
import 'dart:convert'; // Import for secure random generation

Future<String> generatetransref() async {
  // Generate a transaction reference with a length greater than 15 and less than 18
  String prefix = "REF"; // First three characters
  String characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'; // Allowed characters
  Random random = Random.secure(); // Secure random generator
  String transref = prefix;

  // Randomly choose a total length of 16 or 17
  int totalLength = random.nextInt(2) + 18; // Generates either 16 or 17
  int remainingLength =
      totalLength - prefix.length; // Remaining characters to generate

  for (int i = 0; i < remainingLength; i++) {
    int randomIndex = random.nextInt(characters.length);
    transref += characters[randomIndex];
  }

  return transref;
}
