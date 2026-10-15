import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/bills/airtimeconfirmation/airtimeconfirmation_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import '/services/telco_logo_service.dart';
import 'airtimeform_model.dart';
export 'airtimeform_model.dart';

class AirtimeformWidget extends StatefulWidget {
  const AirtimeformWidget({
    super.key,
    required this.phonenumber,
  });

  final String? phonenumber;

  static String routeName = 'airtimeform';
  static String routePath = '/airtimeform';

  @override
  State<AirtimeformWidget> createState() => _AirtimeformWidgetState();
}

class _AirtimeformWidgetState extends State<AirtimeformWidget> {
  late AirtimeformModel _model;
  String? _selectedNetwork;
  bool _isSubmitting = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _quickAmounts = ['100', '200', '500', '1000', '2000', '5000'];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AirtimeformModel());

    _model.textController1 ??= TextEditingController(text: widget.phonenumber ?? '');
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    // If initial phone number provided, detect network
    if ((widget.phonenumber ?? '').length >= 10) {
      _detectNetwork(widget.phonenumber!);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _detectNetwork(String phone) async {
    _model.streetauth = await StreetauthCall.call();
    _model.apiResultn64 = await GetnetworkCall.call(
      phoneno: functions.addcode(phone),
      accessToken: StreetauthCall.streettoken(
        (_model.streetauth?.jsonBody ?? ''),
      ),
    );
    final detected = GetnetworkCall.network((_model.apiResultn64?.jsonBody ?? ''));
    if (detected != null && detected.isNotEmpty) {
      _selectedNetwork = detected.toUpperCase();
    }
    safeSetState(() {});
  }

  Widget _buildNetworkItem(String name, Color brandColor, Color bgColor) {
    final currentNetwork = _selectedNetwork ??
        GetnetworkCall.network((_model.apiResultn64?.jsonBody ?? ''))?.toUpperCase();
    final isSelected = currentNetwork == name.toUpperCase();

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedNetwork = name.toUpperCase();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 68.0,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEDF7EE) : Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(
              color: isSelected ? const Color(0xFF56B84B) : const Color(0xFFE6EAE7),
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: isSelected
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TelcoLogoWidget(
                network: name,
                size: 26.0,
                borderRadius: 6.0,
              ),
              const SizedBox(height: 4.0),
              Text(
                name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? const Color(0xFF2F8F3C) : const Color(0xFF101614),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitAirtime() async {
    if (_isSubmitting) return;
    final phone = _model.textController1?.text.trim() ?? '';
    final amount = (_model.textController2?.text.trim().isNotEmpty ?? false)
        ? _model.textController2!.text.trim()
        : (_model.dropDownValue ?? '');

    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enter a valid phone number',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFD9383A),
        ),
      );
      return;
    }

    if (amount.isEmpty || double.tryParse(amount) == null || double.parse(amount) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enter a valid amount',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFD9383A),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final currentNetwork = _selectedNetwork ??
          GetnetworkCall.network((_model.apiResultn64?.jsonBody ?? '')) ??
          'MTN';

      await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: AirtimeconfirmationWidget(
                amount: amount,
                network: currentNetwork,
                receipent: phone,
                avalbalance: functions.stringtodouble(FFAppState().avalbal),
              ),
            ),
          );
        },
      ).then((value) => safeSetState(() {}));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final detectedNetwork = _selectedNetwork ??
        GetnetworkCall.network((_model.apiResultn64?.jsonBody ?? ''));
    final amountVal = _model.textController2?.text.trim() ?? '';

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
        backgroundColor: const Color(0xFFF6F8F6),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: const Color(0xFFEDF0ED),
              height: 1.0,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () => context.pop(),
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    width: 38.0,
                    height: 38.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6F3),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: const Color(0xFFE6EAE7),
                        width: 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF101614),
                      size: 20.0,
                    ),
                  ),
                ),
                const SizedBox(width: 14.0),
                Text(
                  'Buy Airtime',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF101614),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Network Grid
                      Text(
                        'SELECT NETWORK',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF6E7A72),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          _buildNetworkItem('MTN', const Color(0xFFFDB913), const Color(0xFFFFFBEA)),
                          const SizedBox(width: 8.0),
                          _buildNetworkItem('Glo', const Color(0xFF2E8540), const Color(0xFFF0F8F1)),
                          const SizedBox(width: 8.0),
                          _buildNetworkItem('Airtel', const Color(0xFFE60000), const Color(0xFFFDF0F0)),
                          const SizedBox(width: 8.0),
                          _buildNetworkItem('9mobile', const Color(0xFF005826), const Color(0xFFF0F7F2)),
                        ],
                      ),

                      const SizedBox(height: 24.0),

                      // 2. Phone Number Input
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PHONE NUMBER',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF6E7A72),
                              letterSpacing: 0.6,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              final myPhone = FFAppState().phonenumber;
                              if (myPhone.isNotEmpty) {
                                _model.textController1?.text = myPhone;
                                _detectNetwork(myPhone);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDF7EE),
                                borderRadius: BorderRadius.circular(999.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.person_rounded,
                                    size: 13.0,
                                    color: Color(0xFF2F8F3C),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    'Me',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF2F8F3C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),

                      InkWell(
                        onTap: () {
                          if (!(_model.textFieldFocusNode1?.hasFocus ?? false)) {
                            _model.textFieldFocusNode1?.requestFocus();
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
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x060B2018),
                              blurRadius: 8.0,
                              offset: Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Row(
                          children: [
                            Text(
                              '+234',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF6E7A72),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Container(
                              width: 1.0,
                              height: 24.0,
                              color: const Color(0xFFE6EAE7),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: TextFormField(
                                controller: _model.textController1,
                                focusNode: _model.textFieldFocusNode1,
                                keyboardType: TextInputType.phone,
                                maxLength: 11,
                                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChanged: (val) {
                                  EasyDebounce.debounce(
                                    '_model.textController1',
                                    const Duration(milliseconds: 300),
                                    () => _detectNetwork(val),
                                  );
                                },
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF101614),
                                  letterSpacing: 0.5,
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter mobile number',
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFB0BDB4),
                                    letterSpacing: 0,
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                      if (detectedNetwork != null && detectedNetwork.isNotEmpty) ...[
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 14.0,
                              color: Color(0xFF2F8F3C),
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              '$detectedNetwork number detected automatically',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2F8F3C),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 24.0),

                      // 3. Amount Selection
                      Text(
                        'AMOUNT',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF6E7A72),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 10.0),

                      InkWell(
                        onTap: () {
                          if (!(_model.textFieldFocusNode2?.hasFocus ?? false)) {
                            _model.textFieldFocusNode2?.requestFocus();
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
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x060B2018),
                              blurRadius: 8.0,
                              offset: Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Row(
                          children: [
                            Text(
                              '₦',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF101614),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: TextFormField(
                                controller: _model.textController2,
                                focusNode: _model.textFieldFocusNode2,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChanged: (val) {
                                  setState(() {
                                    _model.dropDownValue = 'Other';
                                  });
                                },
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF101614),
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '0',
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFB0BDB4),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDF7EE),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'Instant top-up',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2F8F3C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                      const SizedBox(height: 12.0),

                      // Quick Amount Pills
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _quickAmounts.map((qAmount) {
                          final isSelected = amountVal == qAmount;
                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _model.textController2?.text = qAmount;
                                _model.dropDownValue = qAmount;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 9.0),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFEDF7EE) : Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF56B84B) : const Color(0xFFE6EAE7),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Text(
                                '₦$qAmount',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.0,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                                  color: isSelected ? const Color(0xFF2F8F3C) : const Color(0xFF2B3630),
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24.0),

                      // 4. Wallet Payment Source Card
                      Container(
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: const Color(0xFFE6EAE7),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38.0,
                              height: 38.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0B2018),
                                borderRadius: BorderRadius.circular(11.0),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '₦',
                                style: TextStyle(
                                  color: Color(0xFF7FD472),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pay from wallet',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF101614),
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    'Balance ₦${FFAppState().avalbal}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF6E7A72),
                                      fontFeatures: const [FontFeature.tabularFigures()],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFF56B84B),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 12.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Action Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFEDF0ED),
                      width: 1.0,
                    ),
                  ),
                ),
                child: SizedBox(
                  height: 54.0,
                  child: FFButtonWidget(
                    onPressed: _submitAirtime,
                    text: amountVal.isNotEmpty ? 'Pay ₦$amountVal' : 'Continue',
                    loading: _isSubmitting,
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 54.0,
                      color: const Color(0xFF56B84B),
                      textStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF06210F),
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(16.0),
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
