import '/backend/api_requests/api_calls.dart';
import '/components/line_item/line_item_widget.dart';
import '/components/verificationstatus_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'profile_model.dart';
export 'profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({
    super.key,
    required this.phonenumber,
  });

  final String? phonenumber;

  static String routeName = 'Profile';
  static String routePath = '/profile';

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState().accountno != '') {
        _model.accountdetails =
            await WalletAsAServiceGroup.walletEnquiryCall.call(
          accountNo: FFAppState().accountno,
          authToken: FFAppState().bsptoken,
        );

        _model.upgradestatus1 =
            await WalletAsAServiceGroup.upgradestatusCall.call(
          account: FFAppState().accountno,
          authToken: FFAppState().bsptoken,
        );

        FFAppState().bvn = getJsonField(
          WalletAsAServiceGroup.walletEnquiryCall.fulldata(
            (_model.accountdetails?.jsonBody ?? ''),
          ),
          r'''$.bvn''',
        ).toString();
        FFAppState().tier = WalletAsAServiceGroup.walletEnquiryCall.tier(
          (_model.accountdetails?.jsonBody ?? ''),
        )!;
        // Cache name and balance so the profile shows instantly on next visit
        final _cachedName = functions.stripSlash(
          WalletAsAServiceGroup.walletEnquiryCall.accountname(
            (_model.accountdetails?.jsonBody ?? ''),
          ),
        );
        if (_cachedName != null && _cachedName.isNotEmpty) {
          FFAppState().accountname = _cachedName;
        }
        final _cachedBal = WalletAsAServiceGroup.walletEnquiryCall
            .availablebalance((_model.accountdetails?.jsonBody ?? ''))
            ?.toString();
        if (_cachedBal != null && _cachedBal.isNotEmpty) {
          FFAppState().avalbal = _cachedBal;
        }
        safeSetState(() {});
      } else {
        context.pushNamed(
          EmptyProfileWidget.routeName,
          queryParameters: {
            'phoneno': serializeParam(
              widget.phonenumber,
              ParamType.String,
            ),
            'registerwith': serializeParam(
              '',
              ParamType.String,
            ),
          }.withoutNulls,
        );
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _toggleBiometric(bool enable) async {
    if (enable) {
      // Verify the device actually supports biometrics before enabling
      final auth = LocalAuthentication();
      final supported = await auth.isDeviceSupported();
      final canCheck = await auth.canCheckBiometrics;
      if (!supported || !canCheck) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Biometric authentication is not available on this device.',
                style: GoogleFonts.plusJakartaSans(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              backgroundColor: const Color(0xFFDC2626),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
        return;
      }
      // Require a biometric proof before enabling the setting
      final authenticated = await auth.authenticate(
        localizedReason: 'Confirm your fingerprint to enable payment biometrics',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (!authenticated) return;
    }

    FFAppState().biometric = enable;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enable
                ? 'Fingerprint payments enabled.'
                : 'Fingerprint payments disabled.',
            style: GoogleFonts.plusJakartaSans(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor:
              enable ? const Color(0xFF1E4230) : const Color(0xFF4A4A4A),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$label copied to clipboard',
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

  Widget _buildInfoRow(String label, String value, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF8FA596),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : '—',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF101614),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (copyable)
            InkWell(
              onTap: () => _copyToClipboard(value, label),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF7EE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.copy_rounded,
                  color: Color(0xFF2F8F3C),
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final String accountName = functions.stripSlash(
              WalletAsAServiceGroup.walletEnquiryCall.accountname(
            (_model.accountdetails?.jsonBody ?? ''),
          ))?.isNotEmpty == true
        ? functions.stripSlash(
              WalletAsAServiceGroup.walletEnquiryCall.accountname(
            (_model.accountdetails?.jsonBody ?? ''),
          ))!
        : FFAppState().accountname;

    final String availBal = valueOrDefault<String>(
      WalletAsAServiceGroup.walletEnquiryCall
          .availablebalance(
            (_model.accountdetails?.jsonBody ?? ''),
          )
          ?.toString(),
      '0.00',
    );

    final String currentTier = FFAppState().tier.isNotEmpty
        ? 'Tier ${FFAppState().tier}'
        : 'Tier 1';

    final String walletTier = WalletAsAServiceGroup.walletEnquiryCall.tier(
          (_model.accountdetails?.jsonBody ?? ''),
        ) ??
        '1';

    final formattedBal = formatNumber(
      functions.stringtodouble(availBal),
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
      currency: '₦',
    );

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
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Profile Hero Header ─────────────────────────
              SliverAppBar(
                expandedHeight: 220.0,
                pinned: true,
                backgroundColor: const Color(0xFF0B2018),
                leading: InkWell(
                  onTap: () => context.pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0x33FFFFFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0B2018), Color(0xFF163627)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative glow top-right
                        Positioned(
                          top: -60,
                          right: -80,
                          child: Container(
                            width: 240,
                            height: 240,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color(0x1E56B84B),
                                  Color(0x0056B84B),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Avatar circle with initials
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF56B84B)
                                        .withValues(alpha: 0.18),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF56B84B),
                                      width: 2.5,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    accountName.isNotEmpty
                                        ? accountName
                                            .trim()
                                            .split(' ')
                                            .map((p) =>
                                                p.isNotEmpty ? p[0] : '')
                                            .take(2)
                                            .join()
                                            .toUpperCase()
                                        : 'SP',
                                    minFontSize: 14,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF7FD472),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Name
                                AutoSizeText(
                                  accountName.isNotEmpty
                                      ? accountName
                                      : 'StreetPay User',
                                  maxLines: 1,
                                  minFontSize: 14,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Balance + Tier row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      formattedBal,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF7FD472),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0x2256B84B),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        border: Border.all(
                                          color: const Color(0x4056B84B),
                                        ),
                                      ),
                                      child: Text(
                                        currentTier,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF7FD472),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Body Content ───────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18.0, 20.0, 18.0, 32.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Account Info card ─────────────────
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: const Color(0xFFE6EAE7)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ACCOUNT INFORMATION',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF8FA596),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildInfoRow(
                              'Account Name', accountName),
                          const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF0F3F1)),
                          _buildInfoRow(
                            'Account Number',
                            FFAppState().accountno,
                            copyable: true,
                          ),
                          const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF0F3F1)),
                          _buildInfoRow('Bank', '9PSB / StreetPay'),
                          const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF0F3F1)),
                          _buildInfoRow(
                            'Phone Number',
                            FFAppState().phonenumber,
                            copyable: true,
                          ),
                          const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF0F3F1)),
                          _buildInfoRow('Account Status', 'Active ✓'),
                          const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF0F3F1)),
                          _buildInfoRow('Wallet ID',
                              FFAppState().walletid.isNotEmpty
                                  ? FFAppState().walletid
                                  : '—',
                              copyable: FFAppState().walletid.isNotEmpty),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    // ── Security Settings card ────────────
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: const Color(0xFFE6EAE7)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SECURITY SETTINGS',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF8FA596),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDF7EE),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.fingerprint_rounded,
                                  color: Color(0xFF2F8F3C),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fingerprint Payments',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF101614),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'Authorize payments using your fingerprint',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF6E7A72),
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: FFAppState().biometric,
                                onChanged: _toggleBiometric,
                                activeColor: const Color(0xFF56B84B),
                                activeTrackColor:
                                    const Color(0xFF56B84B).withValues(alpha: 0.3),
                                inactiveThumbColor: const Color(0xFFB0BEC5),
                                inactiveTrackColor:
                                    const Color(0xFFE0E0E0),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFF0F3F1)),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: FFAppState().disableVoiceBalance
                                      ? const Color(0xFFF1F5F2)
                                      : const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  FFAppState().disableVoiceBalance
                                      ? Icons.volume_off_rounded
                                      : Icons.volume_up_rounded,
                                  color: FFAppState().disableVoiceBalance
                                      ? const Color(0xFF78909C)
                                      : const Color(0xFF2E7D32),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Voice Announcements',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF101614),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      FFAppState().disableVoiceBalance
                                          ? 'Voice announcements are off'
                                          : 'Voice announcements are on',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF6E7A72),
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: !FFAppState().disableVoiceBalance,
                                onChanged: (val) {
                                  setState(() {
                                    FFAppState().disableVoiceBalance = !val;
                                  });
                                },
                                activeColor: const Color(0xFF56B84B),
                                activeTrackColor:
                                    const Color(0xFF56B84B).withValues(alpha: 0.3),
                                inactiveThumbColor: const Color(0xFFB0BEC5),
                                inactiveTrackColor:
                                    const Color(0xFFE0E0E0),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFF0F3F1)),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3E0),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Color(0xFFE65100),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Auto-lock',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF101614),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'App locks after 5 minutes of inactivity',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF6E7A72),
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F3F1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'ON',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF2F8F3C),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    // ── Tier Upgrade card ─────────────────
                    if (walletTier == '1' || walletTier == '2')
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF0B2018), Color(0xFF1A3F2E)],
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0x2256B84B),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.shield_outlined,
                                    color: Color(0xFF7FD472),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  walletTier == '1'
                                      ? 'Upgrade to Tier 2'
                                      : 'Upgrade to Tier 3',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              walletTier == '1'
                                  ? 'Raise your transaction limit to ₦200,000 per day by verifying your BVN.'
                                  : 'Raise your transaction limit to ₦3,000,000 per day with full KYC.',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF8FA596),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () async {
                                  context.pushNamed(
                                    KycpagggeWidget.routeName,
                                    queryParameters: {
                                      'targetTier': serializeParam(
                                          walletTier == '1' ? '2' : '3',
                                          ParamType.String),
                                      'phoneno': serializeParam(
                                        functions.removecode(
                                            WalletAsAServiceGroup
                                                .walletEnquiryCall
                                                .phonenumber(
                                          (_model.accountdetails?.jsonBody ??
                                              ''),
                                        )!),
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF56B84B),
                                  foregroundColor: const Color(0xFF06210F),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  walletTier == '1'
                                      ? 'Verify & Upgrade'
                                      : 'Complete KYC',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF06210F),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // ── Upgrade Status card (if pending) ─────
                    if (WalletAsAServiceGroup.upgradestatusCall.message(
                          (_model.upgradestatus1?.jsonBody ?? ''),
                        ) ==
                        'SUCCESS') ...[
                      const SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF7EE),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: const Color(0xFF56B84B).withValues(alpha: 0.3),
                          ),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.hourglass_top_rounded,
                              color: Color(0xFF2F8F3C),
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Upgrade Request Pending',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF101614),
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Your tier upgrade is being reviewed.',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF6E7A72),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
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
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: VerificationstatusWidget(
                                            status: WalletAsAServiceGroup
                                                .upgradestatusCall
                                                .message(
                                              (_model.upgradestatus1
                                                      ?.jsonBody ??
                                                  ''),
                                            ),
                                            reason: WalletAsAServiceGroup
                                                .upgradestatusCall
                                                .reason(
                                              (_model.upgradestatus1
                                                      ?.jsonBody ??
                                                  ''),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2F8F3C),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Check',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
