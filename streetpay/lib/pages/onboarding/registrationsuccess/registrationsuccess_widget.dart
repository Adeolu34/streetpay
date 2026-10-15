import '/flutter_flow/flutter_flow_util.dart';
import '/services/tts_service.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'registrationsuccess_model.dart';
export 'registrationsuccess_model.dart';

class RegistrationsuccessWidget extends StatefulWidget {
  const RegistrationsuccessWidget({super.key});

  static String routeName = 'registrationsuccess';
  static String routePath = '/registrationsuccess';

  @override
  State<RegistrationsuccessWidget> createState() =>
      _RegistrationsuccessWidgetState();
}

class _RegistrationsuccessWidgetState extends State<RegistrationsuccessWidget>
    with SingleTickerProviderStateMixin {
  late RegistrationsuccessModel _model;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegistrationsuccessModel());

    // Mark user as registered so splash routes to login on next app open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FFAppState().isRegistered = true;
    });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            TtsService.instance.walkthroughNewUser(
              name: FFAppState().accountname,
              accountNo: FFAppState().accountno,
            );
          }
        });
      }
    });
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _model.dispose();
    super.dispose();
  }

  void _copyAccountNumber(String accountNo) {
    Clipboard.setData(ClipboardData(text: accountNo));
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Account number copied to clipboard',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF1E4230),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final accountNo = FFAppState().accountno.isNotEmpty
        ? FFAppState().accountno
        : '1100 234 987';
    final firstName = FFAppState().accountname.isNotEmpty
        ? FFAppState().accountname.split(' ').first
        : 'Adaeze';

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF0B2018),
      body: Stack(
        children: [
          // Top right subtle radial glow
          Positioned(
            top: -90.0,
            right: -100.0,
            child: Container(
              width: 320.0,
              height: 320.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x4D56B84B),
                    Color(0x0056B84B),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 36.0),

                  // Animated Checkmark Success Badge
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 84.0,
                      height: 84.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF56B84B),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x4056B84B),
                            blurRadius: 24.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF06210F),
                        size: 42.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22.0),

                  // Headline & Welcome Subtitle
                  Text(
                    'Your wallet is live',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.7,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Welcome, $firstName. This is your 9PSB StreetPay account number — people can pay you with it right away.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF8FA596),
                        height: 1.55,
                      ),
                    ),
                  ),
                  const SizedBox(height: 26.0),

                  // Account Number Showcase Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF12362A),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: const Color(0xFF22513A),
                        width: 1.2,
                      ),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'YOUR ACCOUNT NUMBER',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF8FB3A0),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          accountNo,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _copyAccountNumber(accountNo),
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Container(
                                    height: 42.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF56B84B),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.copy_rounded,
                                          color: Color(0xFF06210F),
                                          size: 16.0,
                                        ),
                                        const SizedBox(width: 6.0),
                                        Text(
                                          'Copy',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF06210F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _copyAccountNumber(accountNo),
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Container(
                                    height: 42.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: const Color(0xFF2C6045),
                                        width: 1.0,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.share_outlined,
                                          color: Color(0xFFCFE3D6),
                                          size: 16.0,
                                        ),
                                        const SizedBox(width: 6.0),
                                        Text(
                                          'Share',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFFCFE3D6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18.0),

                  // Quick Action 1: Add your first money
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.pushNamed(NewhomeWidget.routeName);
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF112B20),
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(
                            color: const Color(0xFF1E4230),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32.0,
                              height: 32.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D4331),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.arrow_upward_rounded,
                                color: Color(0xFF7FD472),
                                size: 18.0,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Text(
                                'Add your first money',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF7FD472),
                              size: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Quick Action 2: Raise your limit to ₦3m
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.pushNamed(TeirpageWidget.routeName);
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF112B20),
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(
                            color: const Color(0xFF1E4230),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32.0,
                              height: 32.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D4331),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.shield_outlined,
                                color: Color(0xFF7FD472),
                                size: 18.0,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Text(
                                'Raise your limit to ₦3m',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF7FD472),
                              size: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Bottom Action Button: Proceed to Login
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56.0,
                      child: ElevatedButton(
                        onPressed: () {
                          // Route to login — biometric if phone is saved, else standard login
                          if (FFAppState().phonenumber.isNotEmpty) {
                            context.goNamed(LoginbiometricWidget.routeName);
                          } else {
                            context.goNamed(Login1Widget.routeName);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF56B84B),
                          foregroundColor: const Color(0xFF06210F),
                          elevation: 0.0,
                          shadowColor: const Color(0x4056B84B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: Text(
                          'Go to Login',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF06210F),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
