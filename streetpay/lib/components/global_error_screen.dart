import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/components/smart_support_modal_widget.dart';

/// Custom global error screen that replaces Flutter's default release-mode grey screen.
/// Designed to provide immediate reassurance, clear actions, and self-service diagnostics.
class GlobalErrorScreen extends StatefulWidget {
  const GlobalErrorScreen({
    super.key,
    this.details,
    this.message,
    this.onRetry,
  });

  final FlutterErrorDetails? details;
  final String? message;
  final VoidCallback? onRetry;

  @override
  State<GlobalErrorScreen> createState() => _GlobalErrorScreenState();
}

class _GlobalErrorScreenState extends State<GlobalErrorScreen> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF00A651);
    const darkBackground = Color(0xFF14181B);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF1F4F8),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon Header
                  Container(
                    width: 72.0,
                    height: 72.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFFCDD2), width: 1.5),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFD32F2F),
                        size: 38.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Title
                  Text(
                    'Something Went Wrong',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: darkBackground,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Reassurance subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'An unexpected glitch occurred while displaying this view. Don\'t worry—your funds and account details are completely safe.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14.0,
                        color: const Color(0xFF57636C),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28.0),

                  // Main Action: Return Home
                  SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () {
                        if (widget.onRetry != null) {
                          widget.onRetry!();
                        } else {
                          // Safe navigation to root
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/',
                            (route) => false,
                          );
                        }
                      },
                      icon: const Icon(Icons.home_rounded, size: 20.0),
                      label: Text(
                        'Return to Home',
                        style: GoogleFonts.inter(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  // Secondary Action: Diagnostic Support
                  SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: darkBackground,
                        side: const BorderSide(color: Color(0xFFD0D9E8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => const SmartSupportModalWidget(),
                        );
                      },
                      icon: const Icon(Icons.support_agent_rounded, size: 20.0, color: brandGreen),
                      label: Text(
                        'Open Help & Diagnostic Assistant',
                        style: GoogleFonts.inter(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Technical details toggle (helpful for developers)
                  if (widget.details != null || widget.message != null) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showDetails = !_showDetails;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _showDetails ? 'Hide technical info' : 'View technical info',
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: const Color(0xFF8F9BB3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            _showDetails ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            color: const Color(0xFF8F9BB3),
                            size: 18.0,
                          ),
                        ],
                      ),
                    ),
                    if (_showDetails) ...[
                      const SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9ECEF),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: const Color(0xFFCED4DA)),
                        ),
                        child: SelectableText(
                          widget.message ?? widget.details?.exceptionAsString() ?? 'Unknown error',
                          style: GoogleFonts.firaCode(
                            fontSize: 11.0,
                            color: const Color(0xFF333333),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
