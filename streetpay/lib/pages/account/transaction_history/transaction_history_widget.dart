import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/overview_card/overview_card_widget.dart';
import '/components/overview_carddebit/overview_carddebit_widget.dart';
import '/components/transaction_card/transaction_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'transaction_history_model.dart';
export 'transaction_history_model.dart';

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

  bool _isLoading = false;
  int _selectedFilterIndex = 1; // 0: 7 Days, 1: 30 Days, 2: Custom

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransactionHistoryModel());

    // Default dates: last 30 days
    _model.datePicked1 = DateTime.now().subtract(const Duration(days: 30));
    _model.datePicked2 = DateTime.now();

    FFAppState().fromdate = DateFormat('yyyy-MM-dd').format(_model.datePicked1!);
    FFAppState().todate = DateFormat('yyyy-MM-dd').format(_model.datePicked2!);

    // Fetch initial 30 days history once on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTransactions(
        fromDate: FFAppState().fromdate,
        toDate: FFAppState().todate,
      );
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _getEffectiveAccountNo() {
    if (widget.accountno != null && widget.accountno!.trim().isNotEmpty) {
      return widget.accountno!.trim();
    }
    return FFAppState().accountno.trim();
  }

  Future<void> _fetchTransactions({
    required String fromDate,
    required String toDate,
  }) async {
    final account = _getEffectiveAccountNo();
    if (account.isEmpty) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final token = FFAppState().bsptoken.isNotEmpty
          ? FFAppState().bsptoken
          : 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJQYXlzcDEwMTAkaS5pIiwiaWF0IjoxNzcxNzk1NDgwLCJleHAiOjE3NzUzOTU0ODB9.z3jZyAUV1kOvQKD-Y7eXbMi2yhZNtuFObnWc63JoR7w';

      final res = await WalletAsAServiceGroup.wallethistoryCall.call(
        authToken: token,
        accountno: account,
        fromdate: fromDate,
        todate: toDate,
      );

      if (!mounted) return;

      final historyData =
          WalletAsAServiceGroup.wallethistoryCall.message(res.jsonBody ?? '');
      if (historyData != null) {
        FFAppState().transactionhistory = historyData.toList().cast<dynamic>();
      } else {
        FFAppState().transactionhistory = [];
      }
    } catch (e) {
      // Silently handle or keep current data
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyQuickFilter(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedFilterIndex = index;
    });

    final now = DateTime.now();
    if (index == 0) {
      // 7 Days
      _model.datePicked1 = now.subtract(const Duration(days: 7));
      _model.datePicked2 = now;
    } else if (index == 1) {
      // 30 Days
      _model.datePicked1 = now.subtract(const Duration(days: 30));
      _model.datePicked2 = now;
    }

    if (index == 0 || index == 1) {
      final fromStr = DateFormat('yyyy-MM-dd').format(_model.datePicked1!);
      final toStr = DateFormat('yyyy-MM-dd').format(_model.datePicked2!);
      FFAppState().fromdate = fromStr;
      FFAppState().todate = toStr;
      _fetchTransactions(fromDate: fromStr, toDate: toStr);
    }
  }

  Future<void> _selectFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _model.datePicked1 ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return wrapInMaterialDatePickerTheme(
          context,
          child!,
          headerBackgroundColor: const Color(0xFF00A651),
          headerForegroundColor: Colors.white,
          headerTextStyle: GoogleFonts.inter(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          pickerBackgroundColor: Colors.white,
          pickerForegroundColor: const Color(0xFF1F2937),
          selectedDateTimeBackgroundColor: const Color(0xFF00A651),
          selectedDateTimeForegroundColor: Colors.white,
          actionButtonForegroundColor: const Color(0xFF00A651),
          iconSize: 24.0,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _model.datePicked1 = picked;
        _selectedFilterIndex = 2; // Custom
      });
      FFAppState().fromdate = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _model.datePicked2 ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return wrapInMaterialDatePickerTheme(
          context,
          child!,
          headerBackgroundColor: const Color(0xFF00A651),
          headerForegroundColor: Colors.white,
          headerTextStyle: GoogleFonts.inter(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          pickerBackgroundColor: Colors.white,
          pickerForegroundColor: const Color(0xFF1F2937),
          selectedDateTimeBackgroundColor: const Color(0xFF00A651),
          selectedDateTimeForegroundColor: Colors.white,
          actionButtonForegroundColor: const Color(0xFF00A651),
          iconSize: 24.0,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _model.datePicked2 = picked;
        _selectedFilterIndex = 2; // Custom
      });
      FFAppState().todate = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _onSearchPressed() {
    HapticFeedback.lightImpact();
    if (_model.datePicked1 == null || _model.datePicked2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both From and To dates.'),
          backgroundColor: Color(0xFFE53935),
        ),
      );
      return;
    }

    if (_model.datePicked1!.isAfter(_model.datePicked2!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('"From Date" cannot be after "To Date".'),
          backgroundColor: Color(0xFFE53935),
        ),
      );
      return;
    }

    final diff = _model.datePicked2!.difference(_model.datePicked1!).inDays;
    if (diff > 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Date range must be within 30 days.'),
          backgroundColor: Color(0xFFE53935),
        ),
      );
      return;
    }

    final fromStr = DateFormat('yyyy-MM-dd').format(_model.datePicked1!);
    final toStr = DateFormat('yyyy-MM-dd').format(_model.datePicked2!);
    FFAppState().fromdate = fromStr;
    FFAppState().todate = toStr;

    _fetchTransactions(fromDate: fromStr, toDate: toStr);
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilterIndex == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _applyQuickFilter(index),
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00A651) : Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: isSelected ? const Color(0xFF00A651) : const Color(0xFFE5E7EB),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF4B5563),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      children: List.generate(4, (index) {
        return Container(
          width: double.infinity,
          height: 68.0,
          margin: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(11.0),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 130.0,
                      height: 14.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Container(
                      width: 80.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Container(
                    width: 45.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final translist = FFAppState().transactionhistory.toList();

    // Compute totals safely
    final creditStrings = translist
        .map((e) => getJsonField(e, r'''$.credit''')?.toString() ?? '')
        .toList();
    final totalCredit = functions.sumalltran(creditStrings);

    final debitStrings = translist
        .map((e) => getJsonField(e, r'''$.debit''')?.toString() ?? '')
        .toList();
    final totalDebit = functions.sumalltran(debitStrings);

    final fromDateLabel = _model.datePicked1 != null
        ? DateFormat('MMM dd, yyyy').format(_model.datePicked1!)
        : 'From Date';
    final toDateLabel = _model.datePicked2 != null
        ? DateFormat('MMM dd, yyyy').format(_model.datePicked2!)
        : 'To Date';

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF7F9F7),
        appBar: AppBar(
          backgroundColor: const Color(0xFF00A651),
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 48.0,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 22.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Transactions',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: _isLoading
                  ? const SizedBox(
                      width: 18.0,
                      height: 18.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.refresh_rounded, color: Colors.white, size: 22.0),
              onPressed: _isLoading
                  ? null
                  : () {
                      final fromStr = _model.datePicked1 != null
                          ? DateFormat('yyyy-MM-dd').format(_model.datePicked1!)
                          : functions.subtractDaysFromToday(30);
                      final toStr = _model.datePicked2 != null
                          ? DateFormat('yyyy-MM-dd').format(_model.datePicked2!)
                          : DateFormat('yyyy-MM-dd').format(DateTime.now());
                      _fetchTransactions(fromDate: fromStr, toDate: toStr);
                    },
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              RefreshIndicator(
                color: const Color(0xFF00A651),
                onRefresh: () async {
                  final fromStr = _model.datePicked1 != null
                      ? DateFormat('yyyy-MM-dd').format(_model.datePicked1!)
                      : functions.subtractDaysFromToday(30);
                  final toStr = _model.datePicked2 != null
                      ? DateFormat('yyyy-MM-dd').format(_model.datePicked2!)
                      : DateFormat('yyyy-MM-dd').format(DateTime.now());
                  await _fetchTransactions(fromDate: fromStr, toDate: toStr);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                    bottom: 100.0, // Space for BottomAppBar
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Overview Cards (Incoming & Outgoing totals)
                      Row(
                        children: [
                          Expanded(
                            child: OverviewCardWidget(
                              totalAmount: totalCredit,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: OverviewCarddebitWidget(
                              totalAmount: totalDebit,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      // Filter Section Header & Quick Chips
                      Row(
                        children: [
                          Text(
                            'Period',
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          const Spacer(),
                          _buildFilterChip('7 Days', 0),
                          const SizedBox(width: 8.0),
                          _buildFilterChip('30 Days', 1),
                        ],
                      ),
                      const SizedBox(height: 12.0),

                      // Date Pickers and Search Button Row
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // From Date
                                Expanded(
                                  child: InkWell(
                                    onTap: _selectFromDate,
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                        vertical: 9.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(color: const Color(0xFFD1D5DB)),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_rounded,
                                            size: 15.0,
                                            color: Color(0xFF00A651),
                                          ),
                                          const SizedBox(width: 6.0),
                                          Expanded(
                                            child: Text(
                                              fromDateLabel,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF1F2937),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                                  child: Text('–', style: TextStyle(color: Color(0xFF9CA3AF), fontWeight: FontWeight.bold)),
                                ),
                                // To Date
                                Expanded(
                                  child: InkWell(
                                    onTap: _selectToDate,
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                        vertical: 9.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(color: const Color(0xFFD1D5DB)),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_rounded,
                                            size: 15.0,
                                            color: Color(0xFF00A651),
                                          ),
                                          const SizedBox(width: 6.0),
                                          Expanded(
                                            child: Text(
                                              toDateLabel,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF1F2937),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            SizedBox(
                              width: double.infinity,
                              height: 38.0,
                              child: ElevatedButton.icon(
                                onPressed: _isLoading ? null : _onSearchPressed,
                                icon: const Icon(Icons.search_rounded, size: 17.0, color: Colors.white),
                                label: Text(
                                  'Filter Range',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00A651),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Section Title: History
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Activity History',
                            style: GoogleFonts.inter(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF111827),
                            ),
                          ),
                          if (!_isLoading && translist.isNotEmpty)
                            Text(
                              '${translist.length} transactions',
                              style: GoogleFonts.inter(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12.0),

                      // Transactions List State
                      if (_isLoading)
                        _buildLoadingSkeleton()
                      else if (translist.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 64.0,
                                  height: 64.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE5E7EB),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.receipt_long_outlined,
                                    size: 32.0,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                                const SizedBox(height: 14.0),
                                Text(
                                  'No Transactions Found',
                                  style: GoogleFonts.inter(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF374151),
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  'No activity recorded for the selected period.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: translist.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                          itemBuilder: (context, index) {
                            final item = translist[index];
                            final narration = getJsonField(
                                  item,
                                  r'''$.narration''',
                                )?.toString() ??
                                '';
                            final dateStr = getJsonField(
                                  item,
                                  r'''$.transactionDateString''',
                                )?.toString() ??
                                '';
                            final credit = getJsonField(
                                  item,
                                  r'''$.credit''',
                                )?.toString() ??
                                '';
                            final debit = getJsonField(
                                  item,
                                  r'''$.debit''',
                                )?.toString() ??
                                '';

                            final cleanTitle = functions
                                .processTransactionNarration(narration);

                            return TransactionCardWidget(
                              key: ValueKey('tx_${index}_${dateStr}_$credit$debit'),
                              credittitle: cleanTitle,
                              creditsubtitle: dateStr,
                              creditamount: credit,
                              debittitle: cleanTitle,
                              debitamount: debit,
                              debitsubtitle: dateStr,
                              rawItem: item,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // Fixed Bottom Navigation Bar (Activity tab selected = index 3)
              const BottomAppBarWidget(selectedIndex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
