import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:streetpay/backend/api_requests/api_calls.dart';
import 'package:streetpay/custom_code/actions/generate_visit_feedback_jpeg.dart';
import 'package:streetpay/flutter_flow/uploaded_file.dart';
import 'package:streetpay/services/image_compress_service.dart';
import 'package:streetpay/services/kyc_draft_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tier 3 Key 11000 & 4-Parameter API Tests', () {
    test('Proof of address preserves actual verification size and image format', () async {
      // Create a genuine 1024x1448 JPEG image at actual size
      final testImg = img.Image(width: 1024, height: 1448);
      img.fill(testImg, color: img.ColorRgb8(255, 255, 255));
      img.drawString(testImg, 'STREETPAY ADDRESS VERIFICATION', font: img.arial24, x: 50, y: 50);
      final uncompressedBytes = Uint8List.fromList(img.encodeJpg(testImg, quality: 92));

      final uncompressedFile = FFUploadedFile(
        name: 'proof_of_address.jpg',
        bytes: uncompressedBytes,
      );

      final processed = await ImageCompressService.compressUploadedFile(
        uncompressedFile,
      );

      expect(processed.bytes, isNotNull);
      expect(ImageCompressService.isJpeg(processed.bytes), isTrue);
      // Decoded image should maintain actual full resolution (1024x1448) with zero blur
      final decoded = img.decodeImage(processed.bytes!);
      expect(decoded, isNotNull);
      expect(decoded!.width, 1024);
      expect(decoded.height, 1448);
      expect(processed.name?.endsWith('.jpg'), isTrue);
    });

    test('Proof of address automatically converts PDF document to valid image at actual size', () async {
      final fakePdfBytes = Uint8List.fromList([
        0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E, 0x35, // %PDF-1.5
        ...List.filled(2000, 0x41),
      ]);

      final pdfFile = FFUploadedFile(
        name: 'customer_bill.pdf',
        bytes: fakePdfBytes,
      );

      expect(ImageCompressService.isPdf(pdfFile.bytes, pdfFile.name), isTrue);

      final converted = await ImageCompressService.compressUploadedFile(
        pdfFile,
      );

      expect(converted.bytes, isNotNull);
      expect(ImageCompressService.isJpeg(converted.bytes) || ImageCompressService.isPng(converted.bytes), isTrue);
      expect(ImageCompressService.isPdf(converted.bytes, converted.name), isFalse);
    });

    test('Non-proof document compresses to within 150 KB and not less than 100 KB', () async {
      // Create a genuine ~350KB test document
      final testImg = img.Image(width: 1000, height: 1000);
      img.fill(testImg, color: img.ColorRgb8(245, 245, 245));
      for (int i = 0; i < 25; i++) {
        img.drawString(testImg, 'STREETPAY VERIFICATION TEST DOCUMENT $i',
            font: img.arial24, x: 30, y: 30 + (i * 38), color: img.ColorRgb8(10, 20, 30));
        img.drawCircle(testImg, x: 200 + (i * 25), y: 250 + (i * 25), radius: 50 + i, color: img.ColorRgb8(i * 9, 140, 180));
      }
      final largeBytes = Uint8List.fromList(img.encodeJpg(testImg, quality: 98));
      expect(largeBytes.length, greaterThan(150 * 1024));

      final largeNonProofFile = FFUploadedFile(
        name: 'user_selfie.jpg',
        bytes: largeBytes,
      );

      final processed = await ImageCompressService.compressUploadedFile(
        largeNonProofFile,
        maxSizeKB: 150,
        minSizeKB: 100,
        isProof: false,
      );

      expect(processed.bytes, isNotNull);
      // Confirmed within 150 KB max and not less than 100 KB min
      expect(processed.bytes!.length, lessThanOrEqualTo(150 * 1024));
      expect(processed.bytes!.length, greaterThanOrEqualTo(100 * 1024));
    });

    test('UpgradetotierthreeCall helper extracts message and success correctly', () {
      final successPayload = {
        'Success': true,
        'Message': 'Tier 3 upgrade submitted successfully for review',
      };

      expect(UpgradetotierthreeCall.success(successPayload), isTrue);
      expect(UpgradetotierthreeCall.status(successPayload), isTrue);
      expect(
        UpgradetotierthreeCall.message(successPayload),
        'Tier 3 upgrade submitted successfully for review',
      );

      final failPayload = {
        'Success': false,
        'Message': 'Bvn Validation Not successful (NIN details retrieval failure)',
      };

      expect(UpgradetotierthreeCall.success(failPayload), isFalse);
      expect(UpgradetotierthreeCall.status(failPayload), isFalse);
      expect(
        UpgradetotierthreeCall.message(failPayload),
        'Bvn Validation Not successful (NIN details retrieval failure)',
      );
    });

    test('ApiCallResponse isSuccessful and responseMessage handle various backend patterns', () {
      const r1 = ApiCallResponse(
        {'Success': false, 'Message': 'Missing required field(s): proofOfAddressVerification'},
        {},
        200,
      );
      expect(r1.isSuccessful, isFalse);
      expect(r1.responseMessage, 'Missing required field(s): proofOfAddressVerification');

      const r2 = ApiCallResponse(
        {'Success': true, 'message': 'Account upgraded successfully'},
        {},
        200,
      );
      expect(r2.isSuccessful, isTrue);
      expect(r2.responseMessage, 'Account upgraded successfully');

      const r3 = ApiCallResponse(
        {'IsValid': false, 'Message': 'Invalid session token'},
        {},
        200,
      );
      expect(r3.isSuccessful, isFalse);
      expect(r3.responseMessage, 'Invalid session token');
    });

    test('generateVisitFeedbackJpeg properly handles long address without errors and creates non-empty image', () async {
      final file = await generateVisitFeedbackJpeg(
        'JOHN DOE ADEREMI',
        'Plot 14B Admiralty Way, Beside Zenith Bank, Lekki Phase 1, Eti-Osa Local Government Area, Lagos State, Nigeria',
        'Two-storey modern duplex painted white and grey with black automated gate',
        DateTime.now().subtract(const Duration(days: 1)),
        null,
        'Akinwole Oluleye',
        'Abayomi IPADEOLA',
        'Opposite Central Mosque, adjacent to main roundabout',
      );

      expect(file.bytes, isNotNull);
      expect(file.bytes!.isNotEmpty, isTrue);
      expect(file.name?.endsWith('.jpg') ?? false, isTrue);
    });

    test('generateVisitFeedbackJpeg auto-generates description as part of verification form when no description is passed in tab', () async {
      // Simulates when description is not a field in the tab: null residentialDescription & null landmark
      final file = await generateVisitFeedbackJpeg(
        'CHUKWUEMEKA OBI',
        '15 Adeola Odeku Street, Victoria Island, Eti-Osa LGA, Lagos State',
        null,
        DateTime.now().subtract(const Duration(days: 2)),
        null,
        'Akinwole Oluleye',
        'Abayomi IPADEOLA',
        null,
      );

      expect(file.bytes, isNotNull);
      expect(file.bytes!.isNotEmpty, isTrue);
      final decoded = img.decodeImage(file.bytes!);
      expect(decoded, isNotNull);
      expect(decoded!.width, 1024);
      expect(decoded.height, 1448);
    });

    test('UpgradetotierthreeCall rejects request without backend call when proof of address is not generated', () async {
      // Even if utility bill is uploaded, do NOT bypass missing proof of address
      final response = await UpgradetotierthreeCall.call(
        accountNumber: '1100767497',
        bvn: '22534258964',
        nin: '12345678901',
        proofofaddress: null,
        utilityBill: FFUploadedFile(
          name: 'utility_bill.jpg',
          bytes: Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0]),
        ),
      );

      expect(response.isSuccessful, isFalse);
      expect(response.statusCode, 400);
      expect(
        UpgradetotierthreeCall.message(response.jsonBody),
        'Proof of address has not been generated. Please provide or generate proof of address to proceed.',
      );
    });

    test('UpgradetotierthreeCall rejects request when proof of address has empty bytes', () async {
      final response = await UpgradetotierthreeCall.call(
        accountNumber: '1100767497',
        bvn: '22534258964',
        nin: '12345678901',
        proofofaddress: FFUploadedFile(
          name: 'empty_proof.jpg',
          bytes: Uint8List(0),
        ),
      );

      expect(response.isSuccessful, isFalse);
      expect(response.statusCode, 400);
      expect(
        UpgradetotierthreeCall.message(response.jsonBody),
        'Proof of address has not been generated. Please provide or generate proof of address to proceed.',
      );
    });

    test('generateVisitFeedbackJpeg properly integrates closest landmark and generates valid proof of address image', () async {
      final file = await generateVisitFeedbackJpeg(
        'JOHN DOE ADEREMI',
        'Plot 14B Admiralty Way, Lekki Phase 1, Eti-Osa LGA, Lagos State',
        null,
        DateTime.now().subtract(const Duration(days: 1)),
        null,
        'Akinwole Oluleye',
        'Abayomi IPADEOLA',
        'Opposite Central Mosque, adjacent to main roundabout',
      );

      expect(file.bytes, isNotNull);
      expect(file.bytes!.isNotEmpty, isTrue);
      final decoded = img.decodeImage(file.bytes!);
      expect(decoded, isNotNull);
      expect(decoded!.width, 1024);
      expect(decoded.height, 1448);
    });

    test('KycDraftData serializes and deserializes landmark correctly', () {
      final draft = KycDraftData(
        nin: '12345678901',
        bvn: '22345678901',
        street: 'Adetokunbo Ademola Street',
        city: 'Victoria Island',
        state: 'Lagos',
        lga: 'Eti-Osa',
        landmark: 'Opposite Eko Hotel Roundabout',
      );

      final json = draft.toJson();
      expect(json['landmark'], 'Opposite Eko Hotel Roundabout');

      final reconstructed = KycDraftData.fromJson(json);
      expect(reconstructed.landmark, 'Opposite Eko Hotel Roundabout');
    });

    test('UpgradetotierthreeCall.sanitizeLandmark extracts concise landmark from overlong narrative', () {
      const longNarrative =
          'Starting from July Seven Petrol Station, proceed forward along the main access road past the petrol station, continuing straight down the street until reaching a prominent T-junction, where you make a right turn onto Road 10, Ifelodun Community, Agunbelewo Area in Osogbo, Osun State, then advance past the first three structures while counting the properties until arriving at the fourth building which is House number 8, situated in close proximity to the Speaker of House of Assembly House, featuring a distinct cream and chocolate exterior color scheme and structural finish, confirming the precise location as described in the customer records.';

      final sanitized = UpgradetotierthreeCall.sanitizeLandmark(longNarrative);
      expect(sanitized, 'July Seven Petrol Station');
      expect(sanitized.length, lessThanOrEqualTo(60));

      expect(UpgradetotierthreeCall.sanitizeLandmark('Opposite Eko Hotel'), 'Opposite Eko Hotel');
      expect(UpgradetotierthreeCall.sanitizeLandmark(null), '');
      expect(UpgradetotierthreeCall.sanitizeLandmark('   '), '');
    });
  });
}
