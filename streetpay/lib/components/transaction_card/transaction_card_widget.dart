import '/flutter_flow/flutter_flow_util.dart';
import '/pages/payments/payment_receipt/payment_receipt_widget.dart';
import '/services/telco_logo_service.dart';
import '/services/transaction_parser_service.dart';
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

  String _formatAmountDisplay(double val, bool isCredit, bool isReversed) {
    final formatted = formatNumber(
      val,
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
    );
    if (isCredit) {
      return '+₦$formatted';
    } else {
      return '−₦$formatted';
    }
  }

  Widget _buildLeadingIcon(ParsedTransaction parsed) {
    if (parsed.network != null) {
      return TelcoLogoWidget(
        network: parsed.network!,
        size: 38.0,
        borderRadius: 11.0,
      );
    }

    if (parsed.isReversed) {
      return Container(
        width: 38.0,
        height: 38.0,
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(11.0),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.undo_rounded,
          color: Color(0xFFD97706),
          size: 20.0,
        ),
      );
    }

    if (parsed.isReversalCredit) {
      return Container(
        width: 38.0,
        height: 38.0,
        decoration: BoxDecoration(
          color: const Color(0xFFD1FAE5),
          borderRadius: BorderRadius.circular(11.0),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.assignment_return_rounded,
          color: Color(0xFF059669),
          size: 19.0,
        ),
      );
    }

    if (parsed.category == 'electricity' || parsed.category == 'bill_payment') {
      return Container(
        width: 38.0,
        height: 38.0,
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(11.0),
        ),
        alignment: Alignment.center,
        child: Icon(
          parsed.category == 'electricity' ? Icons.bolt_rounded : Icons.receipt_long_rounded,
          color: const Color(0xFFD97706),
          size: 20.0,
        ),
      );
    }

    if (parsed.category == 'fee') {
      return Container(
        width: 38.0,
        height: 38.0,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(11.0),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.receipt_long_rounded,
          color: Color(0xFF475569),
          size: 19.0,
        ),
      );
    }

    final isFailed = parsed.status == 'Failed';
    if (isFailed) {
      return Container(
        width: 38.0,
        height: 38.0,
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(11.0),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.error_outline_rounded,
          color: Color(0xFFDC2626),
          size: 19.0,
        ),
      );
    }

    if (parsed.isCredit) {
      return Container(
        width: 38.0,
        height: 38.0,
        decoration: BoxDecoration(
          color: const Color(0xFF00A651).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(11.0),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.arrow_downward_rounded,
          color: Color(0xFF00A651),
          size: 19.0,
        ),
      );
    }

    // Default Debit
    return Container(
      width: 38.0,
      height: 38.0,
      decoration: BoxDecoration(
        color: const Color(0xFF101614).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(11.0),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.arrow_upward_rounded,
        color: Color(0xFF101614),
        size: 19.0,
      ),
    );
  }

  void _showTransactionDetails(
    BuildContext context,
    ParsedTransaction parsed,
    String formattedAmount,
  ) {
    final isFailed = parsed.status == 'Failed';
    final isReversed = parsed.isReversed;

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle drag bar
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

                // Status or Network Icon
                if (parsed.network != null)
                  TelcoLogoWidget(
                    network: parsed.network!,
                    size: 56.0,
                    borderRadius: 16.0,
                  )
                else
                  Container(
                    width: 56.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: isFailed
                          ? const Color(0xFFFEE2E2)
                          : (isReversed
                              ? const Color(0xFFFEF3C7)
                              : (parsed.isCredit
                                  ? const Color(0xFF00A651).withValues(alpha: 0.12)
                                  : const Color(0xFF101614).withValues(alpha: 0.08))),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      isFailed
                          ? Icons.error_outline_rounded
                          : (isReversed
                              ? Icons.undo_rounded
                              : (parsed.isCredit
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_rounded)),
                      color: isFailed
                          ? const Color(0xFFDC2626)
                          : (isReversed
                              ? const Color(0xFFD97706)
                              : (parsed.isCredit
                                  ? const Color(0xFF00A651)
                                  : const Color(0xFF101614))),
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
                    decoration: isReversed ? TextDecoration.lineThrough : null,
                    decorationColor: const Color(0xFFD97706),
                    color: isFailed
                        ? const Color(0xFFDC2626)
                        : (isReversed
                            ? const Color(0xFF92400E)
                            : (parsed.isCredit
                                ? const Color(0xFF00A651)
                                : const Color(0xFF101614))),
                  ),
                ),
                const SizedBox(height: 6.0),

                // Category & Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: isFailed
                            ? const Color(0xFFFEE2E2)
                            : (isReversed
                                ? const Color(0xFFFEF3C7)
                                : (parsed.isCredit
                                    ? const Color(0xFF00A651).withValues(alpha: 0.1)
                                    : const Color(0xFFE6EAE7))),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        isFailed
                            ? 'TRANSACTION FAILED'
                            : (isReversed
                                ? 'REVERSED PAYMENT'
                                : (parsed.isReversalCredit
                                    ? 'REFUND (CREDIT)'
                                    : (parsed.isCredit ? 'INCOMING (CREDIT)' : 'OUTGOING (DEBIT)'))),
                        style: GoogleFonts.inter(
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          color: isFailed
                              ? const Color(0xFFDC2626)
                              : (isReversed
                                  ? const Color(0xFFD97706)
                                  : (parsed.isCredit
                                      ? const Color(0xFF00A651)
                                      : const Color(0xFF4A5568))),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                // Reversal explanatory banner if reversed
                if (isReversed) ...[
                  const SizedBox(height: 12.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 18.0,
                          color: Color(0xFFD97706),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'This payment was reversed and funds were refunded to your wallet account.',
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF92400E),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20.0),

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
                      _buildDetailRow(
                        'Status',
                        parsed.status,
                        isStatus: true,
                        isError: isFailed,
                        isWarning: isReversed,
                      ),
                      const Divider(height: 20.0, color: Color(0xFFE5E7EB)),
                      _buildDetailRow('Category', parsed.categoryLabel),
                      if (parsed.network != null) ...[
                        const Divider(height: 20.0, color: Color(0xFFE5E7EB)),
                        _buildDetailRow('Network', parsed.network!),
                      ],
                      if (parsed.phoneNumber != null) ...[
                        const Divider(height: 20.0, color: Color(0xFFE5E7EB)),
                        _buildDetailRow('Phone Number', parsed.phoneNumber!, isCopyable: true),
                      ],
                      if (parsed.beneficiaryOrSender != null) ...[
                        const Divider(height: 20.0, color: Color(0xFFE5E7EB)),
                        _buildDetailRow(
                          parsed.isCredit ? 'Sender' : 'Beneficiary',
                          parsed.beneficiaryOrSender!,
                        ),
                      ],
                      if (parsed.rawNarration.isNotEmpty && parsed.rawNarration != '-') ...[
                        const Divider(height: 20.0, color: Color(0xFFE5E7EB)),
                        _buildDetailRow('Narration', parsed.rawNarration),
                      ],
                      const Divider(height: 20.0, color: Color(0xFFE5E7EB)),
                      _buildDetailRow('Date & Time', parsed.dateString.isNotEmpty ? parsed.dateString : 'N/A'),
                      if (parsed.reference.isNotEmpty) ...[
                        const Divider(height: 20.0, color: Color(0xFFE5E7EB)),
                        _buildDetailRow('Reference', parsed.reference, isCopyable: true),
                      ],
                      if (parsed.reversalReferenceNo != null && parsed.reversalReferenceNo!.isNotEmpty) ...[
                        const Divider(height: 20.0, color: Color(0xFFE5E7EB)),
                        _buildDetailRow('Reversal Ref', parsed.reversalReferenceNo!, isCopyable: true),
                      ],
                      if (parsed.balance != null) ...[
                        const Divider(height: 20.0, color: Color(0xFFE5E7EB)),
                        _buildDetailRow(
                          'Balance After',
                          '₦${formatNumber(parsed.balance!, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)}',
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                // Receipt button
                if (!isFailed)
                  SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        final effectiveRef = parsed.reference.isNotEmpty
                            ? parsed.reference
                            : 'TXN-${DateTime.now().millisecondsSinceEpoch}';

                        context.pushNamed(
                          PaymentReceiptWidget.routeName,
                          queryParameters: {
                            'sender': serializeParam(
                                parsed.isCredit
                                    ? (parsed.beneficiaryOrSender ?? parsed.title)
                                    : FFAppState().accountname,
                                ParamType.String),
                            'amount': serializeParam(parsed.amount, ParamType.double),
                            'date': serializeParam(parsed.dateString, ParamType.String),
                            'paymentref': serializeParam(effectiveRef, ParamType.String),
                            'description': serializeParam(
                                parsed.rawNarration.isNotEmpty ? parsed.rawNarration : parsed.title,
                                ParamType.String),
                            'receiver': serializeParam(
                                parsed.isCredit
                                    ? FFAppState().accountname
                                    : (parsed.beneficiaryOrSender ?? parsed.title),
                                ParamType.String),
                            'receiveraccount': serializeParam(
                                FFAppState().accountno, ParamType.String),
                          }.withoutNulls,
                        );
                      },
                      icon: const Icon(Icons.receipt_long_rounded,
                          size: 20.0, color: Colors.white),
                      label: Text(
                        isReversed ? 'View Original Receipt' : 'View Receipt',
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
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isStatus = false,
    bool isError = false,
    bool isWarning = false,
    bool isCopyable = false,
  }) {
    Color valueColor = const Color(0xFF111827);
    if (isStatus) {
      if (isError) {
        valueColor = const Color(0xFFDC2626);
      } else if (isWarning) {
        valueColor = const Color(0xFFD97706);
      } else {
        valueColor = const Color(0xFF00A651);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 95.0,
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
                    color: valueColor,
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
                      SnackBar(
                        content: Text('$label copied to clipboard'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Icon(Icons.copy_rounded,
                      size: 14.0, color: Color(0xFF00A651)),
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
    // Parse complete transaction details with smart fallback
    final parsed = TransactionParserService.parse(
      widget.rawItem,
      credittitle: widget.credittitle,
      debittitle: widget.debittitle,
      creditamount: widget.creditamount,
      debitamount: widget.debitamount,
      subtitle: widget.creditsubtitle.isNotEmpty ? widget.creditsubtitle : widget.debitsubtitle,
    );

    final isFailed = parsed.status == 'Failed';
    final isReversed = parsed.isReversed;
    final formattedAmount = _formatAmountDisplay(parsed.amount, parsed.isCredit, isReversed);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          if (widget.onTap != null) {
            widget.onTap!();
          } else {
            _showTransactionDetails(context, parsed, formattedAmount);
          }
        },
        borderRadius: BorderRadius.circular(14.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(
              color: isFailed
                  ? const Color(0xFFFECACA)
                  : (isReversed ? const Color(0xFFFDE68A) : const Color(0xFFE5E7EB)),
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
              // Type / Telco Icon
              _buildLeadingIcon(parsed),
              const SizedBox(width: 12.0),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      parsed.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            parsed.dateString,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
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
                      decoration: isReversed ? TextDecoration.lineThrough : null,
                      decorationColor: const Color(0xFFD97706),
                      color: isFailed
                          ? const Color(0xFFDC2626)
                          : (isReversed
                              ? const Color(0xFF92400E)
                              : (parsed.isCredit
                                  ? const Color(0xFF00A651)
                                  : const Color(0xFF111827))),
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    parsed.status,
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: isFailed
                          ? const Color(0xFFDC2626)
                          : (isReversed
                              ? const Color(0xFFD97706)
                              : const Color(0xFF00A651)),
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
