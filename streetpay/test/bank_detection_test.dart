import 'package:flutter_test/flutter_test.dart';
import 'package:streetpay/services/bank_detection_service.dart';

void main() {
  group('BankDetectionService - CBN NUBAN Checksum Validation', () {
    test('Calculates and validates CBN NUBAN check digit correctly', () {
      // CBN formula:
      // Weight vector: [3, 7, 3, 3, 7, 3, 3, 7, 3, 3, 7, 3]
      // Bank code: GTBank ("058")
      // First 9 digits: "012345678"
      // Sum:
      // 0*3 + 5*7 + 8*3 = 0 + 35 + 24 = 59
      // + 0*3 + 1*7 + 2*3 + 3*3 + 4*7 + 5*3 + 6*3 + 7*7 + 8*3
      // = 59 + 0 + 7 + 6 + 9 + 28 + 15 + 18 + 49 + 24 = 215
      // 215 % 10 = 5 -> (10 - 5) % 10 = 5
      // Expected 10th check digit is '5'
      const validGtAccount = '0123456785';
      const invalidGtAccount = '0123456789';

      expect(BankDetectionService.isNubanValid(validGtAccount, '058'), isTrue);
      expect(BankDetectionService.isNubanValid(invalidGtAccount, '058'), isFalse);
    });

    test('Access Bank (CBN code 044) check digit verification', () {
      // Access Bank ("044")
      // First 9 digits: "000000001"
      // Sum:
      // 0*3 + 4*7 + 4*3 = 0 + 28 + 12 = 40
      // 0..0 + 1*3 = 3
      // Total sum = 43 -> 43 % 10 = 3 -> (10 - 3) % 10 = 7
      // Expected check digit is '7'
      const validAccessAccount = '0000000017';
      const invalidAccessAccount = '0000000018';

      expect(BankDetectionService.isNubanValid(validAccessAccount, '044'), isTrue);
      expect(BankDetectionService.isNubanValid(invalidAccessAccount, '044'), isFalse);
    });

    test('Rejects non-10-digit strings and malformed bank codes', () {
      expect(BankDetectionService.isNubanValid('12345', '058'), isFalse);
      expect(BankDetectionService.isNubanValid('12345678901', '058'), isFalse);
      expect(BankDetectionService.isNubanValid('abcdefghij', '058'), isFalse);
      expect(BankDetectionService.isNubanValid('0123456785', ''), isFalse);
    });
  });

  group('BankDetectionService - Nigerian Mobile Phone Detection', () {
    test('Identifies 10-digit phone number accounts without leading 0', () {
      expect(BankDetectionService.isNigerianPhoneNumber('8024706049'), isTrue);
      expect(BankDetectionService.isNigerianPhoneNumber('9024706049'), isTrue);
      expect(BankDetectionService.isNigerianPhoneNumber('7031234567'), isTrue);
      expect(BankDetectionService.isNigerianPhoneNumber('8109876543'), isTrue);
      expect(BankDetectionService.isNigerianPhoneNumber('9135551234'), isTrue);
      expect(BankDetectionService.isNigerianPhoneNumber('7123456789'), isTrue);
    });

    test('Rejects standard non-phone bank accounts', () {
      expect(BankDetectionService.isNigerianPhoneNumber('0123456789'), isFalse);
      expect(BankDetectionService.isNigerianPhoneNumber('2123456789'), isFalse);
      expect(BankDetectionService.isNigerianPhoneNumber('5123456789'), isFalse);
      expect(BankDetectionService.isNigerianPhoneNumber('1100767497'), isFalse);
    });
  });

  group('BankDetectionService - Candidate Prediction & Ranking', () {
    test('Prioritizes fintech phone banks for phone-based account numbers', () {
      const phoneAccount = '8024706049';
      final candidates = BankDetectionService.predictCandidateBanks(phoneAccount);

      expect(candidates, isNotEmpty);
      // Top candidate must be a fintech phone bank (OPay, PalmPay, Moniepoint)
      final topCandidate = candidates.first;
      expect(
        topCandidate.name == 'OPay' ||
            topCandidate.name == 'PalmPay' ||
            topCandidate.name.contains('Moniepoint'),
        isTrue,
      );
      expect(topCandidate.isPhoneMatch, isTrue);
    });

    test('Prioritizes GTBank for accounts matching GTBank NUBAN and prefix', () {
      // "0123456785" starts with "01" (GTBank prefix) and passes GTBank NUBAN check
      const gtAccount = '0123456785';
      final candidates = BankDetectionService.predictCandidateBanks(gtAccount);

      expect(candidates, isNotEmpty);
      final gtMatch = candidates.firstWhere((c) => c.name.contains('Guaranty Trust'));
      expect(gtMatch.isNubanMatch, isTrue);
      expect(gtMatch.score, greaterThan(80));
    });

    test('Provides normalized Map with dual-casing keys for backwards compatibility', () {
      final candidate = BankCandidate(
        name: 'Guaranty Trust Bank',
        code: '058',
        cbnCode: '058',
        score: 115,
        isNubanMatch: true,
        accountName: 'ALAGBE JOHN',
        isVerified: true,
      );

      final map = candidate.toMap();
      expect(map['bank_name'], equals('Guaranty Trust Bank'));
      expect(map['bankName'], equals('Guaranty Trust Bank'));
      expect(map['bank_code'], equals('058'));
      expect(map['bankCode'], equals('058'));
      expect(map['account_name'], equals('ALAGBE JOHN'));
      expect(map['accountName'], equals('ALAGBE JOHN'));
      expect(map['is_verified'], isTrue);
    });
  });
}
