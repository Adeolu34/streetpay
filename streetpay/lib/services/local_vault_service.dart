import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// LocalVaultService provides high-performance SQLite caching and uninstall-proof
/// public storage mirroring for beneficiaries, transaction history, and scheduled payments.
class LocalVaultService {
  static Database? _db;
  static bool _initialized = false;

  static const String _publicDirName = 'StreetPay';
  static const String _mirrorFileName = 'streetpay_vault_mirror.json';

  /// Initialize SQLite database and perform automatic recovery if fresh install
  static Future<Database> getDatabase() async {
    if (_db != null && _db!.isOpen) return _db!;
    await initialize();
    return _db!;
  }

  static Future<void> initialize() async {
    if (_initialized && _db != null && _db!.isOpen) return;

    try {
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, 'streetpay_vault.db');

      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS beneficiaries (
              account_number TEXT PRIMARY KEY,
              account_name TEXT NOT NULL,
              bank_name TEXT NOT NULL,
              bank_code TEXT,
              last_used INTEGER NOT NULL,
              transfer_count INTEGER DEFAULT 1
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS transactions (
              ref TEXT PRIMARY KEY,
              amount REAL NOT NULL,
              recipient_name TEXT,
              recipient_account TEXT,
              bank_name TEXT,
              bank_code TEXT,
              narration TEXT,
              status TEXT NOT NULL,
              timestamp INTEGER NOT NULL,
              type TEXT DEFAULT 'debit'
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS scheduled_payments (
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              recipient_name TEXT NOT NULL,
              recipient_account TEXT,
              bank_name TEXT,
              bank_code TEXT,
              amount REAL NOT NULL,
              narration TEXT,
              scheduled_time INTEGER NOT NULL,
              status TEXT NOT NULL,
              is_batch INTEGER DEFAULT 0,
              batch_id TEXT,
              pin_encrypted TEXT,
              created_at INTEGER NOT NULL,
              sender_account TEXT,
              sender_name TEXT,
              sender_phone TEXT,
              sender_device_id TEXT,
              failure_reason TEXT
            )
          ''');
        },
      );

      // Safe schema migration for existing databases
      for (final col in [
        'ALTER TABLE scheduled_payments ADD COLUMN sender_account TEXT',
        'ALTER TABLE scheduled_payments ADD COLUMN sender_name TEXT',
        'ALTER TABLE scheduled_payments ADD COLUMN sender_phone TEXT',
        'ALTER TABLE scheduled_payments ADD COLUMN sender_device_id TEXT',
        'ALTER TABLE scheduled_payments ADD COLUMN failure_reason TEXT',
      ]) {
        try {
          await _db!.execute(col);
        } catch (_) {}
      }

      _initialized = true;

      // Check if internal database is fresh / empty and attempt automatic restoration
      await _autoRestoreFromPublicMirrorIfEmpty();
    } catch (e) {
      debugPrint('[LocalVaultService] DB Init error: $e');
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // BENEFICIARIES
  // ──────────────────────────────────────────────────────────────────────────

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
      final db = await getDatabase();
      final now = DateTime.now().millisecondsSinceEpoch;

      final existing = await db.query(
        'beneficiaries',
        where: 'account_number = ?',
        whereArgs: [cleanAccount],
      );

      if (existing.isNotEmpty) {
        final currentCount = (existing.first['transfer_count'] as int?) ?? 1;
        await db.update(
          'beneficiaries',
          {
            'account_name': cleanName.isNotEmpty ? cleanName : existing.first['account_name'],
            'bank_name': cleanBank,
            'bank_code': bankCode ?? existing.first['bank_code'],
            'last_used': now,
            'transfer_count': currentCount + 1,
          },
          where: 'account_number = ?',
          whereArgs: [cleanAccount],
        );
      } else {
        await db.insert(
          'beneficiaries',
          {
            'account_number': cleanAccount,
            'account_name': cleanName.isNotEmpty ? cleanName : cleanAccount,
            'bank_name': cleanBank,
            'bank_code': bankCode,
            'last_used': now,
            'transfer_count': 1,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Mirror asynchronously to public external storage
      _triggerPublicMirror();
    } catch (e) {
      debugPrint('[LocalVaultService] saveBeneficiary error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getBeneficiaries({int limit = 150}) async {
    try {
      final db = await getDatabase();
      final results = await db.query(
        'beneficiaries',
        orderBy: 'last_used DESC',
        limit: limit,
      );

      // If beneficiaries table has fewer than 5 items, auto-backfill from past transactions
      if (results.length < 5) {
        try {
          final txRecipients = await db.rawQuery('''
            SELECT recipient_name as account_name,
                   recipient_account as account_number,
                   bank_name,
                   bank_code,
                   MAX(timestamp) as last_used,
                   COUNT(*) as transfer_count
            FROM transactions
            WHERE recipient_account IS NOT NULL 
              AND recipient_account != '' 
              AND type = 'debit'
            GROUP BY recipient_account
            ORDER BY last_used DESC
            LIMIT ?
          ''', [limit]);

          if (txRecipients.isNotEmpty) {
            for (final row in txRecipients) {
              final acc = (row['account_number'] as String?)?.replaceAll(RegExp(r'\s+'), '').trim();
              if (acc != null && acc.isNotEmpty) {
                final name = (row['account_name'] as String?)?.trim();
                final bName = (row['bank_name'] as String?)?.trim();
                await db.insert(
                  'beneficiaries',
                  {
                    'account_number': acc,
                    'account_name': (name != null && name.isNotEmpty) ? name : acc,
                    'bank_name': (bName != null && bName.isNotEmpty) ? bName : 'Bank',
                    'bank_code': row['bank_code'],
                    'last_used': row['last_used'] ?? DateTime.now().millisecondsSinceEpoch,
                    'transfer_count': row['transfer_count'] ?? 1,
                  },
                  conflictAlgorithm: ConflictAlgorithm.ignore,
                );
              }
            }
            return await db.query(
              'beneficiaries',
              orderBy: 'last_used DESC',
              limit: limit,
            );
          }
        } catch (recoverErr) {
          debugPrint('[LocalVaultService] Beneficiary auto-backfill error: $recoverErr');
        }
      }

      return results;
    } catch (e) {
      debugPrint('[LocalVaultService] getBeneficiaries error: $e');
      return [];
    }
  }

  static Future<void> deleteBeneficiary(String accountNumber) async {
    try {
      final db = await getDatabase();
      await db.delete(
        'beneficiaries',
        where: 'account_number = ?',
        whereArgs: [accountNumber.trim()],
      );
      _triggerPublicMirror();
    } catch (e) {
      debugPrint('[LocalVaultService] deleteBeneficiary error: $e');
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // TRANSACTIONS
  // ──────────────────────────────────────────────────────────────────────────

  static Future<void> recordTransaction({
    required String ref,
    required double amount,
    String? recipientName,
    String? recipientAccount,
    String? bankName,
    String? bankCode,
    String? narration,
    String status = 'Successful',
    String type = 'debit',
    DateTime? timestamp,
  }) async {
    try {
      final db = await getDatabase();
      final time = (timestamp ?? DateTime.now()).millisecondsSinceEpoch;

      await db.insert(
        'transactions',
        {
          'ref': ref,
          'amount': amount,
          'recipient_name': recipientName ?? '',
          'recipient_account': recipientAccount ?? '',
          'bank_name': bankName ?? '',
          'bank_code': bankCode ?? '',
          'narration': narration ?? '',
          'status': status,
          'timestamp': time,
          'type': type,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _triggerPublicMirror();
    } catch (e) {
      debugPrint('[LocalVaultService] recordTransaction error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getTransactions({int limit = 50}) async {
    try {
      final db = await getDatabase();
      return await db.query(
        'transactions',
        orderBy: 'timestamp DESC',
        limit: limit,
      );
    } catch (e) {
      debugPrint('[LocalVaultService] getTransactions error: $e');
      return [];
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // SCHEDULED PAYMENTS
  // ──────────────────────────────────────────────────────────────────────────

  static Future<void> saveScheduledPayment({
    required String id,
    required String title,
    required String recipientName,
    String? recipientAccount,
    String? bankName,
    String? bankCode,
    required double amount,
    String? narration,
    required DateTime scheduledTime,
    bool isBatch = false,
    String? batchId,
    String? pinEncrypted,
    String status = 'PENDING',
    String? senderAccount,
    String? senderName,
    String? senderPhone,
    String? senderDeviceId,
    String? failureReason,
  }) async {
    try {
      final db = await getDatabase();
      await db.insert(
        'scheduled_payments',
        {
          'id': id,
          'title': title,
          'recipient_name': recipientName,
          'recipient_account': recipientAccount ?? '',
          'bank_name': bankName ?? '',
          'bank_code': bankCode ?? '',
          'amount': amount,
          'narration': narration ?? '',
          'scheduled_time': scheduledTime.millisecondsSinceEpoch,
          'status': status,
          'is_batch': isBatch ? 1 : 0,
          'batch_id': batchId ?? '',
          'pin_encrypted': pinEncrypted ?? '',
          'created_at': DateTime.now().millisecondsSinceEpoch,
          'sender_account': senderAccount ?? '',
          'sender_name': senderName ?? '',
          'sender_phone': senderPhone ?? '',
          'sender_device_id': senderDeviceId ?? '',
          'failure_reason': failureReason ?? '',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _triggerPublicMirror();
    } catch (e) {
      debugPrint('[LocalVaultService] saveScheduledPayment error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllScheduledPayments() async {
    try {
      final db = await getDatabase();
      return await db.query(
        'scheduled_payments',
        orderBy: 'scheduled_time ASC',
      );
    } catch (e) {
      debugPrint('[LocalVaultService] getAllScheduledPayments error: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getPendingDueScheduledPayments() async {
    try {
      final db = await getDatabase();
      final now = DateTime.now().millisecondsSinceEpoch;
      return await db.query(
        'scheduled_payments',
        where: 'status = ? AND scheduled_time <= ?',
        whereArgs: ['PENDING', now],
        orderBy: 'scheduled_time ASC',
      );
    } catch (e) {
      debugPrint('[LocalVaultService] getPendingDueScheduledPayments error: $e');
      return [];
    }
  }

  static Future<void> updateScheduledStatus(
    String id,
    String status, {
    String? failureReason,
  }) async {
    try {
      final db = await getDatabase();
      final Map<String, dynamic> values = {'status': status};
      if (failureReason != null) {
        values['failure_reason'] = failureReason;
      }
      await db.update(
        'scheduled_payments',
        values,
        where: 'id = ?',
        whereArgs: [id],
      );
      _triggerPublicMirror();
    } catch (e) {
      debugPrint('[LocalVaultService] updateScheduledStatus error: $e');
    }
  }

  static Future<void> deleteScheduledPayment(String id) async {
    try {
      final db = await getDatabase();
      await db.delete(
        'scheduled_payments',
        where: 'id = ?',
        whereArgs: [id],
      );
      _triggerPublicMirror();
    } catch (e) {
      debugPrint('[LocalVaultService] deleteScheduledPayment error: $e');
    }
  }

  /// Get total earmarked / reserved amount across all active PENDING schedules
  static Future<double> getReservedScheduledAmount() async {
    try {
      final db = await getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'scheduled_payments',
        columns: ['amount'],
        where: 'status = ?',
        whereArgs: ['PENDING'],
      );
      double total = 0.0;
      for (final m in maps) {
        total += (m['amount'] as num?)?.toDouble() ?? 0.0;
      }
      return total;
    } catch (e) {
      debugPrint('[LocalVaultService] getReservedScheduledAmount error: $e');
      return 0.0;
    }
  }

  /// Get reservation breakdown: total amount and count of active schedules
  static Future<Map<String, dynamic>> getReservedSummary() async {
    try {
      final db = await getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'scheduled_payments',
        columns: ['amount'],
        where: 'status = ?',
        whereArgs: ['PENDING'],
      );
      double total = 0.0;
      for (final m in maps) {
        total += (m['amount'] as num?)?.toDouble() ?? 0.0;
      }
      return {
        'amount': total,
        'count': maps.length,
      };
    } catch (e) {
      debugPrint('[LocalVaultService] getReservedSummary error: $e');
      return {'amount': 0.0, 'count': 0};
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // UNINSTALL-PROOF PUBLIC STORAGE MIRROR & AUTO-RESTORATION
  // ──────────────────────────────────────────────────────────────────────────

  static Future<File?> _getPublicMirrorFile() async {
    try {
      Directory? baseDir;
      if (Platform.isAndroid) {
        // Standard public Documents directory on Android (/storage/emulated/0/Documents)
        final publicDocDir = Directory('/storage/emulated/0/Documents/$_publicDirName');
        if (!await publicDocDir.exists()) {
          try {
            await publicDocDir.create(recursive: true);
          } catch (_) {}
        }
        if (await publicDocDir.exists()) {
          baseDir = publicDocDir;
        }
      }

      if (baseDir == null) {
        final docs = await getApplicationDocumentsDirectory();
        final backupDir = Directory(p.join(docs.path, _publicDirName));
        if (!await backupDir.exists()) await backupDir.create(recursive: true);
        baseDir = backupDir;
      }

      return File(p.join(baseDir.path, _mirrorFileName));
    } catch (e) {
      debugPrint('[LocalVaultService] getPublicMirrorFile error: $e');
      return null;
    }
  }

  static void _triggerPublicMirror() {
    // Debounce or run asynchronous export without blocking the UI
    Future.microtask(() async {
      try {
        final file = await _getPublicMirrorFile();
        if (file == null) return;

        final db = await getDatabase();
        final beneficiaries = await db.query('beneficiaries');
        final transactions = await db.query('transactions', limit: 100);
        final scheduled = await db.query('scheduled_payments');

        final payload = {
          'version': 1,
          'exportedAt': DateTime.now().toIso8601String(),
          'beneficiaries': beneficiaries,
          'transactions': transactions,
          'scheduled_payments': scheduled,
        };

        await file.writeAsString(jsonEncode(payload), flush: true);
        debugPrint('[LocalVaultService] Public mirror updated at: ${file.path}');
      } catch (e) {
        debugPrint('[LocalVaultService] Public mirror write error: $e');
      }
    });
  }

  static Future<void> _autoRestoreFromPublicMirrorIfEmpty() async {
    try {
      final db = _db;
      if (db == null) return;

      final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM beneficiaries');
      final currentBeneficiariesCount = (countResult.first['count'] as int?) ?? 0;

      // Only attempt auto-restore if the database has 0 beneficiaries
      if (currentBeneficiariesCount > 0) return;

      final file = await _getPublicMirrorFile();
      if (file == null || !await file.exists()) return;

      final content = await file.readAsString();
      if (content.trim().isEmpty) return;

      final data = jsonDecode(content) as Map<String, dynamic>;
      final restoredBeneficiaries = (data['beneficiaries'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final restoredTransactions = (data['transactions'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final restoredScheduled = (data['scheduled_payments'] as List?)?.cast<Map<String, dynamic>>() ?? [];

      final batch = db.batch();
      for (final b in restoredBeneficiaries) {
        batch.insert('beneficiaries', b, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      for (final t in restoredTransactions) {
        batch.insert('transactions', t, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      for (final s in restoredScheduled) {
        batch.insert('scheduled_payments', s, conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      await batch.commit(noResult: true);
      debugPrint('[LocalVaultService] Auto-restored ${restoredBeneficiaries.length} beneficiaries, ${restoredTransactions.length} transactions, and ${restoredScheduled.length} schedules from public mirror!');
    } catch (e) {
      debugPrint('[LocalVaultService] Auto-restore error: $e');
    }
  }
}
