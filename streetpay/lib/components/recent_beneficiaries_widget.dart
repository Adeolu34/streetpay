import '/flutter_flow/flutter_flow_theme.dart';
import '/services/beneficiary_service.dart';
import '/services/bank_logo_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentBeneficiariesWidget extends StatefulWidget {
  const RecentBeneficiariesWidget({
    super.key,
    required this.onSelect,
  });

  final Function(BeneficiaryItem beneficiary) onSelect;

  @override
  State<RecentBeneficiariesWidget> createState() => _RecentBeneficiariesWidgetState();
}

class _RecentBeneficiariesWidgetState extends State<RecentBeneficiariesWidget> {
  List<BeneficiaryItem> _beneficiaries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBeneficiaries();
  }

  Future<void> _loadBeneficiaries() async {
    final list = await BeneficiaryService.getRecentBeneficiaries();
    if (mounted) {
      setState(() {
        _beneficiaries = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _beneficiaries.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = FlutterFlowTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 16.0,
                    color: theme.secondaryText,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    'Recent Beneficiaries',
                    style: theme.bodySmall.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                          ),
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              Text(
                '${_beneficiaries.length} saved',
                style: theme.bodySmall.override(
                      font: GoogleFonts.inter(),
                      color: theme.secondaryText.withOpacity(0.7),
                      fontSize: 11.0,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 90.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _beneficiaries.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12.0),
            itemBuilder: (context, index) {
              final item = _beneficiaries[index];
              return _buildBeneficiaryCard(context, item, theme);
            },
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }

  Widget _buildBeneficiaryCard(
    BuildContext context,
    BeneficiaryItem item,
    FlutterFlowTheme theme,
  ) {
    final displayName = item.accountName.split(' ').first;

    return InkWell(
      onTap: () => widget.onSelect(item),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: 76.0,
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: theme.alternate.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0B2018),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.initials,
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF7FD472),
                      fontWeight: FontWeight.w800,
                      fontSize: 13.0,
                    ),
                  ),
                ),
                Positioned(
                  right: -3,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: BankLogoWidget(
                      bankName: item.bankName,
                      size: 18.0,
                      borderRadius: 9.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.bodySmall.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                    ),
                    fontSize: 11.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              item.bankName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.bodySmall.override(
                    font: GoogleFonts.inter(),
                    color: theme.secondaryText,
                    fontSize: 9.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
