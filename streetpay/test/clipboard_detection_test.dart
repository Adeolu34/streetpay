import 'package:flutter_test/flutter_test.dart';
import 'package:streetpay/services/clipboard_detection_service.dart';

void main() {
  setUp(() {
    ClipboardDetectionService.clearSuppression();
  });

  group('ClipboardDetectionService Tests', () {
    test('Extracts exact 10-digit NUBAN numbers', () async {
      final detected =
          await ClipboardDetectionService.checkClipboardForAccountNumber(
        testTextOverride: '0123456789',
      );
      expect(detected, equals('0123456789'));
    });

    test('Extracts 10-digit number surrounded by contextual text', () async {
      final detected =
          await ClipboardDetectionService.checkClipboardForAccountNumber(
        testTextOverride: 'Kindly pay to 0987654321 GTBank Thank you',
      );
      expect(detected, equals('0987654321'));
    });

    test('Ignores phone numbers (11 digits) or short codes', () async {
      final detected =
          await ClipboardDetectionService.checkClipboardForAccountNumber(
        testTextOverride: '08012345678',
      );
      expect(detected, isNull);
    });

    test('Suppresses account numbers once dismissed', () async {
      final firstCheck =
          await ClipboardDetectionService.checkClipboardForAccountNumber(
        testTextOverride: '2233445566',
      );
      expect(firstCheck, equals('2233445566'));

      ClipboardDetectionService.suppress('2233445566');

      final secondCheck =
          await ClipboardDetectionService.checkClipboardForAccountNumber(
        testTextOverride: '2233445566',
      );
      expect(secondCheck, isNull);
    });

    test('Ignores current user own account number', () async {
      final detected =
          await ClipboardDetectionService.checkClipboardForAccountNumber(
        testTextOverride: '5566778899',
        currentAccountNo: '5566778899',
      );
      expect(detected, isNull);
    });
  });
}
