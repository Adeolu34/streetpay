import 'package:intl/intl.dart';

import '/flutter_flow/flutter_flow_util.dart' show getJsonField;
import '/services/transaction_parser_service.dart';

/// One transaction ready for display. Parsed once, when it is loaded, instead
/// of on every rebuild.
class TxEntry {
  const TxEntry({
    required this.raw,
    required this.parsed,
    required this.date,
    required this.isLocal,
    required this.key,
  });

  final dynamic raw;
  final ParsedTransaction parsed;
  final DateTime? date;
  final bool isLocal;
  final String key;

  bool get isFailed => parsed.status == 'Failed';

  /// Money that really moved into the wallet (refunds of reversed payments and
  /// failed items are not new income).
  bool get countsAsIn => parsed.isCredit && !parsed.isReversalCredit && !isFailed;

  /// Money that really left the wallet (reversed and failed debits did not).
  bool get countsAsOut => !parsed.isCredit && !parsed.isReversed && !isFailed;
}

class TxDayGroup {
  TxDayGroup(this.day, this.label);

  final DateTime? day;
  final String label;
  final List<TxEntry> entries = [];

  double get net {
    var sum = 0.0;
    for (final e in entries) {
      if (e.countsAsIn) sum += e.parsed.amount;
      if (e.countsAsOut) sum -= e.parsed.amount;
    }
    return sum;
  }
}

enum TxFilter { all, moneyIn, moneyOut, billsAirtime, issues }

class TxTotals {
  const TxTotals(this.moneyIn, this.moneyOut);
  final double moneyIn;
  final double moneyOut;
}

class TransactionHistoryService {
  TransactionHistoryService._();

  static final List<DateFormat> _formats = [
    DateFormat('yyyy-MM-dd HH:mm:ss'),
    DateFormat('yyyy-MM-dd HH:mm'),
    DateFormat('dd/MM/yyyy HH:mm:ss'),
    DateFormat('dd/MM/yyyy HH:mm'),
    DateFormat('dd/MM/yyyy'),
    DateFormat('dd-MM-yyyy HH:mm:ss'),
    DateFormat('dd-MM-yyyy'),
    DateFormat('MMM dd, yyyy HH:mm:ss'),
    DateFormat('MMM dd, yyyy'),
    DateFormat('dd MMM yyyy HH:mm:ss'),
    DateFormat('dd MMM yyyy'),
  ];

  /// Tolerant date parser. Returns null when the string is unreadable.
  static DateTime? parseDate(String? input) {
    if (input == null) return null;
    final s = input.trim();
    if (s.isEmpty) return null;
    final iso = DateTime.tryParse(s.contains(' ') && !s.contains('T') ? s.replaceFirst(' ', 'T') : s);
    if (iso != null) return iso;
    for (final f in _formats) {
      try {
        return f.parseStrict(s);
      } catch (_) {}
    }
    return null;
  }

  static String _s(dynamic item, String path) =>
      (getJsonField(item, path)?.toString() ?? '').trim();

  static Set<String> _refsOf(dynamic item) => {
        _s(item, r'$.referenceID'),
        _s(item, r'$.uniqueIdentifier'),
        _s(item, r'$.reference'),
        _s(item, r'$.paymentReference'),
      }..remove('');

  static String _dayKey(DateTime? d) =>
      d == null ? 'unknown' : DateFormat('yyyy-MM-dd').format(d);

  /// Build the raw map used for an unsynced local transaction.
  static Map<String, dynamic> localToRaw(Map<String, dynamic> t) {
    final ref = (t['ref'] ?? '').toString().trim();
    final amt = (t['amount'] as num?)?.toDouble() ?? 0.0;
    final ts = (t['timestamp'] as int?) ?? DateTime.now().millisecondsSinceEpoch;
    final dt = DateTime.fromMillisecondsSinceEpoch(ts);
    final isCredit = t['type'] == 'credit';
    String clean(dynamic v) {
      final x = v?.toString().trim() ?? '';
      return x == '-' ? '' : x;
    }

    final narr = clean(t['narration']);
    final recipient = clean(t['recipient_name']);
    final title = narr.isNotEmpty
        ? narr
        : recipient.isNotEmpty
            ? (isCredit ? 'Transfer from $recipient' : 'Transfer to $recipient')
            : (isCredit ? 'Incoming Transfer' : 'Transfer Out');
    final amtStr = amt.toStringAsFixed(2);
    return {
      'reference': ref,
      'referenceID': ref,
      'uniqueIdentifier': ref,
      'narration': title,
      'recipient_name': recipient,
      'transactionDateString': DateFormat('yyyy-MM-dd HH:mm:ss').format(dt),
      'credit': isCredit ? amtStr : '',
      'debit': isCredit ? '' : amtStr,
      'amount': amt,
      'status': t['status'] ?? 'Successful',
      'type': isCredit ? 'credit' : 'debit',
      'isLocal': true,
      'timestamp': ts,
    };
  }

  /// Merge server and local items, drop duplicates and sort newest first.
  ///
  /// Server records are authoritative. A local record is dropped when its
  /// reference matches a server record, or when it matches a server record on
  /// amount + day + direction. Each server record can absorb only ONE local
  /// record, so two genuine same-day transfers of the same amount are kept.
  static List<TxEntry> merge(List<dynamic> server, List<Map<String, dynamic>> local) {
    final entries = <TxEntry>[];
    final seenRefs = <String>{};
    final unmatchedSigs = <String, int>{};

    for (final item in server) {
      final refs = _refsOf(item);
      if (refs.isNotEmpty && refs.any(seenRefs.contains)) continue;
      seenRefs.addAll(refs);
      final parsed = TransactionParserService.parse(item);
      final date = parseDate(parsed.dateString);
      final sig = '${parsed.amount.toStringAsFixed(2)}|${_dayKey(date)}|${parsed.isCredit}';
      unmatchedSigs[sig] = (unmatchedSigs[sig] ?? 0) + 1;
      entries.add(TxEntry(
        raw: item,
        parsed: parsed,
        date: date,
        isLocal: false,
        key: refs.isNotEmpty ? refs.first : 'srv_${entries.length}',
      ));
    }

    for (final t in local) {
      final raw = localToRaw(t);
      final refs = _refsOf(raw);
      if (refs.any(seenRefs.contains)) continue;
      final parsed = TransactionParserService.parse(raw);
      final date = parseDate(parsed.dateString);
      final sig = '${parsed.amount.toStringAsFixed(2)}|${_dayKey(date)}|${parsed.isCredit}';
      final available = unmatchedSigs[sig] ?? 0;
      if (available > 0) {
        unmatchedSigs[sig] = available - 1; // consumed by this local copy
        continue;
      }
      seenRefs.addAll(refs);
      entries.add(TxEntry(
        raw: raw,
        parsed: parsed,
        date: date,
        isLocal: true,
        key: refs.isNotEmpty ? refs.first : 'loc_${entries.length}',
      ));
    }

    return sorted(entries);
  }

  /// Newest first. Undated items go last, keeping their original order.
  static List<TxEntry> sorted(List<TxEntry> list) {
    final indexed = list.asMap().entries.toList();
    indexed.sort((a, b) {
      final da = a.value.date;
      final db = b.value.date;
      if (da == null && db == null) return a.key.compareTo(b.key);
      if (da == null) return 1;
      if (db == null) return -1;
      final c = db.compareTo(da);
      return c != 0 ? c : a.key.compareTo(b.key);
    });
    return indexed.map((e) => e.value).toList();
  }

  static bool matches(TxEntry e, TxFilter filter) {
    final p = e.parsed;
    switch (filter) {
      case TxFilter.all:
        return true;
      case TxFilter.moneyIn:
        return p.isCredit && !p.isReversalCredit && !e.isFailed;
      case TxFilter.moneyOut:
        return !p.isCredit && !p.isReversed && !e.isFailed;
      case TxFilter.billsAirtime:
        return const {'airtime', 'data', 'bill_payment', 'electricity'}
            .contains(p.category);
      case TxFilter.issues:
        return e.isFailed || p.isReversed || p.isReversalCredit || p.category == 'reversal';
    }
  }

  static List<TxEntry> apply(List<TxEntry> all, TxFilter filter, String query) {
    final q = query.trim().toLowerCase();
    return all.where((e) {
      if (!matches(e, filter)) return false;
      if (q.isEmpty) return true;
      final p = e.parsed;
      return p.title.toLowerCase().contains(q) ||
          p.rawNarration.toLowerCase().contains(q) ||
          p.reference.toLowerCase().contains(q) ||
          p.amount.toStringAsFixed(2).contains(q.replaceAll(',', ''));
    }).toList();
  }

  static TxTotals totals(List<TxEntry> list) {
    var inn = 0.0, out = 0.0;
    for (final e in list) {
      if (e.countsAsIn) inn += e.parsed.amount;
      if (e.countsAsOut) out += e.parsed.amount;
    }
    return TxTotals(inn, out);
  }

  static int count(List<TxEntry> all, TxFilter filter) =>
      filter == TxFilter.all ? all.length : all.where((e) => matches(e, filter)).length;

  static String dayLabel(DateTime? d, {DateTime? now}) {
    if (d == null) return 'Date unavailable';
    final today = now ?? DateTime.now();
    final a = DateTime(today.year, today.month, today.day);
    final b = DateTime(d.year, d.month, d.day);
    final diff = a.difference(b).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    final fmt = d.year == today.year ? 'EEE, d MMM' : 'EEE, d MMM yyyy';
    return DateFormat(fmt).format(d);
  }

  /// Entries must already be sorted. Groups consecutive items by calendar day.
  static List<TxDayGroup> groupByDay(List<TxEntry> sortedEntries, {DateTime? now}) {
    final groups = <TxDayGroup>[];
    String? lastKey;
    for (final e in sortedEntries) {
      final k = _dayKey(e.date);
      if (k != lastKey) {
        final d = e.date == null ? null : DateTime(e.date!.year, e.date!.month, e.date!.day);
        groups.add(TxDayGroup(d, dayLabel(e.date, now: now)));
        lastKey = k;
      }
      groups.last.entries.add(e);
    }
    return groups;
  }
}
