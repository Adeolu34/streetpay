import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'loginbiometric_model.dart';
export 'loginbiometric_model.dart';

class LoginbiometricWidget extends StatefulWidget {
  const LoginbiometricWidget({super.key});

  static String routeName = 'Loginbiometric';
  static String routePath = '/loginbiometric';

  @override
  State<LoginbiometricWidget> createState() => _LoginbiometricWidgetState();
}

class _LoginbiometricWidgetState extends State<LoginbiometricWidget> {
  late LoginbiometricModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  bool _isLoading = false;
  bool _isBiometricLoading = false;
  static int _failedAttempts = 0;
  static const int _maxAttempts = 4;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginbiometricModel());

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    // Trigger fingerprint prompt after page load if enabled
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final _localAuth = LocalAuthentication();
      final isBiometricSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (isBiometricSupported && canCheckBiometrics) {
        _triggerBiometrics();
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _triggerBiometrics() async {
    if (_isBiometricLoading || _isLoading) return;
    setState(() {
      _isBiometricLoading = true;
    });

    try {
      final _localAuth = LocalAuthentication();
      _model.biometric = await _localAuth.authenticate(
        localizedReason: 'Please authenticate with your fingerprint',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (_model.biometric == true) {
        setState(() {
          _isLoading = true;
        });

        // Refresh token to prevent expired session failure
        try {
          final authRes = await StreetauthCall.call();
          final freshToken = StreetauthCall.streettoken(authRes.jsonBody);
          if (freshToken != null && freshToken.isNotEmpty) {
            FFAppState().bsptoken = freshToken;
          }
        } catch (authErr) {
          debugPrint('Streetauth refresh error in biometrics: $authErr');
        }

        _model.tierone = await ReturntierprofileCall.call(
          phoneno: functions.removecode(FFAppState().phonenumber),
          accessToken: FFAppState().bsptoken,
        );

        final walletId = ReturntierprofileCall.walletID(_model.tierone?.jsonBody ?? '');
        final isSuccess = ReturntierprofileCall.success(_model.tierone?.jsonBody ?? '') == true ||
            (walletId != null && walletId.isNotEmpty);

        if (isSuccess) {
          if (walletId != null && walletId.isNotEmpty) {
            FFAppState().walletid = walletId;
          }
          final accNo = ReturntierprofileCall.accountNo(_model.tierone?.jsonBody ?? '');
          if (accNo != null && accNo.isNotEmpty) {
            FFAppState().accountno = accNo;
          }
          final fullName = ReturntierprofileCall.fullname(_model.tierone?.jsonBody ?? '');
          final othername = ReturntierprofileCall.othername(_model.tierone?.jsonBody ?? '');
          if (fullName != null && fullName.trim().isNotEmpty) {
            FFAppState().accountname = fullName.trim();
          } else if (othername != null && othername.isNotEmpty) {
            FFAppState().accountname = othername;
          }
          FFAppState().isLoggedIn = true;
          safeSetState(() {});
          if (mounted) {
            context.goNamed(NewhomeWidget.routeName);
          }
        } else {
          final backendMsg = (ReturntierprofileCall.message(_model.tierone?.jsonBody ?? '') ?? '').trim();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(backendMsg.isNotEmpty
                    ? backendMsg
                    : 'Fingerprint sign in failed. Please sign in with your PIN.'),
                backgroundColor: const Color(0xFFB53434),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Biometrics exception: $e');
      _model.biometric = false;
    } finally {
      if (mounted) {
        setState(() {
          _isBiometricLoading = false;
          _isLoading = false;
        });
      }
    }
    safeSetState(() {});
  }

  Future<void> _handleSignIn() async {
    if (_isLoading) return;
    final passwordText = _model.passwordTextController.text.trim();
    if (passwordText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your password / PIN')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Fetch fresh StreetAuth token first so we never send expired credentials
      try {
        final authRes = await StreetauthCall.call();
        final freshToken = StreetauthCall.streettoken(authRes.jsonBody);
        if (freshToken != null && freshToken.isNotEmpty) {
          FFAppState().bsptoken = freshToken;
        }
      } catch (authErr) {
        debugPrint('Streetauth refresh warning: $authErr');
      }

      if (FFAppState().bsptoken.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication service is currently unavailable. Please try again.'),
              backgroundColor: Color(0xFFB53434),
            ),
          );
        }
        return;
      }

      _model.deviceid = await actions.getdeviceid();
      final phoneToUse = functions.removecode(FFAppState().phonenumber) ??
          FFAppState().phonenumber;

      _model.ispincode = await IspincodevalidCall.call(
        phoneno: phoneToUse,
        pincode: passwordText,
        accessToken: FFAppState().bsptoken,
        deviceid: valueOrDefault<String>(_model.deviceid, FFAppState().deviceid),
      );

      if (IspincodevalidCall.success(_model.ispincode?.jsonBody ?? '') ==
          true) {
        _failedAttempts = 0;
        FFAppState().phonenumber = phoneToUse;
        final sid = IspincodevalidCall.sessionid(_model.ispincode?.jsonBody ?? '');
        if (sid != null && sid.isNotEmpty) {
          FFAppState().sessionid = sid;
        }
        final acc = IspincodevalidCall.accountno(_model.ispincode?.jsonBody ?? '');
        if (acc != null && acc.isNotEmpty) {
          FFAppState().accountno = acc;
        }
        final bal = IspincodevalidCall.accountbalanace(_model.ispincode?.jsonBody ?? '');
        if (bal != null && bal.isNotEmpty) {
          FFAppState().avalbal = bal;
        }
        final wid = IspincodevalidCall.walletid(_model.ispincode?.jsonBody ?? '');
        if (wid != null && wid.isNotEmpty) {
          FFAppState().walletid = wid;
        }
        final fn = IspincodevalidCall.fullname(_model.ispincode?.jsonBody ?? '');
        if (fn != null && fn.trim().isNotEmpty) {
          FFAppState().accountname = fn.trim();
        }
        FFAppState().deviceid = _model.deviceid ?? FFAppState().deviceid;
        FFAppState().isLoggedIn = true;
        safeSetState(() {});

        if (mounted) {
          context.goNamed(NewhomeWidget.routeName);
        }
      } else {
        _failedAttempts++;
        // Rely directly on the message from the backend!
        final backendMsg = (IspincodevalidCall.message(_model.ispincode?.jsonBody ?? '') ?? '').trim();

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
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(displayMsg),
              backgroundColor: const Color(0xFFB53434),
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
              closeIconColor: Colors.white,
              dismissDirection: DismissDirection.horizontal,
              duration: const Duration(seconds: 4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );

          if (_failedAttempts >= _maxAttempts) {
            _failedAttempts = 0;
            await Future.delayed(const Duration(milliseconds: 600));
            if (mounted) {
              context.pushNamed(ResetpasswordWidget.routeName);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Biometric sign in error: $e');
      if (mounted) {
        final errorText = e.toString().contains('SocketException') || e.toString().contains('TimeoutException')
            ? 'Connection error. Please check your internet connection and try again.'
            : 'Sign in error: ${e.toString().replaceAll("Exception:", "").trim()}';
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorText),
            backgroundColor: const Color(0xFFB53434),
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            closeIconColor: Colors.white,
            dismissDirection: DismissDirection.horizontal,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatSavedPhone(String phone) {
    if (phone.isEmpty) return '0803 •••• 214';
    if (phone.length >= 10) {
      final prefix = phone.substring(0, 4);
      final suffix = phone.substring(phone.length - 3);
      return '$prefix •••• $suffix';
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final userFullName = FFAppState().accountname;
    final firstName =
        userFullName.isNotEmpty ? userFullName.split(' ').first : 'there';
    final savedPhone = _formatSavedPhone(FFAppState().phonenumber);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24.0),

                      // App Mark & Live Support
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
                              context.pushNamed(
                                YarnChatPageWidget.routeName,
                                queryParameters: {
                                  if (FFAppState().phonenumber.isNotEmpty)
                                    'phoneNumber': serializeParam(FFAppState().phonenumber, ParamType.String),
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
                                    color: Color(0xFF7FD472),
                                    size: 14,
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
                        'Welcome back,\n$firstName',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  savedPhone,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF56B84B)
                                        .withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(999.0),
                                  ),
                                  child: Text(
                                    'Saved',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF7FD472),
                                    ),
                                  ),
                                ),
                              ],
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
                                          enabled: !(_isLoading || _isBiometricLoading),
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
                                          context.pushNamed(ResetpasswordWidget.routeName);
                                        },
                                        child: Text(
                                          'Forgot?',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF7FD472),
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

                      const SizedBox(height: 20.0),

                      // Sign In Button
                      FFButtonWidget(
                        onPressed: (_isLoading || _isBiometricLoading) ? null : _handleSignIn,
                        loading: _isLoading,
                        text: 'Sign in',
                        loadingText: _isBiometricLoading ? 'Verifying fingerprint...' : 'Signing in...',
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

                      const SizedBox(height: 14.0),

                      // Fingerprint Button
                      InkWell(
                        onTap: (_isLoading || _isBiometricLoading) ? null : _triggerBiometrics,
                        borderRadius: BorderRadius.circular(16.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 52.0,
                          decoration: BoxDecoration(
                            color: _isBiometricLoading
                                ? const Color(0xFF132F23)
                                : Colors.transparent,
                            border: Border.all(
                              color: _isBiometricLoading
                                  ? const Color(0xFF56B84B)
                                  : const Color(0xFF1E4230),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _isBiometricLoading
                                ? [
                                    const SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF7FD472),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12.0),
                                    Text(
                                      'Verifying fingerprint...',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF7FD472),
                                      ),
                                    ),
                                  ]
                                : [
                                    const Icon(
                                      Icons.fingerprint_rounded,
                                      color: Color(0xFF7FD472),
                                      size: 22.0,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      'Use fingerprint',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFCFE3D6),
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Footer & Live Support Link
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
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
                              const SizedBox(height: 12.0),
                              InkWell(
                                onTap: () {
                                  context.pushNamed(
                                    YarnChatPageWidget.routeName,
                                    queryParameters: {
                                      if (FFAppState().phonenumber.isNotEmpty)
                                        'phoneNumber': serializeParam(FFAppState().phonenumber, ParamType.String),
                                      if (FFAppState().email.isNotEmpty)
                                        'email': serializeParam(FFAppState().email, ParamType.String),
                                    }.withoutNulls,
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.support_agent_rounded,
                                        color: Color(0xFF7FD472),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Need help? Chat with Live Support',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF8FA596),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                    context.pushNamed(
                      YarnChatPageWidget.routeName,
                      queryParameters: {
                        if (FFAppState().phonenumber.isNotEmpty)
                          'phoneNumber': serializeParam(FFAppState().phonenumber, ParamType.String),
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
