import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'overview_carddebit_model.dart';
export 'overview_carddebit_model.dart';

class OverviewCarddebitWidget extends StatefulWidget {
  const OverviewCarddebitWidget({
    super.key,
    double? totalAmount,
  }) : this.totalAmount = totalAmount ?? 0.0;

  final double totalAmount;

  @override
  State<OverviewCarddebitWidget> createState() =>
      _OverviewCarddebitWidgetState();
}

class _OverviewCarddebitWidgetState extends State<OverviewCarddebitWidget> {
  late OverviewCarddebitModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OverviewCarddebitModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76.0,
      decoration: BoxDecoration(
        color: const Color(0xFF101614),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8.0,
            offset: const Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Outgoing',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  '₦${formatNumber(widget.totalAmount, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)}',
                  style: GoogleFonts.inter(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
