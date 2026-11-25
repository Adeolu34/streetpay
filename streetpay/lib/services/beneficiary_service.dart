import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_vault_service.dart';

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
  static const int _maxBeneficiaries = 150;
  static List<BeneficiaryItem>? _cachedBeneficiaries;

  /// Retrieve list of recent beneficiaries sorted by most recently used
  static Future<List<BeneficiaryItem>> getRecentBeneficiaries({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedBeneficiaries != null && _cachedBeneficiaries!.isNotEmpty) {
      return List<BeneficiaryItem>.from(_cachedBeneficiaries!);
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList(_storageKey) ?? [];
      final Map<String, BeneficiaryItem> mergedMap = {};

      // 1. Read from SharedPreferences
      for (final raw in rawList) {
        try {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          final item = BeneficiaryItem.fromJson(map);
          final key = item.accountNumber.replaceAll(RegExp(r'\s+'), '').trim();
          if (key.isNotEmpty) {
            mergedMap[key] = item;
          }
        } catch (_) {}
      }

      // 2. Read from persistent SQLite vault (authoritative storage)
      final vaultList = await LocalVaultService.getBeneficiaries(limit: _maxBeneficiaries);
      for (final row in vaultList) {
        final acc = (row['account_number'] as String?)?.replaceAll(RegExp(r'\s+'), '').trim() ?? '';
        if (acc.isEmpty) continue;

        final name = (row['account_name'] as String?)?.trim() ?? '';
        final bank = (row['bank_name'] as String?)?.trim() ?? 'Bank';
        final code = row['bank_code'] as String?;
        final time = row['last_used'] != null
            ? DateTime.fromMillisecondsSinceEpoch(row['last_used'] as int)
            : DateTime.now();

        if (mergedMap.containsKey(acc)) {
          final existing = mergedMap[acc]!;
          // Merge keeping best name/bank and latest timestamp
          mergedMap[acc] = BeneficiaryItem(
            accountName: existing.accountName.isNotEmpty ? existing.accountName : name,
            accountNumber: acc,
            bankName: existing.bankName.isNotEmpty && existing.bankName != 'Bank' ? existing.bankName : bank,
            bankCode: existing.bankCode ?? code,
            lastUsed: existing.lastUsed.isAfter(time) ? existing.lastUsed : time,
          );
        } else {
          mergedMap[acc] = BeneficiaryItem(
            accountName: name.isNotEmpty ? name : acc,
            accountNumber: acc,
            bankName: bank.isNotEmpty ? bank : 'Bank',
            bankCode: code,
            lastUsed: time,
          );
        }
      }

      final list = mergedMap.values.toList();
      list.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));

      final cappedList = list.take(_maxBeneficiaries).toList();
      // Keep SharedPreferences refreshed and synced with SQLite
      final stringList = cappedList.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(_storageKey, stringList);

      _cachedBeneficiaries = cappedList;
      return List<BeneficiaryItem>.from(cappedList);
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
    final cleanAccount = accountNumber.replaceAll(RegExp(r'\s+'), '').trim();
    final cleanName = accountName.trim();
    final cleanBank = bankName.trim().isNotEmpty ? bankName.trim() : 'Bank';

    if (cleanAccount.isEmpty) return;

    try {
      // 1. Save to SQLite LocalVaultService (uninstall-proof mirrored database)
      await LocalVaultService.saveBeneficiary(
        accountName: cleanName.isNotEmpty ? cleanName : cleanAccount,
        accountNumber: cleanAccount,
        bankName: cleanBank,
        bankCode: bankCode,
      );

      // 2. Update fast SharedPreferences cache
      final currentList = await getRecentBeneficiaries();

      currentList.removeWhere(
        (item) => item.accountNumber.replaceAll(RegExp(r'\s+'), '') == cleanAccount,
      );

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
      await LocalVaultService.deleteBeneficiary(accountNumber);

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
