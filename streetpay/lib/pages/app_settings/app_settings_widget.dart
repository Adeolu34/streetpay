import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'app_settings_model.dart';
export 'app_settings_model.dart';

class AppSettingsWidget extends StatefulWidget {
  const AppSettingsWidget({super.key});

  static String routeName = 'AppSettings';
  static String routePath = '/appSettings';

  @override
  State<AppSettingsWidget> createState() => _AppSettingsWidgetState();
}

class _AppSettingsWidgetState extends State<AppSettingsWidget> {
  late AppSettingsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppSettingsModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.apiResultu2s = await WalletAsAServiceGroup.walletEnquiryCall.call(
        accountNo: FFAppState().accountno,
        authToken: FFAppState().bsptoken,
      );
      if (mounted && (_model.apiResultu2s?.succeeded ?? false)) {
        safeSetState(() {});
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final String displayName = FFAppState().accountname.isNotEmpty
        ? FFAppState().accountname
        : 'StreetPay User';
    final String tierLabel = FFAppState().tier.isNotEmpty
        ? 'Tier ${FFAppState().tier}'
        : 'Tier 1';

    final initials = displayName
        .trim()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF6F8F6),
        body: Stack(
          children: [
            // ── Main content ──────────────────────────────────────
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Profile Header ────────────────────────────
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0B2018),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Avatar
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF56B84B)
                                        .withValues(alpha: 0.18),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF56B84B),
                                      width: 2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    initials.isEmpty ? 'SP' : initials,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF7FD472),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Name + phone
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        FFAppState().phonenumber,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF8FA596),
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
                                    color: const Color(0x2256B84B),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                        color: const Color(0x4056B84B)),
                                  ),
                                  child: Text(
                                    tierLabel,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF7FD472),
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

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Account section ──────────────────────
                        _sectionLabel('ACCOUNT'),
                        const SizedBox(height: 10),

                        _settingsCard(children: [
                          _settingsTile(
                            icon: Icons.manage_accounts_rounded,
                            iconBg: const Color(0xFFEDF7EE),
                            iconColor: const Color(0xFF2F8F3C),
                            title: 'Account Settings',
                            subtitle: 'Manage linked accounts',
                            onTap: () {
                              HapticFeedback.lightImpact();
                              context.pushNamed(
                                AccountSettingsWidget.routeName,
                                extra: <String, dynamic>{
                                  '__transition_info__': TransitionInfo(
                                    hasTransition: true,
                                    transitionType:
                                        PageTransitionType.rightToLeft,
                                  ),
                                },
                              );
                            },
                          ),
                          _divider(),
                          _settingsTile(
                            icon: Icons.person_add_alt_rounded,
                            iconBg: const Color(0xFFEDF7EE),
                            iconColor: const Color(0xFF2F8F3C),
                            title: 'Grant Access',
                            subtitle: 'Authorize another user',
                            onTap: () {
                              HapticFeedback.lightImpact();
                              context.pushNamed(
                                GrantAccessWidget.routeName,
                                queryParameters: {
                                  'phoneno': serializeParam(
                                    WalletAsAServiceGroup.walletEnquiryCall
                                        .phonenumber(
                                      (_model.apiResultu2s?.jsonBody ?? ''),
                                    ),
                                    ParamType.String,
                                  ),
                                }.withoutNulls,
                              );
                            },
                          ),
                        ]),

                        const SizedBox(height: 20),

                        // ── Preferences section ──────────────────
                        _sectionLabel('PREFERENCES'),
                        const SizedBox(height: 10),

                        _settingsCard(children: [
                          _settingsTileSwitch(
                            icon: Icons.dark_mode_rounded,
                            iconBg: const Color(0xFFF1F1F8),
                            iconColor: const Color(0xFF5A5FBF),
                            title: 'Dark Mode',
                            subtitle: 'Switch app appearance',
                            value: false,
                            onChanged: (val) {
                              // Dark mode toggle — reserved for theme integration
                            },
                          ),
                        ]),

                        const SizedBox(height: 20),

                        // ── About section ─────────────────────────
                        _sectionLabel('ABOUT'),
                        const SizedBox(height: 10),

                        _settingsCard(children: [
                          _settingsTile(
                            icon: Icons.info_outline_rounded,
                            iconBg: const Color(0xFFF1F5F2),
                            iconColor: const Color(0xFF6E7A72),
                            title: 'App Version',
                            subtitle: 'v2.2.5',
                            onTap: null,
                            showArrow: false,
                          ),
                        ]),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom nav ─────────────────────────────────────────
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: wrapWithModel(
                model: _model.bottomAppBarModel,
                updateCallback: () => safeSetState(() {}),
                child: const BottomAppBarWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF9EAAA0),
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EAE7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.only(left: 68),
      child: Divider(height: 1, thickness: 0.5, color: Color(0xFFEDF0ED)),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF101614),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF9EAAA0),
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              const Icon(Icons.chevron_right_rounded,
                  color: Color(0xFFB0BDB5), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _settingsTileSwitch({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF101614),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF9EAAA0),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF56B84B),
            inactiveThumbColor: const Color(0xFFB0BDB5),
            inactiveTrackColor: const Color(0xFFE6EAE7),
          ),
        ],
      ),
    );
  }
}
