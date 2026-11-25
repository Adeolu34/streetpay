import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/backend/api_requests/api_calls.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'local_vault_service.dart';
import 'beneficiary_service.dart';
import 'tts_service.dart';

/// Represents a single beneficiary within a payout batch.
class BatchBeneficiary {
  final String id;
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String bankCode;
  double amount;
  final DateTime addedAt;

  BatchBeneficiary({
    required this.id,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.bankCode,
    this.amount = 0.0,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'accountName': accountName,
        'accountNumber': accountNumber,
        'bankName': bankName,
        'bankCode': bankCode,
        'amount': amount,
        'addedAt': addedAt.toIso8601String(),
      };

  factory BatchBeneficiary.fromJson(Map<String, dynamic> json) {
    final rawName = (json['bankName'] ?? '').toString();
    final rawCode = (json['bankCode'] ?? '').toString();
    final healedCode = BatchPayoutService.resolveBankCode(
      bankCode: rawCode,
      bankName: rawName,
    );
    final rawAccount = (json['accountNumber'] ?? '').toString();
    final cleanedAccount = BatchPayoutService.cleanNigerianAccountNumber(rawAccount);

    return BatchBeneficiary(
      id: json['id'] ?? '',
      accountName: json['accountName'] ?? '',
      accountNumber: cleanedAccount.isNotEmpty ? cleanedAccount : rawAccount,
      bankName: rawName,
      bankCode: healedCode,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      addedAt: json['addedAt'] != null
          ? DateTime.tryParse(json['addedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String get initials {
    final parts = accountName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'ST';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

/// Represents a saved payout batch (e.g. "Staff", "Contractors", "Vendors").
class BatchGroup {
  final String id;
  String name;
  String description;
  List<BatchBeneficiary> beneficiaries;
  final DateTime createdAt;
  DateTime? lastDisbursedAt;
  double? lastDisbursedAmount;

  BatchGroup({
    required this.id,
    required this.name,
    this.description = '',
    List<BatchBeneficiary>? beneficiaries,
    DateTime? createdAt,
    this.lastDisbursedAt,
    this.lastDisbursedAmount,
  })  : beneficiaries = beneficiaries ?? [],
        createdAt = createdAt ?? DateTime.now();

  double get totalAmount =>
      beneficiaries.fold(0.0, (sum, b) => sum + b.amount);

  int get beneficiaryCount => beneficiaries.length;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'beneficiaries': beneficiaries.map((b) => b.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'lastDisbursedAt': lastDisbursedAt?.toIso8601String(),
        'lastDisbursedAmount': lastDisbursedAmount,
      };

  factory BatchGroup.fromJson(Map<String, dynamic> json) => BatchGroup(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        beneficiaries: (json['beneficiaries'] as List?)
                ?.map((b) =>
                    BatchBeneficiary.fromJson(Map<String, dynamic>.from(b)))
                .toList() ??
            [],
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
            : DateTime.now(),
        lastDisbursedAt: json['lastDisbursedAt'] != null
            ? DateTime.tryParse(json['lastDisbursedAt'])
            : null,
        lastDisbursedAmount: (json['lastDisbursedAmount'] as num?)?.toDouble(),
      );
}

/// Result of an individual transfer in a batch execution.
class BatchItemResult {
  final BatchBeneficiary beneficiary;
  final bool success;
  final String? message;

  BatchItemResult({
    required this.beneficiary,
    required this.success,
    this.message,
  });
}

/// Service managing persistent storage and execution of bulk payout batches.
class BatchPayoutService {
  static const String _storageKey = 'sp_batch_payout_groups_v1';
  static List<BatchGroup>? _cachedBatches;

  /// Loads all saved batches from SharedPreferences.
  static Future<List<BatchGroup>> getBatches({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedBatches != null) {
      return List<BatchGroup>.from(_cachedBatches!);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList(_storageKey);

      if (rawList == null || rawList.isEmpty) {
        // Seed initial sample batch for new users
        final sample = [
          BatchGroup(
            id: 'batch_${DateTime.now().millisecondsSinceEpoch}',
            name: 'Staff Payroll',
            description: 'Monthly store staff wages & stipends',
            beneficiaries: [
              BatchBeneficiary(
                id: 'ben_1',
                accountName: 'Ipadeola Abayomi',
                accountNumber: '8164568803',
                bankName: 'StreetPay (9PSB)',
                bankCode: '120001',
                amount: 25000.0,
              ),
            ],
          ),
        ];
        await _saveBatches(sample);
        _cachedBatches = sample;
        return List<BatchGroup>.from(sample);
      }

      final List<BatchGroup> list = [];
      for (final raw in rawList) {
        try {
          final decoded = jsonDecode(raw) as Map<String, dynamic>;
          list.add(BatchGroup.fromJson(decoded));
        } catch (e) {
          debugPrint('[BatchPayoutService] Error parsing batch entry: $e');
        }
      }

      _cachedBatches = list;
      return List<BatchGroup>.from(list);
    } catch (e) {
      debugPrint('[BatchPayoutService] Failed to load batches: $e');
      return _cachedBatches ?? [];
    }
  }

  /// Saves the full list of batches to SharedPreferences.
  static Future<void> _saveBatches(List<BatchGroup> batches) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = batches.map((b) => jsonEncode(b.toJson())).toList();
      await prefs.setStringList(_storageKey, rawList);
      _cachedBatches = List<BatchGroup>.from(batches);
    } catch (e) {
      debugPrint('[BatchPayoutService] Failed to save batches: $e');
    }
  }

  /// Retrieves a specific batch by ID.
  static Future<BatchGroup?> getBatchById(String id) async {
    final batches = await getBatches();
    try {
      return batches.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Creates a new batch with the given name.
  static Future<BatchGroup> createBatch({
    required String name,
    String description = '',
  }) async {
    final batches = await getBatches();
    final newBatch = BatchGroup(
      id: 'batch_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      description: description.trim(),
      beneficiaries: [],
    );

    batches.insert(0, newBatch);
    await _saveBatches(batches);
    return newBatch;
  }

  /// Updates batch details (e.g. name or description).
  static Future<void> updateBatch(BatchGroup updated) async {
    final batches = await getBatches();
    final index = batches.indexWhere((b) => b.id == updated.id);
    if (index != -1) {
      batches[index] = updated;
      await _saveBatches(batches);
    }
  }

  /// Deletes an entire batch by ID.
  static Future<void> deleteBatch(String batchId) async {
    final batches = await getBatches();
    batches.removeWhere((b) => b.id == batchId);
    await _saveBatches(batches);
  }

  /// Cleans Nigerian bank account numbers to standard 10-digit NUBAN
  static String cleanNigerianAccountNumber(String raw) {
    String clean = raw.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 13 && clean.startsWith('234')) {
      clean = clean.substring(3);
    }
    if (clean.length == 11 && clean.startsWith('0')) {
      clean = clean.substring(1);
    }
    return clean;
  }

  /// Robustly resolves a 3-6 digit numeric CBN bank code from either bankCode or bankName.
  /// Handles swapped fields, bank names passed as codes, WAAS remaps, and missing codes.
  static String resolveBankCode({
    required String bankCode,
    required String bankName,
    dynamic allBankJson,
  }) {
    String code = bankCode.trim();
    final name = bankName.trim().toLowerCase();

    // If bankCode has letters and bankName is digits, they were swapped
    if (!RegExp(r'^\d{3,6}$').hasMatch(code) && RegExp(r'^\d{3,6}$').hasMatch(bankName.trim())) {
      code = bankName.trim();
    }

    const Map<String, String> wellKnownBankCodes = {
      'streetpay': '120001',
      'street pay': '120001',
      '9psb': '120001',
      '9 payment': '120001',
      'nine psb': '120001',
      'opay': '100004',
      'paycom': '100004',
      'palmpay': '100033',
      'moniepoint': '090405',
      'kuda': '090267',
      'guaranty': '058',
      'gtbank': '058',
      'gtb': '058',
      'access': '044',
      'zenith': '057',
      'united bank': '033',
      'uba': '033',
      'first bank': '011',
      'firstbank': '011',
      'fidelity': '070',
      'stanbic': '039',
      'sterling': '232',
      'fcmb': '214',
      'first city': '214',
      'union': '032',
      'wema': '035',
      'alat': '035',
      'polaris': '076',
      'ecobank': '050',
      'keystone': '082',
      'providus': '101',
      'jaiz': '301',
      'taj': '302',
    };

    const Map<String, String> bankCodeRemap = {
      '999992': '100004', // OPay
      '999991': '100033', // PalmPay
      '50515': '090405',  // Moniepoint
      '50211': '090267',  // Kuda
    };

    if (RegExp(r'^\d{3,6}$').hasMatch(code) && code != '000000') {
      final remapped = bankCodeRemap[code] ?? code;
      // If code was mistakenly default 120001, but bank name indicates a commercial bank, resolve from name
      if (remapped == '120001' && name.isNotEmpty &&
          !name.contains('street') && !name.contains('9psb')) {
        for (final entry in wellKnownBankCodes.entries) {
          if (name.contains(entry.key)) {
            return entry.value;
          }
        }
      }
      return remapped;
    }

    // Try resolving from code if code is actually a bank name
    final lowerCode = code.toLowerCase();
    for (final entry in wellKnownBankCodes.entries) {
      if (lowerCode.contains(entry.key)) {
        return entry.value;
      }
    }

    // Try resolving from bankName
    for (final entry in wellKnownBankCodes.entries) {
      if (name.contains(entry.key)) {
        return entry.value;
      }
    }

    // Fallback: check dynamic bank list if provided
    final customLookup = functions.getBankCode(allBankJson ?? FFAppState().allbankjson, bankName);
    if (customLookup.isNotEmpty && RegExp(r'^\d{3,6}$').hasMatch(customLookup)) {
      return bankCodeRemap[customLookup] ?? customLookup;
    }

    // Default to StreetPay / 9PSB
    return '120001';
  }

  /// Adds a beneficiary to an existing batch.
  static Future<void> addBeneficiary({
    required String batchId,
    required String accountName,
    required String accountNumber,
    required String bankName,
    required String bankCode,
    double amount = 0.0,
  }) async {
    final batches = await getBatches();
    final batch = batches.firstWhere((b) => b.id == batchId);

    final cleanAccount = cleanNigerianAccountNumber(accountNumber);
    final healedCode = resolveBankCode(
      bankCode: bankCode,
      bankName: bankName,
    );

    // Remove any previous entry for this exact account number in this batch
    batch.beneficiaries.removeWhere((b) =>
        b.accountNumber == cleanAccount ||
        b.accountNumber == accountNumber.trim());

    final ben = BatchBeneficiary(
      id: 'ben_${DateTime.now().millisecondsSinceEpoch}',
      accountName: accountName.trim(),
      accountNumber: cleanAccount.isNotEmpty ? cleanAccount : accountNumber.trim(),
      bankName: bankName.trim(),
      bankCode: healedCode,
      amount: amount,
    );

    batch.beneficiaries.add(ben);
    await _saveBatches(batches);
  }

  /// Removes an individual beneficiary from a batch.
  static Future<void> removeBeneficiary({
    required String batchId,
    required String beneficiaryId,
  }) async {
    final batches = await getBatches();
    final index = batches.indexWhere((b) => b.id == batchId);
    if (index != -1) {
      batches[index]
          .beneficiaries
          .removeWhere((b) => b.id == beneficiaryId);
      await _saveBatches(batches);
    }
  }

  /// Updates the payout amount for an individual beneficiary.
  static Future<void> updateBeneficiaryAmount({
    required String batchId,
    required String beneficiaryId,
    required double newAmount,
  }) async {
    final batches = await getBatches();
    final batch = batches.firstWhere((b) => b.id == batchId);
    final ben = batch.beneficiaries.firstWhere((b) => b.id == beneficiaryId);
    ben.amount = newAmount;
    await _saveBatches(batches);
  }

  /// Executes bulk payout for all beneficiaries in a batch who have amount > 0.
  /// Calls [onProgress] callback with current status for each beneficiary.
  static Future<List<BatchItemResult>> executeBatchPayout({
    required BatchGroup batch,
    required String pin,
    required Function(int current, int total, String name, bool success, String message)
        onProgress,
    bool isScheduledExecution = false,
  }) async {
    final payableBeneficiaries =
        batch.beneficiaries.where((b) => b.amount > 0).toList();

    if (payableBeneficiaries.isEmpty) {
      return [];
    }

    await LocalVaultService.initialize();

    // Ensure user state is populated
    if (FFAppState().accountno.isEmpty || FFAppState().phonenumber.isEmpty) {
      await FFAppState().initializePersistedState();
    }

    // Acquire or refresh authenticated bearer token
    String tokenToUse = FFAppState().bsptoken;
    final authResp = await StreetauthCall.call(forceRefresh: true);
    final fresh = StreetauthCall.streettoken(authResp.jsonBody);
    if (fresh != null && fresh.isNotEmpty) {
      tokenToUse = fresh;
      FFAppState().bsptoken = fresh;
    }

    // 1. Verify PIN and obtain authenticated session
    final cleanPhone = functions.removecode(FFAppState().phonenumber) ??
        FFAppState().phonenumber;

    String sessionId = '';
    if (pin.trim().isNotEmpty) {
      final pinRes = await IspincodevalidCall.call(
        phoneno: cleanPhone,
        pincode: pin.trim(),
        accessToken: tokenToUse,
        deviceid: FFAppState().deviceid,
      );

      final sid = IspincodevalidCall.sessionid(pinRes.jsonBody ?? '');
      final pinValid =
          IspincodevalidCall.success(pinRes.jsonBody ?? '') == true;

      if (!pinValid || sid == null || sid.isEmpty) {
        throw Exception('Invalid transaction PIN. Payout cancelled.');
      }
      sessionId = sid;
      FFAppState().sessionid = sid;
    } else {
      sessionId = FFAppState().sessionid.isNotEmpty
          ? FFAppState().sessionid
          : await actions.generateseesionid();
    }

    // 2. Upfront balance check
    final double ledgerBal = FFAppState().ledgerBalance;
    final double availBal = FFAppState().effectiveAvailableBalance;
    final double reservedBal = FFAppState().reservedBalance;
    final double effectiveSpendable = isScheduledExecution ? ledgerBal : availBal;
    final double totalBatchAmount =
        payableBeneficiaries.fold(0.0, (sum, b) => sum + b.amount);

    if (effectiveSpendable > 0 && effectiveSpendable < payableBeneficiaries.first.amount) {
      final transRef = await actions.generatetransref();
      await LocalVaultService.recordTransaction(
        ref: transRef,
        amount: totalBatchAmount,
        recipientName: 'Batch: ${batch.name}',
        narration: 'Batch payout failed: Insufficient available balance',
        status: 'Failed (Insufficient available balance)',
        type: 'debit',
      );

      await LogtransactionCall.call(
        phoneno: cleanPhone,
        accountId: FFAppState().accountno,
        reqtype: 'Batch Payout--${totalBatchAmount.toStringAsFixed(2)}',
        passorfail: 'Failed',
        balBefore: FFAppState().avalbal,
        balafter: FFAppState().avalbal,
        beneficiary: batch.name,
        tammt: totalBatchAmount.toStringAsFixed(2),
        extra: 'Batch payout failed: Insufficient available balance',
        transREF: transRef,
        accessToken: tokenToUse,
        ttype: 'Debit',
      );

      final msg = reservedBal > 0 && !isScheduledExecution
          ? 'Insufficient available balance: ₦${formatNumber(totalBatchAmount, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)} required, but available balance is ₦${formatNumber(availBal, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)} (₦${formatNumber(reservedBal, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)} held for scheduled payments).'
          : 'Insufficient balance: ₦${formatNumber(totalBatchAmount, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)} required, but available balance is ₦${formatNumber(effectiveSpendable, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)}.';

      throw Exception(msg);
    }

    final List<BatchItemResult> results = [];
    int successfulCount = 0;
    double disbursedTotal = 0.0;
    double runningBalance = effectiveSpendable;

    for (int i = 0; i < payableBeneficiaries.length; i++) {
      final ben = payableBeneficiaries[i];

      // Check if running balance is sufficient for this beneficiary
      if (effectiveSpendable > 0 && runningBalance < ben.amount) {
        final failMsg = 'Insufficient available balance';
        final transRef = await actions.generatetransref();

        await LocalVaultService.recordTransaction(
          ref: transRef,
          amount: ben.amount,
          recipientName: ben.accountName,
          recipientAccount: ben.accountNumber,
          bankName: ben.bankName,
          bankCode: ben.bankCode,
          narration: 'Batch: ${batch.name} - ${ben.accountName} failed: Insufficient available balance',
          status: 'Failed (Insufficient available balance)',
          type: 'debit',
        );

        await LogtransactionCall.call(
          phoneno: cleanPhone,
          accountId: FFAppState().accountno,
          reqtype: 'Batch Transfer--${ben.amount.toStringAsFixed(2)}',
          passorfail: 'Failed',
          balBefore: runningBalance.toStringAsFixed(2),
          balafter: runningBalance.toStringAsFixed(2),
          beneficiary: ben.accountName,
          tammt: ben.amount.toStringAsFixed(2),
          extra: 'Insufficient balance: ₦${ben.amount} for ${ben.accountName}',
          transREF: transRef,
          accessToken: tokenToUse,
          ttype: 'Debit',
        );

        final itemResult = BatchItemResult(
          beneficiary: ben,
          success: false,
          message: failMsg,
        );
        results.add(itemResult);
        onProgress(i + 1, payableBeneficiaries.length, ben.accountName, false, failMsg);
        continue;
      }

      try {
        // Obtain transaction token for this transfer
        final transTokenRes = await GettransactiontokenCall.call(
          accessToken: tokenToUse,
          accountno: FFAppState().accountno,
          deviceid: FFAppState().deviceid,
          sessionid: sessionId,
        );

        final refId = GettransactiontokenCall.transtoken(
          transTokenRes.jsonBody ?? '',
        );

        // Standard 18-19 character alphanumeric reference accepted by NIBSS
        final ref = await actions.generatetransref();

        // Robust bank code resolution: 3-6 digit CBN code guaranteed
        final cleanBankCode = resolveBankCode(
          bankCode: ben.bankCode,
          bankName: ben.bankName,
        );

        // Clean account number: 10 digits
        final cleanAccountNo = cleanNigerianAccountNumber(ben.accountNumber);

        // Safe narration strictly <= 30 chars
        final safeNarration = ben.accountName.trim().isNotEmpty
            ? ben.accountName.trim()
            : 'Batch Payout';
        final cleanNarration = safeNarration.length > 30
            ? safeNarration.substring(0, 30)
            : safeNarration;

        debugPrint('[BatchPayout] Disbursing #${i + 1}/${payableBeneficiaries.length}: ${ben.accountName} (Account: $cleanAccountNo, Bank: $cleanBankCode - ${ben.bankName}, Amount: ₦${ben.amount})');

        final transferRes =
            await WalletAsAServiceGroup.otherBankTransferCall.call(
          customeraccount: cleanBankCode,
          customername: ben.accountName.trim(),
          customeraccountno: cleanAccountNo,
          senderaccountno: FFAppState().accountno.trim(),
          sendername: FFAppState().accountname.isNotEmpty
              ? FFAppState().accountname.trim()
              : 'StreetPay User',
          narration: cleanNarration,
          amount: (ben.amount % 1 == 0)
              ? ben.amount.toInt().toString()
              : ben.amount.toString(),
          description: 'Batch Payout',
          refrence: ref,
          sectionid: sessionId,
          authToken: tokenToUse,
          refid: refId,
          bankname: ben.bankName,
        );

        final isSuccess =
            WalletAsAServiceGroup.otherBankTransferCall.success(
                  transferRes.jsonBody ?? '',
                ) ==
                true;

        final rawMsg = WalletAsAServiceGroup.otherBankTransferCall.message(
              transferRes.jsonBody ?? '',
            ) ??
            (isSuccess ? 'Transferred successfully' : 'Transfer failed');

        debugPrint('[BatchPayout] Result for ${ben.accountName}: success=$isSuccess, msg=$rawMsg, body=${transferRes.jsonBody}');

        String msg = rawMsg;
        if (!isSuccess &&
            (rawMsg.toLowerCase().contains('insufficient') ||
                rawMsg.toLowerCase().contains('balance'))) {
          msg = 'Insufficient balance';
        }

        if (isSuccess) {
          successfulCount++;
          disbursedTotal += ben.amount;
          if (runningBalance >= ben.amount) {
            runningBalance -= ben.amount;
            FFAppState().avalbal = runningBalance.toStringAsFixed(2);
          }

          // Persist beneficiary permanently in both SQLite and SharedPreferences
          await BeneficiaryService.saveBeneficiary(
            accountName: ben.accountName.trim(),
            accountNumber: cleanAccountNo,
            bankName: ben.bankName,
            bankCode: cleanBankCode,
          );

          // Record transaction into persistent SQLite vault
          await LocalVaultService.recordTransaction(
            ref: ref,
            amount: ben.amount,
            recipientName: ben.accountName,
            recipientAccount: cleanAccountNo,
            bankName: ben.bankName,
            bankCode: cleanBankCode,
            narration: 'Batch: ${batch.name} - ${ben.accountName}',
            status: 'Successful',
            type: 'debit',
          );

          // Record in backend user transaction log
          await LogtransactionCall.call(
            phoneno: cleanPhone,
            accountId: FFAppState().accountno,
            reqtype: 'Batch Transfer--${ben.amount.toStringAsFixed(2)}',
            passorfail: 'Success',
            balBefore: (runningBalance + ben.amount).toStringAsFixed(2),
            balafter: runningBalance.toStringAsFixed(2),
            beneficiary: ben.accountName,
            tammt: ben.amount.toStringAsFixed(2),
            extra: 'Batch: ${batch.name} - ${ben.accountName}',
            transREF: ref,
            accessToken: tokenToUse,
            ttype: 'Debit',
          );
        } else {
          // Record failed transaction into persistent SQLite vault
          await LocalVaultService.recordTransaction(
            ref: ref,
            amount: ben.amount,
            recipientName: ben.accountName,
            recipientAccount: cleanAccountNo,
            bankName: ben.bankName,
            bankCode: cleanBankCode,
            narration: 'Batch: ${batch.name} - ${ben.accountName} failed: $msg',
            status: 'Failed ($msg)',
            type: 'debit',
          );

          // Record in backend user transaction log
          await LogtransactionCall.call(
            phoneno: cleanPhone,
            accountId: FFAppState().accountno,
            reqtype: 'Batch Transfer--${ben.amount.toStringAsFixed(2)}',
            passorfail: 'Failed',
            balBefore: runningBalance.toStringAsFixed(2),
            balafter: runningBalance.toStringAsFixed(2),
            beneficiary: ben.accountName,
            tammt: ben.amount.toStringAsFixed(2),
            extra: 'Batch: ${batch.name} - ${ben.accountName} failed: $msg',
            transREF: ref,
            accessToken: tokenToUse,
            ttype: 'Debit',
          );
        }

        final itemResult = BatchItemResult(
          beneficiary: ben,
          success: isSuccess,
          message: msg,
        );
        results.add(itemResult);

        onProgress(i + 1, payableBeneficiaries.length, ben.accountName,
            isSuccess, msg);

        // Small delay between calls to avoid hitting rate limits
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
        final errText = e.toString().replaceAll('Exception: ', '');
        final failRef = await actions.generatetransref();

        await LocalVaultService.recordTransaction(
          ref: failRef,
          amount: ben.amount,
          recipientName: ben.accountName,
          recipientAccount: ben.accountNumber,
          bankName: ben.bankName,
          bankCode: ben.bankCode,
          narration: 'Batch payout failed: $errText',
          status: 'Failed ($errText)',
          type: 'debit',
        );

        final itemResult = BatchItemResult(
          beneficiary: ben,
          success: false,
          message: errText,
        );
        results.add(itemResult);
        onProgress(i + 1, payableBeneficiaries.length, ben.accountName, false,
            errText);
      }
    }

    // Record last disbursed stats if at least one succeeded
    if (successfulCount > 0) {
      batch.lastDisbursedAt = DateTime.now();
      batch.lastDisbursedAmount = disbursedTotal;
      await updateBatch(batch);

      // Announce via TTS if enabled
      if (FFAppState().voiceAnnouncementsActivated) {
        TtsService.instance.announcePaymentSent(
          amount: disbursedTotal.toStringAsFixed(0),
          recipientName: '${batch.name} ($successfulCount recipients)',
        );
      }
    }

    return results;
  }
}
