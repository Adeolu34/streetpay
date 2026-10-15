import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'phonere_verification_model.dart';
export 'phonere_verification_model.dart';

class PhonereVerificationWidget extends StatefulWidget {
  const PhonereVerificationWidget({
    super.key,
    String? phoneNumber,
  }) : this.phoneNumber = phoneNumber ?? '+234 ### ### ####';

  final String phoneNumber;

  static String routeName = 'PhonereVerification';
  static String routePath = '/phonereVerification';

  @override
  State<PhonereVerificationWidget> createState() =>
      _PhonereVerificationWidgetState();
}

class _PhonereVerificationWidgetState extends State<PhonereVerificationWidget>
    with CodeAutoFill, WidgetsBindingObserver {
  late PhonereVerificationModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _otpCode = '';
  bool _isVerifying = false;

  // Resend countdown — 60 seconds cooldown
  static const int _resendCooldownSecs = 60;
  int _resendCountdown = _resendCooldownSecs;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _model = createModel(context, () => PhonereVerificationModel());
    _model.pinCodeFocusNode ??= FocusNode();
    _model.timerController.onStartTimer();
    _startCountdown();
    _initSmsListener();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _listenForSmsCode();
    }
  }

  void _initSmsListener() {
    _listenForSmsCode();
  }

  void _listenForSmsCode() {
    try {
      listenForCode();
    } catch (e) {
      debugPrint('SmsAutoFill listenForCode error: $e');
    }
  }

  String? _extractOtp(String text) {
    if (text.isEmpty) return null;
    final sixDigit = RegExp(r'\b(\d{6})\b').firstMatch(text);
    if (sixDigit != null) return sixDigit.group(1);

    final tagged = RegExp(r'(?:otp|code|pin|verification)\D{0,6}(\d{4,6})', caseSensitive: false).firstMatch(text);
    if (tagged != null) return tagged.group(1);

    final splitDigits = RegExp(r'\b(\d{3})\s*[- ]\s*(\d{3})\b').firstMatch(text);
    if (splitDigits != null) return '${splitDigits.group(1)}${splitDigits.group(2)}';

    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 6) return digits;

    return null;
  }

  @override
  void codeUpdated() {
    if (!mounted || _isVerifying) return;
    final incomingCode = code;
    if (incomingCode != null && incomingCode.isNotEmpty) {
      final otp = _extractOtp(incomingCode);
      if (otp != null && otp.length == 6) {
        _applyAndVerifyOtp(otp);
      }
    }
  }

  void _applyAndVerifyOtp(String otp) {
    if (!mounted || _isVerifying) return;
    setState(() {
      _otpCode = otp;
    });
    _model.pinCodeController?.text = otp;
    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}
    _verifyOtp(otp);
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() => _resendCountdown = _resendCooldownSecs);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    try {
      cancel();
      SmsAutoFill().unregisterListener();
    } catch (_) {}
    _model.dispose();
    super.dispose();
  }

  void _onKeyPress(String digit) {
    if (_isVerifying) return;
    if (_otpCode.length < 6) {
      setState(() {
        _otpCode += digit;
      });
      _model.pinCodeController?.text = _otpCode;
      if (_otpCode.length == 6) {
        _verifyOtp(_otpCode);
      }
    }
  }

  void _onDelete() {
    if (_isVerifying) return;
    if (_otpCode.isNotEmpty) {
      setState(() {
        _otpCode = _otpCode.substring(0, _otpCode.length - 1);
      });
      _model.pinCodeController?.text = _otpCode;
    }
  }

  Future<void> _verifyOtp(String otp) async {
    if (_isVerifying) return;
    setState(() => _isVerifying = true);
    _model.pinCodeController?.text = otp;

    try {
      _model.streetauth = await StreetauthCall.call();
      String? token = StreetauthCall.streettoken(
        (_model.streetauth?.jsonBody ?? ''),
      );
      if (token == null || token.isEmpty) {
        token = FFAppState().bsptoken;
      }

      final cleanPhone = functions.removecode(widget.phoneNumber) ?? widget.phoneNumber;

      _model.apiResult11q = await ReverifyotpCall.call(
        phone: cleanPhone,
        accessToken: token,
        otp: otp,
      );

      if (ReverifyotpCall.status((_model.apiResult11q?.jsonBody ?? '')) == true) {
        FFAppState().phonenumber = cleanPhone;
        FFAppState().isLoggedIn = true;
        FFAppState().isRegistered = true;
        safeSetState(() {});
        _model.teirprofile = await ReturntierprofileCall.call(
          phoneno: cleanPhone,
          accessToken: token,
        );

        final isSuccess = ReturntierprofileCall.success((_model.teirprofile?.jsonBody ?? '')) == true;
        final isSecurityStatus = ReturntierprofileCall.securitystatus((_model.teirprofile?.jsonBody ?? '')) == true;

        if (!isSuccess) {
          if (mounted) {
            context.pushNamed(
              EmptyProfileWidget.routeName,
              queryParameters: {
                'phoneno': serializeParam(cleanPhone, ParamType.String),
              }.withoutNulls,
            );
          }
        } else {
          FFAppState().accountno = ReturntierprofileCall.accountNo((_model.teirprofile?.jsonBody ?? '')) ?? '';
          final fn = ReturntierprofileCall.fullname((_model.teirprofile?.jsonBody ?? ''));
          final on = ReturntierprofileCall.othername((_model.teirprofile?.jsonBody ?? ''));
          FFAppState().accountname = (fn != null && fn.trim().isNotEmpty) ? fn.trim() : (on ?? '');
          FFAppState().walletid = ReturntierprofileCall.walletID((_model.teirprofile?.jsonBody ?? '')) ?? '';
          FFAppState().isLoggedIn = true;
          FFAppState().isRegistered = true;
          safeSetState(() {});

          if (isSecurityStatus) {
            FFAppState().accountno = ReturntierprofileCall.accountNo((_model.teirprofile?.jsonBody ?? '')) ?? '';
            FFAppState().phonenumber = cleanPhone;
            FFAppState().walletid = ReturntierprofileCall.walletID((_model.teirprofile?.jsonBody ?? '')) ?? '';
            FFAppState().tier = '1';
            FFAppState().accountname = ReturntierprofileCall.fullname((_model.teirprofile?.jsonBody ?? '')) ?? '';
            FFAppState().isLoggedIn = true;
            FFAppState().isRegistered = true;
            safeSetState(() {});
            if (mounted) context.pushNamed(NewhomeWidget.routeName);
          } else {
            if (mounted) {
              context.pushNamed(
                QuestionaireWidget.routeName,
                queryParameters: {
                  'phone': serializeParam(cleanPhone, ParamType.String),
                }.withoutNulls,
              );
            }
          }
        }
      } else {
        if (mounted) {
          final errorMsg = getJsonField(_model.apiResult11q?.jsonBody, r'''$.Message''')?.toString() ??
              getJsonField(_model.apiResult11q?.jsonBody, r'''$.message''')?.toString() ??
              'Invalid OTP';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMsg,
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(milliseconds: 4000),
              backgroundColor: const Color(0xFFB53434),
            ),
          );
          safeSetState(() {
            _otpCode = '';
            _model.pinCodeController?.clear();
          });
        }
      }
    } catch (e) {
      debugPrint('OTP verification error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification failed. Please check your connection and try again.'),
            backgroundColor: Color(0xFFB53434),
          ),
        );
        safeSetState(() {
          _otpCode = '';
          _model.pinCodeController?.clear();
        });
      }
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
    safeSetState(() {});
  }

  Future<void> _resendOtp() async {
    if (_model.isResending || _resendCountdown > 0) return;
    safeSetState(() => _model.isResending = true);

    try {
      String? token = FFAppState().bsptoken;
      if (token.isEmpty) {
        _model.streetauth = await StreetauthCall.call();
        token = StreetauthCall.streettoken(_model.streetauth?.jsonBody ?? '');
        if (token != null && token.isNotEmpty) {
          FFAppState().bsptoken = token;
        }
      }

      final cleanPhone = functions.removecode(widget.phoneNumber) ?? widget.phoneNumber;
      _model.apiResultkbz = await GetotpfromphoneCall.call(
        phone: cleanPhone,
        accessToken: token ?? '',
        oldphone: FFAppState().phonenumber,
      );

      final isSuccess = GetotpfromphoneCall.status(_model.apiResultkbz?.jsonBody) == true ||
          _model.apiResultkbz?.succeeded == true;

      if (isSuccess) {
        _model.timerController.onResetTimer();
        _model.timerController.onStartTimer();
        _startCountdown();
        _listenForSmsCode();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'OTP sent successfully',
                style: TextStyle(color: Colors.white),
              ),
              duration: Duration(milliseconds: 4000),
              backgroundColor: Color(0xFF2F8F3C),
            ),
          );
        }
      } else {
        final msg = getJsonField(_model.apiResultkbz?.jsonBody, r'''$.Message''')?.toString() ??
            getJsonField(_model.apiResultkbz?.jsonBody, r'''$.message''')?.toString() ??
            'Failed to resend OTP. Please try again.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: const Color(0xFFB53434),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend OTP: $e'),
            backgroundColor: const Color(0xFFB53434),
          ),
        );
      }
    } finally {
      if (mounted) safeSetState(() => _model.isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Step Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(50.0),
                    child: Container(
                      width: 36.0,
                      height: 36.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF3F6F3),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF101614),
                        size: 18.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm your number',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF101614),
                        ),
                      ),
                      Text(
                        'Security verification · one-time code',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6E7A72),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Progress bar (100% security check)
            Container(
              height: 4.0,
              color: const Color(0xFFEDF0ED),
              alignment: Alignment.centerLeft,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.6,
                height: 4.0,
                color: const Color(0xFF56B84B),
              ),
            ),

            const SizedBox(height: 24.0),

            // Header Instructions
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Text(
                      'Enter the 6-digit code',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF101614),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Sent by SMS to ',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6E7A72),
                        ),
                        children: [
                          TextSpan(
                            text: widget.phoneNumber,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF101614),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 26.0),

            // 6 OTP Digit Boxes with hidden AutofillGroup
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Hidden AutofillGroup for iOS QuickType & Android Autofill Service
                  AutofillGroup(
                    child: SizedBox(
                      width: 1,
                      height: 1,
                      child: Opacity(
                        opacity: 0,
                        child: TextField(
                          controller: _model.pinCodeController,
                          focusNode: _model.pinCodeFocusNode,
                          autofillHints: const [AutofillHints.oneTimeCode],
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (val) {
                            if (val.length <= 6) {
                              setState(() {
                                _otpCode = val;
                              });
                              if (val.length == 6) {
                                _verifyOtp(val);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  // Visual 6 digit boxes
                  GestureDetector(
                    onTap: () {
                      _model.pinCodeFocusNode?.requestFocus();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        final hasDigit = index < _otpCode.length;
                        final digit = hasDigit ? _otpCode[index] : '';
                        final isCurrent = index == _otpCode.length;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.5),
                          width: 46.0,
                          height: 56.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAFCFA),
                            borderRadius: BorderRadius.circular(13.0),
                            border: Border.all(
                              color: isCurrent
                                  ? const Color(0xFF56B84B)
                                  : (hasDigit
                                      ? const Color(0xFF101614)
                                      : const Color(0xFFE6EAE7)),
                              width: isCurrent ? 2.0 : 1.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              digit,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 21.0,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF101614),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // Auto-detection status indicator
            const SizedBox(height: 12.0),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14.0, vertical: 7.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF6EC),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: const Color(0xFF56B84B).withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isVerifying) ...[
                      const SizedBox(
                        width: 13,
                        height: 13,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF2F8F3C)),
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        'Verifying code...',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2F8F3C),
                        ),
                      ),
                    ] else if (_otpCode.length == 6) ...[
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 14.0,
                        color: Color(0xFF2F8F3C),
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        'Code detected',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2F8F3C),
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.sms_outlined,
                        size: 14.0,
                        color: Color(0xFF2F8F3C),
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        'Auto-detecting incoming SMS...',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2F8F3C),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18.0),

            // Resend countdown / button
            Center(
              child: _resendCountdown > 0
                  ? Text(
                      'Resend code in ${_resendCountdown}s',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9EAAA0),
                      ),
                    )
                  : InkWell(
                      onTap: _model.isResending ? null : _resendOtp,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: _model.isResending
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF2F8F3C),
                                ),
                              )
                            : Text(
                                'Resend code',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2F8F3C),
                                ),
                              ),
                      ),
                    ),
            ),

            // Inline Verifying indicator
            if (_isVerifying) ...[
              const SizedBox(height: 14.0),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 14.0,
                      height: 14.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF56B84B)),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Verifying code...',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF56B84B),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Spacer(),

            // Custom On-Screen 3×4 Keypad
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 18.0),
              color: Colors.white,
              child: Column(
                children: [
                  _buildKeypadRow(['1', '2', '3']),
                  const SizedBox(height: 6.0),
                  _buildKeypadRow(['4', '5', '6']),
                  const SizedBox(height: 6.0),
                  _buildKeypadRow(['7', '8', '9']),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      const Expanded(child: SizedBox(height: 52.0)),
                      const SizedBox(width: 6.0),
                      Expanded(child: _buildKeypadButton('0')),
                      const SizedBox(width: 6.0),
                      Expanded(
                        child: InkWell(
                          onTap: _onDelete,
                          borderRadius: BorderRadius.circular(12.0),
                          child: Container(
                            height: 52.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F8F6),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.backspace_outlined,
                                color: Color(0xFF101614),
                                size: 22.0,
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
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      children: [
        Expanded(child: _buildKeypadButton(keys[0])),
        const SizedBox(width: 6.0),
        Expanded(child: _buildKeypadButton(keys[1])),
        const SizedBox(width: 6.0),
        Expanded(child: _buildKeypadButton(keys[2])),
      ],
    );
  }

  Widget _buildKeypadButton(String key) {
    return InkWell(
      onTap: () => _onKeyPress(key),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        height: 52.0,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8F6),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Text(
            key,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 21.0,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF101614),
            ),
          ),
        ),
      ),
    );
  }
}
