import 'dart:async';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'resetpassword_model.dart';
export 'resetpassword_model.dart';

class ResetpasswordWidget extends StatefulWidget {
  const ResetpasswordWidget({super.key});

  static String routeName = 'resetpassword';
  static String routePath = '/resetpassword';

  @override
  State<ResetpasswordWidget> createState() => _ResetpasswordWidgetState();
}

class _ResetpasswordWidgetState extends State<ResetpasswordWidget>
    with CodeAutoFill, WidgetsBindingObserver {
  late ResetpasswordModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOtpVerifying = false;
  String? _lastReceivedOtp;
  int _resendCountdown = 0;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _model = createModel(context, () => ResetpasswordModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.strretauth = await StreetauthCall.call();

      _model.questions = await GetsecretquestionsCall.call(
        accessToken: StreetauthCall.streettoken(
          (_model.strretauth?.jsonBody ?? ''),
        ),
      );

      FFAppState().accountvalidation = false;
      safeSetState(() {});
    });

    _model.phonenoTextController ??= TextEditingController();
    _model.phonenoFocusNode ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.pinCodeController ??= TextEditingController();
    _model.pinCodeFocusNode ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.textController4!.addListener(() => safeSetState(() {}));

    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();
    _model.textController5!.addListener(() => safeSetState(() {}));

    _initSmsListener();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _listenForSmsCode();
    }
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

  void _initSmsListener() {
    _listenForSmsCode();
  }

  void _listenForSmsCode() {
    try {
      listenForCode();
    } catch (e) {
      debugPrint('[ResetPassword] SmsAutoFill listenForCode error: $e');
    }
  }

  String? _extractOtp(String text) {
    if (text.isEmpty) return null;
    // 1. Direct 6 digits
    final sixDigit = RegExp(r'\b(\d{6})\b').firstMatch(text);
    if (sixDigit != null) return sixDigit.group(1);

    // 2. Tagged: otp/code/pin followed by 6 digits
    final tagged = RegExp(r'(?:otp|code|pin|verification)\D{0,6}(\d{4,6})', caseSensitive: false).firstMatch(text);
    if (tagged != null) return tagged.group(1);

    // 3. Formatted: 123-456 or 123 456
    final splitDigits = RegExp(r'\b(\d{3})\s*[- ]\s*(\d{3})\b').firstMatch(text);
    if (splitDigits != null) return '${splitDigits.group(1)}${splitDigits.group(2)}';

    // 4. Cleaned digits exact 6
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 6) return digits;

    return null;
  }

  void _handleIncomingOtp(String raw) {
    final otp = _extractOtp(raw) ?? (raw.length == 6 && RegExp(r'^\d{6}$').hasMatch(raw) ? raw : null);
    if (otp == null || otp.length != 6) return;
    if (_lastReceivedOtp == otp && (_model.pinCodeController?.text == otp)) return;

    debugPrint('[ResetPassword] Extracted OTP successfully');
    _lastReceivedOtp = otp;

    safeSetState(() {
      _model.optuse = true;
      _model.pinCodeController?.text = otp;
    });

    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}

    _verifyResetOtp(otp);
  }

  @override
  void codeUpdated() {
    if (!mounted || _isOtpVerifying) return;
    final incomingCode = code;
    debugPrint('[ResetPassword] SmsAutoFill codeUpdated event received');
    if (incomingCode != null && incomingCode.isNotEmpty) {
      _handleIncomingOtp(incomingCode);
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    safeSetState(() => _resendCountdown = 60);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      safeSetState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          t.cancel();
        }
      });
    });
  }

  Future<void> _sendResetOtp() async {
    if (_resendCountdown > 0) return;
    final rawPhone = _model.phonenoTextController.text.trim();
    final phone = functions.removecode(rawPhone) ?? '';
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your phone number first.'),
          backgroundColor: Color(0xFFB53434),
        ),
      );
      return;
    }
    safeSetState(() => _model.isOtpLoading = true);
    try {
      _listenForSmsCode();

      String? token = StreetauthCall.streettoken(_model.strretauth?.jsonBody ?? '');
      if (token == null || token.isEmpty) {
        _model.strretauth = await StreetauthCall.call();
        token = StreetauthCall.streettoken(_model.strretauth?.jsonBody ?? '');
      }

      _model.otpget = await GetotpfromphoneCall.call(
        phone: phone,
        accessToken: token ?? '',
        oldphone: phone,
      );

      final isSuccess = GetotpfromphoneCall.status(_model.otpget?.jsonBody) == true ||
          _model.otpget?.succeeded == true;
      if (isSuccess) {
        _model.optuse = true;
        _startCountdown();

        // If an OTP arrived while request was sending, apply it now
        if (_lastReceivedOtp != null && _lastReceivedOtp!.length == 6) {
          safeSetState(() {
            _model.pinCodeController?.text = _lastReceivedOtp!;
          });
          _verifyResetOtp(_lastReceivedOtp!);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent. Auto-detecting incoming SMS...'),
            backgroundColor: Color(0xFF56B84B),
          ),
        );
      } else {
        final msg = getJsonField(_model.otpget?.jsonBody, r'''$.Message''')?.toString() ??
            getJsonField(_model.otpget?.jsonBody, r'''$.message''')?.toString() ??
            'Failed to send OTP. Please check your phone number and try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: const Color(0xFFB53434),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending OTP: $e'),
          backgroundColor: const Color(0xFFB53434),
        ),
      );
    } finally {
      safeSetState(() => _model.isOtpLoading = false);
    }
  }

  Future<void> _verifyResetOtp(String otp) async {
    if (_isOtpVerifying) return;
    setState(() => _isOtpVerifying = true);
    try {
      String? token = StreetauthCall.streettoken(_model.strretauth?.jsonBody ?? '');
      if (token == null || token.isEmpty) {
        _model.strretauth = await StreetauthCall.call();
        token = StreetauthCall.streettoken(_model.strretauth?.jsonBody ?? '');
      }

      _model.verifyotp = await ReverifyotpCall.call(
        phone: functions.removecode(_model.phonenoTextController.text),
        accessToken: token ?? '',
        otp: otp,
      );

      if (!mounted) return;

      if (ReverifyotpCall.status((_model.verifyotp?.jsonBody ?? '')) == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP verified successfully.'),
            backgroundColor: Color(0xFF56B84B),
          ),
        );
        await _model.columnController?.animateTo(
          _model.columnController!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        final errorMsg = getJsonField(_model.verifyotp?.jsonBody, r'''$.Message''')?.toString() ??
            getJsonField(_model.verifyotp?.jsonBody, r'''$.message''')?.toString() ??
            'Invalid OTP. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: const Color(0xFFB53434),
          ),
        );
      }
      safeSetState(() {});
    } finally {
      if (mounted) setState(() => _isOtpVerifying = false);
    }
  }

  // ── Shared input decoration ──────────────────────────────────────────────

  InputDecoration _inputDeco({
    required String hint,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        color: const Color(0xFF7F9A89).withValues(alpha: 0.6),
      ),
      border: InputBorder.none,
      isDense: true,
      contentPadding: EdgeInsets.zero,
      suffixIcon: suffix,
    );
  }

  TextStyle _inputTextStyle() => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  Widget _fieldLabel(String text) => Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF7F9A89),
          letterSpacing: 0.8,
        ),
      );

  Widget _dividerLine() => Container(
        height: 1,
        color: const Color(0xFF1E4230),
      );

  Widget _card({required List<Widget> children}) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF112B20),
          border: Border.all(color: const Color(0xFF1E4230)),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );

  Widget _stepBadge(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF1E4230),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF7FD472),
            letterSpacing: 0.6,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final bool otpVerified = ReverifyotpCall.status(
          (_model.verifyotp?.jsonBody ?? ''),
        ) ==
        true;

    final bool showNewPin =
        FFAppState().questionvalidation == true || otpVerified;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF0B2018),
        body: Stack(
          children: [
            // Radial glow
            Positioned(
              top: -90,
              right: -110,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF56B84B).withValues(alpha: 0.28),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                controller: _model.columnController,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),

                    // Back + logo row
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.safePop(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF152F23),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: Color(0xFF7FD472),
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF152F23),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.bolt_rounded,
                              color: Color(0xFF56B84B),
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Reset your PIN',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.6,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Verify your identity to set a new 5-digit PIN.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF8FA596),
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── STEP 1: Phone + Date of birth ────────────────────
                    _card(children: [
                      Row(
                        children: [
                          _fieldLabel('STEP 1'),
                          const SizedBox(width: 8),
                          _stepBadge('PHONE & DATE OF BIRTH'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _dividerLine(),
                      const SizedBox(height: 16),

                      _fieldLabel('PHONE NUMBER'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _model.phonenoTextController,
                        focusNode: _model.phonenoFocusNode,
                        readOnly: FFAppState().accountvalidation,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 11,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        style: _inputTextStyle(),
                        decoration: _inputDeco(hint: '08012345678').copyWith(
                          counterText: '',
                          suffixIcon: FFAppState().accountvalidation
                              ? const Icon(Icons.check_circle_rounded,
                                  color: Color(0xFF56B84B), size: 18)
                              : null,
                        ),
                        validator: _model.phonenoTextControllerValidator
                            .asValidator(context),
                      ),

                      const SizedBox(height: 16),
                      _dividerLine(),
                      const SizedBox(height: 16),

                      _fieldLabel('DATE OF BIRTH'),
                      const SizedBox(height: 12),

                      // DOB dropdowns
                      Row(
                        children: [
                          Expanded(
                            child: _dobDropdown(
                              controller: _model.dropDownValueController1 ??=
                                  FormFieldController<String>(null),
                              hint: 'Day',
                              options: List.generate(
                                  31,
                                  (i) =>
                                      (i + 1).toString().padLeft(2, '0')),
                              onChanged: (val) => safeSetState(
                                  () => _model.dropDownValue1 = val),
                              disabled: FFAppState().accountvalidation,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _dobDropdown(
                              controller: _model.dropDownValueController2 ??=
                                  FormFieldController<String>(null),
                              hint: 'Month',
                              options: List.generate(
                                  12,
                                  (i) =>
                                      (i + 1).toString().padLeft(2, '0')),
                              onChanged: (val) => safeSetState(
                                  () => _model.dropDownValue2 = val),
                              disabled: FFAppState().accountvalidation,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _dobDropdown(
                              controller: _model.dropDownValueController3 ??=
                                  FormFieldController<String>(null),
                              hint: 'Year',
                              options: functions.getyears()!,
                              onChanged: (val) => safeSetState(
                                  () => _model.dropDownValue3 = val),
                              disabled: FFAppState().accountvalidation,
                            ),
                          ),
                        ],
                      ),

                      if (!FFAppState().accountvalidation) ...[
                        const SizedBox(height: 20),
                        FFButtonWidget(
                          onPressed: () async {
                            final phone = _model.phonenoTextController.text.trim();
                            if (phone.isEmpty || phone.length < 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a valid phone number'),
                                  backgroundColor: Color(0xFFB53434),
                                ),
                              );
                              return;
                            }
                            if (_model.dropDownValue1 == null || _model.dropDownValue2 == null || _model.dropDownValue3 == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select your complete date of birth (Day, Month, Year)'),
                                  backgroundColor: Color(0xFFB53434),
                                ),
                              );
                              return;
                            }
                            _model.tierone =
                                await ReturntierprofileCall.call(
                              phoneno: functions.removecode(
                                  _model.phonenoTextController.text),
                              accessToken: StreetauthCall.streettoken(
                                (_model.strretauth?.jsonBody ?? ''),
                              ),
                            );

                            if (ReturntierprofileCall.success(
                                  (_model.tierone?.jsonBody ?? ''),
                                ) ==
                                true) {
                              if (ReturntierprofileCall.dob(
                                    (_model.tierone?.jsonBody ?? ''),
                                  ) ==
                                  '${_model.dropDownValue1}/${_model.dropDownValue2}/${_model.dropDownValue3}') {
                                FFAppState().accountvalidation = true;
                                safeSetState(() {});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Date of birth does not match our records.'),
                                    backgroundColor: Color(0xFFB53434),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    ReturntierprofileCall.message(
                                      (_model.tierone?.jsonBody ?? ''),
                                    ) ?? 'Verification failed.',
                                  ),
                                  backgroundColor: const Color(0xFFB53434),
                                ),
                              );
                            }
                            safeSetState(() {});
                          },
                          text: 'Verify Identity',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 52,
                            color: const Color(0xFF56B84B),
                            textStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF06210F),
                            ),
                            elevation: 0,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                color: Color(0xFF56B84B), size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Identity verified',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF56B84B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ]),

                    const SizedBox(height: 16),

                    // ── STEP 2: Security questions / OTP ─────────────────
                    if (FFAppState().accountvalidation) ...[
                      _card(children: [
                        Row(
                          children: [
                            _fieldLabel('STEP 2'),
                            const SizedBox(width: 8),
                            _stepBadge(_model.optuse
                                ? 'OTP VERIFICATION'
                                : 'SECURITY QUESTIONS'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _dividerLine(),
                        const SizedBox(height: 16),

                        if (!_model.optuse) ...[
                          _fieldLabel('SECURITY QUESTION'),
                          const SizedBox(height: 10),
                          _styledDropdown(
                            controller: _model.dropDownValueController4 ??=
                                FormFieldController<String>(null),
                            hint: 'Select your question...',
                            options: FFAppConstants.Questions,
                            onChanged: (val) => safeSetState(
                                () => _model.dropDownValue4 = val),
                            disabled: FFAppState().questionvalidation,
                          ),

                          const SizedBox(height: 16),
                          _dividerLine(),
                          const SizedBox(height: 16),

                          _fieldLabel('ANSWER 1'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _model.textController2,
                            focusNode: _model.textFieldFocusNode1,
                            readOnly: FFAppState().questionvalidation,
                            style: _inputTextStyle(),
                            decoration: _inputDeco(hint: 'Your answer'),
                            validator: _model.textController2Validator
                                .asValidator(context),
                          ),

                          const SizedBox(height: 16),
                          _dividerLine(),
                          const SizedBox(height: 16),

                          _fieldLabel('ANSWER 2'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _model.textController3,
                            focusNode: _model.textFieldFocusNode2,
                            readOnly: FFAppState().questionvalidation,
                            style: _inputTextStyle(),
                            decoration: _inputDeco(hint: 'Your answer'),
                            validator: _model.textController3Validator
                                .asValidator(context),
                          ),

                          if (!FFAppState().questionvalidation) ...[
                            const SizedBox(height: 20),
                            FFButtonWidget(
                              onPressed: () async {
                                if (_model.dropDownValue4 == null || _model.dropDownValue4!.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select your secret question'),
                                      backgroundColor: Color(0xFFB53434),
                                    ),
                                  );
                                  return;
                                }
                                final a1 = _model.textController2.text.trim();
                                final a2 = _model.textController3.text.trim();
                                if (a1.isEmpty || a2.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter answers for both security questions'),
                                      backgroundColor: Color(0xFFB53434),
                                    ),
                                  );
                                  return;
                                }
                                _model.validquestion =
                                    await VerifysecretquestionCall.call(
                                  phoneno: functions.removecode(
                                      _model.phonenoTextController.text.trim()),
                                  question: _model.dropDownValue4,
                                  answer1: _model.textController2.text,
                                  answer2: _model.textController3.text,
                                  accessToken: StreetauthCall.streettoken(
                                    (_model.strretauth?.jsonBody ?? ''),
                                  ),
                                );

                                if (VerifysecretquestionCall.status(
                                      (_model.validquestion?.jsonBody ?? ''),
                                    ) ==
                                    true) {
                                  FFAppState().questionvalidation = true;
                                  safeSetState(() {});
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        VerifysecretquestionCall.message(
                                          (_model.validquestion?.jsonBody ??
                                              ''),
                                        ) ?? 'Incorrect answers.',
                                      ),
                                      backgroundColor:
                                          const Color(0xFFB53434),
                                    ),
                                  );
                                }
                                safeSetState(() {});
                              },
                              text: 'Verify Answers',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 52,
                                color: const Color(0xFF56B84B),
                                textStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF06210F),
                                ),
                                elevation: 0,
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    color: Color(0xFF56B84B), size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  'Answers verified',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF56B84B),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 16),
                          // Use OTP instead link
                          Center(
                            child: GestureDetector(
                              onTap: _model.isOtpLoading ? null : _sendResetOtp,
                              child: _model.isOtpLoading
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Color(0xFF7FD472)),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Sending OTP...',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF7FD472),
                                          ),
                                        ),
                                      ],
                                    )
                                  : RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: 'Prefer OTP? ',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF6D8577),
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Use OTP instead',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF7FD472),
                                          ),
                                        ),
                                      ]),
                                    ),
                            ),
                          ),
                        ] else ...[
                          // OTP input
                          _fieldLabel('ENTER OTP'),
                          const SizedBox(height: 14),

                          // Auto-detect status indicator
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F2618),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF56B84B)
                                      .withValues(alpha: 0.35),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_isOtpVerifying) ...[
                                    const SizedBox(
                                      width: 13,
                                      height: 13,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFF56B84B)),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Verifying OTP...',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF7FD472),
                                      ),
                                    ),
                                  ] else if ((_model.pinCodeController?.text
                                              .length ??
                                          0) ==
                                      6) ...[
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      size: 14,
                                      color: Color(0xFF56B84B),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Code detected',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF7FD472),
                                      ),
                                    ),
                                  ] else ...[
                                    const Icon(
                                      Icons.sms_outlined,
                                      size: 14,
                                      color: Color(0xFF56B84B),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Auto-detecting incoming SMS...',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF9EBAA9),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          AutofillGroup(
                            child: PinCodeTextField(
                              autoDisposeControllers: false,
                              appContext: context,
                              length: 6,
                              textStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              enableActiveFill: true,
                              autoFocus: true,
                              focusNode: _model.pinCodeFocusNode,
                              enablePinAutofill: true,
                              errorTextSpace: 16,
                              showCursor: true,
                              cursorColor: const Color(0xFF56B84B),
                              obscureText: false,
                              hintCharacter: '●',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              pinTheme: PinTheme(
                                fieldHeight: 48,
                                fieldWidth: 44,
                                borderWidth: 1.5,
                                borderRadius: BorderRadius.circular(12),
                                shape: PinCodeFieldShape.box,
                                activeColor: const Color(0xFF56B84B),
                                activeFillColor: const Color(0xFF152F23),
                                inactiveColor: const Color(0xFF1E4230),
                                inactiveFillColor: const Color(0xFF112B20),
                                selectedColor: const Color(0xFF7FD472),
                                selectedFillColor: const Color(0xFF1A3A28),
                              ),
                              controller: _model.pinCodeController,
                              onChanged: (_) {},
                              onCompleted: (pin) async {
                                await _verifyResetOtp(pin);
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: _model.pinCodeControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  safeSetState(() {
                                    _model.optuse = false;
                                  });
                                },
                                child: Text(
                                  'Use security questions',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF6D8577),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (_model.isOtpLoading || _resendCountdown > 0)
                                    ? null
                                    : _sendResetOtp,
                                child: _model.isOtpLoading
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            width: 12,
                                            height: 12,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Color(0xFF7FD472)),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Sending...',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF7FD472),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        _resendCountdown > 0
                                            ? 'Resend in ${_resendCountdown}s'
                                            : 'Resend OTP',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: _resendCountdown > 0
                                              ? const Color(0xFF6D8577)
                                              : const Color(0xFF7FD472),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ]),

                      const SizedBox(height: 16),
                    ],

                    // ── STEP 3: New PIN ──────────────────────────────────
                    if (showNewPin) ...[
                      _card(children: [
                        Row(
                          children: [
                            _fieldLabel('STEP 3'),
                            const SizedBox(width: 8),
                            _stepBadge('SET NEW PIN'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _dividerLine(),
                        const SizedBox(height: 16),

                        _fieldLabel('NEW PIN'),
                        const SizedBox(height: 8),
                        Form(
                          key: _model.formKey,
                          autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _model.textController4,
                                      focusNode: _model.textFieldFocusNode3,
                                      obscureText:
                                          !_model.passwordVisibility1,
                                      keyboardType: TextInputType.number,
                                      maxLength: 5,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 4,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '•••••',
                                        hintStyle: GoogleFonts.plusJakartaSans(
                                          fontSize: 22,
                                          color: const Color(0xFF56B84B)
                                              .withValues(alpha: 0.5),
                                          letterSpacing: 4,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      validator: _model
                                          .textController4Validator
                                          .asValidator(context),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => safeSetState(() =>
                                        _model.passwordVisibility1 =
                                            !_model.passwordVisibility1),
                                    child: Icon(
                                      _model.passwordVisibility1
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: const Color(0xFF7FD472),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _dividerLine(),
                              const SizedBox(height: 16),
                              _fieldLabel('CONFIRM NEW PIN'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _model.textController5,
                                      focusNode: _model.textFieldFocusNode4,
                                      obscureText:
                                          !_model.passwordVisibility2,
                                      keyboardType: TextInputType.number,
                                      maxLength: 5,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 4,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '•••••',
                                        hintStyle: GoogleFonts.plusJakartaSans(
                                          fontSize: 22,
                                          color: const Color(0xFF56B84B)
                                              .withValues(alpha: 0.5),
                                          letterSpacing: 4,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      validator: _model
                                          .textController5Validator
                                          .asValidator(context),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => safeSetState(() =>
                                        _model.passwordVisibility2 =
                                            !_model.passwordVisibility2),
                                    child: Icon(
                                      _model.passwordVisibility2
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: const Color(0xFF7FD472),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]),

                      const SizedBox(height: 24),

                      // Reset button — always visible, disabled until both fields are 5 digits
                      FFButtonWidget(
                          onPressed: !(RegExp(r'^\d{5}$')
                                      .hasMatch(_model.textController4.text) &&
                                  RegExp(r'^\d{5}$')
                                      .hasMatch(_model.textController5.text))
                              ? null
                              : () async {
                                  if ((_model.textController4.text ==
                                          _model.textController5.text) &&
                                      _model.textController4.text.isNotEmpty &&
                                      (functions.passwordconfirm(int.tryParse(
                                              _model.textController4.text)) ==
                                          true)) {
                                    String? token = StreetauthCall.streettoken(
                                      _model.strretauth?.jsonBody ?? '',
                                    );
                                    if (token == null || token.isEmpty) {
                                      _model.strretauth =
                                          await StreetauthCall.call();
                                      token = StreetauthCall.streettoken(
                                        _model.strretauth?.jsonBody ?? '',
                                      );
                                    }
                                    _model.apiResultb59 =
                                        await ResetpincodeCall.call(
                                      phoneno: functions.removecode(
                                          _model.phonenoTextController.text),
                                      pincode: _model.textController4.text,
                                      accessToken: token ?? '',
                                    );

                                    final isSuccess = ResetpincodeCall.status(
                                            _model.apiResultb59?.jsonBody) ==
                                        true;
                                    if (isSuccess) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'PIN successfully reset! Please log in with your new PIN.'),
                                          backgroundColor: Color(0xFF56B84B),
                                        ),
                                      );
                                      FFAppState().deletePhonenumber();
                                      FFAppState().phonenumber = '';
                                      FFAppState().biometric = false;
                                      safeSetState(() {});
                                      context.pushNamed(Login1Widget.routeName);
                                    } else {
                                      final msg = getJsonField(
                                                  _model.apiResultb59?.jsonBody,
                                                  r'''$.message''')
                                              ?.toString() ??
                                          getJsonField(
                                                  _model.apiResultb59?.jsonBody,
                                                  r'''$.Message''')
                                              ?.toString() ??
                                          'Failed to reset PIN. Please try again.';
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(msg),
                                          backgroundColor:
                                              const Color(0xFFB53434),
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'PINs do not match or are invalid.'),
                                        backgroundColor: Color(0xFFB53434),
                                      ),
                                    );
                                  }
                                  safeSetState(() {});
                                },
                          text: 'Reset PIN',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 56,
                            color: const Color(0xFF56B84B),
                            textStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF06210F),
                            ),
                            elevation: 0,
                            borderRadius: BorderRadius.circular(16),
                            disabledColor: const Color(0xFF1E4230),
                          ),
                        ),

                      const SizedBox(height: 16),
                    ],

                    // Sign in link
                    Center(
                      child: GestureDetector(
                        onTap: () => context.pushNamed(Login1Widget.routeName),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Remember your PIN? ',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6D8577),
                              ),
                            ),
                            TextSpan(
                              text: 'Sign in',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF7FD472),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Styled dropdown for DOB (compact) ────────────────────────────────────

  Widget _dobDropdown({
    required FormFieldController<String> controller,
    required String hint,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    bool disabled = false,
  }) {
    return FlutterFlowDropDown<String>(
      controller: controller,
      options: options,
      onChanged: disabled ? null : onChanged,
      width: double.infinity,
      height: 44,
      textStyle: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      hintText: hint,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF7F9A89), size: 20),
      fillColor: const Color(0xFF152F23),
      elevation: 0,
      borderColor: const Color(0xFF1E4230),
      borderWidth: 1,
      borderRadius: 10,
      margin: EdgeInsets.zero,
      hidesUnderline: true,
      isOverButton: false,
      isSearchable: false,
      isMultiSelect: false,
    );
  }

  // ── Styled dropdown for security question (full width) ───────────────────

  Widget _styledDropdown({
    required FormFieldController<String> controller,
    required String hint,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    bool disabled = false,
  }) {
    return FlutterFlowDropDown<String>(
      controller: controller,
      options: options,
      onChanged: disabled ? null : onChanged,
      width: double.infinity,
      height: 48,
      textStyle: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      hintText: hint,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF7F9A89), size: 20),
      fillColor: const Color(0xFF152F23),
      elevation: 0,
      borderColor: const Color(0xFF1E4230),
      borderWidth: 1,
      borderRadius: 12,
      margin: EdgeInsets.zero,
      hidesUnderline: true,
      disabled: disabled,
      isOverButton: false,
      isSearchable: false,
      isMultiSelect: false,
    );
  }
}
