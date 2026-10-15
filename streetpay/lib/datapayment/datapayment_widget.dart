import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/bills/dataconfirmationpage/dataconfirmationpage_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import '/services/telco_logo_service.dart';
import 'datapayment_model.dart';
export 'datapayment_model.dart';

class DatapaymentWidget extends StatefulWidget {
  const DatapaymentWidget({
    super.key,
    required this.phonenumber,
  });

  final String? phonenumber;

  static String routeName = 'datapayment';
  static String routePath = '/datapayment';

  @override
  State<DatapaymentWidget> createState() => _DatapaymentWidgetState();
}

class _DatapaymentWidgetState extends State<DatapaymentWidget>
    with TickerProviderStateMixin {
  late DatapaymentModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedNetwork = 'MTN';
  String _selectedCategory = 'All';
  bool _isLoadingPlans = false;
  List<dynamic> _customPlans = [];

  final List<String> _categories = ['All', 'Daily', 'Weekly', 'Monthly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DatapaymentModel());

    final initialPhone = widget.phonenumber ?? FFAppState().phonenumber;
    _model.textController ??= TextEditingController(text: initialPhone);
    _model.textFieldFocusNode ??= FocusNode();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.streetauth = await StreetauthCall.call();
      if (initialPhone.length >= 10) {
        await _detectNetwork(initialPhone);
        await _fetchPlans(initialPhone);
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _detectNetwork(String phone) async {
    try {
      _model.getnetwork = await GetnetworkCall.call(
        phoneno: functions.addcode(phone),
        accessToken: StreetauthCall.streettoken(
          (_model.streetauth?.jsonBody ?? ''),
        ),
      );

      final detected =
          GetnetworkCall.network((_model.getnetwork?.jsonBody ?? ''));
      if (detected != null && detected.trim().isNotEmpty) {
        setState(() {
          _selectedNetwork = detected.trim().toUpperCase();
        });
      }
    } catch (_) {}
  }

  Future<void> _fetchPlans(String phone) async {
    if (phone.length < 10) return;

    setState(() {
      _isLoadingPlans = true;
    });

    try {
      final res = await VasCollectionGroup.getdataplanCall.call(
        phoneNumber: functions.addcode(phone),
        accessToken: FFAppState().bsptoken,
      );

      _model.getplans = res;
      final rawPlans = VasCollectionGroup.getdataplanCall.dataplans(res.jsonBody);
      if (rawPlans != null && rawPlans.isNotEmpty) {
        setState(() {
          _customPlans = rawPlans;
        });

        if (_selectedNetwork == 'MTN') {
          FFAppState().mtndataplans = rawPlans;
        } else if (_selectedNetwork == 'GLO') {
          FFAppState().glodataplans = rawPlans;
        } else if (_selectedNetwork == 'AIRTEL') {
          FFAppState().airteldataplans = rawPlans;
        }
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingPlans = false;
        });
      }
    }
  }

  List<dynamic> _getDefaultPlans(String network) {
    final net = network.toUpperCase();
    return [
      // Daily
      {'productId': '$net-110MB-1D', 'dataBundle': '110MB', 'amount': '100', 'validity': '1 Day'},
      {'productId': '$net-230MB-1D', 'dataBundle': '230MB', 'amount': '200', 'validity': '1 Day'},
      {'productId': '$net-500MB-1D', 'dataBundle': '500MB', 'amount': '350', 'validity': '1 Day'},
      {'productId': '$net-1GB-1D', 'dataBundle': '1GB Daily Plan', 'amount': '500', 'validity': '1 Day'},
      {'productId': '$net-2.5GB-2D', 'dataBundle': '2.5GB 2-Days', 'amount': '1000', 'validity': '2 Days'},
      // Weekly
      {'productId': '$net-1.5GB-7D', 'dataBundle': '1.5GB Weekly', 'amount': '1200', 'validity': '7 Days'},
      {'productId': '$net-3.5GB-7D', 'dataBundle': '3.5GB Weekly', 'amount': '2000', 'validity': '7 Days'},
      {'productId': '$net-7GB-7D', 'dataBundle': '7GB Weekly', 'amount': '3500', 'validity': '7 Days'},
      {'productId': '$net-10GB-14D', 'dataBundle': '10GB Bi-Weekly', 'amount': '5000', 'validity': '14 Days'},
      // Monthly
      {'productId': '$net-3GB-30D', 'dataBundle': '3GB Monthly', 'amount': '2000', 'validity': '30 Days'},
      {'productId': '$net-5GB-30D', 'dataBundle': '5GB Monthly', 'amount': '3000', 'validity': '30 Days'},
      {'productId': '$net-10GB-30D', 'dataBundle': '10GB Monthly', 'amount': '5000', 'validity': '30 Days'},
      {'productId': '$net-20GB-30D', 'dataBundle': '20GB Monthly', 'amount': '8000', 'validity': '30 Days'},
      {'productId': '$net-40GB-30D', 'dataBundle': '40GB Monthly', 'amount': '15000', 'validity': '30 Days'},
      {'productId': '$net-75GB-30D', 'dataBundle': '75GB Mega', 'amount': '25000', 'validity': '30 Days'},
      // Yearly & Multi-month
      {'productId': '$net-120GB-60D', 'dataBundle': '120GB 2-Months', 'amount': '30000', 'validity': '60 Days'},
      {'productId': '$net-250GB-90D', 'dataBundle': '250GB 3-Months', 'amount': '50000', 'validity': '90 Days'},
      {'productId': '$net-400GB-120D', 'dataBundle': '400GB 4-Months', 'amount': '75000', 'validity': '120 Days'},
      {'productId': '$net-1TB-365D', 'dataBundle': '1TB Yearly Plan', 'amount': '100000', 'validity': '365 Days'},
      {'productId': '$net-2.5TB-365D', 'dataBundle': '2.5TB Yearly Ultra', 'amount': '250000', 'validity': '365 Days'},
      {'productId': '$net-4.5TB-365D', 'dataBundle': '4.5TB Yearly Infinity', 'amount': '450000', 'validity': '365 Days'},
    ];
  }

  List<dynamic> _getActivePlans() {
    List<dynamic> source;
    if (_customPlans.isNotEmpty) {
      source = _customPlans;
    } else if (_selectedNetwork == 'MTN') {
      source = FFAppState().mtndataplans.length > 4
          ? FFAppState().mtndataplans
          : _getDefaultPlans('MTN');
    } else if (_selectedNetwork == 'GLO') {
      source = FFAppState().glodataplans.length > 4
          ? FFAppState().glodataplans
          : _getDefaultPlans('GLO');
    } else if (_selectedNetwork == 'AIRTEL') {
      source = FFAppState().airteldataplans.length > 4
          ? FFAppState().airteldataplans
          : _getDefaultPlans('AIRTEL');
    } else {
      source = _getDefaultPlans(_selectedNetwork);
    }

    if (_selectedCategory == 'All') {
      return source;
    } else if (_selectedCategory == 'Daily') {
      return source.where((p) {
        final v = (getJsonField(p, r'''$.validity''')?.toString() ?? '').toLowerCase();
        return v.contains('day') &&
            !v.contains('7 day') &&
            !v.contains('14 day') &&
            !v.contains('30 day') &&
            !v.contains('60 day') &&
            !v.contains('90 day') &&
            !v.contains('120 day') &&
            !v.contains('180 day') &&
            !v.contains('365 day');
      }).toList();
    } else if (_selectedCategory == 'Weekly') {
      return source.where((p) {
        final v = (getJsonField(p, r'''$.validity''')?.toString() ?? '').toLowerCase();
        return v.contains('7 day') || v.contains('14 day') || v.contains('week');
      }).toList();
    } else if (_selectedCategory == 'Monthly') {
      return source.where((p) {
        final v = (getJsonField(p, r'''$.validity''')?.toString() ?? '').toLowerCase();
        return (v.contains('30 day') || v.contains('month')) &&
            !v.contains('2 month') &&
            !v.contains('3 month') &&
            !v.contains('4 month') &&
            !v.contains('6 month') &&
            !v.contains('12 month');
      }).toList();
    } else if (_selectedCategory == 'Yearly') {
      return source.where((p) {
        final v = (getJsonField(p, r'''$.validity''')?.toString() ?? '').toLowerCase();
        return v.contains('365') ||
            v.contains('year') ||
            v.contains('annual') ||
            v.contains('12 month') ||
            v.contains('6 month') ||
            v.contains('4 month') ||
            v.contains('3 month') ||
            v.contains('2 month') ||
            v.contains('180 day') ||
            v.contains('120 day') ||
            v.contains('90 day') ||
            v.contains('60 day');
      }).toList();
    }
    return source;
  }

  void _onPlanSelected(dynamic planItem) async {
    HapticFeedback.selectionClick();
    final phone = _model.textController?.text.trim() ?? '';
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid phone number',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFD9383A),
        ),
      );
      return;
    }

    final amount = getJsonField(planItem, r'''$.amount''')?.toString() ?? '0';
    final productId = getJsonField(planItem, r'''$.productId''')?.toString() ?? '';
    final dataBundle = getJsonField(planItem, r'''$.dataBundle''')?.toString() ?? 'Data Plan';

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
            child: DataconfirmationpageWidget(
              amount: amount,
              network: _selectedNetwork,
              receipent: phone,
              productId: productId,
              dataplan: dataBundle,
            ),
          ),
        );
      },
    ).then((value) => safeSetState(() {}));
  }

  Widget _buildNetworkItem(String name, Color brandColor, Color bgColor) {
    final isSelected = _selectedNetwork == name.toUpperCase();

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedNetwork = name.toUpperCase();
            _customPlans = [];
          });
          final phone = _model.textController?.text.trim() ?? '';
          if (phone.length >= 10) {
            _fetchPlans(phone);
          }
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

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final balanceNum = functions.stringtodouble(FFAppState().avalbal);
    final balanceFormatted = formatNumber(
      balanceNum,
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
      currency: '₦',
    );

    final plans = _getActivePlans();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: true,
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
                  const SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Buy Data Bundle',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF101614),
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Instant mobile internet top-up',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6E7A72),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              controller: _model.columnController1,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Balance Bar ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B2018),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: const BoxDecoration(
                              color: Color(0xFF12362A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Color(0xFF7FD472),
                              size: 18.0,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WALLET BALANCE',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF8FA596),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                balanceFormatted,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF12362A),
                              borderRadius: BorderRadius.circular(999.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6.0,
                                  height: 6.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF7FD472),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6.0),
                                Text(
                                  'Active',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF7FD472),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18.0),

                    // --- Phone Number Input ---
                    Container(
                      padding: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: const Color(0xFFE6EAE7)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PHONE NUMBER',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF6E7A72),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            onChanged: (val) => EasyDebounce.debounce(
                              '_model.textController',
                              const Duration(milliseconds: 300),
                              () async {
                                if (val.length >= 10) {
                                  await _detectNetwork(val);
                                  await _fetchPlans(val);
                                }
                              },
                            ),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF101614),
                              letterSpacing: 0.5,
                            ),
                            decoration: InputDecoration(
                              hintText: '0801 234 5678',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFFA0ABA3),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                              ),
                              prefixIcon: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '🇳🇬 +234',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF101614),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Container(
                                      width: 1.0,
                                      height: 20.0,
                                      color: const Color(0xFFE6EAE7),
                                    ),
                                  ],
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                              suffixIcon: (_model.textController?.text.isNotEmpty ?? false)
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.cancel_rounded,
                                        color: Color(0xFFA0ABA3),
                                        size: 18.0,
                                      ),
                                      onPressed: () {
                                        _model.textController?.clear();
                                        safeSetState(() {});
                                      },
                                    )
                                  : null,
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
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFF56B84B),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18.0),

                          // --- Network Selectors ---
                          Text(
                            'NETWORK PROVIDER',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF6E7A72),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              _buildNetworkItem('MTN', const Color(0xFFFFCC00), const Color(0xFFFFFBEA)),
                              const SizedBox(width: 8.0),
                              _buildNetworkItem('AIRTEL', const Color(0xFFE60000), const Color(0xFFFDF0F0)),
                              const SizedBox(width: 8.0),
                              _buildNetworkItem('GLO', const Color(0xFF009900), const Color(0xFFF0FDF4)),
                              const SizedBox(width: 8.0),
                              _buildNetworkItem('9MOBILE', const Color(0xFF006600), const Color(0xFFF0FDF4)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    // --- Validity Tabs ---
                    Row(
                      children: [
                        Text(
                          'SELECT BUNDLE',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6E7A72),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const Spacer(),
                        if (_isLoadingPlans)
                          const SizedBox(
                            width: 14.0,
                            height: 14.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: Color(0xFF2F8F3C),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10.0),

                    // Filter Pills
                    SizedBox(
                      height: 36.0,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8.0),
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final isCatSelected = _selectedCategory == cat;
                          return InkWell(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _selectedCategory = cat;
                              });
                            },
                            borderRadius: BorderRadius.circular(999.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: isCatSelected ? const Color(0xFF101614) : Colors.white,
                                borderRadius: BorderRadius.circular(999.0),
                                border: Border.all(
                                  color: isCatSelected ? const Color(0xFF101614) : const Color(0xFFE6EAE7),
                                ),
                              ),
                              child: Text(
                                cat,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: isCatSelected ? Colors.white : const Color(0xFF4A5568),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 14.0),

                    // --- Plans Grid ---
                    if (plans.isEmpty && !_isLoadingPlans)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.0),
                          border: Border.all(color: const Color(0xFFE6EAE7)),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              size: 40.0,
                              color: Color(0xFFA0ABA3),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              'No plans found for $_selectedNetwork',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF101614),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Enter your phone number above to fetch active bundles.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.0,
                                color: const Color(0xFF6E7A72),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: plans.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 1.45,
                        ),
                        itemBuilder: (context, index) {
                          final plan = plans[index];
                          final bundle = getJsonField(plan, r'''$.dataBundle''')?.toString() ?? 'Data';
                          final validity = getJsonField(plan, r'''$.validity''')?.toString() ?? '';
                          final amountRaw = getJsonField(plan, r'''$.amount''')?.toString() ?? '0';
                          final amountNum = double.tryParse(amountRaw) ?? 0.0;
                          final amountFmt = formatNumber(
                            amountNum,
                            formatType: FormatType.decimal,
                            decimalType: DecimalType.periodDecimal,
                            currency: '₦',
                          );

                          return InkWell(
                            onTap: () => _onPlanSelected(plan),
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(color: const Color(0xFFE6EAE7)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x04000000),
                                    blurRadius: 4.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          bundle,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF101614),
                                            letterSpacing: -0.3,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (validity.isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3F6F3),
                                            borderRadius: BorderRadius.circular(999.0),
                                          ),
                                          child: Text(
                                            validity,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF6E7A72),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        amountFmt,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF2F8F3C),
                                        ),
                                      ),
                                      Container(
                                        width: 26.0,
                                        height: 26.0,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEDF7EE),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 14.0,
                                          color: Color(0xFF2F8F3C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
