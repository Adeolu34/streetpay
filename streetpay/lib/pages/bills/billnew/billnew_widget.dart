import '/backend/api_requests/api_calls.dart';
import '/components/account_card/account_card_widget.dart';
import '/components/bill_card/bill_card_widget.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/withdrawbill_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'billnew_model.dart';
export 'billnew_model.dart';

class BillnewWidget extends StatefulWidget {
  const BillnewWidget({super.key});

  static String routeName = 'billnew';
  static String routePath = '/billnew';

  @override
  State<BillnewWidget> createState() => _BillnewWidgetState();
}

class _BillnewWidgetState extends State<BillnewWidget>
    with TickerProviderStateMixin {
  late BillnewModel _model;
  final Map<String, Future<ApiCallResponse>> _pinProfileFutures = {};
  Future<ApiCallResponse>? _receivedBillsFuture;
  Future<ApiCallResponse>? _sentBillsFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BillnewModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.streetauth = await StreetauthCall.call();

      await Future.wait([
        Future(() async {
          _model.getpinphones = await GetpinlistCall.call(
            fromphone: FFAppState().phonenumber,
            accessToken: StreetauthCall.streettoken(
              (_model.streetauth?.jsonBody ?? ''),
            ),
          );
        }),
        Future(() async {
          _model.getreceivedbill = await GetreceivedbillCall.call(
            tophome: FFAppState().phonenumber,
            accessToken: StreetauthCall.streettoken(
              (_model.streetauth?.jsonBody ?? ''),
            ),
          );
        }),
        Future(() async {
          _model.sentbill = await GetsentbillsCall.call(
            fromphome: FFAppState().phonenumber,
            accessToken: StreetauthCall.streettoken(
              (_model.streetauth?.jsonBody ?? ''),
            ),
          );
        }),
      ]);
      FFAppState().pinphones = GetpinlistCall.phones(
            (_model.getpinphones?.jsonBody ?? ''),
          )?.toList().cast<String>() ??
          [];
      FFAppState().receivedbilled = GetreceivedbillCall.fulldata(
            (_model.getreceivedbill?.jsonBody ?? ''),
          )?.toList().cast<dynamic>() ??
          [];
      FFAppState().sentbills = GetsentbillsCall.fulldata(
            (_model.sentbill?.jsonBody ?? ''),
          )?.toList().cast<dynamic>() ??
          [];
      safeSetState(() {});
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildTopHeader() {
    final toPayCount = FFAppState().receivedbilled.length;
    final sentCount = FFAppState().sentbills.length;
    final isToPay = _model.tabBarCurrentIndex == 0;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () async {
                  context.pushNamed(NewhomeWidget.routeName);
                },
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bill requests',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF101614),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'Ask someone to pay for you. They approve, then it\'s paid.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6E7A72),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Segmented Tab Pill Capsule
          Container(
            height: 44.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F6F3),
              borderRadius: BorderRadius.circular(14.0),
            ),
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _model.tabBarController?.animateTo(0);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isToPay ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(11.0),
                        boxShadow: isToPay
                            ? const [
                                BoxShadow(
                                  color: Color(0x120B2018),
                                  blurRadius: 6.0,
                                  offset: Offset(0.0, 2.0),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'To pay',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w800,
                              color: isToPay
                                  ? const Color(0xFF0B2018)
                                  : const Color(0xFF6E7A72),
                            ),
                          ),
                          if (toPayCount > 0) ...[
                            const SizedBox(width: 6.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF56B84B),
                                borderRadius: BorderRadius.circular(999.0),
                              ),
                              child: Text(
                                '$toPayCount',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF06210F),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _model.tabBarController?.animateTo(1);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: !isToPay ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(11.0),
                        boxShadow: !isToPay
                            ? const [
                                BoxShadow(
                                  color: Color(0x120B2018),
                                  blurRadius: 6.0,
                                  offset: Offset(0.0, 2.0),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'I requested',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w800,
                              color: !isToPay
                                  ? const Color(0xFF0B2018)
                                  : const Color(0xFF6E7A72),
                            ),
                          ),
                          if (sentCount > 0) ...[
                            const SizedBox(width: 6.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDF7EE),
                                borderRadius: BorderRadius.circular(999.0),
                              ),
                              child: Text(
                                '$sentCount',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF2F8F3C),
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildCreateBillCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0B2018),
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x280B2018),
            blurRadius: 16.0,
            offset: Offset(0.0, 6.0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            context.pushNamed(BillPostingWidget.routeName);
          },
          borderRadius: BorderRadius.circular(18.0),
          splashColor: const Color(0x2056B84B),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 42.0,
                  height: 42.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF56B84B),
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.add_rounded,
                    color: Color(0xFF06210F),
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 13.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create a bill',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Text(
                        'School fees, rent, shop supply — send to who is paying.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8FA596),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF7FD472),
                  size: 16.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinnedSection() {
    final pinphones = FFAppState().pinphones;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'PEOPLE WHO CAN BILL YOU',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF6E7A72),
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(width: 6.0),
            AlignedTooltip(
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'When a user pins you, you\'re authorized to send them a bill. You can also pin up to 4 users to approve receiving bills from them.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.0,
                    color: Colors.white,
                  ),
                ),
              ),
              offset: 4.0,
              preferredDirection: AxisDirection.down,
              borderRadius: BorderRadius.circular(8.0),
              backgroundColor: const Color(0xFF0B2018),
              elevation: 4.0,
              waitDuration: const Duration(milliseconds: 100),
              showDuration: const Duration(milliseconds: 3000),
              triggerMode: TooltipTriggerMode.tap,
              child: const Icon(
                Icons.info_outline_rounded,
                size: 15.0,
                color: Color(0xFF6E7A72),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        if (pinphones.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
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
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDF7EE),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.people_outline_rounded,
                    color: Color(0xFF2F8F3C),
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    'No payers pinned yet. Friends or family can pin your phone to send you bills.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6E7A72),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: List.generate(pinphones.length, (index) {
              final phone = pinphones[index];
              final profileFuture = _pinProfileFutures.putIfAbsent(
                phone,
                () => ReturntierprofileCall.call(
                  phoneno: phone,
                  accessToken: StreetauthCall.streettoken(
                    (_model.streetauth?.jsonBody ?? ''),
                  ),
                ),
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: FutureBuilder<ApiCallResponse>(
                  future: profileFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        height: 64.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF0ED),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      );
                    }
                    final profileData = snapshot.data!;
                    final accountName = valueOrDefault<String>(
                      ReturntierprofileCall.othername(profileData.jsonBody),
                      'StreetPay User',
                    );
                    final accountNo = valueOrDefault<String>(
                      ReturntierprofileCall.accountNo(profileData.jsonBody),
                      phone,
                    );

                    return InkWell(
                      onTap: () async {
                        context.pushNamed(
                          BillPostingWidget.routeName,
                          queryParameters: {
                            'accountno': serializeParam(
                              accountNo,
                              ParamType.String,
                            ),
                          }.withoutNulls,
                        );
                      },
                      borderRadius: BorderRadius.circular(16.0),
                      child: AccountCardWidget(
                        key: Key('PinCard_${index}_$phone'),
                        accountName: accountName,
                        accountNumber: accountNo,
                        bankName: 'StreetPay',
                      ),
                    );
                  },
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildReceivedBillsList() {
    _receivedBillsFuture ??= GetreceivedbillCall.call(
      tophome: functions.removecode(FFAppState().phonenumber),
      accessToken: FFAppState().bsptoken,
    );
    return FutureBuilder<ApiCallResponse>(
      future: _receivedBillsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: SpinKitDoubleBounce(
                color: const Color(0xFF2F8F3C),
                size: 38.0,
              ),
            ),
          );
        }

        final response = snapshot.data!;
        final receivedList =
            GetreceivedbillCall.fulldata(response.jsonBody)?.toList() ?? [];

        if (receivedList.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
              border: Border.all(
                color: const Color(0xFFE6EAE7),
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52.0,
                  height: 52.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDF7EE),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Color(0xFF2F8F3C),
                    size: 26.0,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'No bill requests waiting',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF101614),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'When anyone creates a bill requesting you to pay, it will appear here for one-tap approval.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6E7A72),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: List.generate(receivedList.length, (index) {
            final item = receivedList[index];
            final amount = getJsonField(item, r'''$.Amount''')?.toString() ?? '0';
            final desc =
                getJsonField(item, r'''$.Description''')?.toString() ?? 'Bill';
            final fromPhone =
                getJsonField(item, r'''$.FromPhone''')?.toString() ?? '- - -';
            final fullName =
                getJsonField(item, r'''$.Fullname''')?.toString() ?? fromPhone;
            final billId = getJsonField(item, r'''$.ID''')?.toString() ?? '';
            final receiverAcc =
                getJsonField(item, r'''$.AccountNo''')?.toString() ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.0),
                border: Border.all(
                  color: const Color(0xFFD6EAD8),
                  width: 1.0,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x060B2018),
                    blurRadius: 10.0,
                    offset: Offset(0.0, 3.0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42.0,
                          height: 42.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEDF7EE),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            fullName.isNotEmpty ? fullName[0].toUpperCase() : 'B',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF2F8F3C),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF101614),
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                fromPhone,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF6E7A72),
                                  fontFeatures: const [
                                    FontFeature.tabularFigures()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              amount.startsWith('₦') ? amount : '₦$amount',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF101614),
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF8EC),
                                borderRadius: BorderRadius.circular(999.0),
                              ),
                              child: Text(
                                'Awaiting approval',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFC97A12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),

                    // Bill Description container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFCFA),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: const Color(0xFFE6EAE7),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            desc,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF101614),
                            ),
                          ),
                          if (receiverAcc.isNotEmpty) ...[
                            const SizedBox(height: 3.0),
                            Text(
                              'Target Account: $receiverAcc',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6E7A72),
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),

                    // Review & Pay button
                    FFButtonWidget(
                      onPressed: () async {
                        _model.getphoneno = await GetaccountnoCall.call(
                          phoneno: fromPhone,
                          accessToken: StreetauthCall.streettoken(
                            (_model.streetauth?.jsonBody ?? ''),
                          ),
                        );

                        if (!mounted) return;

                        context.pushNamed(
                          BillPaymentWidget.routeName,
                          queryParameters: {
                            'phoneno': serializeParam(fromPhone, ParamType.String),
                            'amount': serializeParam(amount, ParamType.String),
                            'description': serializeParam(desc, ParamType.String),
                            'id': serializeParam(billId, ParamType.String),
                            'sendername': serializeParam(
                                FFAppState().accountname, ParamType.String),
                            'senderphone': serializeParam(
                              functions.addcode(FFAppState().phonenumber),
                              ParamType.String,
                            ),
                            'receiverName':
                                serializeParam(fullName, ParamType.String),
                            'receiveraccountno':
                                serializeParam(receiverAcc, ParamType.String),
                          }.withoutNulls,
                        );
                      },
                      text: 'Review & pay',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 44.0,
                        color: const Color(0xFF56B84B),
                        textStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF06210F),
                        ),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSentBillsList() {
    _sentBillsFuture ??= GetsentbillsCall.call(
      fromphome: functions.removecode(FFAppState().phonenumber),
      accessToken: FFAppState().bsptoken,
    );
    return FutureBuilder<ApiCallResponse>(
      future: _sentBillsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: SpinKitDoubleBounce(
                color: const Color(0xFF2F8F3C),
                size: 38.0,
              ),
            ),
          );
        }

        final response = snapshot.data!;
        final sentList =
            GetsentbillsCall.fulldata(response.jsonBody)?.toList() ?? [];

        if (sentList.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
              border: Border.all(
                color: const Color(0xFFE6EAE7),
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52.0,
                  height: 52.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDF7EE),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.outbox_rounded,
                    color: Color(0xFF2F8F3C),
                    size: 26.0,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'No bills sent yet',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF101614),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Tap "Create a bill" above to request someone to pay for school fees, rent, or supplies.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6E7A72),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: List.generate(sentList.length, (index) {
            final item = sentList[index];
            final amount = getJsonField(item, r'''$.Amount''')?.toString() ?? '0';
            final desc =
                getJsonField(item, r'''$.Description''')?.toString() ?? 'Bill';
            final toPhone =
                getJsonField(item, r'''$.ToPhone''')?.toString() ?? '- - -';
            final billId = getJsonField(item, r'''$.ID''');

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: InkWell(
                onTap: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    enableDrag: true,
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
                            child: WithdrawbillWidget(
                              billid: billId,
                            ),
                          ),
                        ),
                      );
                    },
                  ).then((value) => safeSetState(() {}));
                },
                borderRadius: BorderRadius.circular(16.0),
                child: BillCardWidget(
                  key: Key('SentBillCard_${index}_$toPhone'),
                  title: desc,
                  subtitle: 'Sent to $toPhone',
                  status: 'Pending',
                  amount: amount,
                ),
              ),
            );
          }),
        );
      },
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
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            context.pushNamed(NewhomeWidget.routeName);
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFFF6F8F6),
          body: SafeArea(
            top: true,
            bottom: false,
            child: Stack(
              children: [
                // Scrollable Content
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Top Header & Segmented Pills
                      _buildTopHeader(),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16.0),

                            // 2. Create Bill Hero Card
                            _buildCreateBillCard(),

                            const SizedBox(height: 22.0),

                            // 3. Tab Specific Lists
                            if (_model.tabBarCurrentIndex == 0) ...[
                              // "To pay" view
                              Text(
                                'WAITING FOR YOU',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF6E7A72),
                                  letterSpacing: 0.6,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              _buildReceivedBillsList(),

                              const SizedBox(height: 24.0),

                              // Pinned users section
                              _buildPinnedSection(),
                            ] else ...[
                              // "I requested" view
                              Text(
                                'BILLS I SENT',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF6E7A72),
                                  letterSpacing: 0.6,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              _buildSentBillsList(),
                            ],

                            // Extra bottom padding for Bottom Navigation Dock
                            const SizedBox(height: 110.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Fixed Glassmorphic Bottom Navigation Dock
                const BottomAppBarWidget(selectedIndex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
