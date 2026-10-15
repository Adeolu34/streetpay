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

import 'package:device_info_plus/device_info_plus.dart'; // Ensure this import is present
import 'dart:io'; // Importing dart:io for Platform class

Future<String> getDeviceIP() async {
  // Implement your logic to get the device's IP address
  // This is a placeholder implementation
  return "192.168.1.1"; // Replace with actual logic to get the IP
}

Future<String> getdeviceinfo() async {
  // get the device information and also the ip of the device

  String deviceInfo = "";

  try {
    DeviceInfoPlugin deviceInfoPlugin =
        DeviceInfoPlugin(); // Renamed variable to avoid conflict
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo =
          await deviceInfoPlugin.androidInfo; // Updated variable name
      deviceInfo = "Device Model: ${androidInfo.model}\n";
      deviceInfo += "Device Manufacturer: ${androidInfo.manufacturer}\n";
      deviceInfo += "Device Version: ${androidInfo.version}\n";
      deviceInfo += "Device IP: ${await getDeviceIP()}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo =
          await deviceInfoPlugin.iosInfo; // Updated variable name
      deviceInfo = "Device Model: ${iosInfo.model}\n";
      deviceInfo += "Device Manufacturer: Apple\n";
      deviceInfo += "Device Version: ${iosInfo.systemVersion}\n";
      deviceInfo += "Device IP: ${await getDeviceIP()}";
    }
  } catch (e) {
    deviceInfo = "Error getting device information: $e";
  }

  return deviceInfo;
}
