import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login1_model.dart';
export 'login1_model.dart';

class Login1Widget extends StatefulWidget {
  const Login1Widget({super.key});

  static String routeName = 'Login1';
  static String routePath = '/login1';

  @override
  State<Login1Widget> createState() => _Login1WidgetState();
}

class _Login1WidgetState extends State<Login1Widget> {
  late Login1Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  // Rate limiting — persisted across restarts so clearing app data is required to reset
  static int _failedAttempts = 0;
  static DateTime? _lockUntil;
  static const int _maxAttempts = 4;
  static const _storage = FlutterSecureStorage();
  static const _keyAttempts = 'login_failed_attempts';
  static const _keyLockUntil = 'login_lock_until';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Login1Model());

    _model.emailAddressTextController ??= TextEditingController(
      text: FFAppState().phonenumber.isNotEmpty ? FFAppState().phonenumber : '',
    );
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    _model.emailAddressTextController?.addListener(_dismissSnackBar);
    _model.passwordTextController?.addListener(_dismissSnackBar);

    _loadLockoutState();
  }

  @override
  void dispose() {
    _model.emailAddressTextController?.removeListener(_dismissSnackBar);
    _model.passwordTextController?.removeListener(_dismissSnackBar);
    _model.dispose();
    super.dispose();
  }

  void _dismissSnackBar() {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _showErrorSnackBar(
    String message, {
    bool withHelp = false,
    String? formattedPhone,
  }) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            messenger.hideCurrentSnackBar();
          },
          child: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFB53434),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 4),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        dismissDirection: DismissDirection.horizontal,
        action: withHelp
            ? SnackBarAction(
                label: 'Get Help',
                textColor: const Color(0xFFFFD54F),
                onPressed: () {
                  context.pushNamed(
                    YarnChatPageWidget.routeName,
                    queryParameters: {
                      if (formattedPhone != null && formattedPhone.isNotEmpty)
                        'phoneNumber': serializeParam(formattedPhone, ParamType.String),
                    }.withoutNulls,
                  );
                },
              )
            : null,
      ),
    );
  }

  Future<void> _loadLockoutState() async {
    final attempts = await _storage.read(key: _keyAttempts);
    final lockUntilStr = await _storage.read(key: _keyLockUntil);
    _failedAttempts = int.tryParse(attempts ?? '') ?? 0;
    if (_failedAttempts >= _maxAttempts) {
      _failedAttempts = 0;
      await _storage.delete(key: _keyAttempts);
    }
    if (lockUntilStr != null) _lockUntil = DateTime.tryParse(lockUntilStr);
    if (mounted) safeSetState(() {});
  }

  Future<void> _persistLockoutState() async {
    await _storage.write(key: _keyAttempts, value: _failedAttempts.toString());
    if (_lockUntil != null) {
      await _storage.write(key: _keyLockUntil, value: _lockUntil!.toIso8601String());
    } else {
      await _storage.delete(key: _keyLockUntil);
    }
  }

  Future<void> _clearLockoutState() async {
    _failedAttempts = 0;
    _lockUntil = null;
    await _storage.delete(key: _keyAttempts);
    await _storage.delete(key: _keyLockUntil);
  }

  bool get _isLockedOut =>
      _lockUntil != null && DateTime.now().isBefore(_lockUntil!);

  String get _lockoutMessage {
    if (_lockUntil == null) return '';
    final remaining = _lockUntil!.difference(DateTime.now());
    return 'Too many failed attempts. Try again in ${remaining.inSeconds}s.';
  }

  Future<void> _handleSignIn() async {
    _dismissSnackBar();
    if (_isLockedOut) {
      _showErrorSnackBar(_lockoutMessage);
      return;
    }

    final rawPhone = _model.emailAddressTextController.text.trim();
    final password = _model.passwordTextController.text.trim();

    if (rawPhone.isEmpty) {
      _showErrorSnackBar('Please enter your phone number');
      return;
    }
    if (password.isEmpty) {
      _showErrorSnackBar('Please enter your password / PIN');
      return;
    }

    final cleanPhone = rawPhone.replaceAll(RegExp(r'[\s\-\+]'), '');
    final formattedPhone = functions.removecode(cleanPhone) ?? cleanPhone;

    setState(() => _isLoading = true);

    try {
      _model.streetaut = await StreetauthCall.call();
      final token = StreetauthCall.streettoken(_model.streetaut?.jsonBody ?? '');
      if (token == null || token.isEmpty) {
        if (mounted) {
          _showErrorSnackBar('Authentication service is currently unavailable. Please try again.');
        }
        return;
      }

      FFAppState().bsptoken = token;
      FFAppState().deleteProgressvalue();
      FFAppState().progressvalue = 0.0;
      FFAppState().deleteExamprogress();
      FFAppState().examprogress = 0.0;
      safeSetState(() {});

      _model.deviceid = await actions.getdeviceid();
      _model.pincodevalid = await IspincodevalidCall.call(
        phoneno: formattedPhone,
        pincode: password,
        accessToken: token,
        deviceid: valueOrDefault<String>(_model.deviceid, FFAppState().deviceid),
      );

      if (IspincodevalidCall.success(_model.pincodevalid?.jsonBody ?? '') ==
          true) {
        if (IspincodevalidCall.profileactive(_model.pincodevalid?.jsonBody ?? '') == false) {
          if (mounted) {
            context.pushNamed(
              EmptyProfileWidget.routeName,
              queryParameters: {
                'phoneno': serializeParam(formattedPhone, ParamType.String),
              }.withoutNulls,
            );
          }
          return;
        }

        final cleanInput = functions.removecode(formattedPhone) ?? formattedPhone;
        final cleanStored = functions.removecode(FFAppState().phonenumber) ?? '';

        final isSameDevice = cleanStored.isNotEmpty && cleanInput == cleanStored;

        if (isSameDevice) {
          FFAppState().bsptoken = token;
          FFAppState().sessionid =
              IspincodevalidCall.sessionid(_model.pincodevalid?.jsonBody ?? '') ??
                  '';
          FFAppState().accountno =
              IspincodevalidCall.accountno(_model.pincodevalid?.jsonBody ?? '') ??
                  '';
          FFAppState().phonenumber = formattedPhone;
          FFAppState().accountname =
              IspincodevalidCall.fullname(_model.pincodevalid?.jsonBody ?? '') ??
                  '';
          FFAppState().avalbal =
              IspincodevalidCall.accountbalanace(
                      _model.pincodevalid?.jsonBody ?? '') ??
                  '';
          FFAppState().walletid =
              IspincodevalidCall.walletid(_model.pincodevalid?.jsonBody ?? '') ??
                  '';
          FFAppState().email =
              IspincodevalidCall.email(_model.pincodevalid?.jsonBody ?? '') ?? '';
          FFAppState().deviceid = _model.deviceid ?? FFAppState().deviceid;
          FFAppState().isLoggedIn = true;
          FFAppState().isRegistered = true;
          await _clearLockoutState();
          safeSetState(() {});

          if (mounted) {
            if (IspincodevalidCall.hassecurity(_model.pincodevalid?.jsonBody ?? '') == false) {
              context.pushNamed(
                QuestionaireWidget.routeName,
                queryParameters: {
                  'phone': serializeParam(cleanInput, ParamType.String),
                }.withoutNulls,
              );
            } else {
              context.goNamed(NewhomeWidget.routeName);
            }
          }
        } else {
          // Device change / new device detected!
          // Send verification OTP to the user's phone
          final otpResponse = await GetotpfromphoneCall.call(
            phone: cleanInput,
            accessToken: token,
            oldphone: FFAppState().phonenumber,
          );

          final isOtpSent = GetotpfromphoneCall.status(otpResponse.jsonBody) == true ||
              otpResponse.succeeded;

          if (isOtpSent) {
            FFAppState().bsptoken = token;
            FFAppState().sessionid =
                IspincodevalidCall.sessionid(_model.pincodevalid?.jsonBody ?? '') ?? '';
            FFAppState().biometric = false;
            FFAppState().avalbal =
                IspincodevalidCall.accountbalanace(_model.pincodevalid?.jsonBody ?? '') ?? '';
            FFAppState().password = password;
            FFAppState().deviceid = _model.deviceid ?? FFAppState().deviceid;
            await _clearLockoutState();
            safeSetState(() {});

            if (mounted) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Device change detected. Please enter the OTP sent to your phone.'),
                  backgroundColor: const Color(0xFF56B84B),
                  behavior: SnackBarBehavior.floating,
                  showCloseIcon: true,
                  closeIconColor: Colors.white,
                  duration: const Duration(seconds: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
              context.pushNamed(
                PhonereVerificationWidget.routeName,
                queryParameters: {
                  'phoneNumber': serializeParam(
                    cleanInput,
                    ParamType.String,
                  ),
                }.withoutNulls,
              );
            }
          } else {
            final msg = getJsonField(otpResponse.jsonBody, r'''$.Message''')?.toString() ??
                getJsonField(otpResponse.jsonBody, r'''$.message''')?.toString() ??
                'Failed to send device verification OTP. Please try again.';
            if (mounted) {
              _showErrorSnackBar(msg);
            }
          }
        }
      } else {
        _failedAttempts++;
        await _persistLockoutState();

        final backendMsg = (IspincodevalidCall.message(_model.pincodevalid?.jsonBody ?? '') ?? '').trim();

        final String displayMsg;
        if (backendMsg.isNotEmpty) {
          displayMsg = backendMsg;
        } else if (_failedAttempts >= _maxAttempts) {
          displayMsg = '4 incorrect trials reached. Please reset your password.';
        } else {
          final remaining = _maxAttempts - _failedAttempts;
          displayMsg = 'Incorrect PIN.${remaining > 0 ? ' $remaining attempt${remaining == 1 ? '' : 's'} left.' : ''}';
        }

        if (mounted) {
          _showErrorSnackBar(
            displayMsg,
            withHelp: true,
            formattedPhone: formattedPhone,
          );

          if (_failedAttempts >= _maxAttempts) {
            _failedAttempts = 0;
            _lockUntil = null;
            await _clearLockoutState();
            if (formattedPhone.isNotEmpty) {
              FFAppState().phonenumber = formattedPhone;
            }
            await Future.delayed(const Duration(milliseconds: 600));
            if (mounted) {
              context.pushNamed(ResetpasswordWidget.routeName);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Login exception: $e');
      if (mounted) {
        final errorText = e.toString().contains('SocketException') || e.toString().contains('TimeoutException')
            ? 'Connection error. Please check your internet connection and try again.'
            : 'Sign in error: ${e.toString().replaceAll("Exception:", "").trim()}';
        _showErrorSnackBar(errorText);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _dismissSnackBar();
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFF0B2018),
          body: Stack(
            children: [
              // Radial glow in upper right
              Positioned(
                top: -90,
                right: -110,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF56B84B).withValues(alpha: 0.34),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24.0),

                      // Logo Mark & Live Support
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF152F23),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.bolt_rounded,
                                color: Color(0xFF56B84B),
                                size: 28,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              final phone = _model.emailAddressTextController.text.trim();
                              context.pushNamed(
                                YarnChatPageWidget.routeName,
                                queryParameters: {
                                  if (phone.isNotEmpty)
                                    'phoneNumber': serializeParam(phone, ParamType.String),
                                  if (FFAppState().email.isNotEmpty)
                                    'email': serializeParam(FFAppState().email, ParamType.String),
                                }.withoutNulls,
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF152F23),
                                border: Border.all(color: const Color(0xFF1E4230)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF56B84B),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Live Support',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF7FD472),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 14,
                                    color: Color(0xFF7FD472),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24.0),

                      // Welcome Title
                      Text(
                        'Welcome to\nStreetPay',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.8,
                          height: 1.18,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Your 9PSB StreetPay wallet, bills and payouts in one place.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8FA596),
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(height: 32.0),

                      // Credentials Card
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF112B20),
                          border: Border.all(
                            color: const Color(0xFF1E4230),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                if (!(_model.emailAddressFocusNode?.hasFocus ?? false)) {
                                  _model.emailAddressFocusNode?.requestFocus();
                                }
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PHONE NUMBER',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF7F9A89),
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  TextFormField(
                                    controller: _model.emailAddressTextController,
                                    focusNode: _model.emailAddressFocusNode,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '08012345678',
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        fontSize: 18.0,
                                        color: const Color(0xFF7F9A89).withValues(alpha: 0.5),
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Container(
                              height: 1.0,
                              color: const Color(0xFF1E4230),
                            ),
                            const SizedBox(height: 16.0),
                            InkWell(
                              onTap: () {
                                if (!(_model.passwordFocusNode?.hasFocus ?? false)) {
                                  _model.passwordFocusNode?.requestFocus();
                                }
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PASSWORD',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF7F9A89),
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _model.passwordTextController,
                                          focusNode: _model.passwordFocusNode,
                                          obscureText: !_model.passwordVisibility,
                                          keyboardType: TextInputType.number,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 4.0,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: '••••••',
                                            hintStyle: GoogleFonts.plusJakartaSans(
                                              fontSize: 20.0,
                                              color: const Color(0xFF56B84B)
                                                  .withValues(alpha: 0.6),
                                              letterSpacing: 4.0,
                                            ),
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          onFieldSubmitted: (_) => _handleSignIn(),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          safeSetState(() {
                                            _model.passwordVisibility =
                                                !_model.passwordVisibility;
                                          });
                                        },
                                        child: Icon(
                                          _model.passwordVisibility
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: const Color(0xFF7FD472),
                                          size: 20.0,
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

                      const SizedBox(height: 24.0),

                      // Sign In Button
                      FFButtonWidget(
                        onPressed: _isLoading ? null : _handleSignIn,
                        loading: _isLoading,
                        text: 'Sign in',
                        loadingText: 'Signing in...',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 56.0,
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

                      const SizedBox(height: 16.0),

                      Center(
                        child: InkWell(
                          onTap: () => context.pushNamed(ResetpasswordWidget.routeName),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF7FD472),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      // Footer
                      Center(
                        child: InkWell(
                          onTap: () {
                            context.pushNamed(SignUpWidget.routeName);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'New here? ',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF6D8577),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Create an account',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF7FD472),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Direct Live Chat Link
                      Center(
                        child: InkWell(
                          onTap: () {
                            final phone = _model.emailAddressTextController.text.trim();
                            context.pushNamed(
                              YarnChatPageWidget.routeName,
                              queryParameters: {
                                if (phone.isNotEmpty)
                                  'phoneNumber': serializeParam(phone, ParamType.String),
                                if (FFAppState().email.isNotEmpty)
                                  'email': serializeParam(FFAppState().email, ParamType.String),
                              }.withoutNulls,
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.support_agent_rounded,
                                  color: Color(0xFF7FD472),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Having trouble? Chat with Live Support',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF8FA596),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ),

              // Floating MyYarns Live Chat Trigger Button
              Positioned(
                bottom: 24.0,
                right: 20.0,
                child: InkWell(
                  onTap: () {
                    final phone = _model.emailAddressTextController.text.trim();
                    context.pushNamed(
                      YarnChatPageWidget.routeName,
                      queryParameters: {
                        if (phone.isNotEmpty)
                          'phoneNumber': serializeParam(phone, ParamType.String),
                        if (FFAppState().email.isNotEmpty)
                          'email': serializeParam(FFAppState().email, ParamType.String),
                      }.withoutNulls,
                    );
                  },
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF56B84B),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF56B84B).withValues(alpha: 0.45),
                          blurRadius: 14.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Icon(
                            Icons.chat_bubble_rounded,
                            color: Color(0xFF04190C),
                            size: 26,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4ADE80),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF0B2018), width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
