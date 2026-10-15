import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '/custom_code/actions/getupdatestatus.dart';
import '/custom_code/widgets/force_update_overlay.dart';
import 'settingpage_model.dart';
export 'settingpage_model.dart';

class SettingpageWidget extends StatefulWidget {
  const SettingpageWidget({super.key});

  static String routeName = 'settingpage';
  static String routePath = '/settingpage';

  @override
  State<SettingpageWidget> createState() => _SettingpageWidgetState();
}

class _SettingpageWidgetState extends State<SettingpageWidget> {
  late SettingpageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isCheckingUpdate = false;

  Future<void> _checkForUpdates() async {
    if (_isCheckingUpdate) return;
    setState(() => _isCheckingUpdate = true);

    try {
      final status = await checkAppVersionStatus(timeout: const Duration(seconds: 4));
      if (!mounted) return;

      if (status != null && status.canUpdate) {
        await ForceUpdateOverlay.show(context, status: status, isForceUpdate: false);
      } else if (status != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'StreetPay is up to date (v${status.localVersion})',
              style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            backgroundColor: const Color(0xFF00A651),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not check for updates. Please check your network connection.',
              style: GoogleFonts.plusJakartaSans(color: Colors.white),
            ),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error checking updates: $e',
              style: GoogleFonts.plusJakartaSans(color: Colors.white),
            ),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCheckingUpdate = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingpageModel());
    _model.switchValue = FFAppState().biometric;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildSectionCard({required String title, required List<Widget> items}) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF8FA596),
                fontSize: 11.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 14.0),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String label,
    String? subtitle,
    Color? iconBgColor,
    Color? iconColor,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final bg = iconBgColor ?? const Color(0xFFEDF7EE);
    final ic = iconColor ?? const Color(0xFF2F8F3C);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12.0),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: ic, size: 20.0),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF101614),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF6E7A72),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFB0B8B4),
                  size: 20.0,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Divider(height: 1, thickness: 1, color: Color(0xFFF0F3F1)),
      );

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final String displayName = FFAppState().accountname.isNotEmpty
        ? FFAppState().accountname
        : 'StreetPay User';
    final String phoneDisplay = FFAppState().phonenumber.isNotEmpty
        ? (functions.removecode(FFAppState().phonenumber) ?? '—')
        : '—';
    final String tierLabel = FFAppState().tier.isNotEmpty
        ? 'Tier ${FFAppState().tier}'
        : 'Tier 1';

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
          body: CustomScrollView(
            controller: _model.columnController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Sticky Header / AppBar ─────────────────────────
              SliverAppBar(
                expandedHeight: 180.0,
                pinned: true,
                backgroundColor: const Color(0xFF0B2018),
                leading: InkWell(
                  onTap: () => context.safePop(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0x33FFFFFF),
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
                        colors: [Color(0xFF0B2018), Color(0xFF133A28)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative glow
                        Positioned(
                          top: -40,
                          right: -60,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color(0x2256B84B),
                                  Color(0x0056B84B),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Profile info
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    // Avatar
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF56B84B).withValues(alpha: 0.18),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF56B84B),
                                          width: 2,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        displayName.isNotEmpty
                                            ? displayName
                                                .trim()
                                                .split(' ')
                                                .map((p) => p.isNotEmpty ? p[0] : '')
                                                .take(2)
                                                .join()
                                                .toUpperCase()
                                            : 'SP',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF7FD472),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            displayName,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: -0.3,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            phoneDisplay,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: const Color(0xFF8FA596),
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Tier badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF56B84B).withValues(alpha: 0.18),
                                        borderRadius: BorderRadius.circular(999),
                                        border: Border.all(
                                          color: const Color(0xFF56B84B).withValues(alpha: 0.4),
                                        ),
                                      ),
                                      child: Text(
                                        tierLabel,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF7FD472),
                                          fontSize: 11.5,
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

              // ── Content ───────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18.0, 20.0, 18.0, 32.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Account section ──────────────────────
                    _buildSectionCard(
                      title: 'Account',
                      items: [
                        _buildSettingsTile(
                          icon: Icons.person_outline_rounded,
                          label: 'Edit Profile',
                          subtitle: 'Update your personal information',
                          onTap: () =>
                              context.pushNamed(EditprofileWidget.routeName),
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.upgrade_rounded,
                          label: 'Update Tier',
                          subtitle: 'Raise your transaction limits',
                          iconBgColor: const Color(0xFFFFF3E0),
                          iconColor: const Color(0xFFF57C00),
                          onTap: () => context.pushNamed(
                            ProfileWidget.routeName,
                            queryParameters: {
                              'phonenumber': serializeParam(
                                functions.removecode(FFAppState().phonenumber),
                                ParamType.String,
                              ),
                            }.withoutNulls,
                          ),
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Account Details',
                          subtitle: 'View your wallet & bank info',
                          iconBgColor: const Color(0xFFE3F2FD),
                          iconColor: const Color(0xFF1565C0),
                          onTap: () =>
                              context.pushNamed(AccountdetailsWidget.routeName),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16.0),

                    // ── Security section ─────────────────────
                    _buildSectionCard(
                      title: 'Security',
                      items: [
                        _buildSettingsTile(
                          icon: Icons.lock_outline_rounded,
                          label: 'Change PIN',
                          subtitle: 'Update your transaction PIN',
                          onTap: () =>
                              context.pushNamed(ResetpasswordWidget.routeName),
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.fingerprint_rounded,
                          label: 'Biometric Authentication',
                          subtitle: 'Use face ID or fingerprint to sign in',
                          trailing: Transform.scale(
                            scale: 0.85,
                            child: Switch(
                              value: _model.switchValue ?? false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.switchValue = newValue);
                                if (newValue) {
                                  final _localAuth = LocalAuthentication();
                                  bool _isBiometricSupported =
                                      await _localAuth.isDeviceSupported();
                                  bool canCheckBiometrics =
                                      await _localAuth.canCheckBiometrics;
                                  if (_isBiometricSupported &&
                                      canCheckBiometrics) {
                                    try {
                                      _model.biometric =
                                          await _localAuth.authenticate(
                                              localizedReason:
                                                  'Please authenticate to proceed',
                                              options:
                                                  const AuthenticationOptions(
                                                      biometricOnly: true));
                                    } on PlatformException {
                                      _model.biometric = false;
                                    }
                                    safeSetState(() {});
                                  }

                                  if (_model.biometric == true) {
                                    FFAppState().biometric = true;
                                    safeSetState(() {});
                                  } else {
                                    FFAppState().biometric = false;
                                    safeSetState(() {});
                                  }
                                  safeSetState(() {});
                                }
                              },
                              activeColor: const Color(0xFF56B84B),
                              activeTrackColor:
                                  const Color(0xFF56B84B).withValues(alpha: 0.3),
                              inactiveThumbColor: const Color(0xFFB0B8B4),
                              inactiveTrackColor: const Color(0xFFE6EAE7),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16.0),

                    // ── Support & Legal section ──────────────
                    _buildSectionCard(
                      title: 'Support & Legal',
                      items: [
                        _buildSettingsTile(
                          icon: Icons.headset_mic_outlined,
                          label: 'Help & Support',
                          subtitle: 'Contact us or browse FAQs',
                          iconBgColor: const Color(0xFFF3E5F5),
                          iconColor: const Color(0xFF7B1FA2),
                          onTap: () async {
                            _model.contact = await GetCONTACTCall.call(
                              accessToken: FFAppState().bsptoken,
                            );
                            context.pushNamed(
                              ContactusWidget.routeName,
                              queryParameters: {
                                'email': serializeParam(
                                  GetCONTACTCall.email(
                                    (_model.contact?.jsonBody ?? ''),
                                  ),
                                  ParamType.String,
                                ),
                                'phone': serializeParam(
                                  GetCONTACTCall.phone(
                                    (_model.contact?.jsonBody ?? ''),
                                  ),
                                  ParamType.String,
                                ),
                              }.withoutNulls,
                            );
                            safeSetState(() {});
                          },
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.privacy_tip_outlined,
                          label: 'Privacy Policy',
                          subtitle: 'Read how we handle your data',
                          iconBgColor: const Color(0xFFE8F5E9),
                          iconColor: const Color(0xFF388E3C),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24.0),

                    // ── Logout button ────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 54.0,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          context.pushNamed(Login1Widget.routeName);
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Color(0xFFD32F2F),
                          size: 20,
                        ),
                        label: Text(
                          'Log Out',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFFD32F2F),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDECEC),
                          side: const BorderSide(
                              color: Color(0xFFFFCDD2), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    // App version & Update Check
                    Center(
                      child: InkWell(
                        onTap: _checkForUpdates,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'StreetPay v2.2.5',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFFB0B8B4),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (_isCheckingUpdate)
                                const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00A651)),
                                  ),
                                )
                              else
                                Text(
                                  '• Check for updates',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF00A651),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
