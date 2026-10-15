import '/components/report_issue_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'payment_receipt_model.dart';
export 'payment_receipt_model.dart';

class PaymentReceiptWidget extends StatefulWidget {
  const PaymentReceiptWidget({
    super.key,
    required this.sender,
    required this.amount,
    String? date,
    required this.paymentref,
    required this.description,
    required this.receiver,
    required this.receiveraccount,
  }) : this.date = date ?? '';

  final String? sender;
  final double? amount;
  final String date;
  final String? paymentref;
  final String? description;
  final String? receiver;
  final String? receiveraccount;

  static String routeName = 'PaymentReceipt';
  static String routePath = '/paymentReceipt';

  @override
  State<PaymentReceiptWidget> createState() => _PaymentReceiptWidgetState();
}

class _PaymentReceiptWidgetState extends State<PaymentReceiptWidget> {
  late PaymentReceiptModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _receiptKey = GlobalKey();
  bool _sharingImage = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentReceiptModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _formatAmount(double? val) {
    if (val == null) return '₦0.00';
    final parts = val.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buffer = StringBuffer();
    int count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
      count++;
    }
    return '₦${buffer.toString().split('').reversed.join()}.$decPart';
  }

  Future<void> _shareAsImage() async {
    if (_sharingImage) return;
    setState(() => _sharingImage = true);
    try {
      final boundary =
          _receiptKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        setState(() => _sharingImage = false);
        return;
      }
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        setState(() => _sharingImage = false);
        return;
      }
      final bytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/streetpay_receipt_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'StreetPay Transaction Receipt',
      );
    } catch (e) {
      debugPrint('Share as image error: $e');
    }
    if (mounted) setState(() => _sharingImage = false);
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF6F8F6),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD0D9D1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Share Receipt',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF101614),
                  ),
                ),
                const SizedBox(height: 20),
                _shareOption(
                  icon: Icons.image_outlined,
                  title: 'Share as Image',
                  subtitle: 'Capture and share as PNG',
                  onTap: () {
                    Navigator.pop(ctx);
                    _shareAsImage();
                  },
                ),
                const SizedBox(height: 10),
                _shareOption(
                  icon: Icons.picture_as_pdf_outlined,
                  title: 'Share as PDF',
                  subtitle: 'Download or share branded PDF',
                  onTap: () {
                    Navigator.pop(ctx);
                    actions.pdfGenerator(
                      widget.sender ?? '',
                      (widget.amount ?? 0.0).toString(),
                      widget.date,
                      widget.paymentref ?? '',
                      widget.description ?? '',
                      widget.receiver ?? '',
                      widget.receiveraccount ?? '',
                    );
                  },
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shareOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6EAE7)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF7EE),
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: const Color(0xFF2F8F3C), size: 22),
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
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6E7A72),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFFB0BDB5), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportIssue() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) => Padding(
        padding: MediaQuery.viewInsetsOf(ctx),
        child: ReportIssueWidget(transactionRef: widget.paymentref),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedAmount = _formatAmount(widget.amount);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF6F8F6),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            color: Colors.transparent,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE6EAE7)),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF101614),
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Receipt',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF101614),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
                    // Quick share icon
                    InkWell(
                      onTap: _showShareOptions,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF7EE),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.share_outlined,
                          color: Color(0xFF2F8F3C),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 24.0),
              child: Column(
                children: [
                  // Receipt Card wrapped in RepaintBoundary for image capture
                  RepaintBoundary(
                    key: _receiptKey,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE6EAE7)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          // Forest Green Header Banner
                          Container(
                            width: double.infinity,
                            color: const Color(0xFF0B2018),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 28.0),
                            child: Column(
                              children: [
                                // Success pill
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF56B84B)
                                        .withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_rounded,
                                          color: Color(0xFF7FD472), size: 13),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Transfer Successful',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF7FD472),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'TRANSFER OUT',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF8FA596),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  formattedAmount,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.date,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF637A6D),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Jagged / perforated edge effect
                          Container(
                            height: 16,
                            color: const Color(0xFFF6F8F6),
                            child: Row(
                              children: List.generate(
                                30,
                                (i) => Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 1),
                                    decoration: BoxDecoration(
                                      color: i.isEven
                                          ? Colors.white
                                          : const Color(0xFFF6F8F6),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Receipt Details Body
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                            child: Column(
                              children: [
                                _buildReceiptRow('Recipient',
                                    widget.receiver ?? 'Recipient'),
                                _buildDivider(),
                                _buildReceiptRow('Account',
                                    widget.receiveraccount ?? '-'),
                                _buildDivider(),
                                _buildReceiptRow('Bank', '9PSB StreetPay'),
                                _buildDivider(),
                                _buildReceiptRow(
                                    'Sender',
                                    widget.sender ?? 'StreetPay User'),
                                _buildDivider(),
                                _buildReceiptRow('Narration',
                                    widget.description ?? 'Transfer'),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Color(0xFFEDF0ED),
                                    endIndent: 0,
                                    indent: 0,
                                  ),
                                ),
                                _buildReceiptRow(
                                    'Reference', widget.paymentref ?? '-'),
                                _buildDivider(),
                                _buildReceiptRow('Date & Time', widget.date),
                                const SizedBox(height: 20),
                                // StreetPay branding footer inside card
                                Center(
                                  child: Text(
                                    'Powered by StreetPay · 9PSB',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2F8F3C),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: _showReportIssue,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFE6EAE7)),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.flag_outlined,
                                      color: Color(0xFF101614), size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Report issue',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF101614),
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Material(
                          color: const Color(0xFF56B84B),
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: _showShareOptions,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              height: 52,
                              alignment: Alignment.center,
                              child: _sharingImage
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF06210F)),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.share_outlined,
                                            color: Color(0xFF06210F), size: 16),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Share',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF06210F),
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Send Another Transfer
                  FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(ManualPaymentWidget.routeName);
                    },
                    text: 'Send Another Transfer',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 48.0,
                      padding: EdgeInsets.zero,
                      iconPadding: EdgeInsets.zero,
                      color: Colors.transparent,
                      textStyle: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF2F8F3C),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                      elevation: 0.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF6E7A72),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF101614),
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 0.5, color: Color(0xFFEDF0ED));
  }
}
