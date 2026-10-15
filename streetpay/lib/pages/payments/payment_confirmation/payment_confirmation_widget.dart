import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/paymentpinverify_widget.dart';
import '/components/sucesss_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'payment_confirmation_model.dart';
export 'payment_confirmation_model.dart';

class PaymentConfirmationWidget extends StatefulWidget {
  const PaymentConfirmationWidget({
    super.key,
    required this.sender,
    required this.receiver,
    required this.receiveraccount,
    required this.receiverbank,
    required this.amounttopay,
    required this.description,
    required this.walletbalance,
    required this.myphoneNo,
    required this.sendersaccountno,
  });

  final String? sender;
  final String? receiver;
  final String? receiveraccount;
  final String? receiverbank;
  final double? amounttopay;
  final String? description;
  final double? walletbalance;
  final String? myphoneNo;
  final String? sendersaccountno;

  static String routeName = 'PaymentConfirmation';
  static String routePath = '/paymentConfirmation';

  @override
  State<PaymentConfirmationWidget> createState() =>
      _PaymentConfirmationWidgetState();
}

class _PaymentConfirmationWidgetState extends State<PaymentConfirmationWidget> {
  late PaymentConfirmationModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentConfirmationModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.streetauth = await StreetauthCall.call();

      _model.belong = await GetphonenCall.call(
        accountNo: widget.receiveraccount,
        accessToken: StreetauthCall.streettoken(
          (_model.streetauth?.jsonBody ?? ''),
        ),
      );

      _model.hostnumber = await GetphonenCall.call(
        accountNo: FFAppState().accountno,
        accessToken: StreetauthCall.streettoken(
          (_model.streetauth?.jsonBody ?? ''),
        ),
      );

      _model.pinnedlist = await GetpinnedphonesCall.call(
        hostphone: GetphonenCall.phoneno(
          (_model.hostnumber?.jsonBody ?? ''),
        ),
        accessToken: StreetauthCall.streettoken(
          (_model.streetauth?.jsonBody ?? ''),
        ),
      );
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final formattedAmount = formatNumber(
      widget.amounttopay,
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
      currency: '₦',
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF6F8F6),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
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
                      'Confirm transfer',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF101614),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
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
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _model.columnController,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 120.0),
                  child: Column(
                    children: [
                      // Summary Card (matches prototype)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE6EAE7)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'You are sending',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF6E7A72),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              formattedAmount,
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF101614),
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1.2,
                              ),
                            ),
                            const SizedBox(height: 22),

                            _buildRow('To', widget.receiver ?? 'Recipient'),
                            const SizedBox(height: 12),
                            _buildRow('Account', '${widget.receiveraccount ?? ''} · ${widget.receiverbank ?? 'StreetPay'}'),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Fee',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF6E7A72),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '₦0.00',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF2F8F3C),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.0),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFEDF0ED),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total debit',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF101614),
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  formattedAmount,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF101614),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Save Beneficiary Checkbox
                      if (GetpinnedphonesCall.phones(
                            (_model.pinnedlist?.jsonBody ?? ''),
                          )?.contains(GetphonenCall.phoneno(
                            (_model.belong?.jsonBody ?? ''),
                          )) ??
                          true)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _model.checkboxValue ??= false,
                                  activeColor: const Color(0xFF56B84B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  onChanged: (newValue) async {
                                    safeSetState(() =>
                                        _model.checkboxValue = newValue!);
                                    if (newValue!) {
                                      _model.streetaut =
                                          await StreetauthCall.call();

                                      _model.getreceiverphonenumber =
                                          await GetphonenCall.call(
                                        accountNo: widget.receiveraccount,
                                        accessToken: StreetauthCall.streettoken(
                                          (_model.streetaut?.jsonBody ?? ''),
                                        ),
                                      );

                                      _model.apiResult33o =
                                          await InsertpindataCall.call(
                                        hostphone: FFAppState().phonenumber,
                                        guestphone: GetphonenCall.phoneno(
                                          (_model.getreceiverphonenumber
                                                  ?.jsonBody ??
                                              ''),
                                        ),
                                        datein: dateTimeFormat(
                                          "yMMMd",
                                          getCurrentTimestamp,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ),
                                        timein: dateTimeFormat(
                                          "jm",
                                          getCurrentTimestamp,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ),
                                        accessToken: StreetauthCall.streettoken(
                                          (_model.streetaut?.jsonBody ?? ''),
                                        ),
                                      );

                                      if ((_model.apiResult33o?.succeeded ??
                                          true)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Saved to favorite recipients'),
                                            duration: Duration(milliseconds: 3000),
                                            backgroundColor: Color(0xFF0B2018),
                                          ),
                                        );
                                      }
                                      safeSetState(() {});
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Save as favorite recipient',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF6E7A72),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Proceed CTA Button
                      FFButtonWidget(
                        onPressed: () async {
                          if (_isSubmitting) return;
                          setState(() => _isSubmitting = true);
                          try {
                            if ((widget.walletbalance ?? 0.0) >=
                                (widget.amounttopay ?? 0.0)) {
                              _model.transref = await actions.generatetransref();
                              _model.sessionid = await actions.generateseesionid();

                              final dynamic transferSuccess =
                                  await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                isDismissible: false,
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
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: PaymentpinverifyWidget(
                                        customeraccount: '00005',
                                        customername: widget.receiver ?? '',
                                        customeraccountno:
                                            widget.receiveraccount ?? '',
                                        narration: _model.transref ?? '',
                                        amount: widget.amounttopay ?? 0.0,
                                        description: valueOrDefault<String>(
                                          widget.description,
                                          '-',
                                        ),
                                        refrence: _model.transref ?? '',
                                        sectionid: _model.sessionid ?? '',
                                      ),
                                    ),
                                  );
                                },
                              );

                              safeSetState(() {});

                              if (transferSuccess == true && mounted) {
                                // Background tasks: email & log (non-blocking)
                                unawaited(Future(() async {
                                  try {
                                    _model.walletenquiry = await WalletAsAServiceGroup
                                        .walletEnquiryCall
                                        .call(
                                      accountNo: FFAppState().accountno,
                                      authToken: FFAppState().bsptoken,
                                    );
                                  } catch (_) {}

                                  try {
                                    await LogtransactionCall.call(
                                      phoneno: FFAppState().phonenumber,
                                      accountId: FFAppState().accountno,
                                      reqtype: 'Transfer',
                                      sSid: _model.sessionid,
                                      passorfail: 'Pass',
                                      beneficiary: widget.receiver,
                                      tammt: widget.amounttopay?.toString(),
                                      extra: widget.description,
                                      transREF: _model.transref,
                                      accessToken: StreetauthCall.streettoken(
                                        (_model.streetauth?.jsonBody ?? ''),
                                      ),
                                    );
                                  } catch (_) {}
                                }));

                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  isDismissible: false,
                                  enableDrag: false,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: SucesssWidget(
                                        sender: widget.sender,
                                        amount: widget.amounttopay!,
                                        date: dateTimeFormat(
                                          "yMMMd",
                                          getCurrentTimestamp,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ),
                                        paymentRef: _model.transref!,
                                        description: widget.description!,
                                        receiver: widget.receiver!,
                                        receiveraccount:
                                            widget.receiveraccount!,
                                      ),
                                    );
                                  },
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Insufficient wallet balance'),
                                  duration: Duration(milliseconds: 3000),
                                  backgroundColor: Color(0xFFD32F2F),
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _isSubmitting = false);
                            }
                          }
                        },
                        text: 'Proceed to PIN',
                        loading: _isSubmitting,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom App Bar Dock
              Align(
                alignment: Alignment.bottomCenter,
                child: wrapWithModel(
                  model: _model.bottomAppBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const BottomAppBarWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF6E7A72),
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF101614),
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
