import 'dart:async';
import 'account_lookup_service.dart';

/// Representation of a Nigerian bank with its CBN 3-digit code,
/// routing/enquiry code, common account number prefixes, and classification.
class BankInfo {
  final String name;
  final String cbnCode; // Official 3-digit CBN code used for NUBAN checksum
  final String code; // Routing / NIBSS / WAAS code used for name enquiry API
  final List<String> accountPrefixes; // Common 2-digit account series
  final bool isFintechPhoneBank; // True for OPay, PalmPay, etc. using phone accounts
  final int popularityTier; // 1 = High, 2 = Medium, 3 = Lower

  const BankInfo({
    required this.name,
    required this.cbnCode,
    required this.code,
    this.accountPrefixes = const [],
    this.isFintechPhoneBank = false,
    this.popularityTier = 3,
  });
}

/// A scored candidate bank for a specific account number.
class BankCandidate {
  final String name;
  final String code;
  final String cbnCode;
  final int score;
  final bool isNubanMatch;
  final bool isPhoneMatch;
  String? accountName;
  bool isVerified;

  BankCandidate({
    required this.name,
    required this.code,
    required this.cbnCode,
    this.score = 0,
    this.isNubanMatch = false,
    this.isPhoneMatch = false,
    this.accountName,
    this.isVerified = false,
  });

  Map<String, dynamic> toMap() => {
        'bank_name': name,
        'bankName': name,
        'bank_code': code,
        'bankCode': code,
        'cbn_code': cbnCode,
        'account_name': accountName ?? '',
        'accountName': accountName ?? '',
        'is_verified': isVerified,
        'isNubanMatch': isNubanMatch,
        'isPhoneMatch': isPhoneMatch,
        'score': score,
      };
}

/// Intelligent Nigerian bank detection and account lookup service.
///
/// Features:
/// 1. CBN NUBAN Checksum Validation (prunes ~90% of invalid banks instantly).
/// 2. Nigerian Mobile Phone Number Heuristics (detects OPay, PalmPay, Moniepoint, Kuda).
/// 3. Commercial Bank Account Series Recognition (GTBank, Zenith, Access, UBA, First Bank).
/// 4. Concurrent Live Name Enquiry with early coronation of verified bank accounts.
class BankDetectionService {
  /// CBN NUBAN algorithm weighting vector
  static const List<int> _nubanWeights = [3, 7, 3, 3, 7, 3, 3, 7, 3, 3, 7, 3];

  /// Comprehensive list of Nigerian Commercial Banks, Merchants, and Fintechs
  static const List<BankInfo> supportedBanks = [
    // ── Tier 1: Commercial Giants & Leading Fintechs ───────────────────────────
    BankInfo(
      name: 'StreetPay',
      cbnCode: '120',
      code: '120001',
      accountPrefixes: ['5', '6', '7', '8', '9'],
      isFintechPhoneBank: true,
      popularityTier: 1,
    ),
    BankInfo(
      name: '9PSB',
      cbnCode: '120',
      code: '120001',
      accountPrefixes: ['5', '6', '7', '8', '9'],
      isFintechPhoneBank: true,
      popularityTier: 1,
    ),
    BankInfo(
      name: 'OPay',
      cbnCode: '999',
      code: '100004',
      isFintechPhoneBank: true,
      popularityTier: 1,
    ),
    BankInfo(
      name: 'PalmPay',
      cbnCode: '999',
      code: '100033',
      isFintechPhoneBank: true,
      popularityTier: 1,
    ),
    BankInfo(
      name: 'Moniepoint MFB',
      cbnCode: '505',
      code: '090405',
      accountPrefixes: ['5', '6', '7', '8', '9'],
      isFintechPhoneBank: true,
      popularityTier: 1,
    ),
    BankInfo(
      name: 'Kuda Bank',
      cbnCode: '502',
      code: '090267',
      accountPrefixes: ['1', '2', '3', '7', '8', '9'],
      isFintechPhoneBank: true,
      popularityTier: 1,
    ),
    BankInfo(
      name: 'Guaranty Trust Bank',
      cbnCode: '058',
      code: '058',
      accountPrefixes: ['01', '02', '04', '05', '06', '07', '08', '20'],
      popularityTier: 1,
    ),
    BankInfo(
      name: 'Access Bank',
      cbnCode: '044',
      code: '044',
      accountPrefixes: ['00', '01', '06', '07', '08', '12', '13', '14', '15'],
      popularityTier: 1,
    ),
    BankInfo(
      name: 'Zenith Bank',
      cbnCode: '057',
      code: '057',
      accountPrefixes: ['10', '20', '21', '22', '23', '50', '60', '90'],
      popularityTier: 1,
    ),
    BankInfo(
      name: 'United Bank For Africa',
      cbnCode: '033',
      code: '033',
      accountPrefixes: ['10', '20', '21', '22'],
      popularityTier: 1,
    ),
    BankInfo(
      name: 'First Bank of Nigeria',
      cbnCode: '011',
      code: '011',
      accountPrefixes: ['20', '30', '31', '32'],
      popularityTier: 1,
    ),

    // ── Tier 2: Large Commercial Banks & Specialized Institutions ──────────────
    BankInfo(
      name: 'Fidelity Bank',
      cbnCode: '070',
      code: '070',
      accountPrefixes: ['40', '50', '60'],
      popularityTier: 2,
    ),
    BankInfo(
      name: 'Stanbic IBTC Bank',
      cbnCode: '039',
      code: '039',
      accountPrefixes: ['00', '92'],
      popularityTier: 2,
    ),
    BankInfo(
      name: 'Sterling Bank',
      cbnCode: '232',
      code: '232',
      accountPrefixes: ['00', '01', '05', '80'],
      popularityTier: 2,
    ),
    BankInfo(
      name: 'First City Monument Bank',
      cbnCode: '214',
      code: '214',
      accountPrefixes: ['01', '02', '03'],
      popularityTier: 2,
    ),
    BankInfo(
      name: 'Union Bank of Nigeria',
      cbnCode: '032',
      code: '032',
      accountPrefixes: ['00', '01'],
      popularityTier: 2,
    ),
    BankInfo(
      name: 'Wema Bank',
      cbnCode: '035',
      code: '035',
      accountPrefixes: ['01', '02', '78', '07'],
      popularityTier: 2,
    ),
    BankInfo(
      name: 'Polaris Bank',
      cbnCode: '076',
      code: '076',
      accountPrefixes: ['10', '11', '12'],
      popularityTier: 2,
    ),
    BankInfo(
      name: 'Ecobank Nigeria',
      cbnCode: '050',
      code: '050',
      accountPrefixes: ['00', '20', '24', '26'],
      popularityTier: 2,
    ),
    BankInfo(
      name: 'Keystone Bank',
      cbnCode: '082',
      code: '082',
      accountPrefixes: ['10', '20'],
      popularityTier: 2,
    ),
    BankInfo(
      name: 'Unity Bank',
      cbnCode: '215',
      code: '215',
      accountPrefixes: ['00'],
      popularityTier: 2,
    ),
    BankInfo(
      name: 'Providus Bank',
      cbnCode: '101',
      code: '101',
      accountPrefixes: ['10', '54'],
      popularityTier: 2,
    ),
    BankInfo(
      name: 'Jaiz Bank',
      cbnCode: '301',
      code: '301',
      accountPrefixes: ['00'],
      popularityTier: 2,
    ),
    BankInfo(
      name: 'Taj Bank',
      cbnCode: '302',
      code: '302',
      accountPrefixes: ['00'],
      popularityTier: 2,
    ),

    // ── Tier 3: Emerging Commercial & Fintech Institutions ─────────────────────
    BankInfo(
      name: 'Titan Trust Bank',
      cbnCode: '102',
      code: '102',
      accountPrefixes: ['00'],
      popularityTier: 3,
    ),
    BankInfo(
      name: 'Standard Chartered Bank',
      cbnCode: '068',
      code: '068',
      accountPrefixes: ['00'],
      popularityTier: 3,
    ),
    BankInfo(
      name: 'Citibank Nigeria',
      cbnCode: '023',
      code: '023',
      accountPrefixes: ['00'],
      popularityTier: 3,
    ),
    BankInfo(
      name: 'Parallex Bank',
      cbnCode: '104',
      code: '104',
      accountPrefixes: ['00'],
      popularityTier: 3,
    ),
    BankInfo(
      name: 'Premium Trust Bank',
      cbnCode: '105',
      code: '105',
      accountPrefixes: ['00'],
      popularityTier: 3,
    ),
    BankInfo(
      name: 'Optimus Bank',
      cbnCode: '107',
      code: '107',
      accountPrefixes: ['00'],
      popularityTier: 3,
    ),
    BankInfo(
      name: 'SunTrust Bank',
      cbnCode: '100',
      code: '100',
      accountPrefixes: ['00'],
      popularityTier: 3,
    ),
    BankInfo(
      name: 'Carbon',
      cbnCode: '999',
      code: '100026',
      popularityTier: 3,
    ),
    BankInfo(
      name: 'FairMoney MFB',
      cbnCode: '999',
      code: '090551',
      popularityTier: 3,
    ),
  ];

  /// Checks if a 10-digit account number satisfies the CBN NUBAN checksum
  /// for a given 3-digit CBN bank code.
  static bool isNubanValid(String accountNumber, String cbnCode) {
    if (accountNumber.length != 10 || !RegExp(r'^\d{10}$').hasMatch(accountNumber)) {
      return false;
    }
    final paddedCbn = cbnCode.padLeft(3, '0');
    if (paddedCbn.length != 3 || !RegExp(r'^\d{3}$').hasMatch(paddedCbn)) {
      return false;
    }

    final codeDigits = paddedCbn.split('').map(int.parse).toList();
    final acctDigits = accountNumber.split('').map(int.parse).toList();

    int sum = 0;
    // Bank code digits: index 0, 1, 2
    sum += codeDigits[0] * _nubanWeights[0];
    sum += codeDigits[1] * _nubanWeights[1];
    sum += codeDigits[2] * _nubanWeights[2];

    // First 9 account digits: index 3 to 11
    for (int i = 0; i < 9; i++) {
      sum += acctDigits[i] * _nubanWeights[i + 3];
    }

    final mod = sum % 10;
    final checkDigit = (10 - mod) % 10;
    return checkDigit == acctDigits[9];
  }

  /// Detects if a 10-digit string matches the format of a Nigerian phone number
  /// without the leading zero (e.g. 802..., 810..., 703..., 901..., 912...).
  static bool isNigerianPhoneNumber(String accountNumber) {
    if (accountNumber.length != 10 || !RegExp(r'^\d{10}$').hasMatch(accountNumber)) {
      return false;
    }
    final prefix2 = accountNumber.substring(0, 2);
    return prefix2 == '70' ||
        prefix2 == '71' ||
        prefix2 == '80' ||
        prefix2 == '81' ||
        prefix2 == '90' ||
        prefix2 == '91';
  }

  /// Predicts and ranks candidate Nigerian banks for a 10-digit account number
  /// using NUBAN algorithm checksums, mobile number heuristics, and bank series prefixes.
  static List<BankCandidate> predictCandidateBanks(String accountNumber) {
    final cleanAccount = accountNumber.trim();
    if (cleanAccount.length != 10 || !RegExp(r'^\d{10}$').hasMatch(cleanAccount)) {
      return [];
    }

    final isPhone = isNigerianPhoneNumber(cleanAccount);
    final candidates = <BankCandidate>[];

    for (final bank in supportedBanks) {
      int score = 0;
      bool nubanMatch = false;
      bool phoneMatch = false;

      if (isPhone) {
        if (bank.isFintechPhoneBank) {
          phoneMatch = true;
          // Priority weighting for phone wallets
          if (bank.name.contains('OPay')) {
            score += 90;
          } else if (bank.name.contains('PalmPay')) {
            score += 85;
          } else if (bank.name.contains('Moniepoint')) {
            score += 75;
          } else if (bank.name.contains('Kuda')) {
            score += 70;
          } else {
            score += 60;
          }
        } else {
          // Commercial banks occasionally have phone-based accounts or NUBAN collisions
          if (isNubanValid(cleanAccount, bank.cbnCode)) {
            nubanMatch = true;
            score += 25;
          }
        }
      } else {
        // Standard NUBAN account check
        if (isNubanValid(cleanAccount, bank.cbnCode)) {
          nubanMatch = true;
          score += 60;
        }

        // Account prefix matching (e.g., GTBank 01/02/04/05)
        for (final prefix in bank.accountPrefixes) {
          if (cleanAccount.startsWith(prefix)) {
            score += 35;
            break;
          }
        }

        // Popularity tier weighting
        if (bank.popularityTier == 1) {
          score += 20;
        } else if (bank.popularityTier == 2) {
          score += 10;
        }
      }

      if (score > 0) {
        candidates.add(BankCandidate(
          name: bank.name,
          code: bank.code,
          cbnCode: bank.cbnCode,
          score: score,
          isNubanMatch: nubanMatch,
          isPhoneMatch: phoneMatch,
        ));
      }
    }

    // Sort descending by score
    candidates.sort((a, b) => b.score.compareTo(a.score));

    // Fallback if no specific bank scored > 0
    if (candidates.isEmpty) {
      for (final bank in supportedBanks.where((b) => b.popularityTier == 1)) {
        candidates.add(BankCandidate(
          name: bank.name,
          code: bank.code,
          cbnCode: bank.cbnCode,
          score: 10,
        ));
      }
    }

    return candidates;
  }

  /// In-memory cache for resolved candidate banks: accountNumber -> List<BankCandidate>
  static final Map<String, List<BankCandidate>> _candidateResolutionCache = {};

  /// Synchronously retrieves cached candidate banks if available
  static List<BankCandidate>? getCandidateCache(String accountNumber) =>
      _candidateResolutionCache[accountNumber.trim()];

  /// Predicts candidate banks and concurrently probes the top candidates
  /// with live name enquiry to discover and verify the true account owner.
  ///
  /// Returns the ranked candidate list with verified matches crowned at the top.
  static Future<List<BankCandidate>> detectAndResolveBank(
    String accountNumber, {
    String? authToken,
    int maxProbes = 2,
  }) async {
    final cleanAccount = accountNumber.trim();
    if (_candidateResolutionCache.containsKey(cleanAccount)) {
      return _candidateResolutionCache[cleanAccount]!;
    }

    final candidates = predictCandidateBanks(cleanAccount);
    if (candidates.isEmpty) return [];

    final probesCount = candidates.length < maxProbes ? candidates.length : maxProbes;
    final topToProbe = candidates.take(probesCount).toList();

    await Future.wait(
      topToProbe.map((candidate) async {
        try {
          final resolvedName = await AccountLookupService.resolveAccountName(
            accountNumber: cleanAccount,
            bankCode: candidate.code,
            authToken: authToken,
          );
          if (resolvedName != null && resolvedName.isNotEmpty) {
            candidate.accountName = resolvedName;
            candidate.isVerified = true;
          }
        } catch (_) {}
      }),
    );

    // Re-sort: verified candidates go to the top, then by score
    candidates.sort((a, b) {
      if (a.isVerified && !b.isVerified) return -1;
      if (!a.isVerified && b.isVerified) return 1;
      return b.score.compareTo(a.score);
    });

    _candidateResolutionCache[cleanAccount] = candidates;
    return candidates;
  }

  /// Robustly resolves the NIP/routing bank code for any given Nigerian bank name,
  /// searching through supported banks, aliases, and optionally the dynamic WAAS bank list.
  static String findBankCodeByName(String bankName, {dynamic allBankJson}) {
    if (bankName.trim().isEmpty) return '';
    final clean = bankName.trim().toLowerCase();

    // 0. StreetPay & 9PSB Special handling (120001)
    if (clean.contains('streetpay') || clean.contains('street pay')) return '120001';
    if (clean.contains('9psb') || clean.contains('nine psb') || clean.contains('9 payment')) return '120001';

    // 1. Direct or alias match in supportedBanks
    for (final bank in supportedBanks) {
      final bName = bank.name.trim().toLowerCase();
      if (bName == clean) return bank.code;
      if (clean.contains('opay') && bName.contains('opay')) return bank.code;
      if (clean.contains('palmpay') && bName.contains('palmpay')) return bank.code;
      if (clean.contains('moniepoint') && bName.contains('moniepoint')) return bank.code;
      if (clean.contains('kuda') && bName.contains('kuda')) return bank.code;
      if ((clean.contains('gtb') || clean.contains('guaranty')) &&
          (bName.contains('gtb') || bName.contains('guaranty'))) {
        return bank.code;
      }
      if (clean.contains('zenith') && bName.contains('zenith')) return bank.code;
      if (clean.contains('access') && bName.contains('access')) return bank.code;
      if ((clean.contains('uba') || clean.contains('united bank')) &&
          (bName.contains('uba') || bName.contains('united bank'))) {
        return bank.code;
      }
      if ((clean.contains('first bank') || clean.contains('firstbank')) &&
          bName.contains('first bank')) {
        return bank.code;
      }
      if (clean.contains('fidelity') && bName.contains('fidelity')) return bank.code;
      if (clean.contains('stanbic') && bName.contains('stanbic')) return bank.code;
      if (clean.contains('sterling') && bName.contains('sterling')) return bank.code;
      if (clean.contains('fcmb') && bName.contains('first city')) return bank.code;
      if (clean.contains('wema') && bName.contains('wema')) return bank.code;
      if (clean.contains('polaris') && bName.contains('polaris')) return bank.code;
      if (clean.contains('ecobank') && bName.contains('ecobank')) return bank.code;
      if (clean.contains('keystone') && bName.contains('keystone')) return bank.code;
      if (clean.contains('union') && bName.contains('union')) return bank.code;
      if (clean.contains('providus') && bName.contains('providus')) return bank.code;
      if (clean.contains('jaiz') && bName.contains('jaiz')) return bank.code;
      if (clean.contains('taj') && bName.contains('taj')) return bank.code;
    }

    // 2. Substring matching in supportedBanks
    for (final bank in supportedBanks) {
      final bName = bank.name.trim().toLowerCase();
      if (clean.contains(bName) || bName.contains(clean)) {
        return bank.code;
      }
    }

    // 3. Fallback: inspect WAAS dynamic bank list if provided
    if (allBankJson != null) {
      List<dynamic>? bankList;
      if (allBankJson is Map) {
        if (allBankJson['bankList'] is List) {
          bankList = allBankJson['bankList'] as List;
        } else if (allBankJson['data'] is Map && allBankJson['data']['bankList'] is List) {
          bankList = allBankJson['data']['bankList'] as List;
        }
      } else if (allBankJson is List) {
        bankList = allBankJson;
      }

      if (bankList != null) {
        for (final item in bankList) {
          if (item is Map) {
            final name = (item['bankName'] ?? item['name'] ?? '').toString().trim().toLowerCase();
            final code = (item['bankCode'] ?? item['code'] ?? '').toString().trim();
            if (name == clean || name.contains(clean) || clean.contains(name)) {
              if (code.isNotEmpty) return AccountLookupService.normalizeBankCode(code);
            }
          }
        }
      }
    }

    return '';
  }

  /// Returns a deduplicated, sorted list of all supported bank names.
  static List<String> getAllSupportedBankNames({List<String>? dynamicBankNames}) {
    final bankSet = <String>{};
    bankSet.add('StreetPay');
    if (dynamicBankNames != null) {
      bankSet.addAll(dynamicBankNames.where((n) => n.trim().isNotEmpty));
    }
    for (final b in supportedBanks) {
      bankSet.add(b.name);
    }
    final list = bankSet.toList();
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }
}
