import '/backend/api_requests/api_calls.dart';
import '/services/tts_service.dart';
import '/components/autodiscover_widget.dart';
import '/components/biometriccomp_widget.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/productconfig_widget.dart';
import '/components/clipboard_transfer_bottom_sheet.dart';
import '/components/verificationstatus_widget.dart';
import '/services/clipboard_detection_service.dart';
import '/services/cache_service.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'newhome_model.dart';
export 'newhome_model.dart';

class NewhomeWidget extends StatefulWidget {
  const NewhomeWidget({super.key});

  static String routeName = 'newhome';
  static String routePath = '/newhome';

  @override
  State<NewhomeWidget> createState() => _NewhomeWidgetState();
}

class _NewhomeWidgetState extends State<NewhomeWidget>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late NewhomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  bool get _showBalance => FFAppState().show;
  bool _checkingUpgradeStatus = false;

  static const _cacheKeyBalance = 'home_balance';
  static const _cacheKeyHistory = 'home_history';
  static const _cacheKeyWinners = 'home_winners';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewhomeModel());
    WidgetsBinding.instance.addObserver(this);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadHomeData(forceRefresh: false);

      if (FFAppState().discoverme) {
        try {
          currentUserLocationValue = await getCurrentUserLocation(
            defaultLocation: const LatLng(0.0, 0.0),
            cached: true,
          );
        } catch (_) {}
      }

      TtsService.instance.greetHome(
        name: FFAppState().accountname,
        balance: FFAppState().avalbal,
      );

      if (!FFAppState().biometric) {
        await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
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
                  child: BiometriccompWidget(),
                ),
              ),
            );
          },
        ).then((value) => safeSetState(() {}));
      }

      if (FFAppState().progressvalue < 1.0) {
        await showModalBottomSheet(
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
                  child: ProductconfigWidget(),
                ),
              ),
            );
          },
        ).then((value) => safeSetState(() {}));
      }

      _startHomePeriodicTimer();
      _checkClipboardForTransfer();
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  Future<void> _loadHomeData({required bool forceRefresh}) async {
    if (forceRefresh) {
      CacheService.invalidate(_cacheKeyBalance);
      CacheService.invalidate(_cacheKeyHistory);
      CacheService.invalidate(_cacheKeyWinners);
    }

    // Balance — 2 min cache
    final cachedBalance = CacheService.get<String>(_cacheKeyBalance,
        maxAge: const Duration(minutes: 2));
    if (cachedBalance != null) {
      FFAppState().avalbal = cachedBalance;
      safeSetState(() {});
    } else {
      _model.getbalance = await GetaccountbalanceCall.call(
        phone: FFAppState().phonenumber,
        accessToken: FFAppState().bsptoken,
      );
      final balanceVal =
          GetaccountbalanceCall.avalbal(_model.getbalance?.jsonBody ?? '');
      if (balanceVal != null) {
        FFAppState().avalbal = balanceVal.toString();
        CacheService.set(_cacheKeyBalance, balanceVal.toString());
      }
      final tierVal =
          GetaccountbalanceCall.tier(_model.getbalance?.jsonBody ?? '');
      if (tierVal != null) FFAppState().tier = tierVal;

      final bvnVal =
          GetaccountbalanceCall.bvn(_model.getbalance?.jsonBody ?? '');
      if (bvnVal != null) FFAppState().bvn = bvnVal;
      safeSetState(() {});
    }

    // Winners — 10 min cache
    final cachedWinners = CacheService.get<List<String>>(_cacheKeyWinners,
        maxAge: const Duration(minutes: 10));
    if (cachedWinners != null) {
      FFAppState().winners = cachedWinners;
    } else {
      _model.winner = await GetwinnersCall.call(
        accessToken: FFAppState().bsptoken,
      );
      final winnersList =
          GetwinnersCall.winners(_model.winner?.jsonBody ?? '');
      if (winnersList != null) {
        final list = winnersList.toList().cast<String>();
        FFAppState().winners = list;
        CacheService.set(_cacheKeyWinners, list);
      }
      safeSetState(() {});
    }

    FFAppState().searchid = false;
    FFAppState().connectionoff = false;

    _model.news = await GetnewCall.call(accessToken: FFAppState().bsptoken);
    final newsItem = GetnewCall.news(_model.news?.jsonBody ?? '');
    if (newsItem != null) FFAppState().addToWinners(newsItem);
    safeSetState(() {});

    // Transaction history — 5 min cache
    if (FFAppState().accountno.isNotEmpty) {
      final cachedHistory =
          CacheService.get<List<dynamic>>(_cacheKeyHistory,
              maxAge: const Duration(minutes: 5));
      if (cachedHistory != null) {
        FFAppState().transactionhistory = cachedHistory;
        _model.recentActivityResponse ??=
            ApiCallResponse({'cached': true}, {}, 200);
        safeSetState(() {});
      } else {
        _model.recentActivityResponse =
            await WalletAsAServiceGroup.wallethistoryCall.call(
          authToken: FFAppState().bsptoken,
          accountno: FFAppState().accountno,
          fromdate: functions.subtractDaysFromToday(30),
          todate:
              dateTimeFormat('yyyy-MM-dd', getCurrentTimestamp, locale: 'en'),
        );
        final historyData = WalletAsAServiceGroup.wallethistoryCall
            .message(_model.recentActivityResponse?.jsonBody ?? '');
        if (historyData != null) {
          final list = historyData.toList().cast<dynamic>();
          FFAppState().transactionhistory = list;
          CacheService.set(_cacheKeyHistory, list);
        }
        safeSetState(() {});
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadHomeData(forceRefresh: true);
  }

  Future<void> _showUpgradeStatus() async {
    if (_checkingUpgradeStatus) return;
    setState(() => _checkingUpgradeStatus = true);
    final resp = await WalletAsAServiceGroup.upgradestatusCall.call(
      account: FFAppState().accountno,
      authToken: FFAppState().bsptoken,
    );
    if (mounted) setState(() => _checkingUpgradeStatus = false);
    if (!mounted) return;
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (ctx) => WebViewAware(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(ctx).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: MediaQuery.viewInsetsOf(ctx),
            child: VerificationstatusWidget(
              status: WalletAsAServiceGroup.upgradestatusCall
                  .message(resp.jsonBody ?? ''),
              reason: WalletAsAServiceGroup.upgradestatusCall
                  .reason(resp.jsonBody ?? ''),
            ),
          ),
        ),
      ),
    ).then((_) => safeSetState(() {}));
  }

  void _startHomePeriodicTimer() {
    _model.instantTimer?.cancel();
    if (!FFAppState().discoverme || !mounted) return;

    _model.instantTimer = InstantTimer.periodic(
      duration: const Duration(seconds: 30),
      callback: (timer) async {
        if (!mounted || !FFAppState().discoverme) {
          timer.cancel();
          return;
        }
        try {
          currentUserLocationValue = await getCurrentUserLocation(
              defaultLocation: const LatLng(0.0, 0.0), cached: true);
        } catch (_) {}
        if (!mounted) return;

        _model.getbalance2 = await GetaccountbalanceCall.call(
          phone: FFAppState().phonenumber,
          accessToken: FFAppState().bsptoken,
        );
        _model.nearby = await LocationdetectCall.call(
          phoneno: FFAppState().phonenumber,
          lat: functions.getlat(currentUserLocationValue),
          longi: functions.getlang(currentUserLocationValue),
          accessToken: FFAppState().bsptoken,
        );

        final bal2 = GetaccountbalanceCall.avalbal(
          _model.getbalance2?.jsonBody ?? '',
        );
        if (bal2 != null) {
          FFAppState().avalbal = bal2.toString();
          CacheService.set(_cacheKeyBalance, bal2.toString());
        }

        final nearbyData = LocationdetectCall.fulldata(
          _model.nearby?.jsonBody ?? '',
        );
        if (nearbyData != null) {
          FFAppState().nearbylist = nearbyData.toList().cast<dynamic>();
        }
        if (mounted) {
          safeSetState(() {});
        }
      },
      startImmediately: false,
    );
  }

  @override
  void dispose() {
    _model.instantTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _model.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkClipboardForTransfer();
      _startHomePeriodicTimer();
    } else {
      _model.instantTimer?.cancel();
    }
  }

  Future<void> _checkClipboardForTransfer() async {
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final detectedNumber =
        await ClipboardDetectionService.checkClipboardForAccountNumber(
      currentAccountNo: FFAppState().accountno,
    );

    if (detectedNumber != null && mounted) {
      final shouldProceed = await showModalBottomSheet<bool>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) =>
            ClipboardTransferBottomSheet(accountNumber: detectedNumber),
      );

      if (shouldProceed == true && mounted) {
        context.pushNamed(
          ManualPaymentWidget.routeName,
          queryParameters: {
            'prefillAccountNumber': serializeParam(
              detectedNumber,
              ParamType.String,
            ),
          }.withoutNulls,
        );
      }
    }
  }

  void _copyAccountNumber(String accountNo) {
    Clipboard.setData(ClipboardData(text: accountNo));
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Account number copied to clipboard',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF1E4230),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  String _getUserInitials(String name) {
    if (name.isEmpty) return 'SP';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  void _openStreetPaySheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF6F8F6),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 14, bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6DDD8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      'Transfer to StreetPay',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF101614),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded,
                          color: Color(0xFF6E7A72), size: 22),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(
                  height: 1, thickness: 0.5, color: Color(0xFFE6EAE7)),
              const Expanded(child: AutodiscoverWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem({
    required IconData icon,
    Color? iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52.0,
                  height: 52.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                    border: Border.all(
                      color: const Color(0xFFE6EAE7),
                      width: 1.0,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D0B2018),
                        blurRadius: 6.0,
                        offset: Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    color: iconColor ?? const Color(0xFF2F8F3C),
                    size: 22.0,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2B3630),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityItem({
    required String title,
    required String subtitle,
    required String amount,
    required String status,
    required bool isCredit,
    required bool isPending,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: const Color(0xFFE6EAE7),
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: isPending
                      ? const Color(0xFFFFF4E5)
                      : isCredit
                          ? const Color(0xFFEDF7EE)
                          : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isCredit
                      ? Icons.north_east_rounded
                      : isPending
                          ? Icons.access_time_rounded
                          : Icons.arrow_upward_rounded,
                  color: isPending
                      ? const Color(0xFFC97A12)
                      : isCredit
                          ? const Color(0xFF2F8F3C)
                          : const Color(0xFF475569),
                  size: 18.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF101614),
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6E7A72),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: isCredit
                          ? const Color(0xFF1D7A33)
                          : const Color(0xFF101614),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Row(
                    children: [
                      Text(
                        status,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          color: isPending
                              ? const Color(0xFFC97A12)
                              : const Color(0xFF2F8F3C),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded,
                          color: Color(0xFFB0BDB5), size: 14),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAmount(num value) {
    final str = value.toStringAsFixed(2);
    final parts = str.split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buffer = StringBuffer();
    int count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
      count++;
    }
    return '${buffer.toString().split('').reversed.join()}.$decPart';
  }

  Widget _buildActivityLoadingPlaceholder() {
    return Column(
      children: List.generate(3, (i) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          height: 66.0,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7F5),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14.0),
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6EAE7),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 11.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6EAE7),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Container(
                      height: 9.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF2EF),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14.0),
              Container(
                height: 11.0,
                width: 60.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6EAE7),
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              const SizedBox(width: 14.0),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActivityEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        children: [
          Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF7EE),
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFF2F8F3C),
              size: 26.0,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            'No transactions yet',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF101614),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Your activity in the last 30 days will appear here',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6E7A72),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final userName = FFAppState().accountname.isNotEmpty
        ? FFAppState().accountname
        : 'StreetPay User';
    final accountNo = FFAppState().accountno.isNotEmpty
        ? FFAppState().accountno
        : '──────────';
    final rawBalance =
        FFAppState().avalbal.isNotEmpty ? FFAppState().avalbal : '0.00';
    final tier = FFAppState().tier.isNotEmpty ? FFAppState().tier : '1';
    final tierNum = int.tryParse(tier) ?? 1;
    final userInitials = _getUserInitials(userName);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFFF6F8F6),
          body: Stack(
            children: [
              // Main Scrollable Dashboard Content with pull-to-refresh
              RefreshIndicator(
                onRefresh: _refreshData,
                color: const Color(0xFF56B84B),
                backgroundColor: Colors.white,
                strokeWidth: 2.5,
                child: SingleChildScrollView(
                  controller: _model.columnController1,
                  padding: const EdgeInsets.only(bottom: 96.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Top Curved Forest Green Header
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0B2018),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(26.0),
                            bottomRight: Radius.circular(26.0),
                          ),
                        ),
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 54.0, 20.0, 80.0),
                        child: Row(
                          children: [
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1D4331),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                userInitials,
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF7FD472),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    '9PSB StreetPay · Tier $tier',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF89A394),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                        SettingpageWidget.routeName);
                                  },
                                  child: Container(
                                    width: 36.0,
                                    height: 36.0,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF152F23),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.notifications_none_rounded,
                                      color: Color(0xFFCFE3D6),
                                      size: 19.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                        SettingpageWidget.routeName);
                                  },
                                  child: Container(
                                    width: 36.0,
                                    height: 36.0,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF152F23),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.settings_outlined,
                                      color: Color(0xFFCFE3D6),
                                      size: 19.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 2. Floating Wallet Balance Card
                      Transform.translate(
                        offset: const Offset(0.0, -56.0),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF12362A),
                                  Color(0xFF0F2A20),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(22.0),
                              border: Border.all(
                                color: const Color(0xFF22513A),
                                width: 1.0,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x45071A11),
                                  blurRadius: 28.0,
                                  offset: Offset(0.0, 14.0),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'WALLET BALANCE',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF8FB3A0),
                                        letterSpacing: 0.9,
                                      ),
                                    ),
                                    const Spacer(),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                          safeSetState(() {
                                            FFAppState().show = !_showBalance;
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(20.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            _showBalance
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: const Color(0xFF8FB3A0),
                                            size: 20.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  _showBalance
                                      ? '₦$rawBalance'
                                      : '₦ ••••••',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Text(
                                      'StreetPay · 9PSB',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF8FB3A0),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      accountNo,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFCFE3D6),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    GestureDetector(
                                      onTap: () =>
                                          _copyAccountNumber(accountNo),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 3.0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF56B84B)
                                              .withValues(alpha: 0.16),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: Text(
                                          'Copy',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF7FD472),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            context.pushNamed(
                                                AccountdetailsWidget.routeName);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: Container(
                                            height: 44.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF56B84B),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                    Icons.add_rounded,
                                                    color: Color(0xFF06210F),
                                                    size: 18.0),
                                                const SizedBox(width: 6.0),
                                                Text(
                                                  'Add money',
                                                  style: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontSize: 13.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: const Color(
                                                        0xFF06210F),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            context.pushNamed(
                                                SendChoiceWidget.routeName);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: Container(
                                            height: 44.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                color: const Color(0xFF2C6045),
                                                width: 1.0,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                    Icons.north_east_rounded,
                                                    color: Color(0xFFCFE3D6),
                                                    size: 16.0),
                                                const SizedBox(width: 6.0),
                                                Text(
                                                  'Transfer',
                                                  style: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontSize: 13.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: const Color(
                                                        0xFFCFE3D6),
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
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 3. Discover Nearby Card
                      Transform.translate(
                        offset: const Offset(0.0, -40.0),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                context.pushNamed(
                                    Autodiscover1Widget.routeName);
                              },
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    color: const Color(0xFFD6EAD8),
                                    width: 1.0,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x0D0B2018),
                                      blurRadius: 12.0,
                                      offset: Offset(0.0, 4.0),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48.0,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEDF7EE),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.radar_rounded,
                                        color: Color(0xFF2F8F3C),
                                        size: 24.0,
                                      ),
                                    ),
                                    const SizedBox(width: 14.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Discover nearby devices',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(0xFF101614),
                                            ),
                                          ),
                                          const SizedBox(height: 2.0),
                                          Text(
                                            'Find vendors & people around you to pay',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF6E7A72),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: Color(0xFF2F8F3C),
                                      size: 22.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 4. Quick Services Grid
                      Transform.translate(
                        offset: const Offset(0.0, -28.0),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick services',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF101614),
                                ),
                              ),
                              const SizedBox(height: 14.0),
                              // Row 1: Transfer actions (OPay-style)
                              Row(
                                children: [
                                  _buildServiceItem(
                                    icon: Icons.people_rounded,
                                    iconColor: const Color(0xFF2F8F3C),
                                    label: 'To StreetPay',
                                    onTap: _openStreetPaySheet,
                                  ),
                                  _buildServiceItem(
                                    icon: Icons.account_balance_rounded,
                                    iconColor: const Color(0xFF3D5FA0),
                                    label: 'To Bank',
                                    onTap: () => context.pushNamed(
                                        ManualPaymentWidget.routeName),
                                  ),
                                  _buildServiceItem(
                                    icon: Icons.phone_android_rounded,
                                    iconColor: const Color(0xFF2557B5),
                                    label: 'Airtime',
                                    onTap: () => context
                                        .pushNamed(AirtimeformWidget.routeName),
                                  ),
                                  _buildServiceItem(
                                    icon: Icons.data_usage_rounded,
                                    iconColor: const Color(0xFF0284C7),
                                    label: 'Data',
                                    onTap: () => context.pushNamed(
                                      DatapaymentWidget.routeName,
                                      queryParameters: {
                                        'phonenumber': serializeParam(
                                          FFAppState().phonenumber,
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              // Row 2: Utilities
                              Row(
                                children: [
                                  _buildServiceItem(
                                    icon: Icons.bolt_rounded,
                                    iconColor: const Color(0xFFD97706),
                                    label: 'Electricity',
                                    onTap: () => context.pushNamed(
                                      BilllelectricityWidget.routeName,
                                      queryParameters: {
                                        'id': serializeParam(
                                            '1', ParamType.String),
                                        'name': serializeParam(
                                            'Electricity', ParamType.String),
                                      }.withoutNulls,
                                    ),
                                  ),
                                  _buildServiceItem(
                                    icon: Icons.tv_rounded,
                                    iconColor: const Color(0xFF7C3AED),
                                    label: 'Cable TV',
                                    onTap: () => context.pushNamed(
                                      BilllcabletvWidget.routeName,
                                      queryParameters: {
                                        'id': serializeParam(
                                            '4', ParamType.String),
                                        'name': serializeParam(
                                            'Cable TV', ParamType.String),
                                      }.withoutNulls,
                                    ),
                                  ),
                                  _buildServiceItem(
                                    icon: Icons.wifi_rounded,
                                    iconColor: const Color(0xFF0D9488),
                                    label: 'Internet',
                                    onTap: () => context.pushNamed(
                                      BilllinternetWidget.routeName,
                                      queryParameters: {
                                        'id': serializeParam(
                                            '7', ParamType.String),
                                        'name': serializeParam(
                                            'Internet', ParamType.String),
                                      }.withoutNulls,
                                    ),
                                  ),
                                  _buildServiceItem(
                                    icon: Icons.sports_soccer_rounded,
                                    iconColor: const Color(0xFFEA580C),
                                    label: 'Betting',
                                    onTap: () => context.pushNamed(
                                      BilllbettingWidget.routeName,
                                      queryParameters: {
                                        'id': serializeParam(
                                            '2', ParamType.String),
                                        'name': serializeParam(
                                            'Betting', ParamType.String),
                                      }.withoutNulls,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 5. Bill Requests Banner
                      Transform.translate(
                        offset: const Offset(0.0, -14.0),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  context.pushNamed(BillnewWidget.routeName),
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0B2018),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 42.0,
                                      height: 42.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1D4331),
                                        borderRadius:
                                            BorderRadius.circular(13.0),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.receipt_long_rounded,
                                        color: Color(0xFF7FD472),
                                        size: 20.0,
                                      ),
                                    ),
                                    const SizedBox(width: 14.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Bill requests',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 2.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF56B84B),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          999.0),
                                                ),
                                                child: Text(
                                                  '2 new',
                                                  style: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontSize: 10.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: const Color(
                                                        0xFF06210F),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            'Ask someone to pay a bill for you, or settle one sent to you.',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF8FA596),
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: Color(0xFF7FD472),
                                      size: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 5b. Smart Discovery Show promo card
                      Transform.translate(
                        offset: const Offset(0.0, -10.0),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SpeakingGameWidget(),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0D2419),
                                      Color(0xFF1A4A2E),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    color: const Color(0xFF56B84B).withValues(alpha: 0.4),
                                  ),
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF56B84B).withValues(alpha: 0.15),
                                        border: Border.all(
                                          color: const Color(0xFF56B84B).withValues(alpha: 0.5),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.mic_rounded,
                                        color: Color(0xFF56B84B),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  'Smart Discovery Show',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.plusJakartaSans(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 7, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF56B84B),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  'NEW',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    color: const Color(0xFF06210F),
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: 0.8,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            'Speak English · Get AI-scored · Win prizes. 2 plays/day.',
                                            style: GoogleFonts.plusJakartaSans(
                                              color: const Color(0xFF8FA596),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: Color(0xFF56B84B),
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 6. Tier Progress Card (with upgrade status CTA)
                      Transform.translate(
                        offset: const Offset(0.0, -4.0),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  context.pushNamed(TeirpageWidget.routeName),
                              borderRadius: BorderRadius.circular(18.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18.0),
                                  border: Border.all(
                                    color: const Color(0xFFE6EAE7),
                                    width: 1.0,
                                  ),
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tierNum == 3
                                                    ? 'Premium Tier · Fully Verified'
                                                    : tierNum == 2
                                                        ? 'Upgrade to Premium for unlimited access'
                                                        : 'Raise your limit to ₦3m',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w800,
                                                  color:
                                                      const Color(0xFF101614),
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                tierNum == 3
                                                    ? 'You have the highest wallet tier.'
                                                    : 'Tap to view tier details and upgrade.',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xFF6E7A72),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 44.0,
                                          height: 44.0,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFEDF7EE),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            tierNum == 3
                                                ? '100%'
                                                : tierNum == 2
                                                    ? '66%'
                                                    : '33%',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(0xFF2F8F3C),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12.0),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(999.0),
                                      child: Container(
                                        height: 6.0,
                                        color: const Color(0xFFEDF0ED),
                                        alignment: Alignment.centerLeft,
                                        child: FractionallySizedBox(
                                          widthFactor: tierNum == 3
                                              ? 1.0
                                              : tierNum == 2
                                                  ? 0.66
                                                  : 0.33,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF56B84B),
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Upgrade status CTA (only if not tier 3)
                                    if (tierNum < 3) ...[
                                      const SizedBox(height: 12.0),
                                      GestureDetector(
                                        onTap: () {
                                          _showUpgradeStatus();
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _checkingUpgradeStatus
                                                ? const SizedBox(
                                                    width: 12,
                                                    height: 12,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 1.5,
                                                      color:
                                                          Color(0xFF2F8F3C),
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons
                                                        .info_outline_rounded,
                                                    color: Color(0xFF2F8F3C),
                                                    size: 14,
                                                  ),
                                            const SizedBox(width: 5),
                                            Text(
                                              _checkingUpgradeStatus
                                                  ? 'Checking status…'
                                                  : 'Check KYC upgrade status',
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    const Color(0xFF2F8F3C),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 7. Recent Activity Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Recent activity',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF101614),
                                      ),
                                    ),
                                    Text(
                                      'Last 30 days',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF6E7A72),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                      TransactionHistoryWidget.routeName,
                                      queryParameters: {
                                        'accountno': serializeParam(
                                            accountNo, ParamType.String),
                                        'accountname': serializeParam(
                                            userName, ParamType.String),
                                      }.withoutNulls,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDF7EE),
                                      borderRadius:
                                          BorderRadius.circular(20.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'See all',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF2F8F3C),
                                          ),
                                        ),
                                        const SizedBox(width: 4.0),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Color(0xFF2F8F3C),
                                          size: 13.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14.0),
                            Builder(
                              builder: (context) {
                                final allTx =
                                    FFAppState().transactionhistory.toList();
                                if (allTx.isEmpty) {
                                  return _model.recentActivityResponse == null
                                      ? _buildActivityLoadingPlaceholder()
                                      : _buildActivityEmptyState();
                                }
                                final displayTx = allTx.take(5).toList();
                                return Column(
                                  children: displayTx.map((txItem) {
                                    final narration = getJsonField(
                                          txItem,
                                          r'''$.narration''',
                                        )?.toString() ??
                                        'Transaction';
                                    final dateStr = getJsonField(
                                          txItem,
                                          r'''$.transactionDateString''',
                                        )?.toString() ??
                                        '';
                                    final credit = getJsonField(
                                          txItem,
                                          r'''$.credit''',
                                        )?.toString() ??
                                        '';
                                    final debit = getJsonField(
                                          txItem,
                                          r'''$.debit''',
                                        )?.toString() ??
                                        '';
                                    final isCredit = credit.isNotEmpty &&
                                        credit != '0' &&
                                        credit != '0.0' &&
                                        credit != 'null';
                                    final amountRaw =
                                        isCredit ? credit : debit;
                                    String amount = '';
                                    try {
                                      final num parsed =
                                          double.parse(amountRaw);
                                      amount = isCredit
                                          ? '+₦${_formatAmount(parsed)}'
                                          : '−₦${_formatAmount(parsed)}';
                                    } catch (_) {
                                      amount = isCredit
                                          ? '+₦$amountRaw'
                                          : '−₦$amountRaw';
                                    }
                                    return _buildRecentActivityItem(
                                      title: functions
                                          .processTransactionNarration(
                                              narration),
                                      subtitle: dateStr,
                                      amount: amount,
                                      status: 'Successful',
                                      isCredit: isCredit,
                                      isPending: false,
                                      onTap: () => context.pushNamed(
                                        TransactionHistoryWidget.routeName,
                                        queryParameters: {
                                          'accountno': serializeParam(
                                              accountNo, ParamType.String),
                                          'accountname': serializeParam(
                                              userName, ParamType.String),
                                        }.withoutNulls,
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Fixed Glassmorphic Bottom Navigation Dock
              const BottomAppBarWidget(selectedIndex: 0),
            ],
          ),
        ),
      ),
    );
  }
}
