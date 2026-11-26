import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '/backend/api_requests/api_calls.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'local_vault_service.dart';
import 'beneficiary_service.dart';
import 'batch_payout_service.dart';
import 'tts_service.dart';

/// Top-level callback for Android AlarmManager background execution
@pragma('vm:entry-point')
void scheduledPaymentAlarmCallback(int id) async {
  debugPrint('[ScheduledPaymentAlarm] Alarm triggered with id: $id');
  try {
    WidgetsFlutterBinding.ensureInitialized();
    if (FFAppState().accountno.isEmpty || FFAppState().phonenumber.isEmpty) {
      await FFAppState().initializePersistedState();
    }
    await ScheduledPaymentService.executeDueSchedules();
  } catch (e) {
    debugPrint('[ScheduledPaymentAlarm] Error in background execution: $e');
  }
}

class ScheduledPaymentItem {
  final String id;
  final String title;
  final String recipientName;
  final String accountNumber;
  final String bankName;
  final String? bankCode;
  final double amount;
  final String narration;
  final DateTime scheduledTime;
  final String status; // 'PENDING', 'COMPLETED', 'FAILED', 'CANCELLED'
  final bool isBatch;
  final String? batchId;
  final String? pinEncrypted;
  final DateTime createdAt;
  final String? failureReason;
  final String? senderAccount;
  final String? senderName;
  final String? senderPhone;
  final String? senderDeviceId;

  ScheduledPaymentItem({
    required this.id,
    required this.title,
    required this.recipientName,
    required this.accountNumber,
    required this.bankName,
    this.bankCode,
    required this.amount,
    this.narration = '',
    required this.scheduledTime,
    this.status = 'PENDING',
    this.isBatch = false,
    this.batchId,
    this.pinEncrypted,
    DateTime? createdAt,
    this.failureReason,
    this.senderAccount,
    this.senderName,
    this.senderPhone,
    this.senderDeviceId,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ScheduledPaymentItem.fromMap(Map<String, dynamic> map) {
    final rawName = map['bank_name'] as String? ?? '';
    final rawCode = map['bank_code'] as String? ?? '';
    final healedCode = BatchPayoutService.resolveBankCode(
      bankCode: rawCode,
      bankName: rawName,
    );
    final rawAccount = map['recipient_account'] as String? ?? '';
    final cleanAccount = BatchPayoutService.cleanNigerianAccountNumber(rawAccount);

    return ScheduledPaymentItem(
      id: map['id'] as String,
      title: map['title'] as String? ?? 'Scheduled Transfer',
      recipientName: map['recipient_name'] as String? ?? 'Recipient',
      accountNumber: cleanAccount.isNotEmpty ? cleanAccount : rawAccount,
      bankName: rawName,
      bankCode: healedCode,
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      narration: map['narration'] as String? ?? '',
      scheduledTime: DateTime.fromMillisecondsSinceEpoch(
        (map['scheduled_time'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      ),
      status: map['status'] as String? ?? 'PENDING',
      isBatch: ((map['is_batch'] as int?) ?? 0) == 1,
      batchId: map['batch_id'] as String?,
      pinEncrypted: map['pin_encrypted'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['created_at'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      ),
      failureReason: map['failure_reason'] as String?,
      senderAccount: map['sender_account'] as String?,
      senderName: map['sender_name'] as String?,
      senderPhone: map['sender_phone'] as String?,
      senderDeviceId: map['sender_device_id'] as String?,
    );
  }

  bool get isDue => DateTime.now().isAfter(scheduledTime) && status == 'PENDING';
}

class ScheduledPaymentService {
  static bool _initialized = false;
  static bool _isExecuting = false;
  static Timer? _inAppTicker;
  static final Map<String, Timer> _activeTimers = {};

  /// Initialize AlarmManager, start real-time in-app ticker, and run overdue catch-up check
  static Future<void> initialize() async {
    if (_initialized) {
      await executeDueSchedules();
      return;
    }

    try {
      if (Platform.isAndroid) {
        try {
          await AndroidAlarmManager.initialize();
        } catch (e) {
          debugPrint('[ScheduledPaymentService] AndroidAlarmManager init error: $e');
        }
      }
      _initialized = true;

      // Start in-app periodic ticker every 10 seconds so payments execute once the time clocks
      _inAppTicker?.cancel();
      _inAppTicker = Timer.periodic(const Duration(seconds: 10), (_) {
        executeDueSchedules();
      });

      // Schedule exact in-memory timers for all currently pending items
      final pending = await getPendingSchedules();
      for (final item in pending) {
        _scheduleInMemoryTimer(item);
      }

      // Refresh reserved balance state
      await refreshReservedBalance();

      // Auto-catchup: check for any payments that matured while device was sleeping
      await executeDueSchedules();
    } catch (e) {
      debugPrint('[ScheduledPaymentService] Init error: $e');
    }
  }

  /// Recalculates and updates FFAppState with the total reserved amount across pending schedules
  static Future<Map<String, dynamic>> refreshReservedBalance() async {
    try {
      await LocalVaultService.initialize();
      final summary = await LocalVaultService.getReservedSummary();
      final double amount = (summary['amount'] as num?)?.toDouble() ?? 0.0;
      final int count = (summary['count'] as int?) ?? 0;
      FFAppState().setReservedBalance(amount, count);
      return summary;
    } catch (e) {
      debugPrint('[ScheduledPaymentService] refreshReservedBalance error: $e');
      return {'amount': 0.0, 'count': 0};
    }
  }

  static void _scheduleInMemoryTimer(ScheduledPaymentItem item) {
    if (item.status != 'PENDING') return;
    _activeTimers[item.id]?.cancel();

    final now = DateTime.now();
    final delay = item.scheduledTime.difference(now);
    if (delay <= Duration.zero) {
      // Already due!
      Timer.run(() => executeDueSchedules());
    } else {
      debugPrint('[ScheduledPaymentService] In-memory timer registered for ${item.id} in ${delay.inSeconds}s');
      _activeTimers[item.id] = Timer(delay, () {
        debugPrint('[ScheduledPaymentService] Time clocked! Executing schedule: ${item.id}');
        executeDueSchedules();
      });
    }
  }

  /// Create a new scheduled transfer or scheduled batch
  static Future<ScheduledPaymentItem> createSchedule({
    required String title,
    required String recipientName,
    required String accountNumber,
    required String bankName,
    String? bankCode,
    required double amount,
    String narration = '',
    required DateTime scheduledTime,
    bool isBatch = false,
    String? batchId,
    String? pin,
  }) async {
    await LocalVaultService.initialize();

    final cleanPhone = functions.removecode(FFAppState().phonenumber) ?? FFAppState().phonenumber;
    final cleanAccount = BatchPayoutService.cleanNigerianAccountNumber(accountNumber);
    final healedCode = BatchPayoutService.resolveBankCode(
      bankCode: bankCode ?? '',
      bankName: bankName,
    );
    final id = 'sched_${DateTime.now().millisecondsSinceEpoch}';
    final schedule = ScheduledPaymentItem(
      id: id,
      title: title,
      recipientName: recipientName.trim(),
      accountNumber: cleanAccount.isNotEmpty ? cleanAccount : accountNumber.trim(),
      bankName: bankName.trim(),
      bankCode: healedCode,
      amount: amount,
      narration: narration.trim(),
      scheduledTime: scheduledTime,
      isBatch: isBatch,
      batchId: batchId,
      pinEncrypted: pin,
      status: 'PENDING',
      senderAccount: FFAppState().accountno,
      senderName: FFAppState().accountname,
      senderPhone: cleanPhone,
      senderDeviceId: FFAppState().deviceid,
    );

    await LocalVaultService.saveScheduledPayment(
      id: schedule.id,
      title: schedule.title,
      recipientName: schedule.recipientName,
      recipientAccount: schedule.accountNumber,
      bankName: schedule.bankName,
      bankCode: schedule.bankCode,
      amount: schedule.amount,
      narration: schedule.narration,
      scheduledTime: schedule.scheduledTime,
      isBatch: schedule.isBatch,
      batchId: schedule.batchId,
      pinEncrypted: schedule.pinEncrypted,
      status: 'PENDING',
      senderAccount: schedule.senderAccount,
      senderName: schedule.senderName,
      senderPhone: schedule.senderPhone,
      senderDeviceId: schedule.senderDeviceId,
    );

    // Schedule exact in-memory timer so it triggers instantly once the clock strikes
    _scheduleInMemoryTimer(schedule);

    // Register native Android AlarmManager exact alarm for background wakeup
    if (Platform.isAndroid) {
      try {
        final alarmId = id.hashCode & 0x7FFFFFFF;
        await AndroidAlarmManager.oneShotAt(
          scheduledTime,
          alarmId,
          scheduledPaymentAlarmCallback,
          exact: true,
          wakeup: true,
          allowWhileIdle: true,
          rescheduleOnReboot: true,
        );
        debugPrint('[ScheduledPaymentService] Exact alarm scheduled for: $scheduledTime (id: $alarmId)');
      } catch (e) {
        debugPrint('[ScheduledPaymentService] Alarm registration error: $e');
      }
    }

    // Refresh reserved balance on hold
    await refreshReservedBalance();

    return schedule;
  }

  /// Cancel a scheduled payment
  static Future<void> cancelSchedule(String id) async {
    _activeTimers[id]?.cancel();
    _activeTimers.remove(id);

    await LocalVaultService.initialize();
    await LocalVaultService.updateScheduledStatus(id, 'CANCELLED');

    if (Platform.isAndroid) {
      try {
        final alarmId = id.hashCode & 0x7FFFFFFF;
        await AndroidAlarmManager.cancel(alarmId);
      } catch (_) {}
    }

    // Refresh reserved balance immediately upon cancellation
    await refreshReservedBalance();
  }

  /// Get all scheduled payments
  static Future<List<ScheduledPaymentItem>> getAllSchedules() async {
    await LocalVaultService.initialize();
    final rows = await LocalVaultService.getAllScheduledPayments();
    return rows.map((e) => ScheduledPaymentItem.fromMap(e)).toList();
  }

  /// Get pending scheduled payments
  static Future<List<ScheduledPaymentItem>> getPendingSchedules() async {
    final all = await getAllSchedules();
    return all.where((item) => item.status == 'PENDING').toList();
  }

  /// Process all due scheduled payments (called by in-app ticker, time clock, alarm or on app open)
  static Future<void> executeDueSchedules() async {
    if (_isExecuting) return;
    _isExecuting = true;

    try {
      await LocalVaultService.initialize();
      final dueRows = await LocalVaultService.getPendingDueScheduledPayments();
      if (dueRows.isEmpty) return;

      debugPrint('[ScheduledPaymentService] Processing ${dueRows.length} due payments...');

      // Ensure user state is loaded if empty
      if (FFAppState().accountno.isEmpty || FFAppState().phonenumber.isEmpty) {
        await FFAppState().initializePersistedState();
      }

      for (final row in dueRows) {
        final item = ScheduledPaymentItem.fromMap(row);
        await _executeSingleScheduledPayment(item);
      }
    } catch (e) {
      debugPrint('[ScheduledPaymentService] executeDueSchedules error: $e');
    } finally {
      _isExecuting = false;
      await refreshReservedBalance();
    }
  }

  static Future<void> _executeSingleScheduledPayment(ScheduledPaymentItem item) async {
    try {
      debugPrint('[ScheduledPaymentService] Executing schedule: ${item.id} -> ${item.recipientName} (₦${item.amount})');

      if (item.isBatch && item.batchId != null && item.batchId!.isNotEmpty) {
        // Batch scheduled execution
        await _executeBatchSchedule(item);
        return;
      }

      // Check available balance upfront
      final userBal = functions.stringtodouble(FFAppState().avalbal);
      final stampDuty = item.amount >= 10000.0 ? 50.0 : 0.0;
      final totalNeeded = item.amount + stampDuty;

      if (userBal > 0 && userBal < totalNeeded) {
        final errMsg = 'Insufficient balance (₦${formatNumber(totalNeeded, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)} needed)';
        debugPrint('[ScheduledPaymentService] Schedule ${item.id} failed: $errMsg');

        await LocalVaultService.updateScheduledStatus(
          item.id,
          'FAILED',
          failureReason: errMsg,
        );

        final transRef = await actions.generatetransref();
        await LocalVaultService.recordTransaction(
          ref: transRef,
          amount: item.amount,
          recipientName: item.recipientName,
          recipientAccount: item.accountNumber,
          bankName: item.bankName,
          bankCode: item.bankCode,
          narration: 'Scheduled payment failed: Insufficient balance',
          status: 'Failed (Insufficient balance)',
          type: 'debit',
        );

        final phone = (item.senderPhone?.isNotEmpty == true ? item.senderPhone : FFAppState().phonenumber) ?? '';
        final senderAcc = (item.senderAccount?.isNotEmpty == true ? item.senderAccount : FFAppState().accountno) ?? '';

        await LogtransactionCall.call(
          phoneno: phone,
          accountId: senderAcc,
          reqtype: 'Scheduled Transfer--${item.amount.toStringAsFixed(2)}',
          passorfail: 'Failed',
          balBefore: FFAppState().avalbal,
          balafter: FFAppState().avalbal,
          beneficiary: item.recipientName,
          tammt: item.amount.toStringAsFixed(2),
          extra: 'Scheduled payment failed: Insufficient balance',
          transREF: transRef,
          accessToken: FFAppState().bsptoken,
          ttype: 'Debit',
        );

        return;
      }

      // Single transfer execution
      // 1. Acquire fresh StreetAuth token
      final authResp = await StreetauthCall.call(forceRefresh: true);
      final freshToken = StreetauthCall.streettoken(authResp.jsonBody) ??
          FFAppState().bsptoken;
      if (freshToken.isEmpty) {
        throw Exception('No auth token available for scheduled payment');
      }
      FFAppState().bsptoken = freshToken;

      // 2. Validate PIN code / acquire session
      String sessionId = '';
      final phone = (item.senderPhone?.isNotEmpty == true ? item.senderPhone : FFAppState().phonenumber) ?? '';
      final cleanPhone = functions.removecode(phone) ?? phone;
      final senderAcc = (item.senderAccount?.isNotEmpty == true ? item.senderAccount : FFAppState().accountno) ?? '';
      final senderNm = (item.senderName?.isNotEmpty == true ? item.senderName : FFAppState().accountname) ?? 'StreetPay User';
      final deviceId = (item.senderDeviceId?.isNotEmpty == true ? item.senderDeviceId : FFAppState().deviceid) ?? '';

      if (item.pinEncrypted != null && item.pinEncrypted!.trim().isNotEmpty) {
        final pinResp = await IspincodevalidCall.call(
          phoneno: cleanPhone,
          pincode: item.pinEncrypted!.trim(),
          accessToken: freshToken,
          deviceid: deviceId,
        );
        sessionId = IspincodevalidCall.sessionid(pinResp.jsonBody) ?? '';
      }

      if (sessionId.isEmpty) {
        sessionId = FFAppState().sessionid.isNotEmpty ? FFAppState().sessionid : await actions.generateseesionid();
      }

      // 3. Request transaction token
      final transTokenResp = await GettransactiontokenCall.call(
        accessToken: freshToken,
        accountno: senderAcc,
        deviceid: deviceId,
        sessionid: sessionId,
      );
      final refId = GettransactiontokenCall.transtoken(transTokenResp.jsonBody ?? '');

      final transRef = await actions.generatetransref();

      // Robust bank code resolution: 3-6 digit CBN code guaranteed
      final cleanBankCode = BatchPayoutService.resolveBankCode(
        bankCode: item.bankCode ?? '',
        bankName: item.bankName,
      );

      // Clean account number: 10 digits
      final cleanAccountNo = BatchPayoutService.cleanNigerianAccountNumber(item.accountNumber);

      // Safe narration strictly <= 30 chars
      final safeNarration = item.recipientName.trim().isNotEmpty
          ? item.recipientName.trim()
          : (item.narration.isNotEmpty ? item.narration.trim() : 'Scheduled Transfer');
      final cleanNarration = safeNarration.length > 30
          ? safeNarration.substring(0, 30)
          : safeNarration;

      debugPrint('[ScheduledPayment] Disbursing: ${item.recipientName} (Account: $cleanAccountNo, Bank: $cleanBankCode - ${item.bankName}, Amount: ₦${item.amount})');

      // 4. Execute bank transfer
      final transferResp = await WalletAsAServiceGroup.otherBankTransferCall.call(
        customeraccount: cleanBankCode,
        customername: item.recipientName.trim(),
        customeraccountno: cleanAccountNo,
        senderaccountno: senderAcc,
        sendername: senderNm,
        narration: cleanNarration,
        amount: (item.amount % 1 == 0)
            ? item.amount.toInt().toString()
            : item.amount.toString(),
        description: 'Scheduled Transfer',
        refrence: transRef,
        sectionid: sessionId,
        authToken: freshToken,
        refid: refId,
        bankname: item.bankName,
      );

      final isSuccess = WalletAsAServiceGroup.otherBankTransferCall.success(transferResp.jsonBody) == true;
      final rawMsg = WalletAsAServiceGroup.otherBankTransferCall.message(transferResp.jsonBody) ?? '';

      debugPrint('[ScheduledPayment] Result for ${item.recipientName}: success=$isSuccess, msg=$rawMsg, body=${transferResp.jsonBody}');

      if (isSuccess) {
        await LocalVaultService.updateScheduledStatus(item.id, 'COMPLETED');

        // Deduct from local wallet balance
        final curBal = functions.stringtodouble(FFAppState().avalbal);
        if (curBal >= item.amount) {
          FFAppState().avalbal = (curBal - item.amount).toStringAsFixed(2);
        }

        // Persist beneficiary permanently in both SQLite and SharedPreferences
        await BeneficiaryService.saveBeneficiary(
          accountName: item.recipientName,
          accountNumber: cleanAccountNo,
          bankName: item.bankName,
          bankCode: cleanBankCode,
        );

        // Record in transaction vault
        await LocalVaultService.recordTransaction(
          ref: transRef,
          amount: item.amount,
          recipientName: item.recipientName,
          recipientAccount: cleanAccountNo,
          bankName: item.bankName,
          bankCode: cleanBankCode,
          narration: item.narration.isNotEmpty ? item.narration : item.title,
          status: 'Successful',
          type: 'debit',
        );

        // Record in backend user transaction log
        await LogtransactionCall.call(
          phoneno: cleanPhone,
          accountId: senderAcc,
          reqtype: 'Scheduled Transfer--${item.amount.toStringAsFixed(2)}',
          passorfail: 'Success',
          balBefore: FFAppState().avalbal,
          balafter: FFAppState().avalbal,
          beneficiary: item.recipientName,
          tammt: item.amount.toStringAsFixed(2),
          extra: item.narration.isNotEmpty ? item.narration : item.title,
          transREF: transRef,
          accessToken: freshToken,
          ttype: 'Debit',
        );

        if (FFAppState().voiceAnnouncementsActivated) {
          TtsService.instance.announcePaymentSent(
            amount: item.amount.toString(),
            recipientName: item.recipientName,
          );
        }

        debugPrint('[ScheduledPaymentService] Successfully fulfilled scheduled transfer: ${item.id}');
      } else {
        String errorReason = rawMsg.isNotEmpty ? rawMsg : 'Transfer failed';
        if (errorReason.toLowerCase().contains('insufficient') ||
            errorReason.toLowerCase().contains('balance')) {
          errorReason = 'Insufficient balance';
        }

        await LocalVaultService.updateScheduledStatus(
          item.id,
          'FAILED',
          failureReason: errorReason,
        );

        await LocalVaultService.recordTransaction(
          ref: transRef,
          amount: item.amount,
          recipientName: item.recipientName,
          recipientAccount: cleanAccountNo,
          bankName: item.bankName,
          bankCode: cleanBankCode,
          narration: 'Scheduled payment failed: $errorReason',
          status: 'Failed ($errorReason)',
          type: 'debit',
        );

        await LogtransactionCall.call(
          phoneno: cleanPhone,
          accountId: senderAcc,
          reqtype: 'Scheduled Transfer--${item.amount.toStringAsFixed(2)}',
          passorfail: 'Failed',
          balBefore: FFAppState().avalbal,
          balafter: FFAppState().avalbal,
          beneficiary: item.recipientName,
          tammt: item.amount.toStringAsFixed(2),
          extra: 'Scheduled payment failed: $errorReason',
          transREF: transRef,
          accessToken: freshToken,
          ttype: 'Debit',
        );

        debugPrint('[ScheduledPaymentService] Transfer failed for: ${item.id} ($errorReason)');
      }
    } catch (e) {
      debugPrint('[ScheduledPaymentService] Execution error for ${item.id}: $e');
      final errorReason = e.toString().replaceAll('Exception: ', '');
      await LocalVaultService.updateScheduledStatus(
        item.id,
        'FAILED',
        failureReason: errorReason,
      );
    }
  }

  static Future<void> _executeBatchSchedule(ScheduledPaymentItem item) async {
    try {
      final batches = await BatchPayoutService.getBatches(forceRefresh: true);
      final batch = batches.firstWhere(
        (b) => b.id == item.batchId,
        orElse: () => BatchGroup(id: '', name: '', description: ''),
      );

      if (batch.id.isEmpty || batch.beneficiaries.isEmpty) {
        await LocalVaultService.updateScheduledStatus(
          item.id,
          'FAILED',
          failureReason: 'Batch group not found or has no beneficiaries',
        );
        return;
      }

      final pinToUse = item.pinEncrypted?.trim() ?? '';
      final results = await BatchPayoutService.executeBatchPayout(
        batch: batch,
        pin: pinToUse,
        isScheduledExecution: true,
        onProgress: (current, total, name, success, message) {
          debugPrint('[ScheduledBatch] $current/$total: $name -> $success ($message)');
        },
      );

      final hasSuccess = results.any((r) => r.success);
      final allFailed = results.isNotEmpty && results.every((r) => !r.success);

      if (allFailed) {
        final reason = results.first.message ?? 'All batch payments failed';
        await LocalVaultService.updateScheduledStatus(
          item.id,
          'FAILED',
          failureReason: reason,
        );
      } else if (hasSuccess) {
        final failureCount = results.where((r) => !r.success).length;
        if (failureCount > 0) {
          await LocalVaultService.updateScheduledStatus(
            item.id,
            'COMPLETED',
            failureReason: '$failureCount of ${results.length} payments failed',
          );
        } else {
          await LocalVaultService.updateScheduledStatus(item.id, 'COMPLETED');
        }
      } else {
        await LocalVaultService.updateScheduledStatus(
          item.id,
          'FAILED',
          failureReason: 'No payments processed',
        );
      }
    } catch (e) {
      debugPrint('[ScheduledPaymentService] Batch schedule error: $e');
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      await LocalVaultService.updateScheduledStatus(
        item.id,
        'FAILED',
        failureReason: errorMsg,
      );
    }
  }
}
