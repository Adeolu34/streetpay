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

import 'dart:async';
import '/backend/api_requests/api_calls.dart';

Timer? _tokenRefreshTimer;

Future<bool> startTokenRefresh() async {
  _tokenRefreshTimer?.cancel();
  _tokenRefreshTimer = null;
  return await fetchNewToken();
}

Future<bool> fetchNewToken() async {
  try {
    final response = await WalletAsAServiceGroup.authenticationCall.call();
    if (response.statusCode == 200) {
      final token =
          WalletAsAServiceGroup.authenticationCall.accesstoken(response.jsonBody);
      if (token != null && token.isNotEmpty) {
        FFAppState().bsptoken = token;
        return true;
      }
    }
    debugPrint('Token refresh failed: HTTP ${response.statusCode}');
    return false;
  } catch (e) {
    debugPrint('Token refresh error: ${e.runtimeType}');
    return false;
  }
}
