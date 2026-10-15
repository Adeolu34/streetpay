import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'payment_success_model.dart';
export 'payment_success_model.dart';

class PaymentSuccessWidget extends StatefulWidget {
  const PaymentSuccessWidget({super.key});

  static String routeName = 'PaymentSuccess';
  static String routePath = '/paymentSuccess';

  @override
  State<PaymentSuccessWidget> createState() => _PaymentSuccessWidgetState();
}

class _PaymentSuccessWidgetState extends State<PaymentSuccessWidget> {
  late PaymentSuccessModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentSuccessModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String timestampStr = dateTimeFormat(
      "dd MMM yyyy, hh:mm a",
      getCurrentTimestamp,
      locale: FFLocalizations.of(context).languageCode,
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: SafeArea(
            top: true,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 24.0),
              child: Column(
                children: [
                  const Spacer(flex: 1),

                  // Celebration Hero Icon
                  Container(
                    width: 92.0,
                    height: 92.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDF7EE),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 64.0,
                      height: 64.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF56B84B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 38.0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Transfer successful',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF101614),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Your payment has been sent successfully. Your wallet balance has been updated.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF6E7A72),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Details Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFCFA),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE6EAE7)),
                    ),
                    child: Column(
                      children: [
                        _buildRow('Reference', 'SP-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}'),
                        const SizedBox(height: 12),
                        _buildRow('Date', timestampStr),
                        const SizedBox(height: 12),
                        _buildRow('Channel', 'StreetPay wallet'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed(
                              PaymentReceiptWidget.routeName,
                              queryParameters: {
                                'sender': serializeParam(
                                  FFAppState().accountname,
                                  ParamType.String,
                                ),
                                'amount': serializeParam(
                                  0.0,
                                  ParamType.double,
                                ),
                                'date': serializeParam(
                                  timestampStr,
                                  ParamType.String,
                                ),
                                'paymentref': serializeParam(
                                  'SP-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                                  ParamType.String,
                                ),
                                'description': serializeParam(
                                  'Transfer',
                                  ParamType.String,
                                ),
                                'receiver': serializeParam(
                                  'StreetPay User',
                                  ParamType.String,
                                ),
                                'receiveraccount': serializeParam(
                                  '',
                                  ParamType.String,
                                ),
                              }.withoutNulls,
                            );
                          },
                          text: 'Share receipt',
                          options: FFButtonOptions(
                            height: 50.0,
                            padding: EdgeInsets.zero,
                            iconPadding: EdgeInsets.zero,
                            color: Colors.white,
                            textStyle: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF101614),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                            ),
                            elevation: 0.0,
                            borderSide: const BorderSide(
                              color: Color(0xFFE6EAE7),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed(ManualPaymentWidget.routeName);
                          },
                          text: 'Send again',
                          options: FFButtonOptions(
                            height: 50.0,
                            padding: EdgeInsets.zero,
                            iconPadding: EdgeInsets.zero,
                            color: Colors.white,
                            textStyle: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF101614),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                            ),
                            elevation: 0.0,
                            borderSide: const BorderSide(
                              color: Color(0xFFE6EAE7),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(flex: 2),

                  // Back to home primary CTA
                  FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(
                        NewhomeWidget.routeName,
                        extra: <String, dynamic>{
                          '__transition_info__': const TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.leftToRight,
                          ),
                        },
                      );
                    },
                    text: 'Back to home',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 54.0,
                      padding: EdgeInsets.zero,
                      iconPadding: EdgeInsets.zero,
                      color: const Color(0xFF0B2018),
                      textStyle: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
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
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF101614),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
