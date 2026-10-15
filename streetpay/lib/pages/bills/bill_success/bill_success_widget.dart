import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bill_success_model.dart';
export 'bill_success_model.dart';

class BillSuccessWidget extends StatefulWidget {
  const BillSuccessWidget({super.key});

  static String routeName = 'BillSuccess';
  static String routePath = '/billSuccess';

  @override
  State<BillSuccessWidget> createState() => _BillSuccessWidgetState();
}

class _BillSuccessWidgetState extends State<BillSuccessWidget> {
  late BillSuccessModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BillSuccessModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFFFFFFFF),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // SUCCESS ICON WITH GLOW
                  Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDF7EE),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xFF56B84B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // TITLE & SUBTITLE
                  Text(
                    'Bill Sent Successfully',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF101614),
                      fontSize: 22.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'The recipient has received an instant push notification with bill details to review and pay.',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF6E7A72),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 28),

                  // STATUS INFO CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFCFA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE6EAE7)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF8EC),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.schedule_rounded,
                            color: Color(0xFFD97706),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Awaiting Recipient Approval',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF101614),
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Funds will be deposited directly to your wallet once approved.',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF6E7A72),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // RETURN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        context.goNamed(
                          NewhomeWidget.routeName,
                          extra: <String, dynamic>{
                            '__transition_info__': const TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.leftToRight,
                            ),
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF56B84B),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Back to Home',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF06210F),
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
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
}
