import '/components/errorcomp_widget.dart';
import '/components/sucesss_widget.dart';
import '/components/transerconfirm_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/bank_logo_service.dart';
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

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final balanceFormatted = formatNumber(
      functions.stringtodouble(FFAppState().avalbal),
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
                                'WALLET BALANCE',
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
                        final double userBal =
                            functions.stringtodouble(FFAppState().avalbal);
                        final double stampDuty = parsedAmount >= 10000.0 ? 50.0 : 0.0;
                        final double totalRequired = parsedAmount + stampDuty;
                        final bool isAmountValid = parsedAmount > 0;
                        final bool isBalanceEnough = userBal >= totalRequired;

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
                                  stampDuty > 0
                                      ? 'Insufficient balance. ₦${formatNumber(totalRequired, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)} required (including ₦50 EMTL stamp duty on transfers ≥ ₦10,000). Available: $balanceFormatted'
                                      : 'Insufficient wallet balance (available: $balanceFormatted)',
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
                                      setState(() => _isSubmitting = true);
                                      try {
                                      if (userBal < totalRequired) {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: const ErrorcompWidget(
                                                message: 'Insufficient balance',
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
