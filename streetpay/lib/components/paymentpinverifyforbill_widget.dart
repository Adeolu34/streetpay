import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'paymentpinverifyforbill_model.dart';
export 'paymentpinverifyforbill_model.dart';

class PaymentpinverifyforbillWidget extends StatefulWidget {
  const PaymentpinverifyforbillWidget({
    super.key,
    required this.customeraccount,
    required this.customername,
    required this.customeraccountno,
    required this.narration,
    required this.amount,
    required this.description,
    required this.refrence,
    required this.sectionid,
    required this.billid,
  });

  final String? customeraccount;
  final String? customername;
  final String? customeraccountno;
  final String? narration;
  final double? amount;
  final String? description;
  final String? refrence;
  final String? sectionid;
  final String? billid;

  @override
  State<PaymentpinverifyforbillWidget> createState() =>
      _PaymentpinverifyforbillWidgetState();
}

class _PaymentpinverifyforbillWidgetState
    extends State<PaymentpinverifyforbillWidget> {
  late PaymentpinverifyforbillModel _model;
  String _pin = '';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentpinverifyforbillModel());
    _model.pinCodeFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  void _onKeyPress(String key) {
    if (_isProcessing) return;
    HapticFeedback.lightImpact();
    if (_pin.length < 5) {
      setState(() {
        _pin += key;
        _model.pinCodeController?.text = _pin;
      });
      if (_pin.length == 5) {
        _submitBillPayment();
      }
    }
  }

  void _onDelete() {
    if (_isProcessing || _pin.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _model.pinCodeController?.text = _pin;
    });
  }

  Future<void> _onBiometric() async {
    if (_isProcessing || !FFAppState().biometric) return;
    try {
      final localAuth = LocalAuthentication();
      final isSupported = await localAuth.isDeviceSupported();
      final canCheck = await localAuth.canCheckBiometrics;
      if (isSupported && canCheck) {
        final authenticated = await localAuth.authenticate(
          localizedReason: 'Authorize bill payment with fingerprint',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (authenticated) {
          await _submitBillPayment(viaFingerprint: true);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometrics not available on this device'),
            duration: Duration(milliseconds: 2000),
          ),
        );
      }
    } catch (_) {}
  }

  Future<void> _submitBillPayment({bool viaFingerprint = false}) async {
    if (_isProcessing) return;
    if (!viaFingerprint && _pin.length != 5) return;
    try {
      await _doSubmitBillPayment(viaFingerprint: viaFingerprint).timeout(const Duration(seconds: 30));
    } on TimeoutException {
      if (mounted) {
        setState(() { _isProcessing = false; _pin = ''; _model.pinCodeController?.clear(); });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Request timed out. Please try again.',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFFD9383A),
        ));
      }
    }
  }

  Future<void> _doSubmitBillPayment({bool viaFingerprint = false}) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      bool isSuccess = false;

      if (viaFingerprint) {
        isSuccess = true;
      } else {
        _model.strretauth = await StreetauthCall.call();
        _model.deviceid = await actions.getdeviceid();

        _model.pincode = await IspincodevalidCall.call(
          phoneno: functions.removecode(FFAppState().phonenumber),
          pincode: _pin,
          accessToken: StreetauthCall.streettoken(
            (_model.strretauth?.jsonBody ?? ''),
          ),
          deviceid: valueOrDefault<String>(_model.deviceid, 'StreetPayApp'),
        );

        final sessionId = IspincodevalidCall.sessionid(_model.pincode?.jsonBody ?? '');
        if (sessionId != null && sessionId.isNotEmpty) {
          FFAppState().sessionid = sessionId;
        }

        isSuccess = IspincodevalidCall.success(_model.pincode?.jsonBody ?? '') == true;
      }

      if (isSuccess) {
        if (_model.strretauth == null) {
          _model.strretauth = await StreetauthCall.call();
        }
        if (_model.deviceid == null) {
          _model.deviceid = await actions.getdeviceid();
        }
        final sessionToUse = (FFAppState().sessionid.isNotEmpty)
            ? FFAppState().sessionid
            : await actions.generateseesionid();

        String tokenToUse = FFAppState().bsptoken;
        if (tokenToUse.isEmpty) {
          final authRes = await StreetauthCall.call();
          final fresh = StreetauthCall.streettoken(authRes.jsonBody);
          if (fresh != null && fresh.isNotEmpty) {
            tokenToUse = fresh;
            FFAppState().bsptoken = fresh;
          }
        }

        _model.transtoken = await GettransactiontokenCall.call(
          accessToken: tokenToUse,
          accountno: FFAppState().accountno,
          deviceid: _model.deviceid,
          sessionid: sessionToUse,
        );

        _model.othertrans = await WalletAsAServiceGroup.otherBankTransferCall.call(
          customeraccount: widget.customeraccount,
          customername: widget.customername,
          customeraccountno: widget.customeraccountno,
          senderaccountno: FFAppState().accountno,
          sendername: FFAppState().accountname,
          narration: 'Bill payment',
          amount: widget.amount?.toString(),
          description: valueOrDefault<String>(widget.description, '-'),
          refrence: widget.refrence,
          sectionid: widget.sectionid ?? sessionToUse,
          authToken: tokenToUse,
          refid: GettransactiontokenCall.transtoken(
            (_model.transtoken?.jsonBody ?? ''),
          ),
        );

        final transferSuccess = WalletAsAServiceGroup.otherBankTransferCall.success(
              _model.othertrans?.jsonBody ?? '',
            ) ==
            true;

        if (transferSuccess) {
          _model.paidbill = await PaidbillCall.call(
            tophome: functions.removecode(FFAppState().phonenumber),
            billid: widget.billid,
            accessToken: FFAppState().bsptoken,
          );
          if (mounted) {
            Navigator.pop(context, true);
          }
        } else {
          await LogtransactionCall.call(
            phoneno: FFAppState().phonenumber,
            accountId: FFAppState().accountno,
            reqtype: 'Transfer--${widget.amount?.toString()}',
            sSid: widget.sectionid,
            passorfail: 'Failed',
            balBefore: FFAppState().avalbal,
            balafter: FFAppState().avalbal,
            beneficiary: widget.customername,
            tammt: widget.amount?.toString(),
            extra: WalletAsAServiceGroup.otherBankTransferCall.message(
              _model.othertrans?.jsonBody ?? '',
            ),
            transREF: widget.refrence,
            accessToken: StreetauthCall.streettoken(
              (_model.strretauth?.jsonBody ?? ''),
            ),
            ttype: 'Debit',
          );

          if (mounted) {
            setState(() {
              _isProcessing = false;
              _pin = '';
              _model.pinCodeController?.clear();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  WalletAsAServiceGroup.otherBankTransferCall.message(
                        _model.othertrans?.jsonBody ?? '',
                      ) ??
                      'Payment failed',
                  style: GoogleFonts.plusJakartaSans(color: Colors.white),
                ),
                backgroundColor: const Color(0xFFD9383A),
              ),
            );
          }
        }
      } else {
        final backendMsg = (IspincodevalidCall.message(_model.pincode?.jsonBody ?? '') ?? '').trim();
        setState(() {
          _isProcessing = false;
          _pin = '';
          _model.pinCodeController?.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              backendMsg.isNotEmpty ? backendMsg : 'Invalid PIN. Please try again.',
              style: GoogleFonts.plusJakartaSans(color: Colors.white),
            ),
            backgroundColor: const Color(0xFFD9383A),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _pin = '';
        _model.pinCodeController?.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString()}',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFD9383A),
        ),
      );
    }
  }

  Widget _buildKeypadButton(String text, {VoidCallback? onTap, Widget? icon, double opacity = 1.0}) {
    return Expanded(
      child: Opacity(
        opacity: opacity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 5.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap ?? () => _onKeyPress(text),
              borderRadius: BorderRadius.circular(16.0),
              splashColor: const Color(0x1856B84B),
              child: Container(
                height: 56.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8F6),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: const Color(0xFFE6EAE7),
                    width: 1.0,
                  ),
                ),
                alignment: Alignment.center,
                child: icon ??
                    Text(
                      text,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF101614),
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.0),
          topRight: Radius.circular(28.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Grab Handle
                  Container(
                    width: 36.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6DCD7),
                      borderRadius: BorderRadius.circular(999.0),
                    ),
                  ),
                  const SizedBox(height: 18.0),

                  // Header
                  Text(
                    'Enter Transaction PIN',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF101614),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Pay ₦${widget.amount?.toStringAsFixed(0) ?? "0"} to ${widget.customername ?? "Biller"}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6E7A72),
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // 5 PIN Boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final isFilled = _pin.length > index;
                      final isCurrent = _pin.length == index;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        width: 48.0,
                        height: 56.0,
                        decoration: BoxDecoration(
                          color: isFilled
                              ? const Color(0xFFEDF7EE)
                              : (isCurrent ? Colors.white : const Color(0xFFF6F8F6)),
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(
                            color: isCurrent
                                ? const Color(0xFF56B84B)
                                : (isFilled
                                    ? const Color(0xFF2F8F3C)
                                    : const Color(0xFFE6EAE7)),
                            width: isCurrent ? 2.0 : 1.0,
                          ),
                          boxShadow: isCurrent
                              ? const [
                                  BoxShadow(
                                    color: Color(0x1856B84B),
                                    blurRadius: 8.0,
                                    offset: Offset(0.0, 3.0),
                                  ),
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: isFilled
                            ? Container(
                                width: 14.0,
                                height: 14.0,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0B2018),
                                  shape: BoxShape.circle,
                                ),
                              )
                            : (isCurrent
                                ? Container(
                                    width: 2.0,
                                    height: 20.0,
                                    color: const Color(0xFF56B84B),
                                  )
                                : null),
                      );
                    }),
                  ),

                  const SizedBox(height: 26.0),

                  // Tactile Numpad
                  Column(
                    children: [
                      Row(
                        children: [
                          _buildKeypadButton('1'),
                          _buildKeypadButton('2'),
                          _buildKeypadButton('3'),
                        ],
                      ),
                      Row(
                        children: [
                          _buildKeypadButton('4'),
                          _buildKeypadButton('5'),
                          _buildKeypadButton('6'),
                        ],
                      ),
                      Row(
                        children: [
                          _buildKeypadButton('7'),
                          _buildKeypadButton('8'),
                          _buildKeypadButton('9'),
                        ],
                      ),
                      Row(
                        children: [
                          _buildKeypadButton(
                            '',
                            onTap: _onBiometric,
                            opacity: FFAppState().biometric ? 1.0 : 0.25,
                            icon: Icon(
                              Icons.fingerprint_rounded,
                              size: 26.0,
                              color: FFAppState().biometric
                                  ? const Color(0xFF2F8F3C)
                                  : const Color(0xFF9EAAA0),
                            ),
                          ),
                          _buildKeypadButton('0'),
                          _buildKeypadButton(
                            '',
                            onTap: _onDelete,
                            icon: const Icon(
                              Icons.backspace_outlined,
                              size: 22.0,
                              color: Color(0xFF101614),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Processing Overlay
            if (_isProcessing)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28.0),
                    topRight: Radius.circular(28.0),
                  ),
                  child: Container(
                    color: Colors.white.withValues(alpha: 0.88),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 44.0,
                            height: 44.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF56B84B)),
                              strokeWidth: 3.5,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Paying bill request...',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF101614),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Please do not close this screen',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6E7A72),
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
    );
  }
}
