import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Thrown when the API returns 401 Unauthorized (session expired).
class SessionExpiredException implements Exception {
  const SessionExpiredException();
  @override
  String toString() => 'SessionExpiredException';
}

class AccountLookupService {
  /// Top frequently targeted Nigerian banks & MFBs for instant auto-suggestions
  static const List<Map<String, String>> popularBanks = [
    {'name': 'StreetPay', 'code': '120001'},
    {'name': 'OPay', 'code': '100004'},
    {'name': 'PalmPay', 'code': '100033'},
    {'name': 'Moniepoint MFB', 'code': '090405'},
    {'name': 'Kuda Bank', 'code': '090267'},
    {'name': 'Guaranty Trust Bank', 'code': '058'},
    {'name': 'Access Bank', 'code': '044'},
    {'name': 'United Bank For Africa', 'code': '033'},
    {'name': 'Zenith Bank', 'code': '057'},
    {'name': 'First Bank of Nigeria', 'code': '011'},
  ];

  /// High-performance in-memory cache for verified account names: "$accountNumber:$bankCode" -> name
  static final Map<String, String> _resolvedNameCache = {};

  /// Synchronously returns cached name if already resolved previously.
  static String? getCachedAccountName(String accountNumber, String bankCode) {
    final cleanAccount = accountNumber.trim();
    final cleanBankCode = normalizeBankCode(bankCode);
    return _resolvedNameCache['$cleanAccount:$cleanBankCode'];
  }

  /// Manually seeds the cache (e.g. from saved beneficiaries or smart candidate responses).
  static void cacheAccountName(String accountNumber, String bankCode, String name) {
    final cleanAccount = accountNumber.trim();
    final cleanBankCode = normalizeBankCode(bankCode);
    if (cleanAccount.length == 10 && cleanBankCode.isNotEmpty && name.trim().isNotEmpty) {
      _resolvedNameCache['$cleanAccount:$cleanBankCode'] = name.trim();
    }
  }

  /// Maps codes that the WAAS bank list returns but are not recognized by the
  /// enquiry endpoints → the correct working code confirmed via API testing.
  static const Map<String, String> bankCodeRemap = {
    '999992': '100004', // OPay / Paycom  (999992 → Unknown Bank Code)
    '999991': '100033', // PalmPay        (999991 → Unknown Bank Code)
    '50515':  '090405', // Moniepoint MFB (50515  → Unknown Bank Code)
    '50211':  '090267', // Kuda MFB       (50211  → Unknown Bank Code)
  };

  /// Normalizes known problematic or outdated bank routing codes to their working enquiry code.
  static String normalizeBankCode(String code) {
    final c = code.trim();
    return bankCodeRemap[c] ?? c;
  }

  /// Resolves the verified account name for a given account number and bank code.
  /// Checks in-memory cache first, then attempts WAAS otherbankenquiryCall, then GetreceipentCall.
  /// Throws [SessionExpiredException] if either call returns 401.
  static Future<String?> resolveAccountName({
    required String accountNumber,
    required String bankCode,
    String? authToken,
  }) async {
    final cleanAccount = accountNumber.trim();
    final cleanBankCode = normalizeBankCode(bankCode);

    if (cleanAccount.length != 10 || cleanBankCode.isEmpty) {
      return null;
    }

    // 0. Cache hit — returns in 0ms without hitting the network!
    final cacheKey = '$cleanAccount:$cleanBankCode';
    if (_resolvedNameCache.containsKey(cacheKey)) {
      return _resolvedNameCache[cacheKey];
    }

    final token = (authToken != null && authToken.isNotEmpty)
        ? authToken
        : FFAppState().bsptoken;

    // 1. Primary: WAAS otherbankenquiryCall (bounded by 6s timeout)
    try {
      final waasResponse = await WalletAsAServiceGroup.otherbankenquiryCall
          .call(
            accountNo: cleanAccount,
            bankcode: cleanBankCode,
            authToken: token,
          )
          .timeout(const Duration(seconds: 6));

      if (waasResponse.statusCode == 401) {
        throw const SessionExpiredException();
      }

      if (waasResponse.statusCode >= 200 && waasResponse.statusCode < 300) {
        final name = WalletAsAServiceGroup.otherbankenquiryCall
            .accountname(waasResponse.jsonBody);
        if (_isValidName(name, cleanAccount)) {
          final resolved = name!.trim();
          _resolvedNameCache[cacheKey] = resolved;
          return resolved;
        }
      }
    } on SessionExpiredException {
      rethrow;
    } catch (_) {}

    // 2. Secondary: GetreceipentCall (bounded by 6s timeout)
    try {
      final recipResponse = await GetreceipentCall
          .call(
            accountno: cleanAccount,
            bankcode: cleanBankCode,
            accessToken: token,
          )
          .timeout(const Duration(seconds: 6));

      if (recipResponse.statusCode == 401) {
        throw const SessionExpiredException();
      }

      if (recipResponse.statusCode >= 200 && recipResponse.statusCode < 300) {
        final name =
            GetreceipentCall.accountname(recipResponse.jsonBody ?? '');
        if (_isValidName(name, cleanAccount)) {
          final resolved = name!.trim();
          _resolvedNameCache[cacheKey] = resolved;
          return resolved;
        }
      }
    } on SessionExpiredException {
      rethrow;
    } catch (_) {}

    return null;
  }

  /// Returns true only if [name] looks like a real person/entity name —
  /// not null, not empty, not purely numeric, and not equal to the account number.
  static bool _isValidName(String? name, String accountNumber) {
    if (name == null || name.trim().isEmpty) return false;
    final trimmed = name.trim();
    // Reject if it's the account number itself or all digits (API quirk)
    if (trimmed == accountNumber) return false;
    if (RegExp(r'^\d+$').hasMatch(trimmed)) return false;
    // Reject suspiciously short names (less than 3 chars after trim)
    if (trimmed.length < 3) return false;
    return true;
  }

  /// Concurrently probes candidate banks for an account number.
  /// Returns a map of bankCode -> resolved account name.
  static Future<Map<String, String>> probeCandidateBanks({
    required String accountNumber,
    required List<Map<String, String>> candidates,
    String? authToken,
  }) async {
    final cleanAccount = accountNumber.trim();
    if (cleanAccount.length != 10 || candidates.isEmpty) {
      return {};
    }

    final results = <String, String>{};
    await Future.wait(
      candidates.map((cand) async {
        final code = cand['code'];
        if (code == null || code.isEmpty) return;
        try {
          final resolvedName = await resolveAccountName(
            accountNumber: cleanAccount,
            bankCode: code,
            authToken: authToken,
          );
          if (resolvedName != null && resolvedName.isNotEmpty) {
            results[code] = resolvedName;
          }
        } catch (_) {}
      }),
    );
    return results;
  }
}
