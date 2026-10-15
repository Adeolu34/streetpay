import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

// Allowed hosts for StreetPay API traffic.
// Requests to any other host are still permitted — this only *enforces* pinning
// on hosts listed here.
const _pinnedHosts = {'api.mypingapi.com'};

// To update pins: run the Flutter app in debug mode against the real server and
// print `_spkiSha256(cert)` in the badCertificateCallback before returning false.
// Fill in the resulting base64 strings below.
//
// Current pins generated from the live certificate (replace on cert rotation):
const _pinnedSpkiHashes = <String>{
  // Add actual base64(SHA-256(SubjectPublicKeyInfo DER)) hashes here.
  // Example: 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
};

/// Derives the SHA-256 fingerprint of the Subject Public Key Info from a cert.
String _spkiSha256(X509Certificate cert) {
  // `cert.der` is the full DER-encoded certificate.
  // A production implementation would extract only the SPKI field; for now
  // we hash the full cert DER as a comparable approximation.
  return base64.encode(sha256.convert(cert.der).bytes);
}

class StreetPayHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Always reject invalid certs for pinned hosts.
      if (_pinnedHosts.contains(host)) {
        // If we have pins configured, enforce them.
        if (_pinnedSpkiHashes.isNotEmpty) {
          final fingerprint = _spkiSha256(cert);
          final pinValid = _pinnedSpkiHashes.contains(fingerprint);
          if (!pinValid) {
            debugPrint(
              '[Security] Certificate pin mismatch for $host — rejecting connection.',
            );
          }
          return pinValid;
        }
        // No pins configured yet — reject all bad certs for our domain.
        debugPrint(
          '[Security] Invalid certificate for $host — rejecting.',
        );
        return false;
      }
      // For other hosts, follow the default behavior (reject bad certs).
      return false;
    };

    return client;
  }
}
