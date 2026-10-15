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

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
import 'package:local_auth/local_auth.dart';

Future<String> authenticateUser(String localizedReason) async {
  final LocalAuthentication auth = LocalAuthentication();
  try {
    bool isAuthenticated = await auth.authenticate(
      localizedReason: localizedReason,
      options: const AuthenticationOptions(stickyAuth: true),
    );
    return isAuthenticated ? 'Authorized' : 'Not Authorized';
  } catch (e) {
    return 'Error: ${e.toString()}';
  }
}
