import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'transerconfirm_model.dart';
export 'transerconfirm_model.dart';

class TranserconfirmWidget extends StatefulWidget {
  const TranserconfirmWidget({
    super.key,
    required this.recipient,
    required this.amount,
    required this.transferfee,
    required this.receiveraccount,
    this.bankname,
    this.bankcode,
    this.description,
    this.transref,
    this.sessionid,
  });

  final String? recipient;
  final String? amount;
  final String? transferfee;
  final String? receiveraccount;
  final String? bankname;
  final String? bankcode;
  final String? description;
  final String? transref;
  final String? sessionid;

  @override
  State<TranserconfirmWidget> createState() => _TranserconfirmWidgetState();
}

class _TranserconfirmWidgetState extends State<TranserconfirmWidget> {
  late TranserconfirmModel _model;

  // View state: false = Confirmation summary, true = PIN keypad
  bool _showPinView = false;
  bool _isProcessing = false;
  String _pin = '';
  String? _errorMessage;

  // PIN lockout logic
  int _failedPinAttempts = 0;
  DateTime? _pinLockUntil;
  static const int _maxPinAttempts = 3;
  static const Duration _pinLockoutDuration = Duration(seconds: 30);

  bool get _isPinLocked =>
      _pinLockUntil != null && DateTime.now().isBefore(_pinLockUntil!);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TranserconfirmModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      try {
        _model.streetauth = await StreetauthCall.call();
        _model.receiverphone = await GetphonenCall.call(
          accountNo: widget.receiveraccount,
          accessToken: StreetauthCall.streettoken(
            (_model.streetauth?.jsonBody ?? ''),
          ),
        );
        _model.pinnedlist = await GetpinnedphonesCall.call(
          hostphone: FFAppState().phonenumber,
          accessToken: StreetauthCall.streettoken(
            (_model.streetauth?.jsonBody ?? ''),
          ),
        );
        safeSetState(() {});
      } catch (_) {}
    });
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
      });
      if (_pin.length == 5) {
        _submitPayment();
      }
    }
  }

  void _onDelete() {
    if (_isProcessing || _pin.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _errorMessage = null;
      _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  Future<void> _onBiometric() async {
    if (_isProcessing || _isPinLocked) return;
    if (!FFAppState().biometric) return;
    try {
      final localAuth = LocalAuthentication();
      final isSupported = await localAuth.isDeviceSupported();
      final canCheck = await localAuth.canCheckBiometrics;
      if (isSupported && canCheck) {
        final formattedAmt = formatNumber(
          functions.stringtodouble(widget.amount),
          formatType: FormatType.decimal,
          decimalType: DecimalType.periodDecimal,
          currency: '₦',
        );
        final authenticated = await localAuth.authenticate(
          localizedReason:
              'Send $formattedAmt to ${widget.recipient ?? 'recipient'}',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (authenticated) {
          await _submitPayment(viaFingerprint: true);
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

  Future<void> _submitPayment({bool viaFingerprint = false}) async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      bool pinValid = false;

      if (viaFingerprint) {
        pinValid = true;
      } else {
        final pincodeRes = await IspincodevalidCall.call(
          phoneno: functions.removecode(FFAppState().phonenumber),
          pincode: _pin,
          accessToken: FFAppState().bsptoken,
          deviceid: FFAppState().deviceid,
        );

        final session = IspincodevalidCall.sessionid(
          pincodeRes.jsonBody,
        );
        if (session != null) {
          FFAppState().sessionid = session;
        }

        pinValid = IspincodevalidCall.success(pincodeRes.jsonBody) == true;
      }

      if (pinValid) {
        final parsedAmount = functions.stringtodouble(widget.amount);
        if (parsedAmount <= 0.0) {
          if (mounted) {
            setState(() {
              _isProcessing = false;
              _pin = '';
              _errorMessage = 'Invalid transfer amount.';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter a valid transfer amount greater than ₦0'),
                backgroundColor: Color(0xFFD32F2F),
              ),
            );
          }
          return;
        }

        // Clean account number to strictly 10 digits
        String cleanReceiverAccount =
            (widget.receiveraccount ?? '').replaceAll(RegExp(r'\D'), '');
        if (cleanReceiverAccount.length == 11 &&
            cleanReceiverAccount.startsWith('0')) {
          cleanReceiverAccount = cleanReceiverAccount.substring(1);
        }
        if (cleanReceiverAccount.length != 10) {
          if (mounted) {
            setState(() {
              _isProcessing = false;
              _pin = '';
              _errorMessage =
                  'Recipient account number must be exactly 10 digits.';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Recipient account number must be exactly 10 digits.'),
                backgroundColor: Color(0xFFD32F2F),
              ),
            );
          }
          return;
        }

        // Map StreetPay / 9PSB bank code properly
        String cleanBankCode = (widget.bankcode ?? '').trim();
        if (cleanBankCode.isEmpty ||
            cleanBankCode.toLowerCase().contains('streetpay') ||
            cleanBankCode == '000000' ||
            !RegExp(r'^\d{3,6}$').hasMatch(cleanBankCode)) {
          cleanBankCode = '120001';
        }

        // Check wallet balance against amount + EMTL stamp duty (₦50 on transfers >= ₦10,000) + transfer fee
        final double userBal = functions.stringtodouble(FFAppState().avalbal);
        final double stampDuty = parsedAmount >= 10000.0 ? 50.0 : 0.0;
        final double fee = functions.stringtodouble(widget.transferfee);
        final double totalNeeded = parsedAmount + stampDuty + fee;
        if (userBal < totalNeeded) {
          final errMsg = stampDuty > 0
              ? 'Insufficient balance: ₦${formatNumber(totalNeeded, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)} required (including ₦50 EMTL stamp duty on transfers ≥ ₦10,000).'
              : 'Insufficient wallet balance to cover transfer amount and fee.';
          if (mounted) {
            setState(() {
              _isProcessing = false;
              _pin = '';
              _errorMessage = errMsg;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errMsg),
                backgroundColor: const Color(0xFFD32F2F),
              ),
            );
          }
          return;
        }

        // Generate a fresh unique transaction reference on every submission attempt
        final currentTransRef = await actions.generatetransref();

        // Ensure valid bearer access token from Streetauth
        String tokenToUse = FFAppState().bsptoken;
        if (tokenToUse.isEmpty) {
          final authRes = await StreetauthCall.call(forceRefresh: true);
          final fresh = StreetauthCall.streettoken(authRes.jsonBody);
          if (fresh != null && fresh.isNotEmpty) {
            tokenToUse = fresh;
            FFAppState().bsptoken = fresh;
          }
        }

        // Use verified server session ID from PIN verification
        final sessionToUse = FFAppState().sessionid.isNotEmpty
            ? FFAppState().sessionid
            : (widget.sessionid ?? await actions.generateseesionid());

        final transtokenRes = await GettransactiontokenCall.call(
          accessToken: tokenToUse,
          accountno: FFAppState().accountno,
          deviceid: FFAppState().deviceid,
          sessionid: sessionToUse,
        );

        final othertransRes = await WalletAsAServiceGroup.otherBankTransferCall.call(
          customeraccount: cleanBankCode,
          customername: widget.recipient,
          customeraccountno: cleanReceiverAccount,
          senderaccountno: FFAppState().accountno,
          sendername: FFAppState().accountname,
          narration: '${widget.recipient}',
          amount: parsedAmount.toString(),
          description: valueOrDefault<String>(widget.description, '-'),
          refrence: currentTransRef,
          sectionid: sessionToUse,
          authToken: tokenToUse,
          refid: GettransactiontokenCall.transtoken(
            transtokenRes.jsonBody,
          ),
        );

        if (WalletAsAServiceGroup.otherBankTransferCall
                .success(othertransRes.jsonBody) ==
            true) {
          if (mounted) {
            Navigator.pop(context, true);
          }
        } else {
          final errorMsg = WalletAsAServiceGroup.otherBankTransferCall
                  .message(othertransRes.jsonBody) ??
              'Transaction failed. Please try again.';

          try {
            await LogtransactionCall.call(
              phoneno: FFAppState().phonenumber,
              accountId: FFAppState().accountno,
              reqtype: 'Transfer--${widget.amount}',
              sSid: sessionToUse,
              passorfail: 'Failed',
              balBefore: FFAppState().avalbal,
              balafter: FFAppState().avalbal,
              beneficiary: widget.recipient,
              tammt: widget.amount,
              extra: widget.description,
              transREF: currentTransRef,
              accessToken: FFAppState().bsptoken,
              ttype: 'Debit',
            );
          } catch (_) {}

          if (mounted) {
            setState(() {
              _isProcessing = false;
              _pin = '';
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
          final remaining = _maxPinAttempts - _failedPinAttempts;
          final lockMsg = _isPinLocked
              ? 'Too many wrong PINs. Try again in ${_pinLockUntil!.difference(DateTime.now()).inSeconds}s.'
              : 'Invalid PIN. $remaining attempt${remaining == 1 ? '' : 's'} left.';
          setState(() {
            _isProcessing = false;
            _pin = '';
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
          _pin = '';
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
    final double numericAmount = functions.stringtodouble(widget.amount);
    final String formattedAmount = formatNumber(
      numericAmount,
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
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _isProcessing
              ? _buildProcessingView(formattedAmount)
              : (_showPinView
                  ? _buildPinInputView(formattedAmount)
                  : _buildConfirmationView(formattedAmount)),
        ),
      ),
    );
  }

  Widget _buildConfirmationView(String formattedAmount) {
    final double numericAmount = functions.stringtodouble(widget.amount);
    return Padding(
      key: const ValueKey('confirmation_view'),
      padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 24.0),
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

          // Title Row
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context, false),
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
              const SizedBox(width: 12),
              Text(
                'Confirm transfer',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF101614),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE6EAE7)),
            ),
            child: Column(
              children: [
                Text(
                  'You are sending',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF6E7A72),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    formattedAmount,
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF101614),
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Detail rows
                _buildRow('To', widget.recipient ?? 'Recipient'),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Account',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF6E7A72),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.receiveraccount ?? '',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF101614),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.bankname?.isNotEmpty == true
                            ? widget.bankname!
                            : 'StreetPay',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF6E7A72),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (numericAmount >= 10000.0) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Stamp duty (EMTL)',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF6E7A72),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₦50.00',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF101614),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fee',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF6E7A72),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.transferfee?.isNotEmpty == true
                          ? '₦${widget.transferfee}'
                          : '₦0.00',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF2F8F3C),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFEDF0ED),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total debit',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF101614),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        formatNumber(
                          numericAmount +
                              (numericAmount >= 10000.0 ? 50.0 : 0.0) +
                              functions.stringtodouble(widget.transferfee),
                          formatType: FormatType.decimal,
                          decimalType: DecimalType.periodDecimal,
                          currency: '₦',
                        ),
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF101614),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Pin Payee Checkbox (if applicable)
          if (GetpinnedphonesCall.phones(
                (_model.pinnedlist?.jsonBody ?? ''),
              )?.contains(GetphonenCall.phoneno(
                (_model.receiverphone?.jsonBody ?? ''),
              )) ??
              true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _model.checkboxValue ??= false,
                      activeColor: const Color(0xFF56B84B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      onChanged: (newValue) async {
                        safeSetState(() => _model.checkboxValue = newValue!);
                        if (newValue!) {
                          _model.streetaut = await StreetauthCall.call();
                          _model.getreceiverphonenumber =
                              await GetphonenCall.call(
                            accountNo: widget.receiveraccount,
                            accessToken: StreetauthCall.streettoken(
                              (_model.streetaut?.jsonBody ?? ''),
                            ),
                          );

                          _model.apiResult33o = await InsertpindataCall.call(
                            hostphone: FFAppState().phonenumber,
                            guestphone: GetphonenCall.phoneno(
                              (_model.getreceiverphonenumber?.jsonBody ?? ''),
                            ),
                            datein: dateTimeFormat(
                              "yMMMd",
                              getCurrentTimestamp,
                              locale: FFLocalizations.of(context).languageCode,
                            ),
                            timein: dateTimeFormat(
                              "jm",
                              getCurrentTimestamp,
                              locale: FFLocalizations.of(context).languageCode,
                            ),
                            accessToken: StreetauthCall.streettoken(
                              (_model.streetaut?.jsonBody ?? ''),
                            ),
                          );

                          if ((_model.apiResult33o?.succeeded ?? true)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Recipient saved to favorites'),
                                duration: Duration(milliseconds: 3000),
                                backgroundColor: Color(0xFF0B2018),
                              ),
                            );
                          }
                          safeSetState(() {});
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Save as favorite recipient',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF6E7A72),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          // Confirm Button -> Transitions directly to PIN view
          FFButtonWidget(
            onPressed: () async {
              HapticFeedback.lightImpact();
              setState(() {
                _showPinView = true;
                _pin = '';
                _errorMessage = null;
              });
            },
            text: 'Proceed to PIN',
            options: FFButtonOptions(
              width: double.infinity,
              height: 52.0,
              padding: EdgeInsets.zero,
              iconPadding: EdgeInsets.zero,
              color: const Color(0xFF56B84B),
              textStyle: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF06210F),
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),

          const SizedBox(height: 8),

          // Cancel Button
          FFButtonWidget(
            onPressed: () async {
              Navigator.pop(context, false);
            },
            text: 'Cancel',
            options: FFButtonOptions(
              width: double.infinity,
              height: 44.0,
              padding: EdgeInsets.zero,
              iconPadding: EdgeInsets.zero,
              color: Colors.transparent,
              textStyle: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF6E7A72),
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
              elevation: 0.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinInputView(String amountStr) {
    return Padding(
      key: const ValueKey('pin_input_view'),
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

          // Header with back arrow to return to confirmation view
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _showPinView = false;
                    _pin = '';
                    _errorMessage = null;
                  });
                },
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
                    Icons.arrow_back_rounded,
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
              InkWell(
                onTap: () => Navigator.pop(context, false),
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
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Authorize $amountStr to ${widget.recipient ?? "recipient"}',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF6E7A72),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
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
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
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
                    // Biometric button
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

  Widget _buildProcessingView(String amountStr) {
    return Container(
      key: const ValueKey('processing_view'),
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
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 2,
              offset: Offset(0, 1),
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

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF6E7A72),
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF101614),
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
