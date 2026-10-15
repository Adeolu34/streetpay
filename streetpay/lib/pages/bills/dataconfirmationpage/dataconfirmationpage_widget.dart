import '/backend/api_requests/api_calls.dart';
import '/components/paymentpinverifytopup_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'dataconfirmationpage_model.dart';
export 'dataconfirmationpage_model.dart';

class DataconfirmationpageWidget extends StatefulWidget {
  const DataconfirmationpageWidget({
    super.key,
    required this.amount,
    required this.network,
    required this.receipent,
    required this.productId,
    required this.dataplan,
  });

  final String? amount;
  final String? network;
  final String? receipent;
  final String? productId;
  final String? dataplan;

  @override
  State<DataconfirmationpageWidget> createState() =>
      _DataconfirmationpageWidgetState();
}

class _DataconfirmationpageWidgetState
    extends State<DataconfirmationpageWidget> {
  late DataconfirmationpageModel _model;
  bool _showPinView = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DataconfirmationpageModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.streetauth = await StreetauthCall.call();
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Widget _buildDetailRow(String label, String value, {Widget? trailing, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6E7A72),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: trailing ??
                Text(
                  value,
                  textAlign: TextAlign.end,
                  softWrap: true,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
                    color: const Color(0xFF101614),
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showPinView) {
      return PaymentpinverifytopupWidget(
        amount: widget.amount!,
        network: widget.network!,
        receipent: widget.receipent!,
        productId: widget.productId!,
        dataplan: widget.dataplan!,
        phoneno: FFAppState().phonenumber,
        avalbal: functions.stringtodouble(FFAppState().avalbal),
      );
    }

    final displayAmount = widget.amount ?? '0';
    final formattedAmount = displayAmount.startsWith('₦') ? displayAmount : '₦$displayAmount';

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
              'Confirm Data Purchase',
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
            // Pill Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF7EE),
                borderRadius: BorderRadius.circular(999.0),
              ),
              child: Text(
                '${widget.network ?? "Network"} Data',
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
                border: Border.all(
                  color: const Color(0xFFE6EAE7),
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Recipient',
                    widget.receipent ?? '-',
                    isBold: true,
                  ),
                  const Divider(height: 1.0, thickness: 1.0, color: Color(0xFFEDF0ED)),
                  _buildDetailRow('Network', widget.network ?? '-'),
                  const Divider(height: 1.0, thickness: 1.0, color: Color(0xFFEDF0ED)),
                  _buildDetailRow('Plan', widget.dataplan ?? '-'),
                  const Divider(height: 1.0, thickness: 1.0, color: Color(0xFFEDF0ED)),
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
                  const Divider(height: 1.0, thickness: 1.0, color: Color(0xFFEDF0ED)),
                  _buildDetailRow('Debit from', 'StreetPay Wallet'),
                ],
              ),
            ),

            const SizedBox(height: 22.0),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              height: 54.0,
              child: ElevatedButton(
                onPressed: () async {
                  final avalBal = functions.stringtodouble(FFAppState().avalbal);
                  final amountNum = functions.stringtodouble(widget.amount);

                  if (avalBal >= amountNum) {
                    setState(() {
                      _showPinView = true;
                    });
                  } else {
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
