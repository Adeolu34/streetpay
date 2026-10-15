import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bill_posting_model.dart';
export 'bill_posting_model.dart';

class BillPostingWidget extends StatefulWidget {
  const BillPostingWidget({
    super.key,
    this.accountno,
  });

  final String? accountno;

  static String routeName = 'BillPosting';
  static String routePath = '/billPosting';

  @override
  State<BillPostingWidget> createState() => _BillPostingWidgetState();
}

class _BillPostingWidgetState extends State<BillPostingWidget> {
  late BillPostingModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? _targetAccountNo;
  String? _receiverName;
  String? _receiverPhone;
  bool _isLoadingReceiver = false;
  bool _isPosting = false;
  final TextEditingController _accSearchController = TextEditingController();
  final FocusNode _accSearchFocusNode = FocusNode();

  final List<String> _quickCategories = [
    'School fees',
    'Rent',
    'Supply',
    'Personal',
    'Groceries',
    'Services',
  ];

  final List<int> _quickAmounts = [
    2000,
    5000,
    10000,
    50000,
    100000,
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BillPostingModel());

    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _targetAccountNo = widget.accountno;
    if (_targetAccountNo != null && _targetAccountNo!.isNotEmpty) {
      _accSearchController.text = _targetAccountNo!;
      _fetchReceiverDetails(_targetAccountNo!);
    }
  }

  Future<void> _fetchReceiverDetails(String accountNo) async {
    if (accountNo.trim().length < 10) return;
    setState(() {
      _isLoadingReceiver = true;
    });

    try {
      final res = await WalletAsAServiceGroup.walletEnquiryCall.call(
        accountNo: accountNo.trim(),
        authToken: FFAppState().bsptoken,
      );

      if (res.succeeded) {
        final name = WalletAsAServiceGroup.walletEnquiryCall.accountname(res.jsonBody);
        final phone = WalletAsAServiceGroup.walletEnquiryCall.phonenumber(res.jsonBody);
        final nuban = WalletAsAServiceGroup.walletEnquiryCall.accountno(res.jsonBody);

        if (name != null && name.toString().isNotEmpty) {
          setState(() {
            _receiverName = functions.stripSlash(name);
            _receiverPhone = functions.removecode(phone ?? '');
            _targetAccountNo = nuban ?? accountNo;
            _model.textController1 ??= TextEditingController();
            _model.textController1!.text = _receiverPhone ?? '';
          });
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _isLoadingReceiver = false;
      });
    }
  }

  @override
  void dispose() {
    _accSearchFocusNode.dispose();
    _accSearchController.dispose();
    _model.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'SP';
  }

  Future<void> _handlePostBill() async {
    final amountText = _model.textController2.text.trim();
    final description = _model.textController3.text.trim();
    final phone = _receiverPhone ?? _model.textController1?.text.trim() ?? '';

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter or select a recipient with a valid phone number.'),
          backgroundColor: Color(0xFFC93B2B),
        ),
      );
      return;
    }

    if (amountText.isEmpty || (double.tryParse(amountText) ?? 0) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid bill amount.'),
          backgroundColor: Color(0xFFC93B2B),
        ),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Description is required to explain this bill.'),
          backgroundColor: Color(0xFFC93B2B),
        ),
      );
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      _model.streetauth = await StreetauthCall.call();
      final token = StreetauthCall.streettoken(_model.streetauth?.jsonBody ?? '');

      _model.apiResult6qn = await PostbillCall.call(
        fromphome: FFAppState().phonenumber,
        tophone: functions.removecode(phone),
        amount: amountText,
        description: description,
        accessToken: token,
      );

      final isSuccess = PostbillCall.status(_model.apiResult6qn?.jsonBody ?? '') == true;
      final msg = PostbillCall.message(_model.apiResult6qn?.jsonBody ?? '') ??
          (isSuccess ? 'Bill request sent successfully!' : 'Failed to send bill');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              msg,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: isSuccess ? const Color(0xFF2F8F3C) : const Color(0xFFC93B2B),
            duration: const Duration(seconds: 4),
          ),
        );

        if (isSuccess) {
          context.safePop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating bill: $e'),
            backgroundColor: const Color(0xFFC93B2B),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
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
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          elevation: 0.0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => context.pop(),
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
                'Create a bill',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF101614),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Step 1 of 2 · who is paying',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF6E7A72),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              height: 3.5,
              width: double.infinity,
              color: const Color(0xFFEDF0ED),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    color: const Color(0xFF56B84B),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // RECIPIENT SECTION
                      Text(
                        'SEND THIS BILL TO',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF6E7A72),
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (_receiverName != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FCF7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF56B84B),
                              width: 1.8,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0B2018),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _getInitials(_receiverName!),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF7FD472),
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _receiverName!,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF101614),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${_targetAccountNo ?? ''} · StreetPay',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF6E7A72),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        fontFeatures: const [FontFeature.tabularFigures()],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _receiverName = null;
                                    _targetAccountNo = null;
                                    _receiverPhone = null;
                                    _accSearchController.clear();
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: Text(
                                    'Change',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF2F8F3C),
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        InkWell(
                          onTap: () {
                            if (!_accSearchFocusNode.hasFocus) {
                              _accSearchFocusNode.requestFocus();
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFCFA),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE6EAE7), width: 1.2),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.search_rounded, color: Color(0xFF6E7A72), size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _accSearchController,
                                    focusNode: _accSearchFocusNode,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    onChanged: (val) {
                                      if (val.length == 10) {
                                        _fetchReceiverDetails(val);
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter 10-digit StreetPay account no.',
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFFA0ABA3),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF101614),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontFeatures: const [FontFeature.tabularFigures()],
                                    ),
                                  ),
                                ),
                                if (_isLoadingReceiver)
                                  const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF56B84B),
                                    ),
                                  )
                                else if (_accSearchController.text.length == 10)
                                  IconButton(
                                    icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF56B84B), size: 20),
                                    onPressed: () => _fetchReceiverDetails(_accSearchController.text),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // WHAT IS IT FOR SECTION
                      Text(
                        'WHAT IS IT FOR',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF6E7A72),
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Category Pills
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _quickCategories.map((cat) {
                          final isSelected = _model.textController3.text.toLowerCase().contains(cat.toLowerCase());
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _model.textController3.text = cat;
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFEDF7EE) : const Color(0xFFF3F6F3),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF56B84B) : Colors.transparent,
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                cat,
                                style: GoogleFonts.plusJakartaSans(
                                  color: isSelected ? const Color(0xFF2F8F3C) : const Color(0xFF2B3630),
                                  fontSize: 12.0,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 12),

                      // Description input
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
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          child: TextField(
                            controller: _model.textController3,
                            focusNode: _model.textFieldFocusNode3,
                            maxLines: 2,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF101614),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. Second semester school fees · matric 210544',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFFA0ABA3),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // AMOUNT SECTION
                      Text(
                        'AMOUNT',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF6E7A72),
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Amount Input Card
                      InkWell(
                        onTap: () {
                          if (!(_model.textFieldFocusNode2?.hasFocus ?? false)) {
                            _model.textFieldFocusNode2?.requestFocus();
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
                                  controller: _model.textController2,
                                  focusNode: _model.textFieldFocusNode2,
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
                                  'No fee',
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

                      // Quick Amount Pills
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _quickAmounts.map((amt) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _model.textController2.text = amt.toString();
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
                                    '₦${formatNumber(amt.toDouble(), formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)}',
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

                      const SizedBox(height: 20),

                      // Notice Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F8F6),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE6EAE7)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: Color(0xFF2F8F3C),
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Direct wallet credit',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF101614),
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'When approved, funds are credited straight to your StreetPay wallet with zero deduction fees.',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF6E7A72),
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
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
                    onPressed: _isPosting ? null : _handlePostBill,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF56B84B),
                      disabledBackgroundColor: const Color(0xFF56B84B).withValues(alpha: 0.6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isPosting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Color(0xFF0B2018),
                            ),
                          )
                        : Text(
                            _receiverName != null
                                ? 'Send bill to ${_receiverName!.split(' ').first}'
                                : 'Send bill request',
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
    );
  }
}
