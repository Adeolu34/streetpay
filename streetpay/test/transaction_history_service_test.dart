import 'package:flutter_test/flutter_test.dart';
import 'package:streetpay/services/transaction_history_service.dart';

Map<String, dynamic> srv(String ref, String date, String narration,
        {String credit = '', String debit = '', num amount = 0}) =>
    {
      'referenceID': ref,
      'transactionDateString': date,
      'narration': narration,
      'credit': credit,
      'debit': debit,
      'amount': amount,
    };

void main() {
  group('parseDate', () {
    test('reads common server formats', () {
      expect(TransactionHistoryService.parseDate('2026-11-20 14:05:09'),
          DateTime(2026, 11, 20, 14, 5, 9));
      expect(TransactionHistoryService.parseDate('20/11/2026 14:05'),
          DateTime(2026, 11, 20, 14, 5));
      expect(TransactionHistoryService.parseDate('Nov 20, 2026'),
          DateTime(2026, 11, 20));
      expect(TransactionHistoryService.parseDate('garbage'), isNull);
      expect(TransactionHistoryService.parseDate(''), isNull);
    });
  });

  group('merge', () {
    test('sorts newest first regardless of source order', () {
      final entries = TransactionHistoryService.merge([
        srv('A', '2026-11-01 09:00:00', 'x', debit: '100', amount: 100),
        srv('B', '2026-11-20 09:00:00', 'y', debit: '200', amount: 200),
        srv('C', '2026-11-10 09:00:00', 'z', debit: '300', amount: 300),
      ], []);
      expect(entries.map((e) => e.key), ['B', 'C', 'A']);
    });

    test('unsynced local item is placed by its date, not on top', () {
      final ts = DateTime(2026, 11, 5, 10).millisecondsSinceEpoch;
      final entries = TransactionHistoryService.merge([
        srv('A', '2026-11-01 09:00:00', 'x', debit: '100', amount: 100),
        srv('B', '2026-11-20 09:00:00', 'y', debit: '200', amount: 200),
      ], [
        {'ref': 'L1', 'amount': 750.0, 'timestamp': ts, 'type': 'debit'},
      ]);
      expect(entries.map((e) => e.key), ['B', 'L1', 'A']);
    });

    test('local copy of a server transaction is dropped (by ref)', () {
      final ts = DateTime(2026, 11, 20, 9).millisecondsSinceEpoch;
      final entries = TransactionHistoryService.merge([
        srv('B', '2026-11-20 09:00:00', 'y', debit: '200', amount: 200),
      ], [
        {'ref': 'B', 'amount': 200.0, 'timestamp': ts, 'type': 'debit'},
      ]);
      expect(entries.length, 1);
    });

    test('same-day same-amount transfers are NOT collapsed together', () {
      final ts = DateTime(2026, 11, 20, 9).millisecondsSinceEpoch;
      final entries = TransactionHistoryService.merge([
        srv('S1', '2026-11-20 09:00:00', 'Transfer', debit: '500', amount: 500),
      ], [
        // matches S1 by amount/day/direction -> absorbed
        {'ref': 'L1', 'amount': 500.0, 'timestamp': ts, 'type': 'debit'},
        // a second genuine transfer -> kept
        {'ref': 'L2', 'amount': 500.0, 'timestamp': ts, 'type': 'debit'},
      ]);
      expect(entries.length, 2);
      expect(entries.where((e) => e.isLocal).length, 1);
    });

    test('duplicate server records are removed', () {
      final entries = TransactionHistoryService.merge([
        srv('A', '2026-11-01 09:00:00', 'x', debit: '100', amount: 100),
        srv('A', '2026-11-01 09:00:00', 'x', debit: '100', amount: 100),
      ], []);
      expect(entries.length, 1);
    });

    test('undated items go last in original order', () {
      final entries = TransactionHistoryService.merge([
        srv('N1', '', 'a', debit: '1', amount: 1),
        srv('D', '2026-11-01 09:00:00', 'b', debit: '2', amount: 2),
        srv('N2', '', 'c', debit: '3', amount: 3),
      ], []);
      expect(entries.map((e) => e.key), ['D', 'N1', 'N2']);
    });
  });

  group('totals / filters / groups', () {
    final entries = TransactionHistoryService.merge([
      srv('IN', '2026-11-20 09:00:00', '/JOHN DOE/transfer', credit: '1,000.00', amount: 1000),
      srv('OUT', '2026-11-20 10:00:00', 'Transfer to Ade', debit: '400.00', amount: 400),
      srv('REF', '2026-11-19 10:00:00', 'REV: Transfer to Ade', credit: '400.00', amount: 400),
      srv('AIR', '2026-11-19 08:00:00', 'MTN AIRTIME 08031234567', debit: '200.00', amount: 200),
    ], []);

    test('refunds are not counted as money in', () {
      final t = TransactionHistoryService.totals(entries);
      expect(t.moneyIn, 1000);
      expect(t.moneyOut, 600);
    });

    test('filters', () {
      expect(
          TransactionHistoryService.apply(entries, TxFilter.billsAirtime, '')
              .map((e) => e.key),
          ['AIR']);
      expect(
          TransactionHistoryService.apply(entries, TxFilter.issues, '')
              .map((e) => e.key),
          ['REF']);
      expect(TransactionHistoryService.apply(entries, TxFilter.all, 'out').length, 1);
    });

    test('groups by day with labels', () {
      final groups = TransactionHistoryService.groupByDay(entries,
          now: DateTime(2026, 11, 21, 12));
      expect(groups.map((g) => g.label), ['Yesterday', 'Thu, 19 Nov']);
      expect(groups.first.entries.length, 2);
    });
  });
}
