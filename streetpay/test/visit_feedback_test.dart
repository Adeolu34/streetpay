import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:streetpay/custom_code/actions/visit_feedback_generator.dart';

import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final fontFile = File('C:/Windows/Fonts/arial.ttf');
    if (fontFile.existsSync()) {
      final fontData = fontFile.readAsBytesSync();
      final fontLoader = FontLoader('Roboto')
        ..addFont(Future.value(ByteData.view(fontData.buffer)));
      await fontLoader.load();
    }
  });

  test('generateVisitFeedbackPdf produces valid PDF document file', () async {
    final result = await generateVisitFeedbackPdf(
      'ADEOLU OLUWASEUN',
      '14 Marina Street, Lagos Island, Lagos',
      'Residential apartment building with gated entrance opposite City Hall',
      DateTime(2026, 5, 29),
      null,
      'Akinwole Oluleye',
      'Abayomi IPADEOLA',
      'Near City Hall, Marina',
    );

    File('build/test_output.pdf').writeAsBytesSync(result.bytes!);
    expect(result.bytes, isNotNull);
    expect(result.bytes!.isNotEmpty, isTrue);
    expect(result.name?.endsWith('.pdf'), isTrue);

    // Verify PDF header marker (%PDF-)
    expect(result.bytes![0], equals(0x25)); // %
    expect(result.bytes![1], equals(0x50)); // P
    expect(result.bytes![2], equals(0x44)); // D
    expect(result.bytes![3], equals(0x46)); // F
    expect(result.bytes![4], equals(0x2D)); // -

    print(
        'Generated PDF size: ${result.bytes!.length} bytes (~${(result.bytes!.length / 1024).toStringAsFixed(1)} KB)');
  });

  test('generateVisitFeedbackJpeg produces valid JPEG file with 9PSB address fields and corrected signatures', () async {
    final result = await generateVisitFeedbackJpeg(
      'ADEOLU OLUWASEUN',
      '14 Marina Street, Lagos Island, Lagos',
      null,
      DateTime(2026, 5, 29),
      null,
      'Akinwole Oluleye',
      'Abayomi IPADEOLA',
      'Near City Hall, Marina',
      'Marina Bus Stop',
      'TotalEnergies Filling Station',
      'City Hall Complex',
      '14',
      'Cream and brown two-storey duplex with black gate',
      'From Marina Bus Stop, proceed straight along Marina Street past TotalEnergies Filling Station',
    );

    expect(result.bytes, isNotNull);
    expect(result.bytes!.isNotEmpty, isTrue);
    expect(result.name?.endsWith('.jpg'), isTrue);

    // Verify JPEG SOI marker (0xFF, 0xD8, 0xFF)
    expect(result.bytes![0], equals(0xFF));
    expect(result.bytes![1], equals(0xD8));
    expect(result.bytes![2], equals(0xFF));

    File('build/test_output.jpg').writeAsBytesSync(result.bytes!);
    expect(result.bytes!.length, greaterThan(10 * 1024));
    expect(result.bytes!.length, lessThanOrEqualTo(150 * 1024));
    print(
        'Generated JPEG size: ${result.bytes!.length} bytes (~${(result.bytes!.length / 1024).toStringAsFixed(2)} KB)');
  });
}
