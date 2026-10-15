// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<void> pdfGenerator(
  String sender,
  String amount,
  String dateTime,
  String paymentReference,
  String description,
  String receiver,
  String receiverAccount,
) async {
  try {
    // Format amount with commas
    final amountNum = double.tryParse(amount.replaceAll(',', '').replaceAll('₦', ''));
    final formattedAmount =
        amountNum != null ? NumberFormat('#,##0.00').format(amountNum) : amount;

    // Brand palette
    final darkGreen = PdfColor.fromHex('#0B2018');
    final primaryGreen = PdfColor.fromHex('#56B84B');
    final lightGreenBg = PdfColor.fromHex('#EDF7EE');
    final textColor = PdfColor.fromHex('#101614');
    final subtleText = PdfColor.fromHex('#6E7A72');
    final labelColor = PdfColor.fromHex('#8FA596');
    final dividerColor = PdfColor.fromHex('#E6EAE7');
    final white = PdfColors.white;

    final pdf = pw.Document(
      title: 'StreetPay Receipt',
      author: 'StreetPay',
    );

    // Attempt to fetch branding logo
    Uint8List? logoBytes;
    try {
      final response = await http
          .get(Uri.parse(
            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/steepaybackup-kemszg/assets/o4v3z9yafizz/Streetpay3.png',
          ))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) logoBytes = response.bodyBytes;
    } catch (_) {}

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // ── Dark green header band ──────────────────────────────────
              pw.Container(
                color: darkGreen,
                padding: const pw.EdgeInsets.fromLTRB(40, 44, 40, 44),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // Logo
                    if (logoBytes != null)
                      pw.Center(
                        child: pw.Image(pw.MemoryImage(logoBytes), height: 34),
                      ),
                    if (logoBytes != null) pw.SizedBox(height: 22),

                    // StreetPay wordmark fallback
                    if (logoBytes == null)
                      pw.Text(
                        'STREETPAY',
                        style: pw.TextStyle(
                          color: white,
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                    if (logoBytes == null) pw.SizedBox(height: 22),

                    // Success pill
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#1A4D2E'),
                        borderRadius: pw.BorderRadius.circular(999),
                      ),
                      child: pw.Text(
                        'Transfer Successful',
                        style: pw.TextStyle(
                          color: PdfColor.fromHex('#7FD472'),
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 16),

                    // Label
                    pw.Text(
                      'TRANSFER OUT',
                      style: pw.TextStyle(
                        color: labelColor,
                        fontSize: 10,
                        letterSpacing: 1.8,
                      ),
                    ),
                    pw.SizedBox(height: 8),

                    // Amount
                    pw.Text(
                      'NGN $formattedAmount',
                      style: pw.TextStyle(
                        color: white,
                        fontSize: 40,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // ── White receipt body ──────────────────────────────────────
              pw.Expanded(
                child: pw.Container(
                  color: white,
                  padding: const pw.EdgeInsets.fromLTRB(40, 32, 40, 24),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _receiptRow('Recipient', receiver, textColor, subtleText),
                      _receiptDivider(dividerColor),
                      _receiptRow('Account Number', receiverAccount, textColor, subtleText),
                      _receiptDivider(dividerColor),
                      _receiptRow('Bank', '9PSB StreetPay', textColor, subtleText),
                      _receiptDivider(dividerColor),
                      _receiptRow('Sender', sender, textColor, subtleText),
                      _receiptDivider(dividerColor),
                      _receiptRow('Narration', description.isNotEmpty ? description : 'Transfer', textColor, subtleText),
                      _receiptDivider(dividerColor),
                      _receiptRow('Reference', paymentReference, textColor, subtleText),
                      _receiptDivider(dividerColor),
                      _receiptRow('Date & Time', dateTime, textColor, subtleText),
                      pw.SizedBox(height: 28),

                      // Dashed separator
                      pw.Container(
                        height: 1,
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(
                              color: dividerColor,
                              width: 1,
                              style: pw.BorderStyle.dashed,
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),

                      // Footer text
                      pw.Center(
                        child: pw.Text(
                          'Thank you for using StreetPay',
                          style: pw.TextStyle(
                            color: primaryGreen,
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Center(
                        child: pw.Text(
                          'support@streetpayng.com  |  www.streetpayng.com',
                          style: pw.TextStyle(color: subtleText, fontSize: 9.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Light green footer bar ──────────────────────────────────
              pw.Container(
                color: lightGreenBg,
                padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                child: pw.Center(
                  child: pw.Text(
                    'This receipt is system-generated and does not require a signature.',
                    style: pw.TextStyle(color: subtleText, fontSize: 8.5),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/streetpay_receipt.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'StreetPay Transaction Receipt',
    );
  } catch (e) {
    debugPrint('Receipt PDF error: $e');
  }
}

pw.Widget _receiptRow(
  String label,
  String value,
  PdfColor textColor,
  PdfColor subtleText,
) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 9),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(color: subtleText, fontSize: 11.5),
        ),
        pw.Flexible(
          child: pw.Text(
            value,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              color: textColor,
              fontSize: 11.5,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _receiptDivider(PdfColor color) {
  return pw.Divider(color: color, thickness: 0.5);
}
