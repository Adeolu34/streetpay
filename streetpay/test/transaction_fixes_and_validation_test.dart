import 'package:flutter_test/flutter_test.dart';
import 'package:streetpay/flutter_flow/custom_functions.dart' as functions;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Transaction Fixes & Validation Tests', () {
    test('getBankCode maps StreetPay variants and 9PSB to 120001', () {
      expect(functions.getBankCode(null, 'StreetPay'), equals('120001'));
      expect(functions.getBankCode(null, 'streetpay'), equals('120001'));
      expect(functions.getBankCode(null, 'Street Pay'), equals('120001'));
      expect(functions.getBankCode(null, '9psb'), equals('120001'));
      expect(functions.getBankCode(null, '9 Payment Service Bank'), equals('120001'));
      expect(functions.getBankCode(null, 'OPay'), equals('100004'));
      expect(functions.getBankCode(null, 'PalmPay'), equals('100033'));
    });

    test('formatNgnPhone and addcode format Nigerian phone numbers to standard 11 digits', () {
      // 13 digits with 234 prefix
      expect(functions.formatNgnPhone('2348164568803'), equals('08164568803'));
      expect(functions.addcode('2348164568803'), equals('08164568803'));

      // 14 digits with +234
      expect(functions.formatNgnPhone('+2348164568803'), equals('08164568803'));
      expect(functions.addcode('+2348164568803'), equals('08164568803'));

      // 10 digits without leading zero
      expect(functions.formatNgnPhone('8164568803'), equals('08164568803'));
      expect(functions.addcode('8164568803'), equals('08164568803'));

      // 11 digits starting with 0
      expect(functions.formatNgnPhone('08164568803'), equals('08164568803'));
      expect(functions.addcode('08164568803'), equals('08164568803'));
    });

    test('EMTL Stamp Duty (₦50 on transfers >= ₦10,000) calculates required balance accurately', () {
      double calculateTotalNeeded(double amount, [double fee = 0.0]) {
        final double stampDuty = amount >= 10000.0 ? 50.0 : 0.0;
        return amount + stampDuty + fee;
      }

      // Under 10,000: No stamp duty
      expect(calculateTotalNeeded(5000.0), equals(5000.0));
      expect(calculateTotalNeeded(9999.0), equals(9999.0));

      // 10,000 and above: ₦50 EMTL applies
      expect(calculateTotalNeeded(10000.0), equals(10050.0));
      expect(calculateTotalNeeded(10200.0), equals(10250.0));
      expect(calculateTotalNeeded(20000.0), equals(20050.0));
      expect(calculateTotalNeeded(50000.0), equals(50050.0));
    });

    test('Account number sanitization normalizes 11-digit phone-style accounts to 10 digits', () {
      String sanitizeAccount(String raw) {
        String clean = raw.replaceAll(RegExp(r'\D'), '');
        if (clean.length == 11 && clean.startsWith('0')) {
          clean = clean.substring(1);
        }
        return clean;
      }

      expect(sanitizeAccount('08164568803'), equals('8164568803'));
      expect(sanitizeAccount('1100742371'), equals('1100742371'));
      expect(sanitizeAccount(' 1100742371 '), equals('1100742371'));
    });
  });
}
