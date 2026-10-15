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

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

const _kDeviceIdKey = 'sp_device_id';

Future<String> getdeviceid() async {
  final storage = FlutterSecureStorage();
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = '';

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? '';
    }

    if (deviceId.isNotEmpty) {
      return deviceId;
    }
  } catch (_) {}

  try {
    final stored = await storage.read(key: _kDeviceIdKey);
    if (stored != null && stored.isNotEmpty) return stored;

    final generated = const Uuid().v4();
    await storage.write(key: _kDeviceIdKey, value: generated);
    return generated;
  } catch (_) {
    return 'sp_fallback_${DateTime.now().millisecondsSinceEpoch}';
  }
}
