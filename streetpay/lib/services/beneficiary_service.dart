import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BeneficiaryItem {
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String? bankCode;
  final DateTime lastUsed;

  BeneficiaryItem({
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    this.bankCode,
    DateTime? lastUsed,
  }) : lastUsed = lastUsed ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'accountName': accountName,
        'accountNumber': accountNumber,
        'bankName': bankName,
        'bankCode': bankCode,
        'lastUsed': lastUsed.toIso8601String(),
      };

  factory BeneficiaryItem.fromJson(Map<String, dynamic> json) => BeneficiaryItem(
        accountName: json['accountName'] ?? '',
        accountNumber: json['accountNumber'] ?? '',
        bankName: json['bankName'] ?? '',
        bankCode: json['bankCode'],
        lastUsed: json['lastUsed'] != null
            ? DateTime.tryParse(json['lastUsed']) ?? DateTime.now()
            : DateTime.now(),
      );

  String get initials {
    final parts = accountName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

class BeneficiaryService {
  static const String _storageKey = 'sp_recent_beneficiaries_v1';
  static const int _maxBeneficiaries = 15;
  static List<BeneficiaryItem>? _cachedBeneficiaries;

  /// Retrieve list of recent beneficiaries sorted by most recently used
  static Future<List<BeneficiaryItem>> getRecentBeneficiaries({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedBeneficiaries != null) {
      return List<BeneficiaryItem>.from(_cachedBeneficiaries!);
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList(_storageKey) ?? [];
      final List<BeneficiaryItem> list = [];

      for (final raw in rawList) {
        try {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          list.add(BeneficiaryItem.fromJson(map));
        } catch (_) {}
      }

      list.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
      _cachedBeneficiaries = list;
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Save or update a beneficiary to the top of the recent list
  static Future<void> saveBeneficiary({
    required String accountName,
    required String accountNumber,
    required String bankName,
    String? bankCode,
  }) async {
    final cleanAccount = accountNumber.trim();
    final cleanName = accountName.trim();
    final cleanBank = bankName.trim();

    if (cleanAccount.isEmpty || cleanBank.isEmpty) return;

    try {
      final currentList = await getRecentBeneficiaries();

      // Remove any existing entry matching both account number and bank
      currentList.removeWhere(
        (item) => item.accountNumber == cleanAccount && item.bankName.toLowerCase() == cleanBank.toLowerCase(),
      );

      // Insert fresh entry at top
      currentList.insert(
        0,
        BeneficiaryItem(
          accountName: cleanName.isNotEmpty ? cleanName : cleanAccount,
          accountNumber: cleanAccount,
          bankName: cleanBank,
          bankCode: bankCode,
          lastUsed: DateTime.now(),
        ),
      );

      // Truncate to maximum capacity
      final cappedList = currentList.take(_maxBeneficiaries).toList();

      final prefs = await SharedPreferences.getInstance();
      final stringList = cappedList.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(_storageKey, stringList);
      _cachedBeneficiaries = List<BeneficiaryItem>.from(cappedList);
    } catch (_) {}
  }

  /// Delete a single beneficiary by account number
  static Future<void> deleteBeneficiary(String accountNumber, String bankName) async {
    try {
      final currentList = await getRecentBeneficiaries();
      currentList.removeWhere(
        (item) =>
            item.accountNumber == accountNumber &&
            item.bankName.toLowerCase() == bankName.toLowerCase(),
      );

      final prefs = await SharedPreferences.getInstance();
      final stringList = currentList.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(_storageKey, stringList);
      _cachedBeneficiaries = List<BeneficiaryItem>.from(currentList);
    } catch (_) {}
  }

  /// Clear all beneficiaries
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      _cachedBeneficiaries = [];
    } catch (_) {}
  }
}
