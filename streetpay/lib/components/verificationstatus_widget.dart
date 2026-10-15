import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'verificationstatus_model.dart';
export 'verificationstatus_model.dart';

class VerificationstatusWidget extends StatefulWidget {
  const VerificationstatusWidget({
    super.key,
    String? status,
    String? reason,
  })  : this.status = status ?? 'Declined',
        this.reason = reason ?? 'Try again';

  final String status;
  final String reason;

  @override
  State<VerificationstatusWidget> createState() =>
      _VerificationstatusWidgetState();
}

class _VerificationstatusWidgetState extends State<VerificationstatusWidget> {
  late VerificationstatusModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VerificationstatusModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.status != 'Declined' && widget.reason.isNotEmpty;
    final isPending = widget.status == 'Pending' ||
        widget.status == 'Processing' ||
        widget.status == 'Under Review';

    final Color iconBg = isSuccess
        ? const Color(0xFFEDF7EE)
        : isPending
            ? const Color(0xFFFFF8E1)
            : const Color(0xFFFFEDED);

    final Color iconColor = isSuccess
        ? const Color(0xFF2F8F3C)
        : isPending
            ? const Color(0xFFE6A817)
            : const Color(0xFFD32F2F);

    final IconData statusIcon = isSuccess
        ? Icons.verified_rounded
        : isPending
            ? Icons.hourglass_top_rounded
            : Icons.cancel_rounded;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top bar
            Container(
              height: 5,
              width: 40,
              margin: const EdgeInsets.only(top: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFD6DDD8),
                borderRadius: BorderRadius.circular(3),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: iconBg,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(statusIcon, color: iconColor, size: 40),
                  ),

                  const SizedBox(height: 20),

                  // Status title
                  Text(
                    valueOrDefault<String>(widget.status, 'Processing'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF101614),
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Reason/message
                  Text(
                    widget.reason,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6E7A72),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Status pill
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      isSuccess
                          ? 'Upgrade approved'
                          : isPending
                              ? 'Under review'
                              : 'Upgrade not approved',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: iconColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Divider
                  const Divider(
                      height: 1, thickness: 0.5, color: Color(0xFFEDF0ED)),

                  const SizedBox(height: 20),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B2018),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Got it',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  if (isSuccess) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          context.pushNamed(NewhomeWidget.routeName);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE6EAE7)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Go to Home',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6E7A72),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
