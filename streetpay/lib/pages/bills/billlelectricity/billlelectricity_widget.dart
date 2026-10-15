import '/backend/api_requests/api_calls.dart';
import '/components/paymentpinverifybill_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/services/biller_beneficiary_service.dart';
import '/services/biller_logo_service.dart';
import '/components/recent_biller_beneficiaries_widget.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'billlelectricity_model.dart';
export 'billlelectricity_model.dart';

class BilllelectricityWidget extends StatefulWidget {
  const BilllelectricityWidget({
    super.key,
    String? id,
    required this.name,
  }) : this.id = id ?? '1';

  final String id;
  final String? name;

  static String routeName = 'billlelectricity';
  static String routePath = '/billlelectricity';

  @override
  State<BilllelectricityWidget> createState() => _BilllelectricityWidgetState();
}

class _BilllelectricityWidgetState extends State<BilllelectricityWidget> {
  late BilllelectricityModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessingPayment = false;
  bool _isValidatingCustomer = false;
  String? _validationError;

  final List<int> _quickAmounts = [1000, 2000, 5000, 10000, 20000];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BilllelectricityModel());

    final defaultDiscos = [
      'AEDC (Abuja)',
      'EKEDC (Eko)',
      'IKEDC (Ikeja)',
      'IBEDC (Ibadan)',
      'EEDC (Enugu)',
      'PHEDC (Port Harcourt)',
      'KEDCO (Kano)',
      'JEDC (Jos)',
      'KAEDCO (Kaduna)',
      'BEDC (Benin)',
      'YEDC (Yola)',
      'Aba Power (APLE)',
    ];
    if (FFAppState().electricbillerid.length < 5) {
      FFAppState().electricbillerid = List<String>.from(defaultDiscos);
    }

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.billarcategory = await VasCollectionGroup.billercategoryCall.call(
        id: widget.id,
        accessToken: FFAppState().bsptoken,
      );

      final fetched = VasCollectionGroup.billercategoryCall
          .name((_model.billarcategory?.jsonBody ?? ''))
          ?.toList()
          .cast<String>();
      if (fetched != null && fetched.isNotEmpty) {
        FFAppState().electricbillerid = fetched;
      } else if (FFAppState().electricbillerid.isEmpty) {
        FFAppState().electricbillerid = List<String>.from(defaultDiscos);
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
  }

  @override
  void dispose() {
    EasyDebounce.cancel('meter_validation_debounce');
    _model.dispose();
    super.dispose();
  }

  Future<void> _triggerCustomerValidation() async {
    final meterNo = _model.textController2.text.trim();
    final disco = _model.dropDownValue1;
    final meterType = _model.dropDownValue2;

    if (disco == null || disco.isEmpty || meterNo.isEmpty || meterType == null || meterType.isEmpty) {
      return;
    }

    setState(() {
      _isValidatingCustomer = true;
      _validationError = null;
      _model.validateinputts = null;
    });

    try {
      final billerId = functions.getIdByName(
        _model.billarcategory?.jsonBody ?? '',
        disco,
      );
      final itemId = functions.getItemIdByItemName(
        _model.input?.jsonBody ?? '',
        meterType,
      );

      final res = await VasCollectionGroup.validateddatainputCall.call(
        billerid: billerId,
        customerid: meterNo,
        itemid: itemId,
        amount: '1000',
        phone: functions.addcode(FFAppState().phonenumber),
        accessToken: FFAppState().bsptoken,
      );

      final name = VasCollectionGroup.validateddatainputCall.customername(
        res.jsonBody ?? '',
      );

      if (!mounted) return;

      setState(() {
        _model.validateinputts = res;
        _isValidatingCustomer = false;
        if (name == null || name.trim().isEmpty) {
          _validationError = 'Could not verify meter number. Please check your disco and meter number.';
        } else {
          _validationError = null;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isValidatingCustomer = false;
        _validationError = 'Unable to verify meter details right now. Tap to retry.';
      });
    }
  }

  Future<void> _handlePayment() async {
    final meterNo = _model.textController2.text.trim();
    final phone = _model.textController3.text.trim();
    final amountText = _model.textController4.text.trim();

    if (_model.dropDownValue1 == null || _model.dropDownValue1!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an electricity distribution company.'),
          backgroundColor: Color(0xFFC93B2B),
        ),
      );
      return;
    }

    if (meterNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your meter number.'),
          backgroundColor: Color(0xFFC93B2B),
        ),
      );
      return;
    }

    if (_model.dropDownValue2 == null || _model.dropDownValue2!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select meter type (Prepaid / Postpaid).'),
          backgroundColor: Color(0xFFC93B2B),
        ),
      );
      return;
    }

    final amountVal = functions.stringtodouble(amountText);
    if (amountVal < 350.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Amount must be at least ₦350'),
          backgroundColor: Color(0xFFC93B2B),
        ),
      );
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      _model.walletenquiry = await WalletAsAServiceGroup.walletEnquiryCall.call(
        accountNo: FFAppState().accountno,
        authToken: FFAppState().bsptoken,
      );

      final balance = WalletAsAServiceGroup.walletEnquiryCall
              .availablebalance(_model.walletenquiry?.jsonBody ?? '') ??
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

      _model.validateinput = await VasCollectionGroup.validateddatainputCall.call(
        customerid: meterNo,
        billerid: functions.getIdByName(
          _model.billarcategory?.jsonBody ?? '',
          _model.dropDownValue1!,
        ),
        itemid: functions.getItemIdByItemName(
          _model.input?.jsonBody ?? '',
          _model.dropDownValue2!,
        ),
        accessToken: FFAppState().bsptoken,
        amount: amountText,
        phone: functions.addcode(phone),
      );

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

      _model.payrecipt = pinVerified ?? false;

      if (_model.payrecipt == true) {
        _model.deviceid = await actions.getdeviceid();
        _model.transref = await actions.generatetransref();
        _model.transtoken = await GettransactiontokenCall.call(
          accessToken: FFAppState().bsptoken,
          accountno: FFAppState().accountno,
          deviceid: _model.deviceid,
          sessionid: FFAppState().sessionid,
        );

        _model.apiResultuj1 = await VasCollectionGroup.initaitebillpaymentCall.call(
          customerID: meterNo,
          billerId: functions.getIdByName(
            _model.billarcategory?.jsonBody ?? '',
            _model.dropDownValue1!,
          ),
          itemId: functions.getItemIdByItemName(
            _model.input?.jsonBody ?? '',
            _model.dropDownValue2!,
          ),
          custormername: VasCollectionGroup.validateddatainputCall.customername(
            _model.validateinput?.jsonBody ?? '',
          ),
          debitaccount: FFAppState().accountno,
          amount: amountText,
          transactionref: _model.transref,
          accessToken: FFAppState().bsptoken,
          phone: functions.addcode(phone) ?? phone,
          email: VasCollectionGroup.validateddatainputCall.otherfield(
            _model.validateinput?.jsonBody ?? '',
          ),
          refid: GettransactiontokenCall.transtoken(
            _model.transtoken?.jsonBody ?? '',
          ),
        );

        final isSuccess = VasCollectionGroup.initaitebillpaymentCall.success(
              _model.apiResultuj1?.jsonBody ?? '',
            ) ==
            true;

        final balBefore = WalletAsAServiceGroup.walletEnquiryCall
            .availablebalance(_model.walletenquiry?.jsonBody ?? '')
            ?.toString();
        final balAfter = ((WalletAsAServiceGroup.walletEnquiryCall
                        .availablebalance(_model.walletenquiry?.jsonBody ?? '') ??
                    0.0) -
                amountVal)
            .toString();

        if (isSuccess) {
          _model.apiResult1bj = await LogtransactionCall.call(
            phoneno: FFAppState().phonenumber,
            accountId: FFAppState().accountno,
            reqtype: '${widget.name}-${_model.dropDownValue1}-${_model.dropDownValue2}',
            sSid: 'None',
            passorfail: 'Pass',
            balBefore: balBefore,
            balafter: balAfter,
            beneficiary: meterNo,
            tammt: amountText,
            extra: 'None',
            transREF: _model.transref,
            accessToken: FFAppState().streetauth,
            ttype: 'Debit',
          );

          await BillerBeneficiaryService.saveBeneficiary(
            category: 'electricity',
            billerName: _model.dropDownValue1!,
            customerId: meterNo,
            customerName: VasCollectionGroup.validateddatainputCall.customername(
              _model.validateinput?.jsonBody ?? '',
            ),
            packageType: _model.dropDownValue2,
            lastAmount: amountVal.toStringAsFixed(0),
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Electricity Payment Successful!',
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
                  .message(_model.apiResultuj1?.jsonBody ?? '') ??
              'Electricity payment failed';

          _model.apiResult1bj2 = await LogtransactionCall.call(
            phoneno: FFAppState().phonenumber,
            accountId: FFAppState().accountno,
            reqtype: '${widget.name}-${_model.dropDownValue1}-${_model.dropDownValue2}',
            sSid: 'None',
            passorfail: 'Failed',
            balBefore: balBefore,
            balafter: '',
            beneficiary: meterNo,
            tammt: amountText,
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

    final customerName = VasCollectionGroup.validateddatainputCall.customername(
      _model.validateinputts?.jsonBody ?? '',
    );
    final hasValidatedCustomer = customerName != null && customerName.isNotEmpty;

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
                  'Electricity',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF101614),
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Instant token generation · 0% fee',
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
                        // SAVED / RECENT BENEFICIARIES
                        RecentBillerBeneficiariesWidget(
                          category: 'electricity',
                          title: 'Saved Meter Numbers',
                          onSelect: (beneficiary) async {
                            _model.textController2.text = beneficiary.customerId;
                            if (beneficiary.billerName.isNotEmpty) {
                              _model.dropDownValueController1?.value =
                                  beneficiary.billerName;
                              _model.dropDownValue1 = beneficiary.billerName;
                              _model.input =
                                  await VasCollectionGroup.getbillerinputCall.call(
                                id: functions.getIdByName(
                                  _model.billarcategory?.jsonBody ?? '',
                                  beneficiary.billerName,
                                ),
                                accessToken: FFAppState().bsptoken,
                              );
                              final items = VasCollectionGroup.getbillerinputCall
                                  .fulldata(_model.input?.jsonBody ?? '')
                                  ?.map((e) => getJsonField(e, r'''$.items.itemName'''))
                                  .toList()
                                  .map((e) => e.toString())
                                  .toList()
                                  .cast<String>();
                              if (items != null) {
                                FFAppState().itemlist = items;
                              }
                              if (beneficiary.packageType != null &&
                                  beneficiary.packageType!.isNotEmpty) {
                                _model.dropDownValueController2?.value =
                                    beneficiary.packageType;
                                _model.dropDownValue2 = beneficiary.packageType;
                              }
                            }
                            if (beneficiary.lastAmount != null &&
                                beneficiary.lastAmount!.isNotEmpty) {
                              _model.textController4.text = beneficiary.lastAmount!;
                            }
                            safeSetState(() {});
                            await _triggerCustomerValidation();
                          },
                        ),

                        // SECTION 1: DISCO PROVIDER
                        Text(
                          'DISTRIBUTION COMPANY',
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
                          child: Row(
                            children: [
                              if (_model.dropDownValue1 != null &&
                                  _model.dropDownValue1!.isNotEmpty) ...[
                                BillerLogoWidget(
                                  billerName: _model.dropDownValue1,
                                  category: 'electricity',
                                  size: 28,
                                  borderRadius: 7,
                                ),
                                const SizedBox(width: 10),
                              ],
                              Expanded(
                                child: FlutterFlowDropDown<String>(
                                  controller: _model.dropDownValueController1 ??=
                                      FormFieldController<String>(null),
                                  options: FFAppState()
                                      .electricbillerid
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

                                    FFAppState().itemlist = VasCollectionGroup.getbillerinputCall
                                        .fulldata(_model.input?.jsonBody ?? '')!
                                        .map((e) => getJsonField(e, r'''$.items.itemName'''))
                                        .toList()
                                        .map((e) => e.toString())
                                        .toList()
                                        .cast<String>();
                                    safeSetState(() {});
                                    if (_model.dropDownValue2 != null &&
                                        _model.textController2.text.isNotEmpty) {
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
                                  hintText: 'Select Distribution Company...',
                                  searchHintText: 'Search Disco...',
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
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // SECTION 2: METER NUMBER & PHONE
                        Text(
                          'METER & RECIPIENT DETAILS',
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
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF101614),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                              onChanged: (val) {
                                final clean = val.trim();
                                if (clean.length >= 10 &&
                                    _model.dropDownValue1 != null &&
                                    _model.dropDownValue2 != null) {
                                  EasyDebounce.debounce(
                                    'meter_validation_debounce',
                                    const Duration(milliseconds: 600),
                                    () => _triggerCustomerValidation(),
                                  );
                                } else if (clean.length < 10) {
                                  if (_model.validateinputts != null || _validationError != null) {
                                    setState(() {
                                      _model.validateinputts = null;
                                      _validationError = null;
                                    });
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter 11-digit Meter Number',
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
                                hintText: 'Customer Phone (for token SMS)',
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

                        const SizedBox(height: 20),

                        // SECTION 3: METER TYPE (PREPAID / POSTPAID)
                        Text(
                          'METER TYPE',
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
                            options: const ['POSTPAID', 'PREPAID'],
                            onChanged: (val) async {
                              safeSetState(() => _model.dropDownValue2 = val);
                              if (_model.dropDownValue1 != null &&
                                  _model.textController2.text.isNotEmpty) {
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
                            hintText: 'Select Meter Type (Prepaid / Postpaid)...',
                            searchHintText: 'Search...',
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
                            isSearchable: false,
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
                                            'Fetching customer details...',
                                            style: GoogleFonts.plusJakartaSans(
                                              color: const Color(0xFF15803D),
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Verifying meter ${_model.textController2.text.trim()} with ${_model.dropDownValue1 ?? "Disco"}...',
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
                                        'Verified Customer Account · ${_model.textController2.text}',
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
                                        'Meter Verification Failed',
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
                                          color: const Color(0xFF7F1D1D),
                                          fontSize: 11.5,
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

                        // SECTION 4: AMOUNT SECTION
                        if (_model.dropDownValue2 != null && _model.dropDownValue2!.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            'AMOUNT',
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
                              if (!(_model.textFieldFocusNode4?.hasFocus ?? false)) {
                                _model.textFieldFocusNode4?.requestFocus();
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
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
                                  Expanded(
                                    child: TextField(
                                      controller: _model.textController4,
                                      focusNode: _model.textFieldFocusNode4,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF101614),
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w800,
                                        fontFeatures: const [FontFeature.tabularFigures()],
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: '0',
                                        hintStyle: TextStyle(
                                          color: Color(0xFFC4C4C4),
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDF7EE),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      'Min ₦350',
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
                          ),

                          const SizedBox(height: 12),

                          // Quick Amount Selection
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _quickAmounts.map((amt) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _model.textController4.text = amt.toString();
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(999),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F6F3),
                                        borderRadius: BorderRadius.circular(999),
                                        border: Border.all(color: const Color(0xFFE6EAE7)),
                                      ),
                                      child: Text(
                                        '₦${formatNumber(amt.toDouble(), formatType: FormatType.decimal)}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF2B3630),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          fontFeatures: const [FontFeature.tabularFigures()],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // BOTTOM PAY BUTTON
                if (hasValidatedCustomer || _isValidatingCustomer)
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
                          disabledBackgroundColor: const Color(0xFF56B84B).withValues(alpha: 0.5),
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
                                          color: Color(0xFF0B2018),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Verifying Customer...',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF06210F),
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Pay Electricity Bill',
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
