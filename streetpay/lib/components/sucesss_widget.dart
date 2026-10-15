import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sucesss_model.dart';
export 'sucesss_model.dart';

class SucesssWidget extends StatefulWidget {
  const SucesssWidget({
    super.key,
    required this.sender,
    required this.amount,
    required this.date,
    required this.paymentRef,
    required this.description,
    required this.receiver,
    required this.receiveraccount,
  });

  final String? sender;
  final double? amount;
  final String? date;
  final String? paymentRef;
  final String? description;
  final String? receiver;
  final String? receiveraccount;

  @override
  State<SucesssWidget> createState() => _SucesssWidgetState();
}

class _SucesssWidgetState extends State<SucesssWidget> {
  late SucesssModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SucesssModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedAmount = formatNumber(
      widget.amount,
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
      currency: '₦',
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Animated Pop Checkmark
              Container(
                width: 76.0,
                height: 76.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDF7EE),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 52.0,
                  height: 52.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFF56B84B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                'Transfer successful',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF101614),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                '$formattedAmount sent to ${widget.receiver ?? 'Recipient'}. Your wallet balance has been updated.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF6E7A72),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 22),

              // Transaction Detail Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFCFA),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE6EAE7)),
                ),
                child: Column(
                  children: [
                    _buildRow('Reference', widget.paymentRef ?? 'SP-${DateTime.now().millisecondsSinceEpoch}'),
                    const SizedBox(height: 10),
                    _buildRow('Date', widget.date ?? ''),
                    const SizedBox(height: 10),
                    _buildRow('Channel', 'StreetPay wallet'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () async {
                        Navigator.pop(context);
                        context.pushNamed(
                          PaymentReceiptWidget.routeName,
                          queryParameters: {
                            'sender': serializeParam(
                              widget.sender,
                              ParamType.String,
                            ),
                            'amount': serializeParam(
                              widget.amount,
                              ParamType.double,
                            ),
                            'date': serializeParam(
                              widget.date,
                              ParamType.String,
                            ),
                            'paymentref': serializeParam(
                              widget.paymentRef,
                              ParamType.String,
                            ),
                            'description': serializeParam(
                              widget.description,
                              ParamType.String,
                            ),
                            'receiver': serializeParam(
                              widget.receiver,
                              ParamType.String,
                            ),
                            'receiveraccount': serializeParam(
                              widget.receiveraccount,
                              ParamType.String,
                            ),
                          }.withoutNulls,
                        );
                      },
                      text: 'View Receipt',
                      options: FFButtonOptions(
                        height: 48.0,
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
                        Navigator.pop(context);
                        context.pushNamed(NewhomeWidget.routeName);
                      },
                      text: 'Back Home',
                      options: FFButtonOptions(
                        height: 48.0,
                        padding: EdgeInsets.zero,
                        iconPadding: EdgeInsets.zero,
                        color: const Color(0xFF0B2018),
                        textStyle: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w800,
                        ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                  ),
                ],
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
