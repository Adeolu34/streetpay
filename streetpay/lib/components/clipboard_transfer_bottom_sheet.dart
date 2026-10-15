import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/services/clipboard_detection_service.dart';

class ClipboardTransferBottomSheet extends StatelessWidget {
  final String accountNumber;

  const ClipboardTransferBottomSheet({
    super.key,
    required this.accountNumber,
  });

  String _formatAccountNumber(String raw) {
    if (raw.length == 10) {
      return '${raw.substring(0, 4)} ${raw.substring(4, 7)} ${raw.substring(7)}';
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 28.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 38.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: const Color(0xFFD4DBD6),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            const SizedBox(height: 20.0),

            // Icon Header
            Container(
              width: 54.0,
              height: 54.0,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF7EE),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF2F8F3C).withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.content_paste_go_rounded,
                color: Color(0xFF2F8F3C),
                size: 26.0,
              ),
            ),
            const SizedBox(height: 14.0),

            // Title
            Text(
              'Account Number Detected',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF101614),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6.0),

            // Subtitle
            Text(
              'We detected a copied 10-digit account number. Would you like to make a transfer to this account?',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6E7A72),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18.0),

            // Formatted Account Number Pill Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF6FAF6),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: const Color(0xFFD3E7D6),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2F8F3C),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.tag_rounded,
                      color: Colors.white,
                      size: 14.0,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    _formatAccountNumber(accountNumber),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF101614),
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22.0),

            // Action Buttons
            Row(
              children: [
                // Dismiss Button
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: () {
                      ClipboardDetectionService.suppress(accountNumber);
                      Navigator.of(context).pop(false);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      side: const BorderSide(color: Color(0xFFD4DBD6), width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                    child: Text(
                      'Not Now',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6E7A72),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),

                // Transfer Button
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () {
                      ClipboardDetectionService.suppress(accountNumber);
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F8F3C),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Transfer Now',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
