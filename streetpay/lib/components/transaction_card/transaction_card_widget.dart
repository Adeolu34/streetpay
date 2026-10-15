import '/flutter_flow/flutter_flow_util.dart';
import '/pages/payments/payment_receipt/payment_receipt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'transaction_card_model.dart';
export 'transaction_card_model.dart';

class TransactionCardWidget extends StatefulWidget {
  const TransactionCardWidget({
    super.key,
    String? credittitle,
    String? creditsubtitle,
    String? creditamount,
    required this.debittitle,
    required this.debitamount,
    required this.debitsubtitle,
    this.rawItem,
    this.onTap,
  })  : this.credittitle = credittitle ?? '',
        this.creditsubtitle = creditsubtitle ?? '',
        this.creditamount = creditamount ?? '';

  final String credittitle;
  final String creditsubtitle;
  final String creditamount;
  final String? debittitle;
  final String? debitamount;
  final String? debitsubtitle;
  final dynamic rawItem;
  final VoidCallback? onTap;

  @override
  State<TransactionCardWidget> createState() => _TransactionCardWidgetState();
}

class _TransactionCardWidgetState extends State<TransactionCardWidget> {
  late TransactionCardModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransactionCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  bool _isCredit() {
    final cleanCredit = widget.creditamount.replaceAll(',', '').trim();
    if (cleanCredit.isEmpty || cleanCredit == 'null') return false;
    final val = double.tryParse(cleanCredit);
    return val != null && val > 0.0001;
  }

  String _formatAmountDisplay(String rawAmount, bool isCredit) {
    final clean = rawAmount.replaceAll(',', '').trim();
    final val = double.tryParse(clean);
    if (val != null) {
      final formatted = formatNumber(
        val,
        formatType: FormatType.decimal,
        decimalType: DecimalType.periodDecimal,
      );
      return isCredit ? '+₦$formatted' : '−₦$formatted';
    }
    return isCredit ? '+₦$rawAmount' : '−₦$rawAmount';
  }

  void _showTransactionDetails(
    BuildContext context,
    bool isCredit,
    String title,
    String subtitle,
    String formattedAmount,
    double amountNum,
  ) {
    final narration = widget.rawItem != null
        ? (getJsonField(widget.rawItem, r'''$.narration''')?.toString() ?? title)
        : title;
    final dateStr = widget.rawItem != null
        ? (getJsonField(widget.rawItem, r'''$.transactionDateString''')?.toString() ?? subtitle)
        : subtitle;
    final ref = widget.rawItem != null
        ? (getJsonField(widget.rawItem, r'''$.reference''')?.toString() ??
            getJsonField(widget.rawItem, r'''$.paymentReference''')?.toString() ??
            getJsonField(widget.rawItem, r'''$.id''')?.toString() ??
            '')
        : '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 16.0,
            bottom: MediaQuery.of(ctx).padding.bottom + 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle drag handle
              Center(
                child: Container(
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Status icon
              Container(
                width: 56.0,
                height: 56.0,
                decoration: BoxDecoration(
                  color: isCredit
                      ? const Color(0xFF00A651).withValues(alpha: 0.12)
                      : const Color(0xFF101614).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: isCredit ? const Color(0xFF00A651) : const Color(0xFF101614),
                  size: 28.0,
                ),
              ),
              const SizedBox(height: 12.0),

              // Amount
              Text(
                formattedAmount,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w800,
                  color: isCredit ? const Color(0xFF00A651) : const Color(0xFF101614),
                ),
              ),
              const SizedBox(height: 4.0),

              // Type badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: isCredit
                      ? const Color(0xFF00A651).withValues(alpha: 0.1)
                      : const Color(0xFFE6EAE7),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  isCredit ? 'INCOMING (CREDIT)' : 'OUTGOING (DEBIT)',
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                    color: isCredit ? const Color(0xFF00A651) : const Color(0xFF4A5568),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Detail card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Status', 'Successful', isStatus: true),
                    const Divider(height: 20.0, color: Color(0xFFE5E7EB)),
                    _buildDetailRow('Narration', narration),
                    const Divider(height: 20.0, color: Color(0xFFE5E7EB)),
                    _buildDetailRow('Date & Time', dateStr),
                    if (ref.isNotEmpty) ...[
                      const Divider(height: 20.0, color: Color(0xFFE5E7EB)),
                      _buildDetailRow('Reference', ref, isCopyable: true),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              // Receipt button
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.pushNamed(
                      PaymentReceiptWidget.routeName,
                      queryParameters: {
                        'sender': serializeParam(isCredit ? narration : FFAppState().accountname, ParamType.String),
                        'amount': serializeParam(amountNum, ParamType.double),
                        'date': serializeParam(dateStr, ParamType.String),
                        'paymentref': serializeParam(ref.isNotEmpty ? ref : 'TXN-${DateTime.now().millisecondsSinceEpoch}', ParamType.String),
                        'description': serializeParam(narration, ParamType.String),
                        'receiver': serializeParam(isCredit ? FFAppState().accountname : narration, ParamType.String),
                        'receiveraccount': serializeParam(FFAppState().accountno, ParamType.String),
                      }.withoutNulls,
                    );
                  },
                  icon: const Icon(Icons.receipt_long_rounded, size: 20.0, color: Colors.white),
                  label: Text(
                    'View Receipt',
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A651),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              // Close button
              SizedBox(
                width: double.infinity,
                height: 44.0,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Close',
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false, bool isCopyable = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90.0,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: isStatus ? const Color(0xFF00A651) : const Color(0xFF111827),
                    fontWeight: isStatus ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ),
              if (isCopyable) ...[
                const SizedBox(width: 6.0),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reference copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Icon(Icons.copy_rounded, size: 14.0, color: Color(0xFF00A651)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCredit = _isCredit();
    final title = isCredit
        ? (widget.credittitle.isNotEmpty ? widget.credittitle : 'Deposit')
        : ((widget.debittitle != null && widget.debittitle!.isNotEmpty)
            ? widget.debittitle!
            : (widget.credittitle.isNotEmpty ? widget.credittitle : 'Transfer'));
    final subtitle = isCredit
        ? widget.creditsubtitle
        : ((widget.debitsubtitle != null && widget.debitsubtitle!.isNotEmpty)
            ? widget.debitsubtitle!
            : widget.creditsubtitle);
    final rawAmount = isCredit
        ? widget.creditamount
        : ((widget.debitamount != null && widget.debitamount!.isNotEmpty)
            ? widget.debitamount!
            : widget.creditamount);

    final cleanAmt = rawAmount.replaceAll(',', '').trim();
    final amountNum = double.tryParse(cleanAmt) ?? 0.0;
    final formattedAmount = _formatAmountDisplay(rawAmount, isCredit);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          if (widget.onTap != null) {
            widget.onTap!();
          } else {
            _showTransactionDetails(
              context,
              isCredit,
              title,
              subtitle,
              formattedAmount,
              amountNum,
            );
          }
        },
        borderRadius: BorderRadius.circular(14.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6.0,
                offset: const Offset(0.0, 2.0),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          child: Row(
            children: [
              // Type Icon
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: isCredit
                      ? const Color(0xFF00A651).withValues(alpha: 0.12)
                      : const Color(0xFF101614).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(11.0),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: isCredit ? const Color(0xFF00A651) : const Color(0xFF101614),
                  size: 19.0,
                ),
              ),
              const SizedBox(width: 12.0),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),

              // Amount and Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formattedAmount,
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: isCredit ? const Color(0xFF00A651) : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    'Successful',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF00A651),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
