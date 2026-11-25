import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Decrypts a ciphertext previously encrypted by [encryptpass].
/// The expected format is: "iv_base64:cipher_base64".
/// Uses the device-unique 32-byte AES key persisted in FlutterSecureStorage.
/// If the string is already a plain 4 or 5 digit PIN, returns it as-is.
Future<String> decryptpass(String? ciphertext) async {
  if (ciphertext == null || ciphertext.isEmpty) return '';

  final trimmed = ciphertext.trim();

  // If plain numeric PIN, return directly
  if (!trimmed.contains(':') && RegExp(r'^\d{4,6}$').hasMatch(trimmed)) {
    return trimmed;
  }

  try {
    const storage = FlutterSecureStorage();
    const keyId = 'sp_aes_key_v2';

    final storedKey = await storage.read(key: keyId);
    if (storedKey == null || storedKey.isEmpty) {
      debugPrint('[decryptpass] AES key not found in secure storage.');
      return '';
    }

    final parts = trimmed.split(':');
    if (parts.length != 2) {
      debugPrint('[decryptpass] Invalid ciphertext format (expected iv:cipher).');
      return '';
    }

    final keyBytes = base64Url.decode(storedKey);
    final key = enc.Key(Uint8List.fromList(keyBytes));
    final iv = enc.IV.fromBase64(parts[0]);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

    final decrypted = encrypter.decrypt64(parts[1], iv: iv);
    return decrypted;
  } catch (e) {
    debugPrint('[decryptpass] Decryption error: $e');
    return '';
  }
}
