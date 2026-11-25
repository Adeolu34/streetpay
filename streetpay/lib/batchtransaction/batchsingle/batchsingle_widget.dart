import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/batch_payout_service.dart';
import '/services/account_lookup_service.dart';
import '/services/bank_detection_service.dart';
import '/services/bank_logo_service.dart';
import '/services/scheduled_payment_service.dart';
import '/pages/payments/scheduled_payments/scheduled_payments_widget.dart';
import 'batchsingle_model.dart';
export 'batchsingle_model.dart';

class BatchsingleWidget extends StatefulWidget {
  const BatchsingleWidget({
    super.key,
    this.batchId,
  });

  final String? batchId;

  static String routeName = 'batchsingle';
  static String routePath = '/batchsingle';

  @override
  State<BatchsingleWidget> createState() => _BatchsingleWidgetState();
}

class _BatchsingleWidgetState extends State<BatchsingleWidget> {
  late BatchsingleModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  BatchGroup? _batch;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BatchsingleModel());
    _loadBatch();
  }

  Future<void> _loadBatch() async {
    setState(() => _isLoading = true);
    final batches = await BatchPayoutService.getBatches();

    BatchGroup? found;
    if (widget.batchId != null && widget.batchId!.isNotEmpty) {
      try {
        found = batches.firstWhere((b) => b.id == widget.batchId);
      } catch (_) {}
    }

    if (found == null && batches.isNotEmpty) {
      found = batches.first;
    }

    if (mounted) {
      setState(() {
        _batch = found;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Edit Individual Beneficiary Amount
  // ──────────────────────────────────────────────────────────────────────────
  void _editBeneficiaryAmount(BatchBeneficiary ben) {
    final controller = TextEditingController(
      text: ben.amount > 0 ? ben.amount.toStringAsFixed(0) : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD0D7D2),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 18.0),
              Text(
                'Set Payout Amount',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF0B2018),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Enter amount to disburse to ${ben.accountName} (${ben.bankName})',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF6B7F72),
                  fontSize: 13.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'AMOUNT (₦)',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF8FA596),
                  fontSize: 11.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF0B2018),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  prefixText: '₦ ',
                  prefixStyle: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF2F8F3C),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                  hintText: '0',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF9AA79E),
                    fontSize: 20.0,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF6F8F6),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 14.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide:
                        const BorderSide(color: Color(0xFF2F8F3C), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 14.0),
              Wrap(
                spacing: 8.0,
                children: [5000, 10000, 20000, 50000, 100000].map((quickAmt) {
                  return ActionChip(
                    label: Text(
                      '₦${formatNumber(quickAmt, formatType: FormatType.decimal, decimalType: DecimalType.automatic)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2F8F3C),
                      ),
                    ),
                    backgroundColor: const Color(0xFFEDF7EE),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      controller.text = quickAmt.toString();
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () async {
                    final text = controller.text.trim();
                    final parsed = double.tryParse(text) ?? 0.0;
                    if (_batch != null) {
                      await BatchPayoutService.updateBeneficiaryAmount(
                        batchId: _batch!.id,
                        beneficiaryId: ben.id,
                        newAmount: parsed,
                      );
                      Navigator.pop(ctx);
                      _loadBatch();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B2018),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  child: Text(
                    'Save Amount',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Delete Beneficiary from Batch
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> _confirmDeleteBeneficiary(BatchBeneficiary ben) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFDC2626),
                size: 20.0,
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                'Remove Beneficiary?',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF0B2018),
                  fontSize: 17.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Remove ${ben.accountName} (${ben.accountNumber}) from "${_batch?.name}"?',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF6B7F72),
            fontSize: 13.5,
          ),
        ),
        actionsPadding:
            const EdgeInsets.only(right: 16.0, bottom: 16.0, top: 4.0),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF6B7F72),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(
              'Remove',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && _batch != null) {
      await BatchPayoutService.removeBeneficiary(
        batchId: _batch!.id,
        beneficiaryId: ben.id,
      );
      await _loadBatch();
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Add Beneficiary to Batch Bottom Sheet
  // ──────────────────────────────────────────────────────────────────────────
  void _showAddBeneficiarySheet() {
    if (_batch == null) return;

    final acctController = TextEditingController();
    final amountController = TextEditingController();

    String selectedBankName = '';
    String selectedBankCode = '';
    String resolvedName = '';
    bool isResolving = false;
    String? resolveError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          Future<void> resolveAccount() async {
            final acct = acctController.text.trim();
            if (acct.length != 10 || selectedBankCode.isEmpty) return;

            setSheetState(() {
              isResolving = true;
              resolveError = null;
              resolvedName = '';
            });

            try {
              final name = await AccountLookupService.resolveAccountName(
                accountNumber: acct,
                bankCode: selectedBankCode,
              );

              setSheetState(() {
                isResolving = false;
                if (name != null && name.trim().isNotEmpty) {
                  resolvedName = name.trim();
                } else {
                  resolveError =
                      'Could not resolve account name. Verify bank and account number.';
                }
              });
            } catch (e) {
              setSheetState(() {
                isResolving = false;
                resolveError = 'Lookup failed: $e';
              });
            }
          }

          void onAccountNumberChanged(String val) {
            final clean = val.trim();
            if (clean.length == 10 && selectedBankCode.isEmpty) {
              // Try auto-detecting bank via BankDetectionService
              final candidates = BankDetectionService.predictCandidateBanks(clean);
              if (candidates.isNotEmpty) {
                selectedBankName = candidates.first.name;
                selectedBankCode = BatchPayoutService.resolveBankCode(
                  bankCode: candidates.first.code,
                  bankName: candidates.first.name,
                );
                setSheetState(() {});
                resolveAccount();
                return;
              }
            }

            if (clean.length == 10 && selectedBankCode.isNotEmpty) {
              resolveAccount();
            } else if (clean.length < 10) {
              setSheetState(() {
                resolvedName = '';
                resolveError = null;
              });
            }
          }

          void openBankPicker() {
            final allBanks = BankDetectionService.getAllSupportedBankNames(
              dynamicBankNames: FFAppState().bankname,
            );
            showModalBottomSheet(
              context: ctx,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (pickerCtx) {
                String search = '';
                return StatefulBuilder(
                  builder: (context, setPickerState) {
                    final filtered = search.trim().isEmpty
                        ? allBanks
                        : allBanks
                            .where((b) => b
                                .toLowerCase()
                                .contains(search.trim().toLowerCase()))
                            .toList();

                    return Container(
                      height: MediaQuery.of(pickerCtx).size.height * 0.75,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24.0)),
                      ),
                      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 24.0),
                      child: Column(
                        children: [
                          Container(
                            width: 40.0,
                            height: 4.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD0D7D2),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select Bank',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF0B2018),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded,
                                    color: Color(0xFF8FA596)),
                                onPressed: () => Navigator.pop(pickerCtx),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          TextField(
                            onChanged: (val) =>
                                setPickerState(() => search = val),
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF0B2018),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search Bank (e.g. OPay, GTBank, Access)...',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF9AA79E),
                                fontSize: 13.5,
                              ),
                              prefixIcon: const Icon(Icons.search_rounded,
                                  color: Color(0xFF8FA596), size: 20.0),
                              filled: true,
                              fillColor: const Color(0xFFF6F8F6),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 12.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    color: Color(0xFFE6EAE7)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    color: Color(0xFFE6EAE7)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    color: Color(0xFF2F8F3C), width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Expanded(
                            child: ListView.separated(
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1, color: Color(0xFFF0F3F1)),
                              itemBuilder: (context, idx) {
                                final bName = filtered[idx];
                                final bCode = BatchPayoutService.resolveBankCode(
                                  bankCode: '',
                                  bankName: bName,
                                );
                                final isSelected = selectedBankName == bName;

                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  leading: BankLogoWidget(
                                    bankName: bName,
                                    bankCode: bCode,
                                    size: 36.0,
                                  ),
                                  title: Text(
                                    bName,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: isSelected
                                          ? const Color(0xFF2F8F3C)
                                          : const Color(0xFF0B2018),
                                      fontSize: 14.0,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? const Icon(Icons.check_circle_rounded,
                                          color: Color(0xFF2F8F3C), size: 20.0)
                                      : null,
                                  onTap: () {
                                    Navigator.pop(pickerCtx);
                                    setSheetState(() {
                                      selectedBankName = bName;
                                      selectedBankCode = bCode;
                                    });
                                    resolveAccount();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 28.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD0D7D2),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF7EE),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Icon(
                            Icons.person_add_rounded,
                            color: Color(0xFF2F8F3C),
                            size: 22.0,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add Beneficiary to ${_batch!.name}',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF0B2018),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Enter account number & select bank',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF6B7F72),
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18.0),

                    // Account Number Input
                    Text(
                      'ACCOUNT NUMBER',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF8FA596),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: acctController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: onAccountNumberChanged,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF0B2018),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '10-digit NUBAN',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF9AA79E),
                          fontSize: 14.0,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF6F8F6),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 14.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFE6EAE7)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFE6EAE7)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: const BorderSide(
                              color: Color(0xFF2F8F3C), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Bank Selector
                    Text(
                      'DESTINATION BANK',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF8FA596),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    InkWell(
                      onTap: openBankPicker,
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 14.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F8F6),
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(color: const Color(0xFFE6EAE7)),
                        ),
                        child: Row(
                          children: [
                            if (selectedBankName.isNotEmpty) ...[
                              BankLogoWidget(
                                bankName: selectedBankName,
                                bankCode: selectedBankCode,
                                size: 24.0,
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  selectedBankName,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF0B2018),
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ] else ...[
                              const Icon(Icons.account_balance_rounded,
                                  color: Color(0xFF9AA79E), size: 20.0),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  'Tap to select destination bank',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF9AA79E),
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                            const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF8FA596), size: 22.0),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    // Quick popular bank chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: AccountLookupService.popularBanks.take(6).map((b) {
                          final isSelected = selectedBankCode == b['code'];
                          return Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: ActionChip(
                              avatar: BankLogoWidget(
                                bankName: b['name']!,
                                bankCode: b['code']!,
                                size: 16.0,
                              ),
                              label: Text(
                                b['name']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? const Color(0xFF2F8F3C)
                                      : const Color(0xFF3B4E42),
                                ),
                              ),
                              backgroundColor: isSelected
                                  ? const Color(0xFFEDF7EE)
                                  : const Color(0xFFF1F5F2),
                              side: BorderSide(
                                color: isSelected
                                    ? const Color(0xFF56B84B)
                                    : Colors.transparent,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              onPressed: () {
                                setSheetState(() {
                                  selectedBankName = b['name']!;
                                  selectedBankCode = b['code']!;
                                });
                                resolveAccount();
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Verified Name Indicator
                    if (isResolving)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16.0,
                              height: 16.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF2F8F3C)),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              'Verifying account name...',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF6B7F72),
                                fontSize: 13.0,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (resolvedName.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF7EE),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                              color: const Color(0xFF56B84B)
                                  .withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF2F8F3C),
                              size: 20.0,
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    resolvedName,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF0B2018),
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '$selectedBankName • ${acctController.text}',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF2F8F3C),
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (resolveError != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          resolveError!,
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFFDC2626),
                            fontSize: 12.0,
                          ),
                        ),
                      ),

                    const SizedBox(height: 16.0),

                    // Default Payout Amount
                    Text(
                      'PAYOUT AMOUNT (OPTIONAL)',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF8FA596),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF0B2018),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        prefixText: '₦ ',
                        prefixStyle: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF2F8F3C),
                          fontWeight: FontWeight.w700,
                        ),
                        hintText: 'e.g. 25,000 (can be updated anytime)',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF9AA79E),
                          fontSize: 13.5,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF6F8F6),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 14.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFE6EAE7)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFE6EAE7)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: const BorderSide(
                              color: Color(0xFF2F8F3C), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Add Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: (resolvedName.isNotEmpty &&
                                selectedBankCode.isNotEmpty)
                            ? () async {
                                final amount = double.tryParse(
                                        amountController.text.trim()) ??
                                    0.0;
                                Navigator.pop(ctx);
                                await BatchPayoutService.addBeneficiary(
                                  batchId: _batch!.id,
                                  accountName: resolvedName,
                                  accountNumber: acctController.text.trim(),
                                  bankName: selectedBankName,
                                  bankCode: selectedBankCode,
                                  amount: amount,
                                );
                                _loadBatch();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B2018),
                          disabledBackgroundColor:
                              const Color(0xFF0B2018).withValues(alpha: 0.4),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        child: Text(
                          'Add to ${_batch!.name}',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Schedule Batch Disbursement
  // ──────────────────────────────────────────────────────────────────────────
  void _scheduleBatchFlow() {
    if (_batch == null || _batch!.beneficiaries.isEmpty) return;

    final payable = _batch!.beneficiaries.where((b) => b.amount > 0).toList();
    if (payable.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'All beneficiaries have ₦0 amount. Set payout amounts before scheduling.',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFC62828),
        ),
      );
      return;
    }

    DateTime selectedDateTime = DateTime.now().add(const Duration(hours: 2));
    final schedPinController = TextEditingController();
    String? schedPinError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        DateTime currentScheduled = selectedDateTime;
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final dateStr = DateFormat('EEE, MMM d, y').format(currentScheduled);
            final timeStr = DateFormat('hh:mm a').format(currentScheduled);

            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6DDD8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EAF6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.schedule_rounded,
                          color: Color(0xFF3F51B5),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Schedule Batch Disbursement',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF101614),
                              ),
                            ),
                            Text(
                              '${payable.length} recipients • ₦${_batch!.totalAmount.toStringAsFixed(2)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                color: const Color(0xFF6E7A72),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'EXECUTION TIME',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8FA596),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F8F6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE6EAE7)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: ctx,
                                initialDate: currentScheduled,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (pickedDate != null) {
                                setModalState(() {
                                  currentScheduled = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    currentScheduled.hour,
                                    currentScheduled.minute,
                                  );
                                });
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF2F8F3C)),
                                const SizedBox(width: 8),
                                Text(
                                  dateStr,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF101614),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(width: 1, height: 24, color: const Color(0xFFD6DDD8)),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () async {
                            final pickedTime = await showTimePicker(
                              context: ctx,
                              initialTime: TimeOfDay.fromDateTime(currentScheduled),
                            );
                            if (pickedTime != null) {
                              setModalState(() {
                                currentScheduled = DateTime(
                                  currentScheduled.year,
                                  currentScheduled.month,
                                  currentScheduled.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            }
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF2F8F3C)),
                              const SizedBox(width: 8),
                              Text(
                                timeStr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF101614),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    children: [
                      ActionChip(
                        label: Text('In 1 hr', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          setModalState(() => currentScheduled = DateTime.now().add(const Duration(hours: 1)));
                        },
                      ),
                      ActionChip(
                        label: Text('In 2 hrs', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          setModalState(() => currentScheduled = DateTime.now().add(const Duration(hours: 2)));
                        },
                      ),
                      ActionChip(
                        label: Text('Today 2:00 PM', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          final now = DateTime.now();
                          setModalState(() => currentScheduled = DateTime(now.year, now.month, now.day, 14, 0));
                        },
                      ),
                      ActionChip(
                        label: Text('Tomorrow 9 AM', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          final tom = DateTime.now().add(const Duration(days: 1));
                          setModalState(() => currentScheduled = DateTime(tom.year, tom.month, tom.day, 9, 0));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'ENTER 5-DIGIT PIN TO AUTHORIZE SCHEDULE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8FA596),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: schedPinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 14,
                      color: const Color(0xFF101614),
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '•••••',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF9AA79E),
                        fontSize: 20,
                        letterSpacing: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF6F8F6),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2F8F3C), width: 1.5),
                      ),
                    ),
                  ),
                  if (schedPinError != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      schedPinError!,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFDC2626),
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final pin = schedPinController.text.trim();
                        if (pin.length != 5) {
                          setModalState(() =>
                              schedPinError = 'Enter your 5-digit PIN to authorize schedule');
                          return;
                        }
                        final double currentAvail = FFAppState().effectiveAvailableBalance;
                        if (_batch!.totalAmount > currentAvail) {
                          setModalState(() =>
                              schedPinError = 'Insufficient available balance. You need ₦${formatNumber(_batch!.totalAmount, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)}, but only have ₦${FFAppState().availableBalanceString} available.');
                          return;
                        }
                        Navigator.pop(ctx);
                        await ScheduledPaymentService.createSchedule(
                          title: 'Batch: ${_batch!.name}',
                          recipientName: '${payable.length} Recipients',
                          accountNumber: 'BATCH-${_batch!.id}',
                          bankName: 'StreetPay Batch Engine',
                          amount: _batch!.totalAmount,
                          scheduledTime: currentScheduled,
                          isBatch: true,
                          batchId: _batch!.id,
                          pin: pin,
                        );

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF0B2018),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: Color(0xFF56B84B), size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Batch scheduled for ${DateFormat('MMM d • h:mm a').format(currentScheduled)}',
                                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      context.pushNamed(ScheduledPaymentsWidget.routeName);
                                    },
                                    child: const Text('VIEW', style: TextStyle(color: Color(0xFF7FD472), fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B2018),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        'Confirm Batch Schedule',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Disburse / Execute Bulk Payment
  // ──────────────────────────────────────────────────────────────────────────
  void _startDisbursementFlow() {
    if (_batch == null) return;

    final payable =
        _batch!.beneficiaries.where((b) => b.amount > 0).toList();
    if (payable.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'All beneficiaries have ₦0 amount. Set payout amounts before sending.',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFC93B2B),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      );
      return;
    }

    final pinController = TextEditingController();
    bool isExecuting = false;
    String currentProgressText = '';
    int currentStep = 0;
    int totalSteps = payable.length;
    List<BatchItemResult> results = [];
    String? pinError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDF7EE),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Icon(
                              Icons.payments_rounded,
                              color: Color(0xFF2F8F3C),
                              size: 20.0,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            'Confirm Bulk Payout',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF0B2018),
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      if (!isExecuting)
                        IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: Color(0xFF8FA596)),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Summary Card
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F8F6),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: const Color(0xFFE6EAE7)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Batch Group:',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF6B7F72),
                                fontSize: 13.0,
                              ),
                            ),
                            Text(
                              _batch!.name,
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF0B2018),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recipients:',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF6B7F72),
                                fontSize: 13.0,
                              ),
                            ),
                            Text(
                              '${payable.length} People',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF0B2018),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Payout:',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF6B7F72),
                                fontSize: 13.0,
                              ),
                            ),
                            Text(
                              formatNumber(
                                _batch!.totalAmount,
                                formatType: FormatType.decimal,
                                decimalType: DecimalType.periodDecimal,
                                currency: '₦',
                              ),
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF2F8F3C),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18.0),

                  if (isExecuting) ...[
                    // Progress view
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 32.0,
                            height: 32.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF2F8F3C)),
                            ),
                          ),
                          const SizedBox(height: 14.0),
                          Text(
                            'Disbursing $currentStep of $totalSteps...',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF0B2018),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            currentProgressText,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF6B7F72),
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (results.isNotEmpty) ...[
                    // Completed result view
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: results.any((r) => !r.success)
                                  ? const Color(0xFFFFF3CD)
                                  : const Color(0xFFEDF7EE),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              results.any((r) => !r.success)
                                  ? Icons.warning_amber_rounded
                                  : Icons.check_circle_rounded,
                              color: results.any((r) => !r.success)
                                  ? const Color(0xFFD97706)
                                  : const Color(0xFF2F8F3C),
                              size: 36.0,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            results.every((r) => r.success)
                                ? 'Batch Disbursement Completed!'
                                : 'Disbursement Completed with Issues',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF0B2018),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            '${results.where((r) => r.success).length} of ${results.length} payments sent successfully.',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF6B7F72),
                              fontSize: 13.0,
                            ),
                          ),
                          if (results.any((r) => (r.message ?? '').toLowerCase().contains('insufficient balance'))) ...[
                            const SizedBox(height: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDE8E8),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFF8B4B4)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.error_outline_rounded, size: 14, color: Color(0xFFDC2626)),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      'Insufficient balance recorded on wallet history',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFDC2626),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 14.0),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 180),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: results.length,
                              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
                              itemBuilder: (context, idx) {
                                final r = results[idx];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        r.success ? Icons.check_circle : Icons.cancel,
                                        size: 16,
                                        color: r.success ? const Color(0xFF2F8F3C) : const Color(0xFFDC2626),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              r.beneficiary.accountName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF101614),
                                              ),
                                            ),
                                            if (!r.success && r.message != null)
                                              Text(
                                                r.message!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 11,
                                                  color: const Color(0xFFDC2626),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '₦${r.beneficiary.amount.toStringAsFixed(2)}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                          color: r.success ? const Color(0xFF2F8F3C) : const Color(0xFFDC2626),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          SizedBox(
                            width: double.infinity,
                            height: 48.0,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                _loadBatch();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0B2018),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Text('Done',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Enter PIN input
                    Text(
                      'ENTER 5-DIGIT PIN TO AUTHORIZE',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF8FA596),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: pinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF0B2018),
                        fontSize: 22.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 16.0,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '•••••',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF9AA79E),
                          fontSize: 22.0,
                          letterSpacing: 16.0,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF6F8F6),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFE6EAE7)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFE6EAE7)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: const BorderSide(
                              color: Color(0xFF2F8F3C), width: 1.5),
                        ),
                      ),
                    ),
                    if (pinError != null) ...[
                      const SizedBox(height: 6.0),
                      Text(
                        pinError!,
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFDC2626),
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20.0),

                    // Send Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          final pin = pinController.text.trim();
                          if (pin.length != 5) {
                            setModalState(
                                () => pinError = 'Please enter your 5-digit PIN');
                            return;
                          }
                          final double currentAvail = FFAppState().effectiveAvailableBalance;
                          if (_batch!.totalAmount > currentAvail) {
                            setModalState(() {
                              pinError = 'Insufficient available balance. You need ₦${formatNumber(_batch!.totalAmount, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)}, but only have ₦${FFAppState().availableBalanceString} available.';
                            });
                            return;
                          }

                          setModalState(() {
                            isExecuting = true;
                            pinError = null;
                            currentProgressText = 'Authenticating PIN...';
                          });

                          try {
                            final res =
                                await BatchPayoutService.executeBatchPayout(
                              batch: _batch!,
                              pin: pin,
                              onProgress:
                                  (curr, tot, name, succ, message) {
                                setModalState(() {
                                  currentStep = curr;
                                  totalSteps = tot;
                                  currentProgressText =
                                      '$name: ${succ ? "✓ Sent" : "✗ $message"}';
                                });
                              },
                            );

                            setModalState(() {
                              isExecuting = false;
                              results = res;
                            });
                          } catch (e) {
                            setModalState(() {
                              isExecuting = false;
                              pinError = e.toString().replaceAll('Exception: ', '');
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B2018),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.send_rounded,
                              color: Color(0xFF56B84B),
                              size: 18.0,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Disburse All Now',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F8F6),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B2018),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Batch Details',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2F8F3C)),
          ),
        ),
      );
    }

    if (_batch == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F8F6),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B2018),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Batch Not Found',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
        ),
        body: Center(
          child: Text(
            'Batch not found or was deleted.',
            style: GoogleFonts.plusJakartaSans(color: const Color(0xFF6B7F72)),
          ),
        ),
      );
    }

    final beneficiaries = _batch!.beneficiaries;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF6F8F6),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B2018),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 22.0,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            _batch!.name,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.person_add_rounded,
                color: Colors.white,
                size: 22.0,
              ),
              onPressed: _showAddBeneficiarySheet,
              tooltip: 'Add Beneficiary',
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                // Schedule Batch Button
                Container(
                  height: 52.0,
                  width: 52.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF7EE),
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(color: const Color(0xFFD0EBD2)),
                  ),
                  child: IconButton(
                    tooltip: 'Schedule Batch',
                    icon: const Icon(
                      Icons.schedule_rounded,
                      color: Color(0xFF2F8F3C),
                      size: 22.0,
                    ),
                    onPressed: beneficiaries.isEmpty ? null : _scheduleBatchFlow,
                  ),
                ),
                const SizedBox(width: 10.0),
                // Disburse Now Button
                Expanded(
                  child: SizedBox(
                    height: 52.0,
                    child: ElevatedButton(
                      onPressed: beneficiaries.isEmpty ? null : _startDisbursementFlow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B2018),
                        disabledBackgroundColor:
                            const Color(0xFF0B2018).withValues(alpha: 0.4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.send_rounded,
                            color: Color(0xFF56B84B),
                            size: 18.0,
                          ),
                          const SizedBox(width: 8.0),
                          Flexible(
                            child: Text(
                              'Disburse Batch (${formatNumber(_batch!.totalAmount, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal, currency: '₦')})',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: RefreshIndicator(
            onRefresh: _loadBatch,
            color: const Color(0xFF2F8F3C),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Batch Summary Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0B2018), Color(0xFF163C2E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF0B2018).withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TOTAL BATCH PAYOUT',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF56B84B),
                                fontSize: 11.0,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                '${beneficiaries.length} Recipients',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          formatNumber(
                            _batch!.totalAmount,
                            formatType: FormatType.decimal,
                            decimalType: DecimalType.periodDecimal,
                            currency: '₦',
                          ),
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 26.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (_batch!.lastDisbursedAt != null) ...[
                          const SizedBox(height: 6.0),
                          Text(
                            'Last disbursed: ${dateTimeFormat("MMM d, y • h:mm a", _batch!.lastDisbursedAt)}',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFFC4D5C9),
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // Header Row with "Add Beneficiary"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'BENEFICIARIES (${beneficiaries.length})'
                            .toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF8FA596),
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      InkWell(
                        onTap: _showAddBeneficiarySheet,
                        borderRadius: BorderRadius.circular(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add_circle_outline_rounded,
                                color: Color(0xFF2F8F3C),
                                size: 16.0,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                'Add Person',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF2F8F3C),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12.0),

                  // Beneficiaries List / Empty State
                  if (beneficiaries.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: const Color(0xFFE6EAE7)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEDF7EE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.group_add_outlined,
                              color: Color(0xFF2F8F3C),
                              size: 28.0,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            'No Beneficiaries Added',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF0B2018),
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Add account numbers from any Nigerian bank to disburse payments to this batch.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF6B7F72),
                              fontSize: 12.5,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton.icon(
                            onPressed: _showAddBeneficiarySheet,
                            icon: const Icon(Icons.add_rounded, size: 18.0),
                            label: const Text('Add First Beneficiary'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B2018),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: beneficiaries.length,
                      itemBuilder: (context, index) {
                        final ben = beneficiaries[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border:
                                Border.all(color: const Color(0xFFE6EAE7)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44.0,
                                height: 44.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDF7EE),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(
                                  child: Text(
                                    ben.initials,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF2F8F3C),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ben.accountName,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF0B2018),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3.0),
                                    Text(
                                      '${ben.accountNumber} • ${ben.bankName}',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF6B7F72),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              // Amount Button (Tappable to edit)
                              InkWell(
                                onTap: () => _editBeneficiaryAmount(ben),
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 7.0),
                                  decoration: BoxDecoration(
                                    color: ben.amount > 0
                                        ? const Color(0xFFEDF7EE)
                                        : const Color(0xFFF6F8F6),
                                    borderRadius:
                                        BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: ben.amount > 0
                                          ? const Color(0xFF56B84B)
                                              .withValues(alpha: 0.3)
                                          : const Color(0xFFE6EAE7),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        ben.amount > 0
                                            ? formatNumber(
                                                ben.amount,
                                                formatType:
                                                    FormatType.decimal,
                                                decimalType: DecimalType
                                                    .automatic,
                                                currency: '₦',
                                              )
                                            : 'Set ₦',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: ben.amount > 0
                                              ? const Color(0xFF2F8F3C)
                                              : const Color(0xFF8FA596),
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 4.0),
                                      Icon(
                                        Icons.edit_outlined,
                                        size: 13.0,
                                        color: ben.amount > 0
                                            ? const Color(0xFF2F8F3C)
                                            : const Color(0xFF8FA596),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              // Delete Button
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Color(0xFFDC2626),
                                  size: 19.0,
                                ),
                                onPressed: () => _confirmDeleteBeneficiary(ben),
                                tooltip: 'Remove from batch',
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(6.0),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
