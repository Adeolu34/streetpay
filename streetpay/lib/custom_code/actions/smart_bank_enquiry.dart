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

import '/backend/api_requests/api_calls.dart';
import '/services/bank_detection_service.dart';

// Fallback list of top banks if detection yields no specific candidates
final List<Map<String, String>> _fallbackTopBanks = [
  {"name": "Access Bank", "code": "044"},
  {"name": "Guaranty Trust Bank", "code": "058"},
  {"name": "Zenith Bank", "code": "057"},
  {"name": "United Bank For Africa", "code": "033"},
  {"name": "First Bank of Nigeria", "code": "011"},
  {"name": "OPay", "code": "100004"},
  {"name": "PalmPay", "code": "100033"},
  {"name": "Moniepoint MFB", "code": "090405"},
  {"name": "Kuda Bank", "code": "090267"},
];

/// Helper function to check a single bank
Future<Map<String, String>?> _checkBank(
  Map<String, String> bank,
  String accountNumber,
  String authToken,
) async {
  try {
    final response = await WalletAsAServiceGroup.otherbankenquiryCall
        .call(
          accountNo: accountNumber,
          bankcode: bank['code'],
          authToken: authToken,
        )
        .timeout(const Duration(milliseconds: 3500));

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final accountName = WalletAsAServiceGroup.otherbankenquiryCall
          .accountname(response.jsonBody);

      if (accountName != null && accountName.trim().isNotEmpty) {
        final bName = bank['name'] ?? '';
        final bCode = bank['code'] ?? '';
        final aName = accountName.trim();
        return {
          'bankName': bName,
          'bank_name': bName,
          'bankCode': bCode,
          'bank_code': bCode,
          'accountName': aName,
          'account_name': aName,
        };
      }
    }
  } catch (_) {}

  // Secondary fallback check via GetreceipentCall
  try {
    final response2 = await GetreceipentCall.call(
      accountno: accountNumber,
      bankcode: bank['code'],
      accessToken: authToken,
    ).timeout(const Duration(milliseconds: 3500));

    if (response2.statusCode != null &&
        response2.statusCode! >= 200 &&
        response2.statusCode! < 300) {
      final accountName =
          GetreceipentCall.accountname(response2.jsonBody ?? '');

      if (accountName != null && accountName.trim().isNotEmpty) {
        final bName = bank['name'] ?? '';
        final bCode = bank['code'] ?? '';
        final aName = accountName.trim();
        return {
          'bankName': bName,
          'bank_name': bName,
          'bankCode': bCode,
          'bank_code': bCode,
          'accountName': aName,
          'account_name': aName,
        };
      }
    }
  } catch (_) {}

  return null;
}

/// Returns an empty list if account is not found in any bank.
///
/// Uses an intelligent algorithm: predicts most probable banks using NUBAN checksum
/// and phone-prefix heuristics, probing high-confidence candidates first.
Future<List<dynamic>> smartBankEnquiry(String? accountnumber) async {
  List<dynamic> results = [];

  // Validate input
  if (accountnumber == null || accountnumber.trim().isEmpty) {
    return results;
  }

  // Get auth token from app state
  final authToken = FFAppState().bsptoken;
  if (authToken == null || authToken.isEmpty) {
    return results;
  }

  final trimmedAccount = accountnumber.trim();

  // Phase 1: Predict candidate banks via CBN NUBAN & mobile phone heuristics
  final predicted = BankDetectionService.predictCandidateBanks(trimmedAccount);
  final List<Map<String, String>> topTier = predicted.isNotEmpty
      ? predicted.take(5).map((c) => {'name': c.name, 'code': c.code}).toList()
      : _fallbackTopBanks;

  final topBankFutures = topTier
      .map((bank) => _checkBank(bank, trimmedAccount, authToken))
      .toList();

  final topBankResults = await Future.wait(topBankFutures);
  final topMatches = topBankResults.whereType<Map<String, String>>().toList();

  if (topMatches.isNotEmpty) {
    return topMatches; // Early return for speed
  }

  // Phase 2: Probe remaining candidate banks if top tier didn't hit
  if (predicted.length > 5) {
    final secondTier = predicted
        .skip(5)
        .take(6)
        .map((c) => {'name': c.name, 'code': c.code})
        .toList();

    final secondBankFutures = secondTier
        .map((bank) => _checkBank(bank, trimmedAccount, authToken))
        .toList();

    final secondBankResults = await Future.wait(secondBankFutures);
    final secondMatches =
        secondBankResults.whereType<Map<String, String>>().toList();
    results.addAll(secondMatches);
  }

  return results;
}

