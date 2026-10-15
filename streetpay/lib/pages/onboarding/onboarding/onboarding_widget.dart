import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'onboarding_model.dart';
export 'onboarding_model.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({super.key});

  static String routeName = 'Onboarding';
  static String routePath = '/onboarding1';

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  late OnboardingModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentPage = 0;
  bool _isLoading = false;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Easy, fast and trusted',
      'body':
          'Cashless payments that land instantly, backed by a 9PSB licensed wallet.',
      'tint': '0xFFF0F7F0',
      'icon': 'lightning',
    },
    {
      'title': 'Discover who is around you',
      'body':
          'Pay verified traders, motorists and stores nearby without asking for an account number.',
      'tint': '0xFFEDF7EE',
      'icon': 'radar',
    },
    {
      'title': 'Let someone else pay the bill',
      'body':
          'Create a bill for school fees or rent, send it to whoever is paying, and track it until it is settled.',
      'tint': '0xFFF3F6F3',
      'icon': 'receipt',
    },
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingModel());
    _model.pageViewController ??= PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleFinishOnboarding() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      _model.authh = await StreetauthCall.call();
      _model.appversion = await actions.getappversion();
      _model.update = await GetUPDATECall.call(
        version: _model.appversion,
        accessToken: StreetauthCall.streettoken(
          (_model.authh?.jsonBody ?? ''),
        ),
      );

      FFAppState().updatereq = GetUPDATECall.ismacth(
        (_model.update?.jsonBody ?? ''),
      )!;
      FFAppState().bsptoken = StreetauthCall.streettoken(
        (_model.authh?.jsonBody ?? ''),
      )!;
      safeSetState(() {});

      if (FFAppState().phonenumber != '') {
        _model.deviceid = await actions.getdeviceid();
        FFAppState().deviceid = _model.deviceid!;
        safeSetState(() {});
        if (mounted) {
          context.pushNamed(LoginbiometricWidget.routeName);
        }
      } else {
        _model.deviceid2 = await actions.getdeviceid();
        FFAppState().deviceid = _model.deviceid2!;
        safeSetState(() {});
        if (mounted) {
          context.pushNamed(SignUpWidget.routeName);
        }
      }
    } catch (e) {
      if (mounted) {
        context.pushNamed(SignUpWidget.routeName);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildSlideGraphic(int index) {
    final tintColor = Color(int.parse(_slides[index]['tint']!));
    return Container(
      width: double.infinity,
      height: 280.0,
      decoration: BoxDecoration(
        color: tintColor,
        borderRadius: BorderRadius.circular(26.0),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 210.0,
            height: 210.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF2F8F3C).withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
          ),
          Container(
            width: 140.0,
            height: 140.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF2F8F3C).withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68.0,
                height: 68.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF0B2018),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0B2018).withValues(alpha: 0.2),
                      blurRadius: 16.0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    index == 0
                        ? Icons.bolt_rounded
                        : (index == 1
                            ? Icons.radar_rounded
                            : Icons.receipt_long_rounded),
                    color: const Color(0xFF56B84B),
                    size: 34.0,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'StreetPay',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0B2018),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Skip Action
                Padding(
                  padding: const EdgeInsets.only(top: 14.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => context.pushNamed(SignUpWidget.routeName),
                        borderRadius: BorderRadius.circular(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Text(
                            'Skip',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF6E7A72),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _model.pageViewController,
                    itemCount: _slides.length,
                    onPageChanged: (idx) {
                      setState(() => _currentPage = idx);
                    },
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12.0),
                            _buildSlideGraphic(index),
                            const SizedBox(height: 32.0),
                            Text(
                              slide['title']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 28.0,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF101614),
                                letterSpacing: -0.8,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              slide['body']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6E7A72),
                                height: 1.55,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Animated Pill Dots
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 7.0),
                        width: _currentPage == i ? 26.0 : 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? const Color(0xFF56B84B)
                              : const Color(0xFFDCE4DD),
                          borderRadius: BorderRadius.circular(999.0),
                        ),
                      ),
                    ),
                  ),
                ),

                // Primary CTA Button
                FFButtonWidget(
                  onPressed: () async {
                    if (_currentPage < _slides.length - 1) {
                      await _model.pageViewController!.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      await _handleFinishOnboarding();
                    }
                  },
                  text: _isLoading
                      ? 'Please wait...'
                      : (_currentPage >= _slides.length - 1
                          ? 'Create my wallet'
                          : 'Continue'),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 54.0,
                    color: const Color(0xFF56B84B),
                    textStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF06210F),
                    ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),

                // Secondary Sign In Link
                Padding(
                  padding: const EdgeInsets.only(top: 14.0, bottom: 20.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        if (FFAppState().phonenumber != '') {
                          context.pushNamed(LoginbiometricWidget.routeName);
                        } else {
                          context.pushNamed(Login1Widget.routeName);
                        }
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6E7A72),
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign in',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF2F8F3C),
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
          ),
        ),
      ),
    );
  }
}
