import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/transaction_card/transaction_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/local_vault_service.dart';
import '/services/transaction_history_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'transaction_history_model.dart';
export 'transaction_history_model.dart';

enum _Period { days7, days30, days90, custom }

/// Brand colours used on this screen.
class _C {
  static const green = Color(0xFF00A651);
  static const ink = Color(0xFF111827);
  static const muted = Color(0xFF6B7280);
  static const line = Color(0xFFE5E7EB);
  static const bg = Color(0xFFF7F9F7);
  static const red = Color(0xFFDC2626);
}

/// The wallet API accepts at most 30 days per request.
const int _kWindowDays = 30;
const int _kMaxWindowsPerLoad = 12;

class TransactionHistoryWidget extends StatefulWidget {
  const TransactionHistoryWidget({
    super.key,
    required this.accountno,
    this.accountname,
  });

  final String? accountno;
  final String? accountname;

  static String routeName = 'TransactionHistory';
  static String routePath = '/transactionHistory';

  @override
  State<TransactionHistoryWidget> createState() =>
      _TransactionHistoryWidgetState();
}

class _TransactionHistoryWidgetState extends State<TransactionHistoryWidget> {
  late TransactionHistoryModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  final _money = NumberFormat('#,##0.00');

  // Raw server records for the loaded range (all windows, de-duplicated later).
  final List<dynamic> _server = [];
  List<TxEntry> _entries = [];

  late DateTime _from;
  late DateTime _to;
  _Period _period = _Period.days30;
  TxFilter _filter = TxFilter.all;
  String _query = '';

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  DateTime? _lastUpdated;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransactionHistoryModel());
    _setPeriod(_Period.days30, load: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _model.dispose();
    super.dispose();
  }

  // ─────────────────────────── data ───────────────────────────

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  static String _api(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  String _account() {
    final a = widget.accountno?.trim() ?? '';
    return a.isNotEmpty ? a : FFAppState().accountno.trim();
  }

  Future<String?> _token() async {
    final existing = FFAppState().bsptoken;
    if (existing.isNotEmpty) return existing;
    try {
      final auth = await StreetauthCall.call();
      final t = StreetauthCall.streettoken(auth.jsonBody);
      if (t != null && t.isNotEmpty) {
        FFAppState().bsptoken = t;
        return t;
      }
    } catch (_) {}
    return null;
  }

  /// Fetch one window (<= 30 days). Throws on failure so callers can report it.
  Future<List<dynamic>> _fetchWindow(
      String account, String token, DateTime from, DateTime to) async {
    final res = await WalletAsAServiceGroup.wallethistoryCall.call(
      authToken: token,
      accountno: account,
      fromdate: _api(from),
      todate: _api(to),
    );
    if (!res.succeeded) {
      throw Exception('HTTP ${res.statusCode}');
    }
    return WalletAsAServiceGroup.wallethistoryCall.message(res.jsonBody ?? '') ??
        const [];
  }

  Future<void> _rebuildEntries() async {
    List<Map<String, dynamic>> local = const [];
    try {
      local = await LocalVaultService.getTransactions(limit: 200);
    } catch (_) {}
    // Only keep unsynced local items that fall inside the visible range.
    final start = _from.millisecondsSinceEpoch;
    final end = _dateOnly(_to).add(const Duration(days: 1)).millisecondsSinceEpoch;
    local = local.where((t) {
      final ts = (t['timestamp'] as int?) ?? 0;
      return ts >= start && ts < end;
    }).toList();

    final entries = TransactionHistoryService.merge(_server, local);
    if (!mounted) return;
    setState(() => _entries = entries);

    // Home screen reads this for its "recent activity" strip.
    FFAppState().transactionhistory =
        entries.take(100).map((e) => e.raw).toList();
  }

  Future<void> _reload() async {
    final account = _account();
    if (account.isEmpty) {
      setState(() => _error = 'No account selected.');
      return;
    }
    final id = ++_requestId;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final token = await _token();
    if (token == null) {
      if (!mounted || id != _requestId) return;
      setState(() {
        _isLoading = false;
        _error = 'Your session has expired. Please log in again.';
      });
      return;
    }

    final fetched = <dynamic>[];
    var failed = 0;
    var cursor = _from;
    var windows = 0;
    while (!cursor.isAfter(_to) && windows < _kMaxWindowsPerLoad) {
      var end = cursor.add(const Duration(days: _kWindowDays - 1));
      if (end.isAfter(_to)) end = _to;
      try {
        fetched.addAll(await _fetchWindow(account, token, cursor, end));
      } catch (_) {
        failed++;
      }
      if (!mounted || id != _requestId) return; // a newer request took over
      cursor = end.add(const Duration(days: 1));
      windows++;
    }

    _server
      ..clear()
      ..addAll(fetched);
    await _rebuildEntries();
    if (!mounted || id != _requestId) return;
    setState(() {
      _isLoading = false;
      if (failed > 0) {
        _error = fetched.isEmpty
            ? "Couldn't load your transactions."
            : 'Some transactions could not be loaded.';
      } else {
        _lastUpdated = DateTime.now();
      }
    });
  }

  Future<void> _loadEarlier() async {
    if (_isLoadingMore || _isLoading) return;
    final account = _account();
    final token = await _token();
    if (account.isEmpty || token == null) return;

    setState(() => _isLoadingMore = true);
    final newFrom = _from.subtract(const Duration(days: _kWindowDays));
    final windowEnd = _from.subtract(const Duration(days: 1));
    try {
      final items = await _fetchWindow(account, token, newFrom, windowEnd);
      _server.addAll(items);
      _from = newFrom;
      _period = _Period.custom;
      await _rebuildEntries();
      if (mounted && items.isEmpty) {
        _toast('No activity between ${DateFormat('d MMM').format(newFrom)} and '
            '${DateFormat('d MMM yyyy').format(windowEnd)}.');
      }
    } catch (_) {
      _toast("Couldn't load earlier transactions. Try again.");
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _setPeriod(_Period p, {bool load = true}) {
    final today = _dateOnly(DateTime.now());
    final days = switch (p) {
      _Period.days7 => 7,
      _Period.days30 => 30,
      _Period.days90 => 90,
      _Period.custom => 0,
    };
    setState(() {
      _period = p;
      if (p != _Period.custom) {
        _to = today;
        _from = today.subtract(Duration(days: days));
      }
    });
    FFAppState().fromdate = _api(_from);
    FFAppState().todate = _api(_to);
    if (load) _reload();
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: DateTimeRange(start: _from, end: _to),
      helpText: 'Select period',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: _C.green,
                onPrimary: Colors.white,
              ),
        ),
        child: child!,
      ),
    );
    if (picked == null || !mounted) return;
    var from = _dateOnly(picked.start);
    final to = _dateOnly(picked.end);
    final maxSpan = _kWindowDays * _kMaxWindowsPerLoad;
    if (to.difference(from).inDays > maxSpan) {
      from = to.subtract(const Duration(days: 365));
      _toast('Showing the last 12 months of that range.');
    }
    setState(() {
      _from = from;
      _to = to;
    });
    _setPeriod(_Period.custom);
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  // ─────────────────────────── UI pieces ───────────────────────────

  String get _periodLabel {
    final f = DateFormat('d MMM');
    final fy = DateFormat('d MMM yyyy');
    return '${f.format(_from)} – ${fy.format(_to)}';
  }

  static const _filterLabels = {
    TxFilter.all: 'All',
    TxFilter.moneyIn: 'Money in',
    TxFilter.moneyOut: 'Money out',
    TxFilter.billsAirtime: 'Bills & airtime',
    TxFilter.issues: 'Failed & reversed',
  };

  Widget _pill({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    int? count,
    IconData? icon,
  }) {
    return Semantics(
      button: true,
      selected: selected,
      label: count == null ? label : '$label, $count',
      excludeSemantics: true,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? _C.green : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: selected ? _C.green : _C.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: selected ? Colors.white : _C.muted),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? Colors.white : const Color(0xFF374151),
                ),
              ),
              if (count != null && count > 0 && !selected) ...[
                const SizedBox(width: 6),
                Text(
                  '$count',
                  style: GoogleFonts.inter(
                      fontSize: 11, fontWeight: FontWeight.w700, color: _C.muted),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(TxTotals t) {
    Widget cell(String label, double v, Color color, IconData icon) => Expanded(
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: _C.muted, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text('₦${_money.format(v)}',
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w800, color: _C.ink)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_periodLabel,
              style: GoogleFonts.inter(
                  fontSize: 12, color: _C.muted, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            children: [
              cell('Money in', t.moneyIn, _C.green, Icons.south_west_rounded),
              const SizedBox(width: 12),
              cell('Money out', t.moneyOut, _C.ink, Icons.north_east_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      onChanged: (v) => setState(() => _query = v),
      textInputAction: TextInputAction.search,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Search name, amount or reference',
        hintStyle: GoogleFonts.inter(fontSize: 14, color: _C.muted),
        prefixIcon: const Icon(Icons.search_rounded, color: _C.muted),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                icon: const Icon(Icons.close_rounded, color: _C.muted),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _C.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _C.green, width: 1.5),
        ),
      ),
    );
  }

  Widget _periodRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _pill(label: '7 days', selected: _period == _Period.days7, onTap: () => _setPeriod(_Period.days7)),
          const SizedBox(width: 8),
          _pill(label: '30 days', selected: _period == _Period.days30, onTap: () => _setPeriod(_Period.days30)),
          const SizedBox(width: 8),
          _pill(label: '90 days', selected: _period == _Period.days90, onTap: () => _setPeriod(_Period.days90)),
          const SizedBox(width: 8),
          _pill(
            label: _period == _Period.custom ? _periodLabel : 'Custom',
            icon: Icons.calendar_today_rounded,
            selected: _period == _Period.custom,
            onTap: _pickCustomRange,
          ),
        ],
      ),
    );
  }

  Widget _filterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TxFilter.values.map((f) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _pill(
              label: _filterLabels[f]!,
              selected: _filter == f,
              count: f == TxFilter.all ? null : TransactionHistoryService.count(_entries, f),
              onTap: () => setState(() => _filter = f),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _errorBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: _C.red, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(_error!,
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF991B1B))),
          ),
          TextButton(
            onPressed: _isLoading ? null : _reload,
            child: Text('Retry',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: _C.red)),
          ),
        ],
      ),
    );
  }

  Widget _dayHeader(TxDayGroup g) {
    final net = g.net;
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8, left: 2, right: 2),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(g.label,
                  style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF374151))),
            ),
          ),
          if (net != 0)
            Text(
              '${net > 0 ? '+' : '−'}₦${_money.format(net.abs())}',
              style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600, color: _C.muted),
            ),
        ],
      ),
    );
  }

  Widget _skeleton() {
    return Column(
      children: List.generate(
        5,
        (_) => Container(
          height: 66,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.line),
          ),
        ),
      ),
    );
  }

  Widget _empty(bool filtered) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(color: _C.line, shape: BoxShape.circle),
            child: const Icon(Icons.receipt_long_outlined, size: 30, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 14),
          Text(filtered ? 'No matching transactions' : 'No transactions yet',
              style: GoogleFonts.inter(
                  fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF374151))),
          const SizedBox(height: 6),
          Text(
            filtered
                ? 'Try a different filter or search.'
                : 'Nothing was recorded between $_periodLabel.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 13, color: _C.muted),
          ),
          if (!filtered) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _isLoadingMore ? null : _loadEarlier,
              child: const Text('Look further back'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          if (_lastUpdated != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Updated ${DateFormat('h:mm a').format(_lastUpdated!)}',
                style: GoogleFonts.inter(fontSize: 11, color: _C.muted),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: _isLoadingMore ? null : _loadEarlier,
              icon: _isLoadingMore
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: _C.green))
                  : const Icon(Icons.history_rounded, size: 18, color: _C.green),
              label: Text('Load earlier transactions',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: _C.green)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _C.green),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── build ───────────────────────────

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final visible =
        TransactionHistoryService.apply(_entries, _filter, _query);
    final totals = TransactionHistoryService.totals(visible);
    final groups = TransactionHistoryService.groupByDay(visible);
    final isFiltered = _filter != TxFilter.all || _query.trim().isNotEmpty;

    // Flatten day headers and rows so a lazy builder can render them.
    final rows = <Object>[];
    for (final g in groups) {
      rows.add(g);
      rows.addAll(g.entries);
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _C.bg,
        appBar: AppBar(
          backgroundColor: _C.green,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 48.0,
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22.0),
            onPressed: () async => context.pop(),
          ),
          title: Text('Transactions',
              style: GoogleFonts.inter(
                  color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w700)),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Refresh',
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                  : const Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
              onPressed: _isLoading ? null : _reload,
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              RefreshIndicator(
                color: _C.green,
                onRefresh: _reload,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                  // header + body rows + footer
                  itemCount: 1 + (_isLoading && _entries.isEmpty ? 1 : (rows.isEmpty ? 1 : rows.length)) + (rows.isEmpty ? 0 : 1),
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _summaryCard(totals),
                          const SizedBox(height: 14),
                          _searchField(),
                          const SizedBox(height: 12),
                          _periodRow(),
                          const SizedBox(height: 10),
                          _filterRow(),
                          const SizedBox(height: 4),
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            _errorBanner(),
                          ],
                        ],
                      );
                    }
                    if (_isLoading && _entries.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: _skeleton(),
                      );
                    }
                    if (rows.isEmpty) {
                      return _error != null && _entries.isEmpty
                          ? const SizedBox.shrink()
                          : _empty(isFiltered);
                    }
                    if (i - 1 == rows.length) return _footer();
                    final row = rows[i - 1];
                    if (row is TxDayGroup) return _dayHeader(row);
                    final e = row as TxEntry;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TransactionCardWidget(
                        key: ValueKey(e.key),
                        credittitle: e.parsed.title,
                        creditsubtitle: e.parsed.dateString,
                        creditamount: e.parsed.isCredit ? e.parsed.amount.toString() : '',
                        debittitle: e.parsed.title,
                        debitamount: e.parsed.isCredit ? '' : e.parsed.amount.toString(),
                        debitsubtitle: e.parsed.dateString,
                        rawItem: e.raw,
                        compactSubtitle: true,
                      ),
                    );
                  },
                ),
              ),
              const BottomAppBarWidget(selectedIndex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
