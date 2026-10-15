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
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

// Define a custom light grey color with opacity
final PdfColor lightGrey =
    PdfColor.fromInt(0xFFCCCCCC); // Adjust the color as needed

Future<String> pdfGeneratorShare(
  String sender,
  String amount,
  String dateTime,
  String paymentReference,
  String description,
  String receiver,
  String receiverAccount,
) async {
  // Generate the PDF content
  final pdf = pw.Document();

  // URL of the logo image
  final String logoUrl =
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/steepaybackup-kemszg/assets/o4v3z9yafizz/Streetpay3.png';

  try {
    // Download the logo image from the URL
    final response = await http.get(Uri.parse(logoUrl));
    final Uint8List logoBytes = response.bodyBytes;

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with Logo
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Image(pw.MemoryImage(logoBytes), width: 100),
                ],
              ),
              pw.SizedBox(height: 20),
              // Title Section
              pw.Text(
                "Payment Receipt",
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueAccent,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 10),
              // Amount Section
              pw.Text(
                "₦$amount", // Display the amount from the parameter
                style: pw.TextStyle(
                  fontSize: 36,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                "$dateTime", // Display date and time from the parameter
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 20),
              // Transaction Details
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(" Card Number:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("507881 ******** 5207"), // Example card number
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(" Account Number:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          receiverAccount), // Use the receiverAccount parameter
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(" Order Amount:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          "₦$amount"), // Display order amount from the parameter
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(" Payment Amount:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          "N$amount"), // Display payment amount from the parameter
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(" Transaction Type:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Card Payment-POS"), // Example transaction type
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(" Transaction ID:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          paymentReference), // Use the paymentReference parameter
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(" Payment Method:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("CashBox"), // Example payment method
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(" Terminal Type:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("POS"), // Example terminal type
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(" Transaction Scenario:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(description), // Use the description parameter
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "Thank you for using our service!",
                style: pw.TextStyle(
                  fontStyle: pw.FontStyle.italic,
                  fontSize: 14,
                  color: PdfColors.black,
                ),
                textAlign: pw.TextAlign.center,
              ),
              // Watermark
              pw.Positioned(
                child: pw.Text(
                  "STREETPAY",
                  style: pw.TextStyle(
                    fontSize: 100,
                    color: lightGrey, // Use the custom light grey color
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                left: 50,
                top: 200, // Adjust position as needed
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF locally
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/receipt.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Open the saved PDF
    final result = await OpenFile.open(filePath);

    // Check the result of the open operation
    if (result.type == ResultType.done) {
      print("PDF opened successfully.");
    } else {
      print("Failed to open PDF: ${result.message}");
    }

    return filePath; // Return the path of the generated PDF
  } catch (e) {
    print("Error generating or opening PDF: $e");
    return ''; // Return an empty string in case of error
  }
}
