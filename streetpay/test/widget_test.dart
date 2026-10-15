import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streetpay/components/recent_beneficiaries_widget.dart';
import 'package:streetpay/custom_code/inactivity_service.dart';
import 'package:streetpay/services/beneficiary_service.dart';
import 'package:streetpay/services/kyc_draft_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    InactivityService().stopTracking();
  });

  group('BeneficiaryService Tests', () {
    test('BeneficiaryItem serialization and initials', () {
      final item = BeneficiaryItem(
        accountName: 'John Doe',
        accountNumber: '0123456789',
        bankName: 'Access Bank',
        bankCode: '044',
      );

      expect(item.initials, 'JD');

      final json = item.toJson();
      final restored = BeneficiaryItem.fromJson(json);

      expect(restored.accountName, 'John Doe');
      expect(restored.accountNumber, '0123456789');
      expect(restored.bankName, 'Access Bank');
      expect(restored.bankCode, '044');
    });

    test('BeneficiaryService save and retrieve', () async {
      await BeneficiaryService.saveBeneficiary(
        accountName: 'Jane Smith',
        accountNumber: '9876543210',
        bankName: 'GTBank',
      );

      final list = await BeneficiaryService.getRecentBeneficiaries();
      expect(list.length, 1);
      expect(list.first.accountName, 'Jane Smith');
      expect(list.first.accountNumber, '9876543210');
      expect(list.first.bankName, 'GTBank');
    });

    test('BeneficiaryService deduplication', () async {
      await BeneficiaryService.saveBeneficiary(
        accountName: 'Jane Smith',
        accountNumber: '9876543210',
        bankName: 'GTBank',
      );

      // Save same recipient again with updated name
      await BeneficiaryService.saveBeneficiary(
        accountName: 'Jane Smith Updated',
        accountNumber: '9876543210',
        bankName: 'GTBank',
      );

      final list = await BeneficiaryService.getRecentBeneficiaries();
      expect(list.length, 1);
      expect(list.first.accountName, 'Jane Smith Updated');
    });
  });

  group('KycDraftService Tests', () {
    test('KycDraftData empty and non-empty check', () {
      final emptyDraft = KycDraftData();
      expect(emptyDraft.isEmpty, true);

      final filledDraft = KycDraftData(
        nin: '12345678901',
        city: 'Lagos',
        state: 'Lagos State',
      );
      expect(filledDraft.isNotEmpty, true);
    });

    test('KycDraftService save, retrieve, and clear', () async {
      await KycDraftService.saveDraft(
        nin: '11122233344',
        bvn: '22233344455',
        city: 'Ikeja',
        street: 'Allen Avenue',
        houseNumber: '12',
        state: 'Lagos',
        lga: 'Ikeja',
      );

      final retrieved = await KycDraftService.getDraft();
      expect(retrieved, isNotNull);
      expect(retrieved!.nin, '11122233344');
      expect(retrieved.bvn, '22233344455');
      expect(retrieved.city, 'Ikeja');
      expect(retrieved.street, 'Allen Avenue');

      await KycDraftService.clearDraft();
      final cleared = await KycDraftService.getDraft();
      expect(cleared, isNull);
    });
  });

  testWidgets('RecentBeneficiariesWidget renders properly in MaterialApp', (WidgetTester tester) async {
    await BeneficiaryService.saveBeneficiary(
      accountName: 'Test Beneficiary',
      accountNumber: '1234567890',
      bankName: 'Test Bank',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecentBeneficiariesWidget(
            onSelect: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Recent Beneficiaries'), findsOneWidget);
    expect(find.text('Test'), findsOneWidget);
  });
}
