import '/auth/custom_auth/auth_util.dart';
import '/components/link_account_card/link_account_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'account_settings_model.dart';
export 'account_settings_model.dart';

class AccountSettingsWidget extends StatefulWidget {
  const AccountSettingsWidget({
    super.key,
    String? phoneNumber,
  }) : this.phoneNumber = phoneNumber ?? '[phoneNumber]';

  final String phoneNumber;

  static String routeName = 'AccountSettings';
  static String routePath = '/accountSettings';

  @override
  State<AccountSettingsWidget> createState() => _AccountSettingsWidgetState();
}

class _AccountSettingsWidgetState extends State<AccountSettingsWidget> {
  late AccountSettingsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccountSettingsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFD6DDD8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEDED),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.logout_rounded,
                  color: Color(0xFFD32F2F), size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              'Sign out?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF101614),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ll need to log in again to access your account.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6E7A72),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'Sign Out',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6E7A72),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      GoRouter.of(context).prepareAuthEvent();
      await authManager.signOut();
      FFAppState().isLoggedIn = false;
      FFAppState().sessionid = '';
      GoRouter.of(context).clearRedirectLocation();
      if (mounted) {
        context.goNamedAuth(SplashWidget.routeName, context.mounted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF6F8F6),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App Bar ────────────────────────────────────────────
            SliverAppBar(
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
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
              title: Text(
                'Account Settings',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              centerTitle: true,
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── BVN header ──────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B2018),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1D4331),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                    Icons.account_balance_rounded,
                                    color: Color(0xFF7FD472),
                                    size: 20),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BVN-Linked Accounts',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    FFAppState().phonenumber.isNotEmpty
                                        ? FFAppState().phonenumber
                                        : widget.phoneNumber,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF8FA596),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Color(0xFF1D4331)),
                          const SizedBox(height: 14),
                          Text(
                            'Accounts linked to your BVN can be used across StreetPay for transfers and payments.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8FA596),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Linked accounts section ─────────────────────
                    Text(
                      'MY ACCOUNTS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9EAAA0),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),

                    wrapWithModel(
                      model: _model.linkAccountCardModel,
                      updateCallback: () => safeSetState(() {}),
                      child: const LinkAccountCardWidget(),
                    ),

                    const SizedBox(height: 32),

                    // ── Danger zone ─────────────────────────────────
                    Text(
                      'ACCOUNT',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9EAAA0),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),

                    InkWell(
                      onTap: _confirmLogout,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFEDED)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEDED),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.logout_rounded,
                                  color: Color(0xFFD32F2F), size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign Out',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFD32F2F),
                                    ),
                                  ),
                                  Text(
                                    'You\'ll be logged out of your account',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF9EAAA0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded,
                                color: Color(0xFFD32F2F), size: 20),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
