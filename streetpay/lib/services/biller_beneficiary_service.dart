import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BillerBeneficiaryItem {
  final String category; // 'electricity', 'cabletv', 'betting', 'internet', 'exam'
  final String billerName;
  final String customerId; // Meter number, Smartcard / IUC number, Account ID
  final String? customerName;
  final String? packageType;
  final String? lastAmount;
  final DateTime lastUsed;

  BillerBeneficiaryItem({
    required this.category,
    required this.billerName,
    required this.customerId,
    this.customerName,
    this.packageType,
    this.lastAmount,
    DateTime? lastUsed,
  }) : lastUsed = lastUsed ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'category': category,
        'billerName': billerName,
        'customerId': customerId,
        'customerName': customerName,
        'packageType': packageType,
        'lastAmount': lastAmount,
        'lastUsed': lastUsed.toIso8601String(),
      };

  factory BillerBeneficiaryItem.fromJson(Map<String, dynamic> json) =>
      BillerBeneficiaryItem(
        category: json['category'] ?? 'bills',
        billerName: json['billerName'] ?? '',
        customerId: json['customerId'] ?? '',
        customerName: json['customerName'],
        packageType: json['packageType'],
        lastAmount: json['lastAmount'],
        lastUsed: json['lastUsed'] != null
            ? DateTime.tryParse(json['lastUsed']) ?? DateTime.now()
            : DateTime.now(),
      );

  String get initials {
    if (customerName != null && customerName!.trim().isNotEmpty) {
      final parts = customerName!.trim().split(RegExp(r'\s+'));
      if (parts.isNotEmpty && parts[0].isNotEmpty) {
        if (parts.length >= 2 && parts[1].isNotEmpty) {
          return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
        }
        return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
      }
    }
    final cleanBiller = billerName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    if (cleanBiller.length >= 2) {
      return cleanBiller.substring(0, 2).toUpperCase();
    }
    return 'BP';
  }
}

class BillerBeneficiaryService {
  static const String _storageKey = 'sp_biller_beneficiaries_v1';
  static const int _maxPerCategory = 12;
  static List<BillerBeneficiaryItem>? _cachedItems;

  /// Retrieve list of recent biller beneficiaries for a given category
  static Future<List<BillerBeneficiaryItem>> getBeneficiaries(String category, {bool forceRefresh = false}) async {
    final cleanCategory = category.trim().toLowerCase();
    if (!forceRefresh && _cachedItems != null) {
      final filtered = _cachedItems!
          .where((item) => item.category.trim().toLowerCase() == cleanCategory)
          .toList()
        ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
      return filtered;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList(_storageKey) ?? [];
      final List<BillerBeneficiaryItem> all = [];

      for (final raw in rawList) {
        try {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          all.add(BillerBeneficiaryItem.fromJson(map));
        } catch (_) {}
      }

      _cachedItems = all;
      final list = all
          .where((item) => item.category.trim().toLowerCase() == cleanCategory)
          .toList()
        ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Save or update a biller beneficiary
  static Future<void> saveBeneficiary({
    required String category,
    required String billerName,
    required String customerId,
    String? customerName,
    String? packageType,
    String? lastAmount,
  }) async {
    final cleanCustId = customerId.trim();
    final cleanBiller = billerName.trim();
    final cleanCategory = category.trim().toLowerCase();

    if (cleanCustId.isEmpty || cleanBiller.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList(_storageKey) ?? [];
      final List<BillerBeneficiaryItem> allItems = [];

      for (final raw in rawList) {
        try {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          allItems.add(BillerBeneficiaryItem.fromJson(map));
        } catch (_) {}
      }

      // Remove any existing entry matching category, customerId, and biller
      allItems.removeWhere(
        (item) =>
            item.category.toLowerCase() == cleanCategory &&
            item.customerId == cleanCustId &&
            item.billerName.toLowerCase() == cleanBiller.toLowerCase(),
      );

      // Insert fresh entry at index 0
      allItems.insert(
        0,
        BillerBeneficiaryItem(
          category: cleanCategory,
          billerName: cleanBiller,
          customerId: cleanCustId,
          customerName: customerName?.trim().isNotEmpty == true ? customerName!.trim() : null,
          packageType: packageType?.trim().isNotEmpty == true ? packageType!.trim() : null,
          lastAmount: lastAmount?.trim().isNotEmpty == true ? lastAmount!.trim() : null,
          lastUsed: DateTime.now(),
        ),
      );

      // Cap per category to avoid unbounded growth
      final categoryCounts = <String, int>{};
      final cappedItems = <BillerBeneficiaryItem>[];
      for (final item in allItems) {
        final cat = item.category.toLowerCase();
        final count = categoryCounts[cat] ?? 0;
        if (count < _maxPerCategory) {
          cappedItems.add(item);
          categoryCounts[cat] = count + 1;
        }
      }

      final stringList = cappedItems.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(_storageKey, stringList);
      _cachedItems = cappedItems;
    } catch (_) {}
  }

  /// Delete a saved biller beneficiary
  static Future<void> deleteBeneficiary(
    String category,
    String customerId,
    String billerName,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList(_storageKey) ?? [];
      final List<BillerBeneficiaryItem> allItems = [];

      for (final raw in rawList) {
        try {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          allItems.add(BillerBeneficiaryItem.fromJson(map));
        } catch (_) {}
      }

      final cleanCategory = category.trim().toLowerCase();
      allItems.removeWhere(
        (item) =>
            item.category.toLowerCase() == cleanCategory &&
            item.customerId == customerId.trim() &&
            item.billerName.toLowerCase() == billerName.trim().toLowerCase(),
      );

      final stringList = allItems.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(_storageKey, stringList);
      _cachedItems = allItems;
    } catch (_) {}
  }
}
