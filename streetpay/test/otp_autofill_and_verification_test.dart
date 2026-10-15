import 'package:flutter_test/flutter_test.dart';
import 'package:streetpay/flutter_flow/custom_functions.dart' as functions;

void main() {
  String? extractOtp(String text) {
    if (text.isEmpty) return null;
    final sixDigit = RegExp(r'\b(\d{6})\b').firstMatch(text);
    if (sixDigit != null) return sixDigit.group(1);

    final tagged = RegExp(
      r'(?:otp|code|pin|verification)\D{0,6}(\d{4,6})',
      caseSensitive: false,
    ).firstMatch(text);
    if (tagged != null) return tagged.group(1);

    final splitDigits = RegExp(r'\b(\d{3})\s*[- ]\s*(\d{3})\b').firstMatch(text);
    if (splitDigits != null) return '${splitDigits.group(1)}${splitDigits.group(2)}';

    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 6) return digits;

    return null;
  }

  group('OTP SMS Autofill & Parsing Logic Tests', () {
    test('Extracts 6-digit OTP from standard SMS body', () {
      const sms =
          'Your StreetPay verification code is 492015. Valid for 10 minutes.';
      expect(extractOtp(sms), equals('492015'));
    });

    test('Extracts 6-digit OTP from Android SMS Retriever formatted message', () {
      const sms = '<#> 123456 is your StreetPay code\nFA+9qCX9VSu';
      expect(extractOtp(sms), equals('123456'));
    });

    test('Extracts 6-digit OTP from bank/gateway prompt', () {
      const sms =
          'DO NOT DISCLOSE. Use OTP: 837192 to authenticate your StreetPay request.';
      expect(extractOtp(sms), equals('837192'));
    });

    test('Extracts raw 6-digit string from autofill payload', () {
      const rawCode = '719304';
      expect(extractOtp(rawCode), equals('719304'));
    });

    test('Ignores text without a 6-digit code', () {
      const sms = 'Welcome to StreetPay! Visit streetpay.com for more info.';
      expect(extractOtp(sms), isNull);
    });

    test(
        'Does not incorrectly match phone numbers (11 digits) as 6-digit OTP',
        () {
      const smsWithPhone =
          'Call customer care at 08012345678 for assistance';
      expect(extractOtp(smsWithPhone), isNull);
    });

    test(
        'Extracts 6-digit OTP even when preceded or followed by punctuation',
        () {
      const sms = 'Your security code is [654321]. Do not share.';
      expect(extractOtp(sms), equals('654321'));
    });

    test('Extracts OTP from Termii / Africa Talking multi-line template', () {
      const sms =
          'StreetPay OTP Verification\nYour verification code is 884102.\nExpires in 5 minutes.\nDo not share.';
      expect(extractOtp(sms), equals('884102'));
    });

    test('Extracts OTP from 9PSB bank gateway alert format', () {
      const sms =
          '9PSB: 301948 is your authorization OTP for StreetPay wallet creation. Ref: TXN98124.';
      expect(extractOtp(sms), equals('301948'));
    });
  });

  group('Password Reset OTP Specific Extraction Tests', () {
    test('Extracts OTP from password reset SMS with period', () {
      const sms = 'Your StreetPay password reset code is 492015. Do not share.';
      expect(extractOtp(sms), equals('492015'));
    });

    test('Extracts OTP from tagged password reset SMS format', () {
      const sms =
          'StreetPay: Use reset code 789123 to complete your password change.';
      expect(extractOtp(sms), equals('789123'));
    });

    test('Extracts hyphen-split OTP code e.g. 654-321', () {
      const sms = 'Your StreetPay password reset OTP is 654-321.';
      expect(extractOtp(sms), equals('654321'));
    });

    test('Extracts space-split OTP code e.g. 654 321', () {
      const sms = 'Reset code: 654 321. Valid for 10 minutes.';
      expect(extractOtp(sms), equals('654321'));
    });

    test('Extracts OTP from clipboard copied text with whitespace', () {
      const clipboard = '  889900  \n';
      expect(extractOtp(clipboard), equals('889900'));
    });
  });

  group('Phone Number Sanitization for OTP API Calls', () {
    test('Cleans international +234 prefix for backend calls', () {
      const phone = '+2348012345678';
      final cleaned = functions.removecode(phone);
      expect(cleaned, isNotNull);
      expect(cleaned!.startsWith('+234'), isFalse);
    });

    test('Handles already clean 11-digit local phone', () {
      const phone = '08012345678';
      final cleaned = functions.removecode(phone) ?? phone;
      expect(cleaned, isNotEmpty);
    });
  });

  group('OTP UI Box State Determination Tests', () {
    String getBorderType(int index, String currentOtp) {
      if (index == currentOtp.length) return 'active';
      if (index < currentOtp.length) return 'filled';
      return 'empty';
    }

    test('Correctly highlights box 0 when OTP is empty', () {
      expect(getBorderType(0, ''), equals('active'));
      expect(getBorderType(1, ''), equals('empty'));
      expect(getBorderType(5, ''), equals('empty'));
    });

    test('Correctly marks boxes 0-2 as filled and box 3 as active', () {
      const currentOtp = '123';
      expect(getBorderType(0, currentOtp), equals('filled'));
      expect(getBorderType(1, currentOtp), equals('filled'));
      expect(getBorderType(2, currentOtp), equals('filled'));
      expect(getBorderType(3, currentOtp), equals('active'));
      expect(getBorderType(4, currentOtp), equals('empty'));
    });

    test('Correctly marks all boxes filled when OTP has 6 digits', () {
      const currentOtp = '123456';
      for (var i = 0; i < 6; i++) {
        expect(getBorderType(i, currentOtp), equals('filled'));
      }
    });
  });
}
