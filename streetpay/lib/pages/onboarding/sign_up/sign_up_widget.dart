import '/components/errorcomp_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'sign_up_model.dart';
export 'sign_up_model.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  static String routeName = 'SignUp';
  static String routePath = '/signUp';

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  late SignUpModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _bvnController;
  late TextEditingController _ninController;
  late FocusNode _bvnFocusNode;
  late FocusNode _ninFocusNode;
  bool _termsAccepted = false;
  bool _isLoading = false;

  final List<String> _referralOptions = [
    'Radio Station Ad',
    'StreetPay Agent',
    'Friend / Family',
    'Social Media',
    'None / Other',
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignUpModel());
    _model.phoneNumberFieldModel.textController ??= TextEditingController();
    _bvnController = TextEditingController();
    _ninController = TextEditingController();
    _bvnFocusNode = FocusNode();
    _ninFocusNode = FocusNode();
    _model.checkboxValue = _termsAccepted;
  }

  @override
  void dispose() {
    _bvnController.dispose();
    _ninController.dispose();
    _bvnFocusNode.dispose();
    _ninFocusNode.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (_isLoading) return;
    final rawPhone = _model.phoneNumberFieldModel.textController.text.trim();
    final bvn = _bvnController.text.replaceAll(RegExp(r'\D'), '');
    final nin = _ninController.text.replaceAll(RegExp(r'\D'), '');

    if (rawPhone.isEmpty) {
      _showError('Please enter your phone number');
      return;
    }
    if (bvn.length != 11) {
      _showError('Please enter your 11-digit Bank Verification Number (BVN)');
      return;
    }
    if (nin.length != 11) {
      _showError('Please enter your 11-digit National Identity Number (NIN)');
      return;
    }
    if (!_termsAccepted) {
      _showError('Please accept the terms and conditions');
      return;
    }

    setState(() => _isLoading = true);
    try {
      _model.checkboxValue = _termsAccepted;

      final formattedPhone = functions.addcode(rawPhone);

      await context.pushNamed(
        ConsentfieldWidget.routeName,
        queryParameters: {
          'phone': serializeParam(
            formattedPhone,
            ParamType.String,
          ),
          'registerwith': serializeParam(
            'BOTH',
            ParamType.String,
          ),
          'bvn': serializeParam(
            bvn,
            ParamType.String,
          ),
          'nin': serializeParam(
            nin,
            ParamType.String,
          ),
          'radio': serializeParam(
            _model.dropDownValue ?? 'None',
            ParamType.String,
          ),
        }.withoutNulls,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
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

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar with back button and step header
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 12.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(50.0),
                      child: Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF3F6F3),
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
                          'Create your wallet',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF101614),
                          ),
                        ),
                        Text(
                          'Step 1 of 5 · your details',
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

              // Progress line (20%)
              Container(
                height: 4.0,
                color: const Color(0xFFEDF0ED),
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.2,
                  height: 4.0,
                  color: const Color(0xFF56B84B),
                ),
              ),

              // Form content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What is your phone number?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF101614),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Use the number linked to your BVN or NIN. We send a one-time code to confirm it.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6E7A72),
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 18.0),

                      // Phone Input with Nigerian Flag & +234
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (!(_model.phoneNumberFieldModel.textFieldFocusNode?.hasFocus ?? false)) {
                                _model.phoneNumberFieldModel.textFieldFocusNode?.requestFocus();
                              }
                            },
                            borderRadius: BorderRadius.circular(14.0),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              width: 94.0,
                              height: 56.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14.0),
                                border: Border.all(
                                  color: const Color(0xFFE6EAE7),
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(2.0),
                                    child: Container(
                                      width: 20.0,
                                      height: 14.0,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                                  color:
                                                      const Color(0xFF2F8F3C))),
                                          Expanded(
                                              child: Container(
                                                  color: Colors.white)),
                                          Expanded(
                                              child: Container(
                                                  color:
                                                      const Color(0xFF2F8F3C))),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    '+234',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF101614),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (!(_model.phoneNumberFieldModel.textFieldFocusNode?.hasFocus ?? false)) {
                                  _model.phoneNumberFieldModel.textFieldFocusNode?.requestFocus();
                                }
                              },
                              borderRadius: BorderRadius.circular(14.0),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                height: 56.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7FCF7),
                                  borderRadius: BorderRadius.circular(14.0),
                                  border: Border.all(
                                    color: const Color(0xFF56B84B),
                                    width: 2.0,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0),
                                alignment: Alignment.centerLeft,
                                child: TextFormField(
                                  controller: _model
                                      .phoneNumberFieldModel.textController,
                                  focusNode: _model
                                      .phoneNumberFieldModel.textFieldFocusNode,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF101614),
                                    letterSpacing: 0.6,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '803 421 4214',
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF8B968F)
                                          .withValues(alpha: 0.6),
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22.0),

                      // DUAL VERIFICATION BANNER
                      Container(
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FCF7),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: const Color(0xFF56B84B).withValues(alpha: 0.35),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32.0,
                              height: 32.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFF56B84B).withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.shield_rounded,
                                color: Color(0xFF2F8F3C),
                                size: 18.0,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dual Identity Verification',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF101614),
                                    ),
                                  ),
                                  const SizedBox(height: 3.0),
                                  Text(
                                    'Enter both your BVN and NIN. StreetPay verifies both in parallel so your tier 1 wallet opens instantly without downtime.',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
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

                      const SizedBox(height: 20.0),

                      // BVN FIELD
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'BANK VERIFICATION NUMBER (BVN)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF6E7A72),
                              letterSpacing: 0.7,
                            ),
                          ),
                          Text(
                            '11 digits',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF8B968F),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      InkWell(
                        onTap: () {
                          if (!_bvnFocusNode.hasFocus) {
                            _bvnFocusNode.requestFocus();
                          }
                        },
                        borderRadius: BorderRadius.circular(14.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          height: 56.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(
                              color: const Color(0xFFE6EAE7),
                              width: 1.0,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.account_balance_rounded,
                                color: Color(0xFF2F8F3C),
                                size: 20.0,
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _bvnController,
                                  focusNode: _bvnFocusNode,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF101614),
                                    letterSpacing: 1.0,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter 11-digit BVN',
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFA0ABA3),
                                      letterSpacing: 0.0,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18.0),

                      // NIN FIELD
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'NATIONAL IDENTITY NUMBER (NIN)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF6E7A72),
                              letterSpacing: 0.7,
                            ),
                          ),
                          Text(
                            '11 digits',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF8B968F),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      InkWell(
                        onTap: () {
                          if (!_ninFocusNode.hasFocus) {
                            _ninFocusNode.requestFocus();
                          }
                        },
                        borderRadius: BorderRadius.circular(14.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          height: 56.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(
                              color: const Color(0xFFE6EAE7),
                              width: 1.0,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.credit_card_rounded,
                                color: Color(0xFF2F8F3C),
                                size: 20.0,
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _ninController,
                                  focusNode: _ninFocusNode,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF101614),
                                    letterSpacing: 1.0,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter 11-digit NIN',
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFA0ABA3),
                                      letterSpacing: 0.0,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24.0),

                      // WHO REFERRED YOU
                      Text(
                        'WHO REFERRED YOU (optional)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF6E7A72),
                          letterSpacing: 0.7,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        height: 54.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(
                            color: const Color(0xFFE6EAE7),
                            width: 1.0,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _model.dropDownValue,
                            hint: Text(
                              'Select a referral channel or agent',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8B968F),
                              ),
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF6E7A72),
                            ),
                            isExpanded: true,
                            items: _referralOptions
                                .map(
                                  (opt) => DropdownMenuItem(
                                    value: opt,
                                    child: Text(
                                      opt,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF101614),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() => _model.dropDownValue = val);
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      // Terms & Conditions Checkbox
                      InkWell(
                        onTap: () {
                          setState(() => _termsAccepted = !_termsAccepted);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 22.0,
                              height: 22.0,
                              decoration: BoxDecoration(
                                color: _termsAccepted
                                    ? const Color(0xFF56B84B)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(
                                  color: _termsAccepted
                                      ? const Color(0xFF56B84B)
                                      : const Color(0xFFC3CDC6),
                                  width: 2.0,
                                ),
                              ),
                              child: _termsAccepted
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 14.0,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 11.0),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'I have read the ',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF6E7A72),
                                    height: 1.5,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms and Conditions',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF2F8F3C),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const TextSpan(text: ' and the '),
                                    TextSpan(
                                      text: 'Data Privacy Policy',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF2F8F3C),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const TextSpan(text: '.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),

              // Sticky Continue Button Area
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFEDF0ED),
                      width: 1.0,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    FFButtonWidget(
                      onPressed: _isLoading ? null : _handleContinue,
                      loading: _isLoading,
                      text: 'Continue',
                      loadingText: 'Processing...',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 54.0,
                        color: _termsAccepted
                            ? const Color(0xFF56B84B)
                            : const Color(0xFFE4EAE5),
                        textStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: _termsAccepted
                              ? const Color(0xFF06210F)
                              : const Color(0xFF9AA5A0),
                        ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    Center(
                      child: InkWell(
                        onTap: () {
                          context.pushNamed(Login1Widget.routeName);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6E7A72),
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign in',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF2F8F3C),
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
            ],
          ),
        ),
      ),
    );
  }
}
