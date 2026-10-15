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
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'dart:typed_data';

Future<void> generateTransactionReceipt(
  String sender,
  String senderDetails,
  String amount,
  String dateTime,
  String transactionNumber,
  String sessionId,
  String receiver,
  String receiverDetails,
) async {
  final pdf = pw.Document();

  // Define PDF content
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(300, 600), // Adjusted for receipt size
      build: (context) {
        return pw.Container(
          padding: pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Logo Section
              pw.Center(
                child: pw.Text(
                  'StreetPay', // Replace with your app name/logo
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green,
                  ),
                ),
              ),
              pw.SizedBox(height: 16),
              // Amount Section
              pw.Center(
                child: pw.Text(
                  'N$amount',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'Successful',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Center(
                child: pw.Text(
                  dateTime,
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey,
                  ),
                ),
              ),
              pw.SizedBox(height: 16),
              // Details Section
              pw.Divider(color: PdfColors.grey),
              pw.Text(
                'Recipient Details',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              pw.Text(receiver),
              pw.Text(receiverDetails),
              pw.SizedBox(height: 8),
              pw.Text(
                'Sender Details',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              pw.Text(sender),
              pw.Text(senderDetails),
              pw.SizedBox(height: 8),
              pw.Text(
                'Transaction Type',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              pw.Text('Transfer to Bank Account'),
              pw.SizedBox(height: 8),
              pw.Text(
                'Transaction No.',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              pw.Text(transactionNumber),
              pw.SizedBox(height: 8),
              pw.Text(
                'Session ID',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              pw.Text(sessionId),
              pw.Divider(color: PdfColors.grey),
              // Footer Section
              pw.SizedBox(height: 16),
              pw.Text(
                'Enjoy a better life with Streetpay. Get free transfers, withdrawals, bill payments, instant loans, and good annual interest on your savings. OPay is licensed by the Central Bank of Nigeria and insured by the NDIC.',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ],
          ),
        );
      },
    ),
  );

  // Save the PDF to a file
  final outputDir = await getApplicationDocumentsDirectory();
  final file = File("${outputDir.path}/TransactionReceipt.pdf");
  await file.writeAsBytes(await pdf.save());
  print('PDF saved to ${file.path}');
}
