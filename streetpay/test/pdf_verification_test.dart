import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  test('pw.Document compiles with CustomPaint', () async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Address Verification Form'),
              pw.CustomPaint(
                size: const PdfPoint(200, 50),
                painter: (PdfGraphics canvas, PdfPoint size) {
                  canvas.setColor(PdfColors.green);
                  canvas.drawRect(0, 0, size.x, size.y);
                  canvas.fillPath();
                  canvas.setColor(PdfColors.black);
                  canvas.moveTo(10, 10);
                  canvas.lineTo(50, 40);
                  canvas.strokePath();
                },
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    expect(bytes, isNotEmpty);
    expect(bytes[0], equals(0x25));
  });
}
