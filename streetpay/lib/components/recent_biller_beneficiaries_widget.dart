import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/biller_beneficiary_service.dart';
import '/services/biller_logo_service.dart';

class RecentBillerBeneficiariesWidget extends StatefulWidget {
  final String category; // 'electricity', 'cabletv', 'betting', 'internet'
  final String title;
  final Function(BillerBeneficiaryItem beneficiary) onSelect;

  const RecentBillerBeneficiariesWidget({
    super.key,
    required this.category,
    this.title = 'Saved Accounts',
    required this.onSelect,
  });

  @override
  State<RecentBillerBeneficiariesWidget> createState() =>
      _RecentBillerBeneficiariesWidgetState();
}

class _RecentBillerBeneficiariesWidgetState
    extends State<RecentBillerBeneficiariesWidget> {
  List<BillerBeneficiaryItem> _beneficiaries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBeneficiaries();
  }

  Future<void> _loadBeneficiaries() async {
    final list = await BillerBeneficiaryService.getBeneficiaries(widget.category);
    if (mounted) {
      setState(() {
        _beneficiaries = list;
        _isLoading = false;
      });
    }
  }

  /// Expose method to reload from parent after new payment
  void reload() {
    _loadBeneficiaries();
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
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.history_rounded,
                    size: 15.0,
                    color: Color(0xFF6E7A72),
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    widget.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF6E7A72),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF7EE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_beneficiaries.length} recent',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2F8F3C),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 76.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _beneficiaries.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10.0),
            itemBuilder: (context, index) {
              final item = _beneficiaries[index];
              return _buildCard(context, item, theme);
            },
          ),
        ),
        const SizedBox(height: 14.0),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context,
    BillerBeneficiaryItem item,
    FlutterFlowTheme theme,
  ) {
    return InkWell(
      onTap: () => widget.onSelect(item),
      borderRadius: BorderRadius.circular(14.0),
      child: Container(
        width: 175.0,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: const Color(0xFFE6EAE7),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            BillerLogoWidget(
              billerName: item.billerName,
              category: item.category,
              size: 34.0,
              borderRadius: 8.0,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.customerId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF101614),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 1.0),
                  Text(
                    item.customerName?.isNotEmpty == true
                        ? item.customerName!
                        : item.billerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6E7A72),
                    ),
                  ),
                  if (item.lastAmount != null && item.lastAmount!.isNotEmpty) ...[
                    const SizedBox(height: 2.0),
                    Text(
                      '₦${item.lastAmount}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2F8F3C),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
