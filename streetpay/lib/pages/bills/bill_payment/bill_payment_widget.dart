import '/backend/api_requests/api_calls.dart';
import '/components/account_card/account_card_widget.dart';
import '/components/paymentpinverifyforbill_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'bill_payment_model.dart';
export 'bill_payment_model.dart';

class BillPaymentWidget extends StatefulWidget {
  const BillPaymentWidget({
    super.key,
    required this.phoneno,
    required this.amount,
    required this.description,
    required this.id,
    required this.sendername,
    required this.senderphone,
    required this.receiverName,
    required this.receiveraccountno,
  });

  final String? phoneno;
  final String? amount;
  final String? description;
  final String? id;
  final String? sendername;
  final String? senderphone;
  final String? receiverName;
  final String? receiveraccountno;

  static String routeName = 'BillPayment';
  static String routePath = '/billPayment';

  @override
  State<BillPaymentWidget> createState() => _BillPaymentWidgetState();
}

class _BillPaymentWidgetState extends State<BillPaymentWidget> {
  late BillPaymentModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BillPaymentModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.streetaut = await StreetauthCall.call();

      if (widget.phoneno != null && widget.phoneno!.isNotEmpty) {
        _model.getphoneno = await GetaccountnoCall.call(
          phoneno: functions.removecode(widget.phoneno!),
          accessToken: StreetauthCall.streettoken(
            (_model.streetaut?.jsonBody ?? ''),
          ),
        );

        final accNo = GetaccountnoCall.accountno(_model.getphoneno?.jsonBody ?? '');
        if (accNo != null && accNo.isNotEmpty) {
          _model.apiResultsou = await WalletAsAServiceGroup.walletEnquiryCall.call(
            accountNo: accNo,
            authToken: FFAppState().bsptoken,
          );
        }
      }
    });

    _model.textController1 ??= TextEditingController(text: widget.amount);
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(text: widget.description);
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildDetailRow(String label, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6E7A72),
            ),
          ),
          trailing ??
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF101614),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final displayAmount = widget.amount ?? '0';
    final formattedAmount = displayAmount.startsWith('₦') ? displayAmount : '₦$displayAmount';

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF6F8F6),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: const Color(0xFFEDF0ED),
              height: 1.0,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () => context.pop(),
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    width: 38.0,
                    height: 38.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6F3),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: const Color(0xFFE6EAE7),
                        width: 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF101614),
                      size: 20.0,
                    ),
                  ),
                ),
                const SizedBox(width: 14.0),
                Text(
                  'Review Bill Request',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF101614),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Amount Hero Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: const Color(0xFFE6EAE7),
                            width: 1.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x060B2018),
                              blurRadius: 10.0,
                              offset: Offset(0.0, 3.0),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'REQUESTED AMOUNT',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF6E7A72),
                                letterSpacing: 0.6,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              formattedAmount,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 34.0,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF101614),
                                fontFeatures: const [FontFeature.tabularFigures()],
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDF7EE),
                                borderRadius: BorderRadius.circular(999.0),
                              ),
                              child: Text(
                                'Direct Settlement',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2F8F3C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22.0),

                      // Requester Card
                      Text(
                        'REQUESTED BY',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF6E7A72),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 10.0),

                      AccountCardWidget(
                        accountName: widget.receiverName ?? 'StreetPay User',
                        accountNumber: widget.receiveraccountno ?? (widget.phoneno ?? '- - -'),
                        bankName: 'StreetPay',
                      ),

                      const SizedBox(height: 22.0),

                      // Bill Details Card
                      Text(
                        'BILL DETAILS',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF6E7A72),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 10.0),

                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: const Color(0xFFE6EAE7),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow('Purpose / Narration', widget.description ?? 'Bill Payment'),
                            const Divider(height: 1.0, color: Color(0xFFEDF0ED)),
                            _buildDetailRow('Bill Reference', '#${widget.id ?? "---"}'),
                            const Divider(height: 1.0, color: Color(0xFFEDF0ED)),
                            _buildDetailRow('Phone Number', widget.phoneno ?? '- - -'),
                            const Divider(height: 1.0, color: Color(0xFFEDF0ED)),
                            _buildDetailRow(
                              'Fee',
                              '₦0.00',
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDF7EE),
                                  borderRadius: BorderRadius.circular(999.0),
                                ),
                                child: Text(
                                  'Free',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2F8F3C),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(height: 1.0, color: Color(0xFFEDF0ED)),
                            _buildDetailRow('Debit from', 'StreetPay Wallet (₦${FFAppState().avalbal})'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Action Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFEDF0ED),
                      width: 1.0,
                    ),
                  ),
                ),
                child: SizedBox(
                  height: 54.0,
                  child: FFButtonWidget(
                    onPressed: () async {
                      if (_isSubmitting) return;
                      setState(() => _isSubmitting = true);
                      try {
                        _model.transref = await actions.generatetransref();
                        _model.sessionid = await actions.generateseesionid();

                        final amountNum = functions.stringtodouble(widget.amount);
                        final avalBal = functions.stringtodouble(FFAppState().avalbal);

                        if (avalBal < amountNum) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Insufficient wallet balance (₦${avalBal.toStringAsFixed(2)})',
                                  style: GoogleFonts.plusJakartaSans(color: Colors.white),
                                ),
                                backgroundColor: const Color(0xFFD9383A),
                              ),
                            );
                          }
                          return;
                        }

                        if (mounted) {
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            isDismissible: false,
                            enableDrag: false,
                            context: context,
                            builder: (context) {
                              return WebViewAware(
                                child: Padding(
                                  padding: MediaQuery.viewInsetsOf(context),
                                  child: PaymentpinverifyforbillWidget(
                                    customeraccount: '00005',
                                    customername: widget.receiverName ?? 'Biller',
                                    customeraccountno: widget.receiveraccountno ?? '',
                                    narration: widget.description ?? 'Bill payment',
                                    amount: amountNum,
                                    description: widget.description ?? '',
                                    refrence: _model.transref ?? '',
                                    sectionid: _model.sessionid ?? '',
                                    billid: widget.id ?? '',
                                  ),
                                ),
                              );
                            },
                          ).then((value) => safeSetState(() {}));
                        }
                      } finally {
                        if (mounted) {
                          setState(() => _isSubmitting = false);
                        }
                      }
                    },
                    text: 'Pay $formattedAmount',
                    loading: _isSubmitting,
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 54.0,
                      color: const Color(0xFF56B84B),
                      textStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF06210F),
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(16.0),
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
}
