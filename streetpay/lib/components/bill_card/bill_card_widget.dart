import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bill_card_model.dart';
export 'bill_card_model.dart';

class BillCardWidget extends StatefulWidget {
  const BillCardWidget({
    super.key,
    String? title,
    String? subtitle,
    String? status,
    String? amount,
  })  : this.title = title ?? '[title]',
        this.subtitle = subtitle ?? '[subtitle]',
        this.status = status ?? '[status]',
        this.amount = amount ?? '[amount]';

  final String title;
  final String subtitle;
  final String status;
  final String amount;

  @override
  State<BillCardWidget> createState() => _BillCardWidgetState();
}

class _BillCardWidgetState extends State<BillCardWidget> {
  late BillCardModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BillCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPaid = widget.status.toLowerCase().contains('paid');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFE6EAE7),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060B2018),
            blurRadius: 10.0,
            offset: Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 13.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: isPaid ? const Color(0xFFEDF7EE) : const Color(0xFFFFF8EC),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                isPaid ? Icons.check_circle_rounded : Icons.receipt_long_rounded,
                color: isPaid ? const Color(0xFF2F8F3C) : const Color(0xFFC97A12),
                size: 20.0,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF101614),
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    widget.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6E7A72),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.amount.startsWith('₦') ? widget.amount : '₦${widget.amount}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF101614),
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 3.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: isPaid ? const Color(0xFFEDF7EE) : const Color(0xFFFFF8EC),
                    borderRadius: BorderRadius.circular(999.0),
                  ),
                  child: Text(
                    widget.status.isNotEmpty ? widget.status : (isPaid ? 'Paid' : 'Pending'),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: isPaid ? const Color(0xFF2F8F3C) : const Color(0xFFC97A12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
