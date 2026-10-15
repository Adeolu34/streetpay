import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'account_card_model.dart';
export 'account_card_model.dart';

class AccountCardWidget extends StatefulWidget {
  const AccountCardWidget({
    super.key,
    String? accountName,
    String? accountNumber,
    String? bankName,
  })  : this.accountName = accountName ?? 'Peter Willmott',
        this.accountNumber = accountNumber ?? '6567890056',
        this.bankName = bankName ?? 'UBA';

  final String accountName;
  final String accountNumber;
  final String bankName;

  @override
  State<AccountCardWidget> createState() => _AccountCardWidgetState();
}

class _AccountCardWidgetState extends State<AccountCardWidget> {
  late AccountCardModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccountCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initials = widget.accountName.trim().isNotEmpty
        ? widget.accountName
            .trim()
            .split(RegExp(r'\s+'))
            .take(2)
            .map((s) => s.isNotEmpty ? s[0].toUpperCase() : '')
            .join()
        : 'SP';

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
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 42.0,
              height: 42.0,
              decoration: const BoxDecoration(
                color: Color(0xFFEDF7EE),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2F8F3C),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.accountName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF101614),
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    '${widget.accountNumber} · ${widget.bankName}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6E7A72),
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6F3),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Pinned',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2F8F3C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
