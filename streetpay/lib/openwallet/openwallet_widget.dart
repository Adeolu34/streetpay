import '/backend/api_requests/api_calls.dart';
import '/components/errorcomp_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'openwallet_model.dart';
export 'openwallet_model.dart';

class OpenwalletWidget extends StatefulWidget {
  const OpenwalletWidget({
    super.key,
    this.openwith,
    this.phone,
    this.bvn,
    this.nin,
  });

  final String? openwith;
  final String? phone;
  final String? bvn;
  final String? nin;

  static String routeName = 'openwallet';
  static String routePath = '/openwallet';

  @override
  State<OpenwalletWidget> createState() => _OpenwalletWidgetState();
}

class _OpenwalletWidgetState extends State<OpenwalletWidget> {
  late OpenwalletModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  String _loadingStatus = '';

  // Phone verification state
  String _originalPhone = '';
  bool _phoneVerified = true;
  bool _otpSent = false;
  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;
  String _otpInput = '';
  final _otpController = TextEditingController();

  // Day, Month, Year lists for Date of Birth
  final List<String> _days = List.generate(
    31,
    (index) => (index + 1).toString().padLeft(2, '0'),
  );

  final List<String> _months = List.generate(
    12,
    (index) => (index + 1).toString().padLeft(2, '0'),
  );

  late final List<String> _years = List.generate(
    85,
    (index) => (DateTime.now().year - 16 - index).toString(),
  );

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OpenwalletModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textControllerNIN ??= TextEditingController(text: widget.nin ?? '');
    _model.textFieldFocusNodeNIN ??= FocusNode();

    _model.textControllerBVN ??= TextEditingController(text: widget.bvn ?? '');
    _model.textFieldFocusNodeBVN ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    final initialPhone = widget.phone != null && widget.phone!.isNotEmpty
        ? functions.addcode(widget.phone)
        : '';
    _model.textController5 ??= TextEditingController(text: initialPhone);
    _model.textFieldFocusNode5 ??= FocusNode();

    _originalPhone = initialPhone ?? '';
    _model.textController5!.addListener(_onPhoneChanged);

    // Default dropdown values
    _model.dropDownValue1 ??= 'Male';
    _model.dropDownValue2 ??= '01';
    _model.dropDownValue3 ??= '01';
    _model.dropDownValue4 ??= '2000';
  }

  @override
  void dispose() {
    _model.textController5?.removeListener(_onPhoneChanged);
    _otpController.dispose();
    _model.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    final current = _model.textController5?.text.trim() ?? '';
    final changed = current != _originalPhone && current.isNotEmpty;
    if (changed && _phoneVerified) {
      setState(() {
        _phoneVerified = false;
        _otpSent = false;
        _otpInput = '';
        _otpController.clear();
      });
    } else if (!changed) {
      setState(() {
        _phoneVerified = true;
        _otpSent = false;
      });
    }
  }

  Future<void> _sendPhoneOtp() async {
    final rawPhone = _model.textController5?.text.trim() ?? '';
    final cleanPhone = rawPhone.startsWith('+234')
        ? rawPhone.substring(4)
        : rawPhone.startsWith('0')
            ? rawPhone.substring(1)
            : rawPhone;
    if (cleanPhone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid phone number first.')),
      );
      return;
    }
    setState(() => _isSendingOtp = true);
    try {
      await GetotpfromphoneCall.call(
        phone: cleanPhone,
        accessToken: FFAppState().bsptoken,
        oldphone: FFAppState().phonenumber,
      );
      setState(() {
        _otpSent = true;
        _isSendingOtp = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent to your new phone number.'),
          backgroundColor: Color(0xFF2F8F3C),
        ),
      );
    } catch (_) {
      setState(() => _isSendingOtp = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send OTP. Please check your connection.')),
      );
    }
  }

  Future<void> _verifyPhoneOtp() async {
    final otp = _otpInput.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter the 6-digit OTP.')),
      );
      return;
    }
    final rawPhone = _model.textController5?.text.trim() ?? '';
    setState(() => _isVerifyingOtp = true);
    try {
      final streetauthResp = await StreetauthCall.call();
      final token = StreetauthCall.streettoken(streetauthResp.jsonBody) ?? FFAppState().streetauth;
      final resp = await VerifyphoneCall.call(
        phoneno: rawPhone,
        otp: otp,
        accessToken: token,
      );
      if (VerifyphoneCall.status(resp.jsonBody) == true) {
        setState(() {
          _phoneVerified = true;
          _isVerifyingOtp = false;
          _originalPhone = rawPhone;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number verified!'),
            backgroundColor: Color(0xFF2F8F3C),
          ),
        );
      } else {
        setState(() => _isVerifyingOtp = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP. Please try again.'),
            backgroundColor: Color(0xFFB53434),
          ),
        );
        _otpController.clear();
        setState(() => _otpInput = '');
      }
    } catch (_) {
      setState(() => _isVerifyingOtp = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification failed. Please try again.')),
      );
    }
  }

  Future<void> _handleVerificationAndRegistration() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!_model.formKey.currentState!.validate()) {
      return;
    }

    if (_model.dropDownValue1 == null || _model.dropDownValue1!.isEmpty) {
      _showGeneralError('Please select your gender.');
      return;
    }

    if (_model.dropDownValue2 == null || _model.dropDownValue3 == null || _model.dropDownValue4 == null) {
      _showGeneralError('Please select your complete date of birth (Day, Month, and Year).');
      return;
    }

    final firstName = _model.textController1!.text.trim();
    final lastName = _model.textController2!.text.trim();
    final nin = _model.textControllerNIN!.text.trim();
    final bvn = _model.textControllerBVN!.text.trim();
    final email = _model.textController4!.text.trim();
    final rawPhone = _model.textController5!.text.trim();
    final phone = functions.addcode(rawPhone);
    final cleanPhone = functions.removecode(rawPhone) ?? rawPhone;

    final day = _model.dropDownValue2 ?? '01';
    final month = _model.dropDownValue3 ?? '01';
    final year = _model.dropDownValue4 ?? '2000';
    final dob = '$day/$month/$year';

    final genderStr = _model.dropDownValue1 ?? 'Male';
    final genderCode = (genderStr.toLowerCase() == 'male') ? 0 : 1;

    setState(() {
      _isLoading = true;
      _loadingStatus = 'Authenticating verification service...';
    });

    try {
      // 1. Streetauth Call
      _model.streetauth = await StreetauthCall.call();
      final streetToken =
          StreetauthCall.streettoken(_model.streetauth?.jsonBody ?? '');

      if (streetToken == null || streetToken.isEmpty) {
        setState(() => _isLoading = false);
        _showGeneralError(
          'Verification service is momentarily unavailable. Please check your internet connection and try again.',
        );
        return;
      }

      // 2. PRIMARY ATTEMPT: Try NIN first
      setState(() => _loadingStatus = 'Verifying identity with NIN...');

      _model.openwallet = await WalletAsAServiceGroup.openwalletCall.call(
        dob: dob,
        gender: genderCode,
        lastName: functions.textformat(lastName),
        otherName: functions.textformat(firstName),
        phoneNo: phone,
        transactionTrackingRef:
            random_data.randomString(6, 12, true, false, false),
        accountName:
            '${functions.textformat(lastName)} ${functions.textformat(firstName)}',
        email: email.isNotEmpty ? email : 'nil',
        authToken: streetToken,
        ninUserId: 'ABSSEF-0123',
        nationalIdentityNo: nin,
      );

      final ninStatus = WalletAsAServiceGroup.openwalletCall
          .status(_model.openwallet?.jsonBody ?? '');
      final ninSuccess = (ninStatus == 'SUCCESS');

      if (ninSuccess) {
        // NIN Succeeded! Finalize tier 1 creation
        setState(() => _loadingStatus = 'NIN verified! Setting up tier 1 wallet...');

        _model.insertintotierone = await InsertintotieroneCall.call(
          phoneno: cleanPhone,
          surname: lastName,
          othernames: firstName,
          dob: dob,
          gender: genderStr,
          accessToken: FFAppState().bsptoken,
          useremail: email.isNotEmpty ? email : 'nil',
          bvn: bvn.isNotEmpty ? bvn : nin,
        );

        final accountNo = WalletAsAServiceGroup.openwalletCall
            .accountno(_model.openwallet?.jsonBody ?? '');
        final customerNo = WalletAsAServiceGroup.openwalletCall
            .customerid(_model.openwallet?.jsonBody ?? '');

        _model.createid = await CreateNewIdCall.call(
          phoneno: cleanPhone,
          accountno: accountNo,
          customerno: customerNo,
          accessToken: FFAppState().bsptoken,
        );

        if (CreateNewIdCall.status(_model.createid?.jsonBody ?? '') == true) {
          FFAppState().accountno = accountNo ?? '';
          FFAppState().tier = '1';
          FFAppState().phonenumber = cleanPhone;
          FFAppState().accountname = WalletAsAServiceGroup.openwalletCall
                  .fullname(_model.openwallet?.jsonBody ?? '') ??
              '$firstName $lastName';
          FFAppState().email = email.isNotEmpty ? email : 'nil';
          FFAppState().bvn = bvn.isNotEmpty ? bvn : nin;
          FFAppState().walletid =
              CreateNewIdCall.message(_model.createid?.jsonBody ?? '') ?? '';
          FFAppState().avalbal = '0.00';
          safeSetState(() {});

          setState(() => _isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Wallet successfully opened with NIN verification!',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: const Color(0xFF2F8F3C),
              duration: const Duration(seconds: 4),
            ),
          );

          context.pushNamed(
            QuestionaireWidget.routeName,
            queryParameters: {
              'phone': serializeParam(cleanPhone, ParamType.String),
            }.withoutNulls,
          );
          return;
        }
      }

      // 3. FALLBACK ATTEMPT: NIN was not successful, try BVN
      final ninError = WalletAsAServiceGroup.openwalletCall
              .message(_model.openwallet?.jsonBody ?? '') ??
          'NIN verification could not be confirmed';

      setState(() =>
          _loadingStatus = 'NIN verification unsuccessful. Trying BVN fallback...');

      _model.waasopen = await WassopenCall.call(
        accessToken: streetToken,
        bvn: bvn,
        dob: dob,
        gender: genderCode,
        lastname: functions.textformat(lastName),
        phone: phone,
        tracking: random_data.randomString(15, 18, true, false, false),
        email: email.isNotEmpty ? email : 'nil',
        othername: functions.textformat(firstName),
      );

      final bvnStatus =
          WassopenCall.status(_model.waasopen?.jsonBody ?? '');
      final bvnSuccess = (bvnStatus == 'SUCCESS');

      if (bvnSuccess) {
        // BVN Succeeded! Finalize tier 1 creation
        setState(() => _loadingStatus = 'BVN verified! Setting up tier 1 wallet...');

        _model.insertintotierone1 = await InsertintotieroneCall.call(
          phoneno: cleanPhone,
          surname: lastName,
          othernames: firstName,
          dob: dob,
          gender: genderStr,
          accessToken: FFAppState().bsptoken,
          useremail: email.isNotEmpty ? email : 'nil',
          bvn: bvn,
        );

        final accountNo =
            WassopenCall.accountno(_model.waasopen?.jsonBody ?? '');
        final customerNo =
            WassopenCall.custormerid(_model.waasopen?.jsonBody ?? '');

        _model.createid1 = await CreateNewIdCall.call(
          accessToken: FFAppState().bsptoken,
          phoneno: cleanPhone,
          accountno: accountNo,
          customerno: customerNo,
        );

        if (CreateNewIdCall.status(_model.createid1?.jsonBody ?? '') == true) {
          FFAppState().accountno = accountNo ?? '';
          FFAppState().tier = '1';
          FFAppState().phonenumber = cleanPhone;
          FFAppState().walletid =
              CreateNewIdCall.message(_model.createid1?.jsonBody ?? '') ?? '';
          FFAppState().accountname =
              WassopenCall.accountname(_model.waasopen?.jsonBody ?? '') ??
                  '$firstName $lastName';
          FFAppState().bvn = bvn;
          FFAppState().email = email.isNotEmpty ? email : 'nil';
          FFAppState().avalbal = '0.00';
          safeSetState(() {});

          setState(() => _isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Wallet successfully opened with BVN fallback verification!',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: const Color(0xFF2F8F3C),
              duration: const Duration(seconds: 4),
            ),
          );

          context.pushNamed(
            QuestionaireWidget.routeName,
            queryParameters: {
              'phone': serializeParam(cleanPhone, ParamType.String),
            }.withoutNulls,
          );
          return;
        }
      }

      // 4. BOTH FAILED: Report complete failure
      final bvnError = WassopenCall.message(_model.waasopen?.jsonBody ?? '') ??
          'BVN verification could not be confirmed';

      setState(() => _isLoading = false);

      _showDualFailureBottomSheet(
        ninError: ninError,
        bvnError: bvnError,
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showGeneralError('An unexpected error occurred: ${e.toString()}');
    }
  }

  void _showGeneralError(String message) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return WebViewAware(
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: ErrorcompWidget(message: message),
          ),
        );
      },
    );
  }

  void _showDualFailureBottomSheet({
    required String ninError,
    required String bvnError,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          padding: EdgeInsets.fromLTRB(
            24.0,
            16.0,
            24.0,
            MediaQuery.of(context).padding.bottom + 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 44.0,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6DCD7),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Title Header
              Row(
                children: [
                  Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECEB),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: Color(0xFFE53935),
                      size: 26.0,
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verification Failed',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF101614),
                          ),
                        ),
                        const SizedBox(height: 3.0),
                        Text(
                          'Both NIN and BVN attempts were unsuccessful',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: const Color(0xFF6E7A72),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Error explanation box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFCFA),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFE6EAE7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NIN Result
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.cancel_outlined,
                          size: 18.0,
                          color: Color(0xFFE53935),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NIN Attempt',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF101614),
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                ninError,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.0,
                                  color: const Color(0xFF6E7A72),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 22.0, color: Color(0xFFE6EAE7)),

                    // BVN Result
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.cancel_outlined,
                          size: 18.0,
                          color: Color(0xFFE53935),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BVN Fallback Attempt',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF101614),
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                bvnError,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.0,
                                  color: const Color(0xFF6E7A72),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // Helpful advice
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9E6),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: const Color(0xFFFFE082)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline_rounded,
                      color: Color(0xFFB78103),
                      size: 20.0,
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        'Tip: Ensure your First Name, Last Name, and Date of Birth match the official records on your NIN slip and Bank BVN profile exactly.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.0,
                          color: const Color(0xFF7A5600),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Button: Review and edit details
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F8F3C),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  child: Text(
                    'Review & Correct Information',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 13.0,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF6E7A72),
      ),
      hintText: hintText,
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 14.0,
        color: const Color(0xFFA0ABA3),
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFFAFCFA),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 14.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: const BorderSide(
          color: Color(0xFFE6EAE7),
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: const BorderSide(
          color: Color(0xFF56B84B),
          width: 1.6,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: const BorderSide(
          color: Color(0xFFE53935),
          width: 1.2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: const BorderSide(
          color: Color(0xFFE53935),
          width: 1.6,
        ),
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
        backgroundColor: const Color(0xFFF6F8F6),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 24.0,
            buttonSize: 44.0,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF101614),
              size: 22.0,
            ),
            onPressed: () async {
              context.pushNamed(SignUpWidget.routeName);
            },
          ),
          title: Text(
            'Open Wallet',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF101614),
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                'Step 2 of 2',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2F8F3C),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            controller: _model.columnController,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Form(
              key: _model.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trust Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(color: const Color(0xFFE6EAE7)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 10.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.0,
                          height: 44.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            color: Color(0xFF2F8F3C),
                            size: 24.0,
                          ),
                        ),
                        const SizedBox(width: 14.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Instant Identity Setup',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF101614),
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                'Bank-grade encryption • Licensed CBN Partner',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: const Color(0xFF6E7A72),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22.0),

                  // SECTION 1: PERSONAL INFORMATION
                  Text(
                    'PERSONAL INFORMATION',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF6E7A72),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(color: const Color(0xFFE6EAE7)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First Name
                        TextFormField(
                          controller: _model.textController1,
                          focusNode: _model.textFieldFocusNode1,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF101614),
                          ),
                          decoration: _buildInputDecoration(
                            labelText: 'First Name',
                            hintText: 'Enter legal first name',
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              size: 20.0,
                              color: Color(0xFF6E7A72),
                            ),
                          ),
                          validator: (val) =>
                              _model.textController1Validator?.call(context, val),
                        ),

                        const SizedBox(height: 16.0),

                        // Last Name
                        TextFormField(
                          controller: _model.textController2,
                          focusNode: _model.textFieldFocusNode2,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF101614),
                          ),
                          decoration: _buildInputDecoration(
                            labelText: 'Last Name (Surname)',
                            hintText: 'Enter legal surname',
                            prefixIcon: const Icon(
                              Icons.badge_outlined,
                              size: 20.0,
                              color: Color(0xFF6E7A72),
                            ),
                          ),
                          validator: (val) =>
                              _model.textController2Validator?.call(context, val),
                        ),

                        const SizedBox(height: 16.0),

                        // Gender Selection
                        Text(
                          'Gender',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6E7A72),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Row(
                          children: ['Male', 'Female'].map((gender) {
                            final isSelected = _model.dropDownValue1 == gender;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: gender == 'Male' ? 8.0 : 0.0,
                                  left: gender == 'Female' ? 8.0 : 0.0,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() => _model.dropDownValue1 = gender);
                                  },
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Container(
                                    height: 48.0,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFFE8F5E9)
                                          : const Color(0xFFFAFCFA),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF56B84B)
                                            : const Color(0xFFE6EAE7),
                                        width: isSelected ? 1.8 : 1.0,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          gender == 'Male'
                                              ? Icons.male_rounded
                                              : Icons.female_rounded,
                                          size: 18.0,
                                          color: isSelected
                                              ? const Color(0xFF2F8F3C)
                                              : const Color(0xFF6E7A72),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          gender,
                                          style:
                                              GoogleFonts.plusJakartaSans(
                                            fontSize: 14.0,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                            color: isSelected
                                                ? const Color(0xFF2F8F3C)
                                                : const Color(0xFF101614),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 18.0),

                        // Date of Birth
                        Text(
                          'Date of Birth (Day / Month / Year)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6E7A72),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Row(
                          children: [
                            // Day
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFCFA),
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: const Color(0xFFE6EAE7),
                                    width: 1.2,
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10.0),
                                child: FlutterFlowDropDown<String>(
                                  controller:
                                      _model.dropDownValueController2 ??=
                                          FormFieldController<String>(
                                              _model.dropDownValue2),
                                  options: _days,
                                  onChanged: (val) =>
                                      setState(() => _model.dropDownValue2 = val),
                                  width: double.infinity,
                                  height: 48.0,
                                  textStyle: GoogleFonts.plusJakartaSans(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF101614),
                                  ),
                                  hintText: 'Day',
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xFF6E7A72),
                                    size: 20.0,
                                  ),
                                  fillColor: Colors.transparent,
                                  dropdownColor: Colors.white,
                                  elevation: 4.0,
                                  borderColor: Colors.transparent,
                                  borderWidth: 0.0,
                                  borderRadius: 12.0,
                                  margin: EdgeInsets.zero,
                                  hidesUnderline: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),

                            // Month
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFCFA),
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: const Color(0xFFE6EAE7),
                                    width: 1.2,
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10.0),
                                child: FlutterFlowDropDown<String>(
                                  controller:
                                      _model.dropDownValueController3 ??=
                                          FormFieldController<String>(
                                              _model.dropDownValue3),
                                  options: _months,
                                  onChanged: (val) =>
                                      setState(() => _model.dropDownValue3 = val),
                                  width: double.infinity,
                                  height: 48.0,
                                  textStyle: GoogleFonts.plusJakartaSans(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF101614),
                                  ),
                                  hintText: 'Month',
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xFF6E7A72),
                                    size: 20.0,
                                  ),
                                  fillColor: Colors.transparent,
                                  dropdownColor: Colors.white,
                                  elevation: 4.0,
                                  borderColor: Colors.transparent,
                                  borderWidth: 0.0,
                                  borderRadius: 12.0,
                                  margin: EdgeInsets.zero,
                                  hidesUnderline: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),

                            // Year
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFCFA),
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: const Color(0xFFE6EAE7),
                                    width: 1.2,
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10.0),
                                child: FlutterFlowDropDown<String>(
                                  controller:
                                      _model.dropDownValueController4 ??=
                                          FormFieldController<String>(
                                              _model.dropDownValue4),
                                  options: _years,
                                  onChanged: (val) =>
                                      setState(() => _model.dropDownValue4 = val),
                                  width: double.infinity,
                                  height: 48.0,
                                  textStyle: GoogleFonts.plusJakartaSans(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF101614),
                                  ),
                                  hintText: 'Year',
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xFF6E7A72),
                                    size: 20.0,
                                  ),
                                  fillColor: Colors.transparent,
                                  dropdownColor: Colors.white,
                                  elevation: 4.0,
                                  borderColor: Colors.transparent,
                                  borderWidth: 0.0,
                                  borderRadius: 12.0,
                                  margin: EdgeInsets.zero,
                                  hidesUnderline: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // SECTION 2: IDENTITY VERIFICATION (NIN & BVN)
                  Text(
                    'IDENTITY VERIFICATION (NIN & BVN)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF6E7A72),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FCF7),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: const Color(0xFFC8E6C9),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dual explanation banner
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(color: const Color(0xFFE0EFE0)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.shield_outlined,
                                  color: Color(0xFF2F8F3C),
                                  size: 18.0,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dual Fallback Verification',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF101614),
                                      ),
                                    ),
                                    const SizedBox(height: 3.0),
                                    Text(
                                      'We will verify your NIN first. If the government NIN portal is unreachable or unconfirmed, we will automatically try your BVN as a fallback.',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.5,
                                        color: const Color(0xFF4A554E),
                                        height: 1.45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18.0),

                        // National Identity Number (NIN)
                        TextFormField(
                          controller: _model.textControllerNIN,
                          focusNode: _model.textFieldFocusNodeNIN,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF101614),
                            letterSpacing: 1.0,
                          ),
                          decoration: _buildInputDecoration(
                            labelText: 'National Identity Number (NIN)',
                            hintText: '11 digits without space',
                            prefixIcon: const Icon(
                              Icons.credit_card_outlined,
                              size: 20.0,
                              color: Color(0xFF2F8F3C),
                            ),
                          ),
                          validator: (val) =>
                              _model.textControllerNINValidator?.call(context, val),
                        ),

                        const SizedBox(height: 16.0),

                        // Bank Verification Number (BVN)
                        TextFormField(
                          controller: _model.textControllerBVN,
                          focusNode: _model.textFieldFocusNodeBVN,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF101614),
                            letterSpacing: 1.0,
                          ),
                          decoration: _buildInputDecoration(
                            labelText: 'Bank Verification Number (BVN)',
                            hintText: '11 digits without space',
                            prefixIcon: const Icon(
                              Icons.account_balance_outlined,
                              size: 20.0,
                              color: Color(0xFF2F8F3C),
                            ),
                          ),
                          validator: (val) =>
                              _model.textControllerBVNValidator?.call(context, val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // SECTION 3: CONTACT & COMMUNICATION
                  Text(
                    'CONTACT & COMMUNICATION',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF6E7A72),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(color: const Color(0xFFE6EAE7)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Phone Number
                        TextFormField(
                          controller: _model.textController5,
                          focusNode: _model.textFieldFocusNode5,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF101614),
                          ),
                          decoration: _buildInputDecoration(
                            labelText: 'Phone Number',
                            hintText: '0801 234 5678',
                            prefixIcon: const Icon(
                              Icons.phone_outlined,
                              size: 20.0,
                              color: Color(0xFF6E7A72),
                            ),
                          ),
                          validator: (val) =>
                              _model.textController5Validator?.call(context, val),
                        ),

                        // Phone change OTP verification
                        if (!_phoneVerified) ...[
                          const SizedBox(height: 10.0),
                          Container(
                            padding: const EdgeInsets.all(14.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: const Color(0xFFFFE082)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phone number changed. Verify the new number to continue.',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    color: const Color(0xFF7A5600),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                if (!_otpSent) ...[
                                  SizedBox(
                                    width: double.infinity,
                                    height: 42.0,
                                    child: ElevatedButton(
                                      onPressed: _isSendingOtp ? null : _sendPhoneOtp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2F8F3C),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: _isSendingOtp
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              'Send OTP to New Number',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ] else ...[
                                  TextField(
                                    controller: _otpController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    onChanged: (v) => setState(() => _otpInput = v),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 6.0,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '000000',
                                      counterText: '',
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 42.0,
                                    child: ElevatedButton(
                                      onPressed: _isVerifyingOtp ? null : _verifyPhoneOtp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2F8F3C),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: _isVerifyingOtp
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              'Verify OTP',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  TextButton(
                                    onPressed: _isSendingOtp ? null : _sendPhoneOtp,
                                    child: Text(
                                      'Resend OTP',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12.0,
                                        color: const Color(0xFF2F8F3C),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 16.0),

                        // Email Address
                        TextFormField(
                          controller: _model.textController4,
                          focusNode: _model.textFieldFocusNode4,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) =>
                              _model.textController4Validator?.call(context, val),
                          textInputAction: TextInputAction.done,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF101614),
                          ),
                          decoration: _buildInputDecoration(
                            labelText: 'Email Address (Optional)',
                            hintText: 'name@example.com',
                            prefixIcon: const Icon(
                              Icons.mail_outline_rounded,
                              size: 20.0,
                              color: Color(0xFF6E7A72),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28.0),

                  // SUBMISSION BUTTON WITH LIVE VERIFICATION STATUS
                  Container(
                    width: double.infinity,
                    height: 54.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2F8F3C).withValues(alpha: 0.28),
                          blurRadius: 16.0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: (_isLoading || !_phoneVerified)
                          ? null
                          : _handleVerificationAndRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F8F3C),
                        disabledBackgroundColor: const Color(0xFFA5D6A7),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Flexible(
                                  child: Text(
                                    _loadingStatus,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Verify & Open Wallet',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 36.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
