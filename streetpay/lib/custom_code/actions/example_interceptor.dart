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

import 'index.dart'; // Imports other custom actions

import '/backend/api_requests/api_interceptor.dart';
import '/app_state.dart';
import '/custom_code/inactivity_service.dart';

// ... existing code ...
class ExampleInterceptor extends FFApiInterceptor {
  @override
  Future<ApiCallOptions> onRequest({
    required ApiCallOptions options,
  }) async {
    // Perform any necessary calls or modifications to the [options] before
    // the API call is made.
    return options;
  }

  @override
  Future<ApiCallResponse> onResponse({
    required ApiCallResponse response,
    required Future<ApiCallResponse> Function() retryFn,
  }) async {
    if (response.succeeded) {
      InactivityService().handleUserActivity(FFAppState());
    }

    // Convert the response to a string (assuming it has a toString() method)
    final responseString = response.toString(); // Adjust this if necessary

    // Check if the response contains "Failed" or "error"
    if (responseString.contains('Failed') || responseString.contains('error')) {
      // Handle the error and redirect back to the previous page
      print('Error: API call failed with response: $responseString');

      // Redirect logic (navigate back)
      // You need to pass the context to this method or find another way to access it
      // Navigator.of(context).pop(); // Uncomment and adjust as needed

      // Optionally, you can log the error or perform other actions here
    }
    return response;
  }
}
