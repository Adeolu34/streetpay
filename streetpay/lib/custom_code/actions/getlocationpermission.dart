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

// locationaction.dart
import 'package:geolocator/geolocator.dart'; // Import Geolocator package

Future<bool> getlocationpermission() async {
  // Check if the app has permission to access user location
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    // Location permission is denied, trigger user to turn it on
    permission = await Geolocator.requestPermission(); // Request permission
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      // If permission is still denied after request, return false
      return false;
    }
  }

  // Check if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are turned off, trigger user to turn it on
    await Geolocator.openLocationSettings();
    return false; // Exit the function after prompting user
  }

  // Location is turned on, get the current location
  try {
    Position position = await Geolocator.getCurrentPosition();
    print('Current location: ${position.latitude}, ${position.longitude}');
    return true; // Return true if location is successfully retrieved
  } catch (e) {
    // Handle any errors that occur while getting the position
    print('Error getting location: $e');
    return false; // Return false in case of an error
  }
}
