import '/backend/api_requests/api_calls.dart';
import '/components/verificationstatus_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'teirpage_model.dart';
export 'teirpage_model.dart';

class TeirpageWidget extends StatefulWidget {
  const TeirpageWidget({super.key});

  static String routeName = 'teirpage';
  static String routePath = '/teirpage';

  @override
  State<TeirpageWidget> createState() => _TeirpageWidgetState();
}

class _TeirpageWidgetState extends State<TeirpageWidget> {
  late TeirpageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = true;
  bool _checkingStatus = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TeirpageModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _loading = true);

    _model.accountdetails = await WalletAsAServiceGroup.walletEnquiryCall.call(
      accountNo: FFAppState().accountno,
      authToken: FFAppState().bsptoken,
    );

    _model.upgradestatus1 = await WalletAsAServiceGroup.upgradestatusCall.call(
      account: FFAppState().accountno,
      authToken: FFAppState().bsptoken,
    );

    if (mounted) {
      final bvn = getJsonField(
        _model.accountdetails?.jsonBody ?? '',
        r'''$.bvn''',
      ).toString();
      FFAppState().bvn = bvn;

      final tier = WalletAsAServiceGroup.walletEnquiryCall
          .tier(_model.accountdetails?.jsonBody ?? '');
      if (tier != null) FFAppState().tier = tier;

      setState(() => _loading = false);
    }
  }

  Future<void> _showUpgradeStatus({bool fetchFresh = false}) async {
    if (_checkingStatus) return;
    setState(() => _checkingStatus = true);

    ApiCallResponse? statusResp = _model.upgradestatus1;
    if (fetchFresh) {
      statusResp = await WalletAsAServiceGroup.upgradestatusCall.call(
        account: FFAppState().accountno,
        authToken: FFAppState().bsptoken,
      );
    }

    if (mounted) setState(() => _checkingStatus = false);
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
                  .message(statusResp?.jsonBody ?? ''),
              reason: WalletAsAServiceGroup.upgradestatusCall
                  .reason(statusResp?.jsonBody ?? ''),
            ),
          ),
        ),
      ),
    ).then((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final tierStr = FFAppState().tier;
    final tierNum = int.tryParse(tierStr) ?? 1;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF6F8F6),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: const Color(0xFF0B2018),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => context.safePop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF152F23),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.arrow_back_rounded,
                            color: Color(0xFFCFE3D6), size: 18),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Account Tiers',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
                    if (_loading)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF7FD472),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _loadData,
          color: const Color(0xFF56B84B),
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Visual tier progression stepper ──────────────────────
                _buildStepper(tierNum),
                const SizedBox(height: 24),

                // ── Tier 1 — Basic ────────────────────────────────────────
                _buildTierCard(
                  tierNum: tierNum,
                  cardTier: 1,
                  name: 'Basic',
                  subtitle: 'No KYC required · Instant signup',
                  limits: [
                    _TierLimit('Wallet balance', '₦50,000'),
                    _TierLimit('Daily transactions', '₦50,000'),
                    _TierLimit('Monthly transactions', '₦300,000'),
                  ],
                  requirements: [],
                ),
                const SizedBox(height: 14),

                // ── Tier 2 — Standard ─────────────────────────────────────
                _buildTierCard(
                  tierNum: tierNum,
                  cardTier: 2,
                  name: 'Standard',
                  subtitle: 'BVN verification required',
                  limits: [
                    _TierLimit('Wallet balance', '₦500,000'),
                    _TierLimit('Daily transactions', '₦200,000'),
                    _TierLimit('Monthly transactions', '₦3,000,000'),
                  ],
                  requirements: ['Valid BVN', 'Phone number verified'],
                ),
                const SizedBox(height: 14),

                // ── Tier 3 — Premium ─────────────────────────────────────
                _buildTierCard(
                  tierNum: tierNum,
                  cardTier: 3,
                  name: 'Premium',
                  subtitle: 'Full KYC · AML-compliant',
                  limits: [
                    _TierLimit('Wallet balance', 'Unlimited'),
                    _TierLimit('Daily transactions', '₦5,000,000'),
                    _TierLimit('Monthly transactions', 'AML-based'),
                  ],
                  requirements: [
                    'Government-issued ID',
                    'Utility bill or address proof',
                    'Facial verification',
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepper(int tierNum) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EAE7)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _stepDot(label: '1', isActive: tierNum >= 1, isDone: tierNum > 1),
              _stepLine(tierNum >= 2),
              _stepDot(label: '2', isActive: tierNum >= 2, isDone: tierNum > 2),
              _stepLine(tierNum >= 3),
              _stepDot(label: '3', isActive: tierNum >= 3, isDone: false),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text('Basic',
                    textAlign: TextAlign.center,
                    style: _stepLabelStyle(tierNum >= 1)),
              ),
              Expanded(
                child: Text('Standard',
                    textAlign: TextAlign.center,
                    style: _stepLabelStyle(tierNum >= 2)),
              ),
              Expanded(
                child: Text('Premium',
                    textAlign: TextAlign.center,
                    style: _stepLabelStyle(tierNum >= 3)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepDot({
    required String label,
    required bool isActive,
    required bool isDone,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF56B84B) : const Color(0xFFE6EAE7),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: isDone
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
          : Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isActive ? Colors.white : const Color(0xFFB0BDB5),
              ),
            ),
    );
  }

  Widget _stepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF56B84B)
              : const Color(0xFFE6EAE7),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  TextStyle _stepLabelStyle(bool isActive) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 11,
      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
      color: isActive ? const Color(0xFF2F8F3C) : const Color(0xFFB0BDB5),
    );
  }

  Widget _buildTierCard({
    required int tierNum,
    required int cardTier,
    required String name,
    required String subtitle,
    required List<_TierLimit> limits,
    required List<String> requirements,
  }) {
    final isCurrent = tierNum == cardTier;
    final isUnlocked = tierNum > cardTier;
    final isLocked = tierNum < cardTier;
    final isNextUpgrade = cardTier == tierNum + 1;

    final bgColor = isCurrent
        ? const Color(0xFF0B2018)
        : isUnlocked
            ? const Color(0xFF1A3B2A)
            : Colors.white;

    final borderColor = isCurrent
        ? const Color(0xFF2C6045)
        : isUnlocked
            ? const Color(0xFF2C5040)
            : const Color(0xFFE6EAE7);

    final titleColor = (isCurrent || isUnlocked) ? Colors.white : const Color(0xFF101614);
    final subtitleColor = (isCurrent || isUnlocked)
        ? const Color(0xFF8FB3A0)
        : const Color(0xFF6E7A72);
    final labelColor = (isCurrent || isUnlocked)
        ? const Color(0xFF8FB3A0)
        : const Color(0xFF6E7A72);
    final valueColor = (isCurrent || isUnlocked) ? Colors.white : const Color(0xFF101614);
    final iconColor = isCurrent
        ? const Color(0xFF7FD472)
        : isUnlocked
            ? const Color(0xFF5CB85C)
            : isLocked
                ? const Color(0xFFB0BDB5)
                : const Color(0xFF2F8F3C);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: isCurrent
            ? const [
                BoxShadow(
                  color: Color(0x30071A11),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? const Color(0xFF1D4331)
                        : isUnlocked
                            ? const Color(0xFF1A3B2A)
                            : const Color(0xFFEDF7EE),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    isUnlocked
                        ? Icons.verified_rounded
                        : isCurrent
                            ? Icons.account_balance_wallet_rounded
                            : Icons.lock_outline_rounded,
                    color: iconColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Tier $cardTier — $name',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: titleColor,
                            ),
                          ),
                          if (isCurrent) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF56B84B)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Current',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF7FD472),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: (isCurrent || isUnlocked)
                  ? const Color(0xFF1D4331)
                  : const Color(0xFFEDF0ED),
            ),
          ),

          // Limits table
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Column(
              children: limits.map((limit) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              size: 15, color: iconColor),
                          const SizedBox(width: 8),
                          Text(
                            limit.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: labelColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        limit.value,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: valueColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Requirements (shown only for locked tiers)
          if (isLocked && requirements.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Divider(
                height: 1,
                thickness: 0.5,
                color: const Color(0xFFEDF0ED),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Requirements',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9EAAA0),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...requirements.map((req) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.radio_button_unchecked_rounded,
                              size: 14, color: Color(0xFFB0BDB5)),
                          const SizedBox(width: 8),
                          Text(
                            req,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6E7A72),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],

          // Action buttons
          if (isCurrent || isNextUpgrade || isLocked) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: _buildCardActions(
                tierNum: tierNum,
                cardTier: cardTier,
                isCurrent: isCurrent,
                isNextUpgrade: isNextUpgrade,
              ),
            ),
          ] else ...[
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildCardActions({
    required int tierNum,
    required int cardTier,
    required bool isCurrent,
    required bool isNextUpgrade,
  }) {
    if (isCurrent && tierNum < 3) {
      // Current tier — show only status check; upgrade button lives on the next tier card
      return SizedBox(
        width: double.infinity,
        height: 44,
        child: OutlinedButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            _showUpgradeStatus(fetchFresh: true);
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF2C6045)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          child: _checkingStatus
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Color(0xFF7FD472)),
                )
              : Text(
                  'View Upgrade Status',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF7FD472),
                  ),
                ),
        ),
      );
    }

    if (isCurrent && tierNum == 3) {
      // Max tier — show achievement
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events_rounded,
              color: Color(0xFF7FD472), size: 18),
          const SizedBox(width: 8),
          Text(
            'You\'ve reached the highest tier!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF7FD472),
            ),
          ),
        ],
      );
    }

    if (isNextUpgrade) {
      // Next available upgrade card
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                context.pushNamed(
                  KycpagggeWidget.routeName,
                  queryParameters: {
                    'targetTier':
                        serializeParam(cardTier.toString(), ParamType.String),
                    if (cardTier == 3)
                      'phoneno': serializeParam(
                        FFAppState().phonenumber,
                        ParamType.String,
                      ),
                  }.withoutNulls,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F8F3C),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'Upgrade Now',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _showUpgradeStatus(fetchFresh: true);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFB8D4BF)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _checkingStatus
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Color(0xFF2F8F3C)),
                    )
                  : Text(
                      'View Upgrade Status',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2F8F3C),
                      ),
                    ),
            ),
          ),
        ],
      );
    }

    // Locked (tier > cardTier + 1) — need to complete lower tiers first
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline_rounded,
              size: 14, color: Color(0xFFB0BDB5)),
          const SizedBox(width: 6),
          Text(
            'Complete Tier ${cardTier - 1} first',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFB0BDB5),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierLimit {
  final String label;
  final String value;
  const _TierLimit(this.label, this.value);
}
