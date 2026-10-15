import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:streetpay/flutter_flow/flutter_flow_util.dart';
import 'package:streetpay/openwallet/openwallet_widget.dart';

void main() {
  test('OpenwalletModel validates 11 digits for both NIN and BVN', () {
    final model = OpenwalletModel();
    final context = _MockBuildContext();

    // Init state
    model.initState(context);

    // NIN Validation
    expect(model.textControllerNINValidator!(context, ''), equals('NIN is required'));
    expect(model.textControllerNINValidator!(context, '12345'), equals('NIN must be exactly 11 digits'));
    expect(model.textControllerNINValidator!(context, '123456789012'), equals('NIN must be exactly 11 digits'));
    expect(model.textControllerNINValidator!(context, '1234567890a'), equals('NIN must be exactly 11 digits'));
    expect(model.textControllerNINValidator!(context, '12345678901'), isNull);

    // BVN Validation
    expect(model.textControllerBVNValidator!(context, ''), equals('BVN is required'));
    expect(model.textControllerBVNValidator!(context, '12345'), equals('BVN must be exactly 11 digits'));
    expect(model.textControllerBVNValidator!(context, '123456789012'), equals('BVN must be exactly 11 digits'));
    expect(model.textControllerBVNValidator!(context, '12345678901'), isNull);

    // First Name & Last Name
    expect(model.textController1Validator!(context, ''), equals('First Name is required'));
    expect(model.textController1Validator!(context, 'John'), isNull);
    expect(model.textController2Validator!(context, ''), equals('Last Name is required'));
    expect(model.textController2Validator!(context, 'Doe'), isNull);
  });

  testWidgets('OpenwalletWidget renders both NIN and BVN fields with verification CTA',
      (WidgetTester tester) async {
    // Set screen size
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final appState = FFAppState();

    await tester.pumpWidget(
      ChangeNotifierProvider<FFAppState>.value(
        value: appState,
        child: const MaterialApp(
          home: OpenwalletWidget(
            openwith: 'BVN',
            phone: '08012345678',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Title & Step Badge
    expect(find.text('Open Wallet'), findsOneWidget);
    expect(find.text('Step 2 of 2'), findsOneWidget);

    // Verify Personal Info section
    expect(find.text('PERSONAL INFORMATION'), findsOneWidget);
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name (Surname)'), findsOneWidget);

    // Verify Identity Verification (NIN & BVN) section
    expect(find.text('IDENTITY VERIFICATION (NIN & BVN)'), findsOneWidget);
    expect(find.text('National Identity Number (NIN)'), findsOneWidget);
    expect(find.text('Bank Verification Number (BVN)'), findsOneWidget);

    // Verify CTA button
    expect(find.text('Verify & Open Wallet'), findsOneWidget);
  });
}

class _MockBuildContext extends Fake implements BuildContext {}
