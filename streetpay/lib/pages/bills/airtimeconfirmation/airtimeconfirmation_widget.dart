import '/components/paymentpinverifyairtime_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'airtimeconfirmation_model.dart';
export 'airtimeconfirmation_model.dart';

class AirtimeconfirmationWidget extends StatefulWidget {
  const AirtimeconfirmationWidget({
    super.key,
    required this.amount,
    required this.network,
    required this.receipent,
    required this.avalbalance,
  });

  final String? amount;
  final String? network;
  final String? receipent;
  final double? avalbalance;

  @override
  State<AirtimeconfirmationWidget> createState() =>
      _AirtimeconfirmationWidgetState();
}

class _AirtimeconfirmationWidgetState extends State<AirtimeconfirmationWidget> {
  late AirtimeconfirmationModel _model;

  bool _showPinView = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AirtimeconfirmationModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Widget _buildDetailRow(String label, String value,
      {Widget? trailing, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
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
    if (_showPinView) {
      return PaymentpinverifyairtimeWidget(
        amount: widget.amount ?? '0',
        network: widget.network ?? 'MTN',
        receipent: widget.receipent ?? '',
        phoneno: FFAppState().phonenumber,
        avalbalence: widget.avalbalance ?? 0.0,
      );
    }

    final displayAmount = widget.amount ?? '0';
    final formattedAmount =
        displayAmount.startsWith('₦') ? displayAmount : '₦$displayAmount';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 24.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Grab Handle
            Container(
              width: 36.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: const Color(0xFFD6DCD7),
                borderRadius: BorderRadius.circular(999.0),
              ),
            ),
            const SizedBox(height: 16.0),

            Text(
              'Confirm Airtime Purchase',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17.0,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF101614),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 18.0),

            // Big Amount
            Text(
              formattedAmount,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 32.0,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF101614),
                fontFeatures: const [FontFeature.tabularFigures()],
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 6.0),

            // Network pill
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF7EE),
                borderRadius: BorderRadius.circular(999.0),
              ),
              child: Text(
                '${widget.network ?? "Network"} Top-up',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2F8F3C),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Details Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFCFA),
                borderRadius: BorderRadius.circular(18.0),
                border: Border.all(color: const Color(0xFFE6EAE7)),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Recipient',
                    widget.receipent ?? '-',
                    isBold: true,
                  ),
                  const Divider(
                      height: 1.0,
                      thickness: 1.0,
                      color: Color(0xFFEDF0ED)),
                  _buildDetailRow('Network', widget.network ?? '-'),
                  const Divider(
                      height: 1.0,
                      thickness: 1.0,
                      color: Color(0xFFEDF0ED)),
                  _buildDetailRow(
                    'Fee',
                    'Free',
                    trailing: Text(
                      'Free',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2F8F3C),
                      ),
                    ),
                  ),
                  const Divider(
                      height: 1.0,
                      thickness: 1.0,
                      color: Color(0xFFEDF0ED)),
                  _buildDetailRow('Debit from', 'StreetPay Wallet'),
                ],
              ),
            ),

            const SizedBox(height: 22.0),

            // CTA Button
            SizedBox(
              width: double.infinity,
              height: 54.0,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  final amountNum =
                      functions.stringtodouble(widget.amount);
                  final avalBal = widget.avalbalance ?? 0.0;

                  if (avalBal < amountNum) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Insufficient wallet balance (₦${avalBal.toStringAsFixed(2)})',
                          style: GoogleFonts.plusJakartaSans(
                              color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFFD9383A),
                      ),
                    );
                    return;
                  }

                  setState(() => _showPinView = true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF56B84B),
                  foregroundColor: const Color(0xFF06210F),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: Text(
                  'Proceed to PIN',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
