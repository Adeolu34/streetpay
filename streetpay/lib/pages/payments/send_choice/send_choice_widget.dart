import '/components/autodiscover_widget.dart';
import '/components/recent_beneficiaries_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/services/beneficiary_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'send_choice_model.dart';
export 'send_choice_model.dart';

class SendChoiceWidget extends StatefulWidget {
  const SendChoiceWidget({super.key});

  static String routeName = 'SendChoice';
  static String routePath = '/sendChoice';

  @override
  State<SendChoiceWidget> createState() => _SendChoiceWidgetState();
}

class _SendChoiceWidgetState extends State<SendChoiceWidget> {
  late SendChoiceModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SendChoiceModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _openStreetPaySearch() {
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
              const Divider(height: 1, thickness: 0.5, color: Color(0xFFE6EAE7)),
              const Expanded(child: AutodiscoverWidget()),
            ],
          ),
        ),
      ),
    );
  }

  void _openOtherBanks({BeneficiaryItem? prefill}) {
    HapticFeedback.lightImpact();
    context.pushNamed(
      ManualPaymentWidget.routeName,
      queryParameters: prefill != null
          ? {
              'prefillAccountNumber': serializeParam(
                prefill.accountNumber,
                ParamType.String,
              ),
            }.withoutNulls
          : {},
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
      child: Scaffold(
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
                'Send Money',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Text(
                    'How would you like to send?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8FA596),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Transfer options ────────────────────────────
                    _TransferOptionCard(
                      icon: Icons.bolt_rounded,
                      iconBg: const Color(0xFFEDF7EE),
                      iconColor: const Color(0xFF2F8F3C),
                      accentColor: const Color(0xFF56B84B),
                      title: 'Transfer to StreetPay',
                      description:
                          'Instant & free. Send to any StreetPay user by wallet ID, phone number, or find them nearby.',
                      badge: 'Instant · Free',
                      badgeBg: const Color(0xFFEDF7EE),
                      badgeColor: const Color(0xFF2F8F3C),
                      onTap: _openStreetPaySearch,
                    ),

                    const SizedBox(height: 14),

                    _TransferOptionCard(
                      icon: Icons.account_balance_rounded,
                      iconBg: const Color(0xFFF0F4FF),
                      iconColor: const Color(0xFF3D5FA0),
                      accentColor: const Color(0xFF3D5FA0),
                      title: 'Transfer to Other Banks',
                      description:
                          'Send to any Nigerian bank account. Supports 100+ banks via NIP transfer.',
                      badge: 'NIP Transfer',
                      badgeBg: const Color(0xFFF0F4FF),
                      badgeColor: const Color(0xFF3D5FA0),
                      onTap: () => _openOtherBanks(),
                    ),

                    const SizedBox(height: 32),

                    // ── Recent beneficiaries ─────────────────────────
                    Text(
                      'RECENT',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9EAAA0),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),

                    RecentBeneficiariesWidget(
                      onSelect: (beneficiary) {
                        _openOtherBanks(prefill: beneficiary);
                      },
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

class _TransferOptionCard extends StatelessWidget {
  const _TransferOptionCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.accentColor,
    required this.title,
    required this.description,
    required this.badge,
    required this.badgeBg,
    required this.badgeColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color accentColor;
  final String title;
  final String description;
  final String badge;
  final Color badgeBg;
  final Color badgeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE6EAE7)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF101614),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6E7A72),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded,
                color: const Color(0xFFB0BDB5), size: 16),
          ],
        ),
      ),
    );
  }
}
