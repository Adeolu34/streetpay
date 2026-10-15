import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streetpay/services/biller_beneficiary_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('BillerBeneficiaryService Tests', () {
    test('Saves and retrieves biller beneficiaries by category', () async {
      await BillerBeneficiaryService.saveBeneficiary(
        category: 'electricity',
        billerName: 'EKEDC (Eko)',
        customerId: '04123456789',
        customerName: 'EMMANUEL CHUKWU',
        packageType: 'Prepaid',
        lastAmount: '5000',
      );

      await BillerBeneficiaryService.saveBeneficiary(
        category: 'cabletv',
        billerName: 'DSTV',
        customerId: '1023456789',
        customerName: 'JANE DOE',
        packageType: 'DStv Compact',
        lastAmount: '12500',
      );

      final electricList =
          await BillerBeneficiaryService.getBeneficiaries('electricity');
      final cableList =
          await BillerBeneficiaryService.getBeneficiaries('cabletv');

      expect(electricList.length, equals(1));
      expect(electricList[0].billerName, equals('EKEDC (Eko)'));
      expect(electricList[0].customerId, equals('04123456789'));
      expect(electricList[0].customerName, equals('EMMANUEL CHUKWU'));
      expect(electricList[0].packageType, equals('Prepaid'));
      expect(electricList[0].lastAmount, equals('5000'));

      expect(cableList.length, equals(1));
      expect(cableList[0].billerName, equals('DSTV'));
      expect(cableList[0].customerId, equals('1023456789'));
      expect(cableList[0].customerName, equals('JANE DOE'));
      expect(cableList[0].initials, equals('JD'));
    });

    test('Deduplicates and moves existing beneficiary to top', () async {
      await BillerBeneficiaryService.saveBeneficiary(
        category: 'betting',
        billerName: 'Bet9ja',
        customerId: 'BET1001',
        lastAmount: '1000',
      );

      await BillerBeneficiaryService.saveBeneficiary(
        category: 'betting',
        billerName: 'SportyBet',
        customerId: 'SPORTY2002',
        lastAmount: '2000',
      );

      // Re-save Bet9ja with updated amount
      await BillerBeneficiaryService.saveBeneficiary(
        category: 'betting',
        billerName: 'Bet9ja',
        customerId: 'BET1001',
        lastAmount: '3500',
      );

      final bettingList =
          await BillerBeneficiaryService.getBeneficiaries('betting');
      expect(bettingList.length, equals(2));
      expect(bettingList[0].billerName, equals('Bet9ja'));
      expect(bettingList[0].lastAmount, equals('3500'));
      expect(bettingList[1].billerName, equals('SportyBet'));
    });

    test('Deletes a saved biller beneficiary', () async {
      await BillerBeneficiaryService.saveBeneficiary(
        category: 'electricity',
        billerName: 'IKEDC (Ikeja)',
        customerId: '0101010101',
      );

      final beforeDelete =
          await BillerBeneficiaryService.getBeneficiaries('electricity');
      expect(beforeDelete.length, equals(1));

      await BillerBeneficiaryService.deleteBeneficiary(
        'electricity',
        '0101010101',
        'IKEDC (Ikeja)',
      );

      final afterDelete =
          await BillerBeneficiaryService.getBeneficiaries('electricity');
      expect(afterDelete.isEmpty, isTrue);
    });
  });
}
