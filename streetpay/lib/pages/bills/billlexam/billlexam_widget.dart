import '/backend/api_requests/api_calls.dart';
import '/components/paymentpinverifybill_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'billlexam_model.dart';
export 'billlexam_model.dart';

class BilllexamWidget extends StatefulWidget {
  BilllexamWidget({
    super.key,
    String? id,
    required this.name,
  }) : this.id = (id == null || id == '' || id == '1') ? '3' : id;

  final String id;
  final String? name;

  static String routeName = 'billlexam';
  static String routePath = '/billlexam';

  @override
  State<BilllexamWidget> createState() => _BilllexamWidgetState();
}

class _BilllexamWidgetState extends State<BilllexamWidget> {
  late BilllexamModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessingPayment = false;
  bool _isValidatingCustomer = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BilllexamModel());

    final defaultExamProviders = ['WAEC', 'JAMB', 'NECO', 'NABTEB'];
    if (FFAppState().exambillerid.isEmpty ||
        FFAppState().exambillerid.any((b) => b.contains('EDC') || b.contains('Electric'))) {
      FFAppState().exambillerid = List<String>.from(defaultExamProviders);
    }

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.billarcategory = await VasCollectionGroup.billercategoryCall.call(
        id: widget.id,
        accessToken: FFAppState().bsptoken,
      );

      final fetchedNames = VasCollectionGroup.billercategoryCall
          .name((_model.billarcategory?.jsonBody ?? ''))
          ?.toList()
          .cast<String>();

      if (fetchedNames != null && fetchedNames.isNotEmpty) {
        FFAppState().exambillerid = fetchedNames;
      } else if (FFAppState().exambillerid.isEmpty) {
        FFAppState().exambillerid = List<String>.from(defaultExamProviders);
      }
      safeSetState(() {});
    });

    _model.textController1 ??= TextEditingController(text: widget.name);
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??=
        TextEditingController(text: functions.addcode(FFAppState().phonenumber));
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode5 ??= FocusNode();
  }

  @override
  void dispose() {
    EasyDebounce.cancel('exam_candidate_debounce');
    _model.dispose();
    super.dispose();
  }

  Future<void> _triggerCustomerValidation() async {
    final candidateId = _model.textController2.text.trim();
    final provider = _model.dropDownValue1;
    final package = _model.dropDownValue2;

    if (provider == null || provider.isEmpty || candidateId.isEmpty) {
      return;
    }

    setState(() {
      _isValidatingCustomer = true;
      _validationError = null;
      _model.validateinput1 = null;
    });

    try {
      final billerId = functions.getIdByName(
        _model.billarcategory?.jsonBody ?? '',
        provider,
      );
      final amountVal = package != null && package.isNotEmpty
          ? functions.extractAmount(package).toDouble()
          : 1000.0;

      final res = await VasCollectionGroup.validateddatainputCall.call(
        customerid: candidateId,
        billerid: billerId,
        accessToken: FFAppState().bsptoken,
        amount: amountVal.toString(),
        phone: functions.addcode(_model.textController3.text.trim().isNotEmpty
            ? _model.textController3.text.trim()
            : FFAppState().phonenumber),
      );

      final name = VasCollectionGroup.validateddatainputCall.customername(
        res.jsonBody ?? '',
      );

      if (!mounted) return;

      setState(() {
        _model.validateinput1 = res;
        _isValidatingCustomer = false;
        if (name == null || name.trim().isEmpty) {
          _validationError = 'Could not verify candidate details. Please check the ID / Profile Code.';
        } else {
          _validationError = null;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isValidatingCustomer = false;
        _validationError = 'Unable to reach verification service. Tap to retry.';
      });
    }
  }

  List<String> _getExamPackages() {
    if (_model.dropDownValue1 == 'JAMB') {
      return FFAppState().jambitems;
    } else {
      return FFAppState().weacitems;
    }
  }

  Future<void> _handlePayment() async {
    final candidateId = _model.textController2.text.trim();
    final phone = _model.textController3.text.trim();

    if (_model.dropDownValue1 == null || _model.dropDownValue1!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an examination board.'),
          backgroundColor: Color(0xFFC93B2B),
        ),
      );
      return;
    }

    if (candidateId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter candidate profile code / ID.'),
          backgroundColor: Color(0xFFC93B2B),
        ),
      );
      return;
    }

    if (_model.dropDownValue2 == null || _model.dropDownValue2!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an exam PIN package.'),
          backgroundColor: Color(0xFFC93B2B),
        ),
      );
      return;
    }

    final amountVal = functions.extractAmount(_model.dropDownValue2!).toDouble();
    final amountStr = amountVal.toString();

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      _model.validateinput1 = await VasCollectionGroup.validateddatainputCall.call(
        customerid: candidateId,
        billerid: functions.getIdByName(
          _model.billarcategory?.jsonBody ?? '',
          _model.dropDownValue1!,
        ),
        accessToken: FFAppState().bsptoken,
        amount: amountStr,
        phone: functions.addcode(phone),
      );

      _model.walletenquiry1 = await WalletAsAServiceGroup.walletEnquiryCall.call(
        accountNo: FFAppState().accountno,
        authToken: FFAppState().bsptoken,
      );

      final balance = WalletAsAServiceGroup.walletEnquiryCall
              .availablebalance(_model.walletenquiry1?.jsonBody ?? '') ??
          0.0;

      if (balance < amountVal) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Insufficient wallet balance.'),
              backgroundColor: Color(0xFFC93B2B),
            ),
          );
        }
        return;
      }

      _model.transref = await actions.generatetransref();

      if (!mounted) return;

      final pinVerified = await showModalBottomSheet<bool>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (context) {
          return WebViewAware(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Padding(
                padding: MediaQuery.viewInsetsOf(context),
                child: const PaymentpinverifybillWidget(),
              ),
            ),
          );
        },
      );

      _model.paybill = pinVerified ?? false;

      if (_model.paybill == true) {
        _model.deviceid = await actions.getdeviceid();
        _model.transref = await actions.generatetransref();
        _model.transtoken = await GettransactiontokenCall.call(
          accessToken: FFAppState().bsptoken,
          accountno: FFAppState().accountno,
          deviceid: _model.deviceid,
          sessionid: FFAppState().sessionid,
        );

        _model.initpayment = await VasCollectionGroup.initaitebillpaymentCall.call(
          customerID: candidateId,
          billerId: functions.getIdByName(
            _model.billarcategory?.jsonBody ?? '',
            _model.dropDownValue1!,
          ),
          itemId: functions.getItemIdByItemName(
            _model.input?.jsonBody ?? '',
            _model.dropDownValue2!,
          ),
          custormername: VasCollectionGroup.validateddatainputCall.customername(
            _model.validateinput1?.jsonBody ?? '',
          ),
          debitaccount: FFAppState().accountno,
          amount: amountStr,
          transactionref: _model.transref,
          accessToken: FFAppState().bsptoken,
          phone: functions.addcode(phone) ?? phone,
          email: VasCollectionGroup.validateddatainputCall.otherfield(
            _model.validateinput1?.jsonBody ?? '',
          ),
          refid: GettransactiontokenCall.transtoken(
            _model.transtoken?.jsonBody ?? '',
          ),
        );

        final isSuccess = VasCollectionGroup.initaitebillpaymentCall.success(
              _model.initpayment?.jsonBody ?? '',
            ) ==
            true;

        final balBefore = balance.toString();
        final balAfter = (balance - amountVal).toString();

        if (isSuccess) {
          _model.apiResult1bj = await LogtransactionCall.call(
            phoneno: FFAppState().phonenumber,
            accountId: FFAppState().accountno,
            reqtype: '${widget.name}-${_model.dropDownValue1}-${_model.dropDownValue2}',
            sSid: 'None',
            passorfail: 'Pass',
            balBefore: balBefore,
            balafter: balAfter,
            beneficiary: candidateId,
            tammt: amountStr,
            extra: 'None',
            transREF: _model.transref,
            accessToken: FFAppState().streetauth,
            ttype: 'Debit',
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Exam PIN Purchased Successfully!',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: const Color(0xFF2F8F3C),
                duration: const Duration(seconds: 4),
              ),
            );
            context.safePop();
          }
        } else {
          final errMsg = VasCollectionGroup.initaitebillpaymentCall
                  .message(_model.initpayment?.jsonBody ?? '') ??
              'Exam PIN purchase failed';

          _model.apiResult1bj2 = await LogtransactionCall.call(
            phoneno: FFAppState().phonenumber,
            accountId: FFAppState().accountno,
            reqtype: '${widget.name}-${_model.dropDownValue1}-${_model.dropDownValue2}',
            sSid: 'None',
            passorfail: 'Failed',
            balBefore: balBefore,
            balafter: '',
            beneficiary: candidateId,
            tammt: amountStr,
            extra: 'None',
            transREF: _model.transref,
            accessToken: FFAppState().streetauth,
            ttype: 'Debit',
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  errMsg,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: const Color(0xFFC93B2B),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFC93B2B),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final packageAmount = _model.dropDownValue2 != null && _model.dropDownValue2!.isNotEmpty
        ? functions.extractAmount(_model.dropDownValue2!)
        : 0;
    final customerName = VasCollectionGroup.validateddatainputCall.customername(
      _model.validateinput1?.jsonBody ?? '',
    );
    final hasValidatedCustomer = customerName != null && customerName.trim().isNotEmpty;

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
          backgroundColor: const Color(0xFFFFFFFF),
          appBar: AppBar(
            backgroundColor: const Color(0xFFFFFFFF),
            elevation: 0.0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => context.safePop(),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F6F3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF101614),
                    size: 20,
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exam PINs',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF101614),
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'WAEC, JAMB & NECO direct token',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF6E7A72),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: InkWell(
                  onTap: () => context.pushNamed(NewhomeWidget.routeName),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F6F3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.home_outlined,
                      color: Color(0xFF101614),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: const Color(0xFFEDF0ED),
                height: 1.0,
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _model.columnController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SECTION 1: EXAMINATION BOARD
                        Text(
                          'EXAMINATION BOARD',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF6E7A72),
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAFCFA),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE6EAE7), width: 1.2),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: FlutterFlowDropDown<String>(
                            controller: _model.dropDownValueController1 ??=
                                FormFieldController<String>(null),
                            options: FFAppState()
                                .exambillerid
                                .sortedList(keyOf: (e) => e, desc: false),
                            onChanged: (val) async {
                              safeSetState(() => _model.dropDownValue1 = val);
                              _model.input = await VasCollectionGroup.getbillerinputCall.call(
                                id: functions.getIdByName(
                                  _model.billarcategory?.jsonBody ?? '',
                                  _model.dropDownValue1!,
                                ),
                                accessToken: FFAppState().bsptoken,
                              );

                              FFAppState().examitemlist = VasCollectionGroup.getbillerinputCall
                                  .itemname(_model.input?.jsonBody ?? '')!
                                  .toList()
                                  .cast<String>();

                              if (_model.dropDownValue1 == 'WAEC') {
                                FFAppState().weacitems = VasCollectionGroup
                                    .getbillerinputCall
                                    .itemname(_model.input?.jsonBody ?? '')!
                                    .toList()
                                    .cast<String>();
                              } else if (_model.dropDownValue1 == 'JAMB') {
                                FFAppState().jambitems = VasCollectionGroup
                                    .getbillerinputCall
                                    .itemname(_model.input?.jsonBody ?? '')!
                                    .toList()
                                    .cast<String>();
                              }
                              safeSetState(() {});
                              if (_model.textController2.text.isNotEmpty) {
                                await _triggerCustomerValidation();
                              }
                            },
                            width: double.infinity,
                            height: 48.0,
                            searchHintTextStyle: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFFA0ABA3),
                              fontSize: 13,
                            ),
                            searchTextStyle: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF101614),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            textStyle: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF101614),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            hintText: 'Select Examination Board (e.g. WAEC, JAMB)...',
                            searchHintText: 'Search board...',
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF6E7A72),
                              size: 22.0,
                            ),
                            fillColor: Colors.transparent,
                            dropdownColor: Colors.white,
                            elevation: 4.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 14.0,
                            margin: EdgeInsets.zero,
                            hidesUnderline: true,
                            isOverButton: false,
                            isSearchable: true,
                            isMultiSelect: false,
                          ),
                        ),

                        if (_model.dropDownValue1 != null && _model.dropDownValue1!.isNotEmpty) ...[
                          const SizedBox(height: 20),

                          // SECTION 2: CANDIDATE CREDENTIALS
                          Text(
                            'CANDIDATE INFORMATION',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF6E7A72),
                              fontSize: 11.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 8),

                          InkWell(
                            onTap: () {
                              if (!(_model.textFieldFocusNode2?.hasFocus ?? false)) {
                                _model.textFieldFocusNode2?.requestFocus();
                              }
                            },
                            borderRadius: BorderRadius.circular(14),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAFCFA),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFE6EAE7), width: 1.2),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              child: TextField(
                                controller: _model.textController2,
                                focusNode: _model.textFieldFocusNode2,
                                onChanged: (val) {
                                  final clean = val.trim();
                                  if (clean.length >= 6 &&
                                      _model.dropDownValue1 != null &&
                                      _model.dropDownValue1!.isNotEmpty) {
                                    EasyDebounce.debounce(
                                      'exam_candidate_debounce',
                                      const Duration(milliseconds: 600),
                                      () => _triggerCustomerValidation(),
                                    );
                                  } else if (clean.isEmpty) {
                                    if (_model.validateinput1 != null || _validationError != null) {
                                      setState(() {
                                        _model.validateinput1 = null;
                                        _validationError = null;
                                      });
                                    }
                                  }
                                },
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF101614),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                                decoration: InputDecoration(
                                  hintText: _model.dropDownValue1 == 'JAMB'
                                      ? 'Enter JAMB Profile Code'
                                      : 'Enter Examination Number / Phone',
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFFA0ABA3),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 10),

                        InkWell(
                          onTap: () {
                            if (!(_model.textFieldFocusNode3?.hasFocus ?? false)) {
                              _model.textFieldFocusNode3?.requestFocus();
                            }
                          },
                          borderRadius: BorderRadius.circular(14),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFCFA),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE6EAE7), width: 1.2),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            child: TextField(
                              controller: _model.textController3,
                              focusNode: _model.textFieldFocusNode3,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF101614),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                              decoration: InputDecoration(
                                hintText: 'Recipient Phone Number (for PIN SMS)',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFFA0ABA3),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ),

                        if (_model.dropDownValue1 == 'JAMB') ...[
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              if (!(_model.textFieldFocusNode4?.hasFocus ?? false)) {
                                _model.textFieldFocusNode4?.requestFocus();
                              }
                            },
                            borderRadius: BorderRadius.circular(14),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAFCFA),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFE6EAE7), width: 1.2),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              child: TextField(
                                controller: _model.textController4,
                                focusNode: _model.textFieldFocusNode4,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF101614),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Candidate Email (optional)',
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFFA0ABA3),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),

                        // SECTION 3: PIN PACKAGE
                        Text(
                          'SELECT EXAM PIN PACKAGE',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF6E7A72),
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAFCFA),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE6EAE7), width: 1.2),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: FlutterFlowDropDown<String>(
                            controller: _model.dropDownValueController2 ??=
                                FormFieldController<String>(null),
                            options: _getExamPackages(),
                            onChanged: (val) async {
                              safeSetState(() => _model.dropDownValue2 = val);
                              if (_model.dropDownValue1 != null && _model.textController2.text.isNotEmpty) {
                                await _triggerCustomerValidation();
                              }
                            },
                            width: double.infinity,
                            height: 48.0,
                            searchHintTextStyle: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFFA0ABA3),
                              fontSize: 13,
                            ),
                            searchTextStyle: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF101614),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            textStyle: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF101614),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            hintText: 'Select Pin Package...',
                            searchHintText: 'Search package...',
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF6E7A72),
                              size: 22.0,
                            ),
                            fillColor: Colors.transparent,
                            dropdownColor: Colors.white,
                            elevation: 4.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 14.0,
                            margin: EdgeInsets.zero,
                            hidesUnderline: true,
                            isOverButton: false,
                            isSearchable: true,
                            isMultiSelect: false,
                          ),
                        ),

                        // CUSTOMER VALIDATION / FEEDBACK SECTION
                        if (_isValidatingCustomer) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF86EFAC),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF22C55E).withValues(alpha: 0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Fetching candidate details...',
                                            style: GoogleFonts.plusJakartaSans(
                                              color: const Color(0xFF15803D),
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Verifying ${_model.textController2.text.trim()} with ${_model.dropDownValue1 ?? "Board"}...',
                                            style: GoogleFonts.plusJakartaSans(
                                              color: const Color(0xFF4B5563),
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: const LinearProgressIndicator(
                                    minHeight: 3.5,
                                    backgroundColor: Color(0xFFDCFCE7),
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (hasValidatedCustomer) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(14.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7FCF7),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF56B84B),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEDF7EE),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.verified_rounded,
                                    color: Color(0xFF2F8F3C),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        customerName,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF101614),
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Verified Candidate · ${_model.textController2.text}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF2F8F3C),
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDF7EE),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_circle, size: 13, color: Color(0xFF2F8F3C)),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Verified',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF2F8F3C),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (_validationError != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(14.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFFCA5A5),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFEE2E2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.error_outline_rounded,
                                    color: Color(0xFFDC2626),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Candidate Verification Failed',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF991B1B),
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _validationError!,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFFB91C1C),
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _triggerCustomerValidation(),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDC2626),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Retry',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // SECTION 4: PIN PRICE
                        if (packageAmount > 0) ...[
                          const SizedBox(height: 20),
                          Text(
                            'PIN COST',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF6E7A72),
                              fontSize: 11.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Container(
                            height: 64,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7FCF7),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF56B84B),
                                width: 2.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '₦',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF101614),
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formatNumber(packageAmount.toDouble(),
                                      formatType: FormatType.decimal),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF101614),
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w800,
                                    fontFeatures: const [FontFeature.tabularFigures()],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDF7EE),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'Instant PIN SMS',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF2F8F3C),
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),

              // BOTTOM PAY BUTTON
              if (_model.dropDownValue2 != null && _model.dropDownValue2!.isNotEmpty && packageAmount > 0)
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Color(0xFFEDF0ED), width: 1.0),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: (_isProcessingPayment || _isValidatingCustomer) ? null : _handlePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF56B84B),
                        disabledBackgroundColor: const Color(0xFF56B84B).withValues(alpha: 0.6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isProcessingPayment
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Color(0xFF0B2018),
                              ),
                            )
                          : _isValidatingCustomer
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF06210F)),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Verifying Candidate...',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF06210F),
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Buy PIN ₦${formatNumber(packageAmount.toDouble(), formatType: FormatType.decimal)}',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF06210F),
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
