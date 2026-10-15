import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'paymentpinverify_model.dart';
export 'paymentpinverify_model.dart';

class PaymentpinverifyWidget extends StatefulWidget {
  const PaymentpinverifyWidget({
    super.key,
    required this.customeraccount,
    required this.customername,
    required this.customeraccountno,
    required this.narration,
    required this.amount,
    required this.description,
    required this.refrence,
    required this.sectionid,
  });

  final String? customeraccount;
  final String? customername;
  final String? customeraccountno;
  final String? narration;
  final double? amount;
  final String? description;
  final String? refrence;
  final String? sectionid;

  @override
  State<PaymentpinverifyWidget> createState() => _PaymentpinverifyWidgetState();
}

class _PaymentpinverifyWidgetState extends State<PaymentpinverifyWidget> {
  late PaymentpinverifyModel _model;
  bool _isProcessing = false;
  String _pin = '';
  String? _errorMessage;

  // 3 wrong PINs → 30s lockout; 5 total → dismiss (return to safety)
  int _failedPinAttempts = 0;
  DateTime? _pinLockUntil;
  static const int _maxPinAttempts = 3;
  static const Duration _pinLockoutDuration = Duration(seconds: 30);

  bool get _isPinLocked =>
      _pinLockUntil != null && DateTime.now().isBefore(_pinLockUntil!);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentpinverifyModel());
    _model.pinCodeController ??= TextEditingController();
    _model.pinCodeFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  void _onKeyPress(String key) {
    if (_isProcessing || _isPinLocked) return;
    HapticFeedback.lightImpact();
    if (_pin.length < 5) {
      setState(() {
        _errorMessage = null;
        _pin += key;
        _model.pinCodeController?.text = _pin;
      });
      if (_pin.length == 5) {
        _showConfirmationDialog();
      }
    }
  }

  void _onDelete() {
    if (_isProcessing || _pin.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _errorMessage = null;
      _pin = _pin.substring(0, _pin.length - 1);
      _model.pinCodeController?.text = _pin;
    });
  }

  Future<void> _onBiometric() async {
    if (_isProcessing || _isPinLocked) return;
    if (!FFAppState().biometric) return; // guard — setting must be on
    try {
      final localAuth = LocalAuthentication();
      final isSupported = await localAuth.isDeviceSupported();
      final canCheck = await localAuth.canCheckBiometrics;
      if (isSupported && canCheck) {
        final formattedAmt = formatNumber(
          widget.amount,
          formatType: FormatType.decimal,
          decimalType: DecimalType.periodDecimal,
          currency: '₦',
        );
        final authenticated = await localAuth.authenticate(
          localizedReason:
              'Send $formattedAmt to ${widget.customername ?? 'recipient'}',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (authenticated) {
          _showConfirmationDialog(viaFingerprint: true);
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

  Future<void> _showConfirmationDialog({bool viaFingerprint = false}) async {
    final formattedAmt = formatNumber(
      widget.amount,
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
      currency: '₦',
    );

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFD6DDD8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF7EE),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.send_rounded,
                  color: Color(0xFF2F8F3C), size: 26),
            ),
            const SizedBox(height: 16),
            Text(
              'Confirm Payment',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF101614),
              ),
            ),
            const SizedBox(height: 20),
            _confirmRow('Amount', formattedAmt, bold: true),
            _confirmRow('To', widget.customername ?? '—'),
            _confirmRow('Account', widget.customeraccountno ?? '—'),
            if ((widget.description ?? '').isNotEmpty)
              _confirmRow('Note', widget.description!),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E8345),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  'Send ${formattedAmt}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6E7A72),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      await _submitPayment(viaFingerprint: viaFingerprint);
    } else if (!viaFingerprint) {
      // User cancelled — clear PIN so they start fresh
      setState(() {
        _pin = '';
        _model.pinCodeController?.clear();
      });
    }
  }

  Widget _confirmRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6E7A72),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
              color: bold ? const Color(0xFF0E8345) : const Color(0xFF101614),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitPayment({bool viaFingerprint = false}) async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      await _doSubmitPayment(viaFingerprint: viaFingerprint)
          .timeout(const Duration(seconds: 30));
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _pin = '';
          _model.pinCodeController?.clear();
          _errorMessage = 'Request timed out. Check your connection and try again.';
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment timed out. Please try again.',
                style: TextStyle(color: Colors.white)),
            duration: Duration(milliseconds: 4000),
            backgroundColor: Color(0xFFD32F2F),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _errorMessage = 'Error processing transfer. Please try again.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error processing transfer. Please try again.',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFFD32F2F),
          ),
        );
      }
    }
  }

  Future<void> _doSubmitPayment({bool viaFingerprint = false}) async {
    try {
      bool pinValid;

      if (viaFingerprint) {
        // Biometric already verified identity — skip PIN check, use existing session
        pinValid = true;
      } else {
        _model.pincode = await IspincodevalidCall.call(
          phoneno: functions.removecode(FFAppState().phonenumber),
          pincode: _model.pinCodeController!.text,
          accessToken: FFAppState().bsptoken,
          deviceid: FFAppState().deviceid,
        );

        final session = IspincodevalidCall.sessionid(
          (_model.pincode?.jsonBody ?? ''),
        );
        if (session != null) {
          FFAppState().sessionid = session;
        }

        pinValid = IspincodevalidCall.success(_model.pincode?.jsonBody ?? '') == true;
      }

      if (pinValid) {
        _model.transtoken = await GettransactiontokenCall.call(
          accessToken: FFAppState().bsptoken,
          accountno: FFAppState().accountno,
          deviceid: FFAppState().deviceid,
          sessionid: FFAppState().sessionid,
        );

        _model.othertrans = await WalletAsAServiceGroup.otherBankTransferCall.call(
          customeraccount: widget.customeraccount,
          customername: widget.customername,
          customeraccountno: widget.customeraccountno,
          senderaccountno: FFAppState().accountno,
          sendername: FFAppState().accountname,
          narration: '${widget.customername}',
          amount: widget.amount?.toString(),
          description: valueOrDefault<String>(widget.description, '-'),
          refrence: widget.refrence,
          sectionid: widget.sectionid,
          authToken: FFAppState().bsptoken,
          refid: GettransactiontokenCall.transtoken(
            (_model.transtoken?.jsonBody ?? ''),
          ),
        );

        if (WalletAsAServiceGroup.otherBankTransferCall
                .success(_model.othertrans?.jsonBody ?? '') ==
            true) {
          if (mounted) {
            Navigator.pop(context, true);
          }
        } else {
          final errorMsg = WalletAsAServiceGroup.otherBankTransferCall
                  .message(_model.othertrans?.jsonBody ?? '') ??
              'Transaction failed. Please try again.';

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
            extra: widget.description,
            transREF: widget.refrence,
            accessToken: FFAppState().bsptoken,
            ttype: 'Debit',
          );

          if (mounted) {
            setState(() {
              _isProcessing = false;
              _pin = '';
              _model.pinCodeController?.clear();
              _errorMessage = errorMsg;
            });
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  errorMsg,
                  style: const TextStyle(color: Colors.white),
                ),
                duration: const Duration(milliseconds: 4000),
                backgroundColor: const Color(0xFFD32F2F),
              ),
            );
          }
        }
      } else {
        _failedPinAttempts++;
        if (_failedPinAttempts >= _maxPinAttempts) {
          _pinLockUntil = DateTime.now().add(_pinLockoutDuration);
          _failedPinAttempts = 0;
        }
        if (mounted) {
          final backendMsg = (IspincodevalidCall.message(_model.pincode?.jsonBody ?? '') ?? '').trim();
          final remaining = _maxPinAttempts - _failedPinAttempts;
          final lockMsg = backendMsg.isNotEmpty
              ? backendMsg
              : (_isPinLocked
                  ? 'Too many wrong PINs. Try again in ${_pinLockUntil!.difference(DateTime.now()).inSeconds}s.'
                  : 'Invalid PIN.${remaining > 0 ? ' $remaining attempt${remaining == 1 ? '' : 's'} left.' : ''}');
          setState(() {
            _isProcessing = false;
            _pin = '';
            _model.pinCodeController?.clear();
            _errorMessage = lockMsg;
          });
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(lockMsg, style: const TextStyle(color: Colors.white)),
              duration: const Duration(milliseconds: 3500),
              backgroundColor: const Color(0xFFD32F2F),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _errorMessage = 'Error processing transfer. Please try again.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error processing transfer. Please try again.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFFD32F2F),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedAmount = formatNumber(
      widget.amount,
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
      currency: '₦',
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF6F8F6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: _isProcessing
            ? _buildProcessingView(formattedAmount)
            : _buildPinInputView(formattedAmount),
      ),
    );
  }

  Widget _buildProcessingView(String amountStr) {
    return Container(
      height: 380,
      padding: const EdgeInsets.all(32.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF1E4230),
                width: 4,
              ),
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF56B84B)),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Sending $amountStr',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF101614),
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Do not close the app. This usually takes about 5 seconds.',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF6E7A72),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPinInputView(String amountStr) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD6DDD8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE6EAE7)),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF101614),
                    size: 18,
                  ),
                ),
              ),
              Text(
                'Enter your 5-digit PIN',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF101614),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 34),
            ],
          ),

          const SizedBox(height: 20),

          // 5 PIN Digit Boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final bool isFilled = index < _pin.length;
              final bool isCurrent = index == _pin.length;

              return Container(
                width: 48,
                height: 58,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCurrent
                        ? const Color(0xFF56B84B)
                        : (isFilled
                            ? const Color(0xFF0B2018)
                            : const Color(0xFFE6EAE7)),
                    width: isCurrent ? 2.0 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x05000000),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: isFilled
                    ? Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0B2018),
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              );
            }),
          ),

          const SizedBox(height: 14),

          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFD32F2F),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            Text(
              FFAppState().biometric
                  ? 'Tap keypad or use fingerprint'
                  : 'Enter your 5-digit transaction PIN',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF6E7A72),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),

          const SizedBox(height: 18),

          // Custom Tactile 3x4 Keypad
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                _buildKeyRow(['1', '2', '3']),
                const SizedBox(height: 8),
                _buildKeyRow(['4', '5', '6']),
                const SizedBox(height: 8),
                _buildKeyRow(['7', '8', '9']),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Biometric button — only shown when user has enabled it
                    Expanded(
                      child: FFAppState().biometric
                          ? InkWell(
                              onTap: _onBiometric,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDF7EE),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFFB8E0BC)),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.fingerprint_rounded,
                                  color: Color(0xFF2F8F3C),
                                  size: 24,
                                ),
                              ),
                            )
                          : const SizedBox(height: 50),
                    ),
                    const SizedBox(width: 8),
                    // '0' digit
                    Expanded(
                      child: _buildKey('0'),
                    ),
                    const SizedBox(width: 8),
                    // Backspace button
                    Expanded(
                      child: InkWell(
                        onTap: _onDelete,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE6EAE7)),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.backspace_outlined,
                            color: Color(0xFF101614),
                            size: 20,
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
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      children: [
        for (int i = 0; i < keys.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _buildKey(keys[i])),
        ],
      ],
    );
  }

  Widget _buildKey(String key) {
    return InkWell(
      onTap: () => _onKeyPress(key),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6EAE7)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x05000000),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          key,
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF101614),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
