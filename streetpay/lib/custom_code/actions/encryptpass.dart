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
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// AES-256-CBC encryption. IV is randomly generated per call and prepended
// to the ciphertext (iv_base64:cipher_base64).
// Key is device-unique: generated once and persisted in FlutterSecureStorage.
// This ensures each device has its own key — no hardcoded secret in the APK.
Future<String> encryptpass(String? encryptedvalue) async {
  if (encryptedvalue == null || encryptedvalue.isEmpty) return '';

  const _storage = FlutterSecureStorage();
  const _keyId = 'sp_aes_key_v2';

  // Retrieve or generate the device-unique 32-byte AES key.
  String? storedKey = await _storage.read(key: _keyId);
  if (storedKey == null) {
    final rng = Random.secure();
    final keyBytes = Uint8List.fromList(
        List<int>.generate(32, (_) => rng.nextInt(256)));
    storedKey = base64Url.encode(keyBytes);
    await _storage.write(key: _keyId, value: storedKey);
  }

  final keyBytes = base64Url.decode(storedKey);
  final key = enc.Key(Uint8List.fromList(keyBytes));
  final iv = enc.IV.fromSecureRandom(16);
  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final encrypted = encrypter.encrypt(encryptedvalue, iv: iv);

  return '${iv.base64}:${encrypted.base64}';
}
