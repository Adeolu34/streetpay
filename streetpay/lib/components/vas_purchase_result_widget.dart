import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/index.dart';

/// A premium bottom-sheet widget shown after an airtime or data purchase.
/// Displays a success or failure state with transaction details.
class VasPurchaseResultWidget extends StatelessWidget {
  const VasPurchaseResultWidget({
    super.key,
    required this.isSuccess,
    required this.title,
    required this.message,
    required this.amount,
    required this.recipient,
    required this.serviceType,
    required this.transactionRef,
  });

  final bool isSuccess;
  final String title;
  final String message;
  final String amount;
  final String recipient;
  final String serviceType;
  final String transactionRef;

  @override
  Widget build(BuildContext context) {
    final formattedAmount = amount.startsWith('?') ? amount : '?$amount';
    final now = DateTime.now();
    final dateStr =
        '${now.day} ${_monthName(now.month)} ${now.year}, ${_pad(now.hour)}:${_pad(now.minute)}';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.0),
          topRight: Radius.circular(28.0),
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
              // Drag Handle
              Container(
                width: 36.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6DCD7),
                  borderRadius: BorderRadius.circular(999.0),
                ),
              ),
              const SizedBox(height: 24.0),

              // Status Icon
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: isSuccess
                      ? const Color(0xFFEDF7EE)
                      : const Color(0xFFFEEEEE),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 54.0,
                  height: 54.0,
                  decoration: BoxDecoration(
                    color: isSuccess
                        ? const Color(0xFF56B84B)
                        : const Color(0xFFD9383A),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_rounded : Icons.close_rounded,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
              const SizedBox(height: 18.0),

              // Title
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF101614),
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),

              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6E7A72),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22.0),

              // Transaction Detail Card
              if (isSuccess)
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
                      _buildRow('Service', serviceType),
                      const SizedBox(height: 10.0),
                      _buildRow('Recipient', recipient),
                      const SizedBox(height: 10.0),
                      _buildRow('Amount', formattedAmount, isBold: true),
                      const SizedBox(height: 10.0),
                      _buildRow('Date', dateStr),
                      const SizedBox(height: 10.0),
                      _buildRow(
                          'Reference',
                          transactionRef.length > 16
                              ? '${transactionRef.substring(0, 16)}...'
                              : transactionRef),
                    ],
                  ),
                ),

              const SizedBox(height: 24.0),

              // Primary Action Button
              SizedBox(
                width: double.infinity,
                height: 54.0,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil(
                      (route) =>
                          route.settings.name == NewhomeWidget.routeName),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuccess
                        ? const Color(0xFF56B84B)
                        : const Color(0xFF101614),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    isSuccess ? 'Done' : 'Go Home',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              if (!isSuccess) ...[
                const SizedBox(height: 12.0),
                SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2F8F3C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: Text(
                      'Try Again',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6E7A72),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.0,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: const Color(0xFF101614),
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}
