import '/backend/api_requests/api_calls.dart';
import '/components/errorcomp_widget.dart';
import '/components/sucesss_widget.dart';
import '/components/transerconfirm_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/bank_logo_service.dart';
import '/services/beneficiary_service.dart';
import '/services/local_vault_service.dart';
import '/services/payment_guard_service.dart';
import '/services/scheduled_payment_service.dart';
import '/pages/payments/scheduled_payments/scheduled_payments_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'payment_model.dart';
export 'payment_model.dart';

class PaymentWidget extends StatefulWidget {
  const PaymentWidget({
    super.key,
    String? walletBalance,
    required this.receiveraccountname,
    required this.receiveraccountnumber,
    required this.receiverbankname,
    required this.sender,
    required this.senderaccountnumber,
    required this.sendersbank,
    this.phoneno,
  }) : this.walletBalance = walletBalance ?? '[balance]';

  final String walletBalance;
  final String? receiveraccountname;
  final String? receiveraccountnumber;
  final String? receiverbankname;
  final String? sender;
  final String? senderaccountnumber;
  final String? sendersbank;
  final String? phoneno;

  static String routeName = 'Payment';
  static String routePath = '/payment';

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  late PaymentModel _model;
  bool _isSubmitting = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    // Fetch live balance from bank on open
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (FFAppState().phonenumber.isNotEmpty) {
          final res = await GetaccountbalanceCall.call(
            phone: FFAppState().phonenumber,
            accessToken: FFAppState().bsptoken,
          );
          final balVal = GetaccountbalanceCall.avalbal(res.jsonBody);
          if (balVal != null) {
            FFAppState().avalbal = balVal.toString();
            safeSetState(() {});
          }
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'SP';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  void _openScheduleTransferModal(
    BuildContext context, {
    required String recipientName,
    required String accountNumber,
    required String bankName,
    String? bankCode,
    required double amount,
    String narration = '',
  }) {
    DateTime currentScheduled = DateTime.now().add(const Duration(hours: 2));
    final schedPinController = TextEditingController();
    String? schedPinError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
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
                          color: const Color(0xFFEDF7EE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.schedule_rounded,
                          color: Color(0xFF2F8F3C),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Schedule Transfer',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF101614),
                              ),
                            ),
                            Text(
                              'Pay ₦${amount.toStringAsFixed(2)} to $recipientName',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                color: const Color(0xFF6E7A72),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'WHEN SHOULD IT SEND?',
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
                        if (amount > currentAvail) {
                          setModalState(() =>
                              schedPinError = 'Insufficient available balance. You have ₦${FFAppState().availableBalanceString} available to schedule.');
                          return;
                        }
                        Navigator.pop(ctx);
                        await ScheduledPaymentService.createSchedule(
                          title: 'Transfer to $recipientName',
                          recipientName: recipientName,
                          accountNumber: accountNumber,
                          bankName: bankName,
                          bankCode: bankCode,
                          amount: amount,
                          narration: narration,
                          scheduledTime: currentScheduled,
                          pin: pin,
                        );

                        // Save beneficiary immediately
                        BeneficiaryService.saveBeneficiary(
                          accountName: recipientName,
                          accountNumber: accountNumber,
                          bankName: bankName,
                          bankCode: bankCode,
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
                                      'Transfer scheduled for ${DateFormat('MMM d • h:mm a').format(currentScheduled)}',
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
                        'Confirm Schedule',
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

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final double availBal = FFAppState().effectiveAvailableBalance;
    final double ledgerBal = FFAppState().ledgerBalance;
    final double reservedBal = FFAppState().reservedBalance;

    final balanceFormatted = formatNumber(
      availBal,
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
      currency: '₦',
    );

    final String recipientName = widget.receiveraccountname ?? 'Recipient';
    final String recipientAccount = widget.receiveraccountnumber ?? '-';
    final String recipientBank = widget.receiverbankname ?? 'StreetPay';

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: PopScope(
        canPop: true,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFFF6F8F6),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(64.0),
            child: Container(
              color: Colors.white,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => context.pop(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F6F3),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE6EAE7)),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF101614),
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Send money',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF101614),
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF7EE),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2F8F3C),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Free · instant',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF2F8F3C),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              controller: _model.columnController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B2018),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFF12362A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Color(0xFF7FD472),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AVAILABLE BALANCE',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF8FA596),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                balanceFormatted,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              if (reservedBal > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.5),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.15),
                                        width: 0.7,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.lock_clock_rounded, size: 10.0, color: Color(0xFF7FD472)),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          'Ledger: ₦${formatNumber(ledgerBal, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)}  •  ₦${formatNumber(reservedBal, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)} held',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFFE2F7DF),
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            FFAppState().accountno,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF8FA596),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SENDING TO Header
                    Text(
                      'SENDING TO',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF6E7A72),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Recipient Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFCFA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE6EAE7)),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0B2018),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _getInitials(recipientName),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF7FD472),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -2,
                                bottom: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(1.5),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: BankLogoWidget(
                                    bankName: recipientBank,
                                    size: 19,
                                    borderRadius: 9.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipientName,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF101614),
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$recipientAccount · $recipientBank',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF6E7A72),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEDF7EE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF2F8F3C),
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Amount Card
                    InkWell(
                      onTap: () {
                        if (!(_model.textFieldFocusNode1?.hasFocus ?? false)) {
                          _model.textFieldFocusNode1?.requestFocus();
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE6EAE7)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'AMOUNT',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF6E7A72),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 8),

                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (!(_model.textFieldFocusNode1?.hasFocus ?? false)) {
                                  _model.textFieldFocusNode1?.requestFocus();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '₦',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF101614),
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: (_model.textController1?.text.isEmpty ?? true)
                                        ? 40.0
                                        : (_model.textController1!.text.length * 24.0 + 16.0)
                                            .clamp(40.0, 260.0),
                                    child: TextFormField(
                                      controller: _model.textController1,
                                      focusNode: _model.textFieldFocusNode1,
                                      keyboardType: const TextInputType.numberWithOptions(
                                        decimal: false,
                                        signed: false,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF101614),
                                        fontSize: 36,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -1.2,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '0',
                                        hintStyle: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFFC8D5CC),
                                          fontSize: 36,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -1.2,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                      ),
                                      onChanged: (_) => safeSetState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Daily limit ₦200,000 · Free transfer',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF6E7A72),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Quick Amount Pills
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (final amt in ['5000', '10000', '25000', '50000'])
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: InkWell(
                                      onTap: () {
                                        _model.textController1?.text = amt;
                                        safeSetState(() {});
                                      },
                                      borderRadius: BorderRadius.circular(999),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: _model.textController1?.text == amt
                                              ? const Color(0xFFEDF7EE)
                                              : const Color(0xFFF3F6F3),
                                          borderRadius: BorderRadius.circular(999),
                                          border: Border.all(
                                            color: _model.textController1?.text == amt
                                                ? const Color(0xFF56B84B)
                                                : Colors.transparent,
                                          ),
                                        ),
                                        child: Text(
                                          '₦${formatNumber(double.parse(amt), formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)}',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: _model.textController1?.text == amt
                                                ? const Color(0xFF2F8F3C)
                                                : const Color(0xFF2B3630),
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                    const SizedBox(height: 16),

                    // Narration Field
                    InkWell(
                      onTap: () {
                        if (!(_model.textFieldFocusNode2?.hasFocus ?? false)) {
                          _model.textFieldFocusNode2?.requestFocus();
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE6EAE7)),
                        ),
                        child: TextFormField(
                          controller: _model.textController2,
                          focusNode: _model.textFieldFocusNode2,
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF101614),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Add a note (optional)...',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF9EABA2),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: const Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Color(0xFF6E7A72),
                              size: 18,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Continue CTA
                    Builder(
                      builder: (context) {
                        final double parsedAmount =
                            functions.stringtodouble(_model.textController1?.text);
                        final double availBal = FFAppState().ledgerBalance;
                        final bool isAmountValid = parsedAmount > 0;
                        // Use actual wallet balance; don't block user if balance is still loading (<= 0)
                        final bool isBalanceEnough = (availBal <= 0) || (availBal >= parsedAmount);

                        String cleanRecipientAccount =
                            recipientAccount.replaceAll(RegExp(r'\D'), '');
                        if (cleanRecipientAccount.length == 11 &&
                            cleanRecipientAccount.startsWith('0')) {
                          cleanRecipientAccount =
                              cleanRecipientAccount.substring(1);
                        }
                        final bool hasValidRecipient =
                            cleanRecipientAccount.length == 10;

                        final bool canProceed = isAmountValid && isBalanceEnough && hasValidRecipient;

                        return Column(
                          children: [
                            if (!hasValidRecipient)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Text(
                                  'Recipient account number must be 10 digits',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFFD32F2F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            if (!isBalanceEnough && isAmountValid)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Text(
                                  'Insufficient wallet balance (Available: $balanceFormatted)',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFFD32F2F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            FFButtonWidget(
                              loading: _isSubmitting,
                              onPressed: (!canProceed || _isSubmitting)
                                  ? null
                                  : () async {
                                      if (_isSubmitting) return;
                                      if (!PaymentGuardService.canTapButton()) return;
                                      setState(() => _isSubmitting = true);
                                      try {
                                      if (availBal > 0 && availBal < parsedAmount) {
                                        // Record failed transaction to LocalVaultService so user sees it in their history
                                        LocalVaultService.recordTransaction(
                                          ref: 'SP-FAIL-${DateTime.now().millisecondsSinceEpoch}',
                                          amount: parsedAmount,
                                          recipientName: recipientName,
                                          recipientAccount: cleanRecipientAccount,
                                          bankName: recipientBank,
                                          bankCode: '120001',
                                          narration: valueOrDefault<String>(_model.textController2?.text, '-'),
                                          status: 'Failed (Insufficient available balance)',
                                          type: 'debit',
                                        );

                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: ErrorcompWidget(
                                                message: 'Insufficient balance. Your available balance is $balanceFormatted.',
                                              ),
                                            );
                                          },
                                        );
                                        return;
                                      }

                                      // Resolve numeric bank code
                                      String resolvedBankCode = '120001';
                                      final rawBank = (widget.receiverbankname ?? '').trim();
                                      if (RegExp(r'^\d{3,6}$').hasMatch(rawBank)) {
                                        resolvedBankCode = rawBank;
                                      } else if (rawBank.isNotEmpty &&
                                          !rawBank.toLowerCase().contains('streetpay')) {
                                        final lookup = functions.getBankCode(
                                            FFAppState().allbankjson, rawBank);
                                        if (RegExp(r'^\d{3,6}$').hasMatch(lookup)) {
                                          resolvedBankCode = lookup;
                                        }
                                      }

                                      // Generate transaction details upfront
                                      final remainingCooldown =
                                          PaymentGuardService.getRemainingCooldown(
                                        accountNumber: cleanRecipientAccount,
                                        amount: parsedAmount,
                                      );
                                      if (remainingCooldown > 0) {
                                        PaymentGuardService.showDuplicateWarningDialog(
                                          context: context,
                                          recipientName: recipientName,
                                          accountNumber: cleanRecipientAccount,
                                          amount: parsedAmount,
                                          remainingSeconds: remainingCooldown,
                                        );
                                        return;
                                      }

                                      _model.transref =
                                          await actions.generatetransref();
                                      _model.sessionid =
                                          await actions.generateseesionid();

                                      if (!mounted) return;

                                      // Show Unified Confirmation & PIN Bottom Sheet
                                      final bool? transferSuccess =
                                          await showModalBottomSheet<bool>(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        enableDrag: false,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: TranserconfirmWidget(
                                                recipient: recipientName,
                                                amount: _model
                                                    .textController1!.text,
                                                transferfee: parsedAmount >= 20000.0
                                                    ? '50.36'
                                                    : '0.00',
                                                receiveraccount:
                                                    cleanRecipientAccount,
                                                bankname: recipientBank,
                                                bankcode: resolvedBankCode,
                                                description: valueOrDefault<String>(
                                                  _model.textController2?.text,
                                                  '-',
                                                ),
                                                transref: _model.transref,
                                                sessionid: _model.sessionid,
                                              ),
                                            ),
                                          );
                                        },
                                      );

                                      safeSetState(() =>
                                          _model.payrecipt = transferSuccess == true);

                                      if (transferSuccess == true && mounted) {
                                        if (cleanRecipientAccount.isNotEmpty && recipientName.isNotEmpty) {
                                          BeneficiaryService.saveBeneficiary(
                                            accountName: recipientName,
                                            accountNumber: cleanRecipientAccount,
                                            bankName: recipientBank,
                                            bankCode: resolvedBankCode,
                                          );
                                        }
                                        LocalVaultService.recordTransaction(
                                          ref: _model.transref ?? 'SP-${DateTime.now().millisecondsSinceEpoch}',
                                          amount: parsedAmount,
                                          recipientName: recipientName,
                                          recipientAccount: cleanRecipientAccount,
                                          bankName: recipientBank,
                                          bankCode: resolvedBankCode,
                                          narration: valueOrDefault<String>(_model.textController2?.text, '-'),
                                          status: 'Successful',
                                          type: 'debit',
                                        );

                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          isDismissible: false,
                                          enableDrag: false,
                                          useSafeArea: true,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: SucesssWidget(
                                                sender: FFAppState().accountname,
                                                amount: parsedAmount,
                                                date: dateTimeFormat(
                                                  "dd/MM/yyyy hh:mm a",
                                                  getCurrentTimestamp,
                                                  locale: 'en',
                                                ),
                                                paymentRef: _model.transref ??
                                                    'SP-${DateTime.now().millisecondsSinceEpoch}',
                                                description: valueOrDefault<String>(
                                                  _model.textController2?.text,
                                                  '-',
                                                ),
                                                receiver: recipientName,
                                                receiveraccount: functions
                                                        .accountstrip(
                                                            recipientAccount) ??
                                                    recipientAccount,
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      } finally {
                                        if (mounted) {
                                          setState(() => _isSubmitting = false);
                                        }
                                      }
                                    },
                              text: 'Continue',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 54.0,
                                padding: EdgeInsets.zero,
                                iconPadding: EdgeInsets.zero,
                                color: const Color(0xFF56B84B),
                                textStyle: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF06210F),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(16.0),
                                disabledColor: const Color(0xFFC8D5CC),
                                disabledTextColor: const Color(0xFF6E7A72),
                              ),
                            ),
                            if (hasValidRecipient && isAmountValid) ...[
                              const SizedBox(height: 12.0),
                              SizedBox(
                                width: double.infinity,
                                height: 52.0,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    String resolvedBankCode = '120001';
                                    final rawBank = (widget.receiverbankname ?? '').trim();
                                    if (RegExp(r'^\d{3,6}$').hasMatch(rawBank)) {
                                      resolvedBankCode = rawBank;
                                    } else if (rawBank.isNotEmpty &&
                                        !rawBank.toLowerCase().contains('streetpay')) {
                                      final lookup = functions.getBankCode(
                                          FFAppState().allbankjson, rawBank);
                                      if (RegExp(r'^\d{3,6}$').hasMatch(lookup)) {
                                        resolvedBankCode = lookup;
                                      }
                                    }
                                    _openScheduleTransferModal(
                                      context,
                                      recipientName: recipientName,
                                      accountNumber: cleanRecipientAccount,
                                      bankName: recipientBank,
                                      bankCode: resolvedBankCode,
                                      amount: parsedAmount,
                                      narration: valueOrDefault<String>(
                                          _model.textController2?.text, '-'),
                                    );
                                  },
                                  icon: const Icon(Icons.schedule_rounded,
                                      size: 18.0, color: Color(0xFF2F8F3C)),
                                  label: Text(
                                    'Schedule for Later',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF0B2018),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Color(0xFF2F8F3C), width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
