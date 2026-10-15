import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/components/vas_purchase_result_widget.dart';
import '/index.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'paymentpinverifytopup_model.dart';
export 'paymentpinverifytopup_model.dart';

class PaymentpinverifytopupWidget extends StatefulWidget {
  const PaymentpinverifytopupWidget({
    super.key,
    required this.amount,
    required this.network,
    required this.receipent,
    required this.productId,
    required this.dataplan,
    required this.phoneno,
    required this.avalbal,
  });

  final String? amount;
  final String? network;
  final String? receipent;
  final String? productId;
  final String? dataplan;
  final String? phoneno;
  final double? avalbal;

  @override
  State<PaymentpinverifytopupWidget> createState() =>
      _PaymentpinverifytopupWidgetState();
}

class _PaymentpinverifytopupWidgetState
    extends State<PaymentpinverifytopupWidget> {
  late PaymentpinverifytopupModel _model;
  String _pin = '';
  bool _isProcessing = false;
  bool _showResult = false;
  bool _isSuccessResult = false;
  String _resultMessage = '';
  String _resultTitle = '';
  String _resultServiceType = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentpinverifytopupModel());
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
        _submitDataPayment();
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
          localizedReason: 'Authorize data bundle purchase with fingerprint',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (authenticated) {
          await _submitDataPayment(viaFingerprint: true);
        }
      }
    } catch (_) {}
  }

  Future<void> _submitDataPayment({bool viaFingerprint = false}) async {
    if (_isProcessing) return;
    if (!viaFingerprint && _pin.length != 5) return;
    try {
      await _doSubmitDataPayment(viaFingerprint: viaFingerprint)
          .timeout(const Duration(seconds: 30));
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _pin = '';
          _model.pinCodeController?.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Request timed out. Please try again.',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFFD9383A),
        ));
      }
    }
  }

  Future<void> _doSubmitDataPayment({bool viaFingerprint = false}) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final phoneToUse = widget.phoneno ?? FFAppState().phonenumber;
      bool isSuccess = false;

      if (viaFingerprint) {
        isSuccess = true;
      } else {
        _model.streetauth = await StreetauthCall.call();
        _model.deviceid = await actions.getdeviceid();

        _model.pincode = await IspincodevalidCall.call(
          phoneno: functions.removecode(phoneToUse),
          pincode: _pin,
          accessToken: StreetauthCall.streettoken(
            (_model.streetauth?.jsonBody ?? ''),
          ),
          deviceid: _model.deviceid,
        );

        final sessionId =
            IspincodevalidCall.sessionid(_model.pincode?.jsonBody ?? '');
        if (sessionId != null && sessionId.isNotEmpty) {
          FFAppState().sessionid = sessionId;
        }

        isSuccess =
            IspincodevalidCall.success(_model.pincode?.jsonBody ?? '') == true;
      }

      if (isSuccess) {
        if (_model.streetauth == null) {
          _model.streetauth = await StreetauthCall.call();
        }
        if (_model.deviceid == null) {
          _model.deviceid = await actions.getdeviceid();
        }
        final sessionToUse = (FFAppState().sessionid.isNotEmpty)
            ? FFAppState().sessionid
            : await actions.generateseesionid();

        _model.transtoken = await GettransactiontokenCall.call(
          accessToken: FFAppState().bsptoken,
          accountno: FFAppState().accountno,
          deviceid: _model.deviceid,
          sessionid: sessionToUse,
        );

        final dataTransRef = await actions.generatetransref();

        _model.apiResultqua = await VasCollectionGroup.datatopupCall.call(
          debitaccount: FFAppState().accountno,
          productid: widget.productId,
          network: widget.network,
          transferref: dataTransRef,
          amount: widget.amount,
          phonenumber: functions.addcode(widget.receipent ?? ''),
          accessToken: StreetauthCall.streettoken(
            (_model.streetauth?.jsonBody ?? ''),
          ),
          refid: GettransactiontokenCall.transtoken(
            (_model.transtoken?.jsonBody ?? ''),
          ),
        );

        final purchaseStatus = VasCollectionGroup.datatopupCall
            .status(_model.apiResultqua?.jsonBody ?? '') == true;
        final purchaseMessage = purchaseStatus
            ? '${widget.dataplan ?? widget.network ?? "Data"} sent to ${widget.receipent ?? ""}. Your wallet has been debited.'
            : (VasCollectionGroup.datatopupCall
                    .message(_model.apiResultqua?.jsonBody ?? '') ??
                'Data purchase could not be completed. Please try again.');

        if (purchaseStatus) {
          await LogtransactionCall.call(
            phoneno: phoneToUse,
            accountId: FFAppState().accountno,
            reqtype: 'Data-${widget.productId}-${widget.dataplan}',
            passorfail: 'Pass',
            balBefore: FFAppState().avalbal,
            balafter: (functions.stringtodouble(FFAppState().avalbal) -
                    functions.stringtodouble(widget.amount ?? '0'))
                .toString(),
            beneficiary: widget.receipent,
            tammt: widget.amount,
            accessToken: StreetauthCall.streettoken(
              (_model.streetauth?.jsonBody ?? ''),
            ),
          );
        }

        setState(() {
          _showResult = true;
          _isSuccessResult = purchaseStatus;
          _resultTitle = purchaseStatus ? 'Data Purchased!' : 'Purchase Failed';
          _resultMessage = purchaseMessage;
          _resultServiceType = '${widget.network ?? ""} Data${widget.dataplan != null ? " (${widget.dataplan})" : ""}';
          _isProcessing = false;
        });
      } else {
        setState(() {
          _isProcessing = false;
          _pin = '';
          _model.pinCodeController?.clear();
        });
        final backendMsg = (IspincodevalidCall.message(_model.pincode?.jsonBody ?? '') ?? '').trim();
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

  Widget _buildResultRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5, fontWeight: FontWeight.w500,
            color: const Color(0xFF6E7A72),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.0,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: const Color(0xFF101614),
          ),
        ),
      ],
    );
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
    // Show inline result view after transaction completes
    if (_showResult) {
      final formattedAmount = (widget.amount ?? '0').startsWith('₦')
          ? (widget.amount ?? '0')
          : '₦${widget.amount ?? '0'}';
      final now = DateTime.now();
      final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      final dateStr = '${now.day} ${months[now.month - 1]} ${now.year}, ${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}';

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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36.0, height: 4.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6DCD7),
                    borderRadius: BorderRadius.circular(999.0),
                  ),
                ),
                const SizedBox(height: 24.0),
                Container(
                  width: 80.0, height: 80.0,
                  decoration: BoxDecoration(
                    color: _isSuccessResult ? const Color(0xFFEDF7EE) : const Color(0xFFFEEEEE),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 54.0, height: 54.0,
                    decoration: BoxDecoration(
                      color: _isSuccessResult ? const Color(0xFF56B84B) : const Color(0xFFD9383A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isSuccessResult ? Icons.check_rounded : Icons.close_rounded,
                      color: Colors.white, size: 30.0,
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                Text(
                  _resultTitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22.0, fontWeight: FontWeight.w800,
                    color: const Color(0xFF101614), letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Text(
                  _resultMessage,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5, fontWeight: FontWeight.w500,
                    color: const Color(0xFF6E7A72), height: 1.5,
                  ),
                ),
                if (_isSuccessResult) ...[
                  const SizedBox(height: 22.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFCFA),
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(color: const Color(0xFFE6EAE7)),
                    ),
                    child: Column(
                      children: [
                        _buildResultRow('Service', _resultServiceType),
                        const SizedBox(height: 10.0),
                        _buildResultRow('Recipient', widget.receipent ?? ''),
                        const SizedBox(height: 10.0),
                        _buildResultRow('Amount', formattedAmount, isBold: true),
                        const SizedBox(height: 10.0),
                        _buildResultRow('Date', dateStr),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity, height: 54.0,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil(
                      (route) => route.settings.name == NewhomeWidget.routeName,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSuccessResult
                          ? const Color(0xFF56B84B)
                          : const Color(0xFF101614),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: Text(
                      _isSuccessResult ? 'Done' : 'Go Home',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15.5, fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                if (!_isSuccessResult) ...[
                  const SizedBox(height: 12.0),
                  SizedBox(
                    width: double.infinity, height: 48.0,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF2F8F3C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: Text(
                        'Try Again',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15.0, fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

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
                    'Authorize ${widget.dataplan ?? "data bundle"} purchase',
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
                            'Processing data purchase...',
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
