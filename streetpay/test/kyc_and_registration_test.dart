import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:streetpay/pages/onboarding/sign_up/sign_up_widget.dart';
import 'package:streetpay/kycpaggge/kycpaggge_widget.dart';
import 'package:streetpay/flutter_flow/flutter_flow_util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SignUpWidget displays both BVN and NIN inputs without selection toggle',
      (WidgetTester tester) async {
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
          home: SignUpWidget(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify that both BVN and NIN labels are present
    expect(find.text('BANK VERIFICATION NUMBER (BVN)'), findsOneWidget);
    expect(find.text('NATIONAL IDENTITY NUMBER (NIN)'), findsOneWidget);
    expect(find.text('Dual Identity Verification'), findsOneWidget);

    // Verify that the old 'REGISTER WITH' radio header is NOT present
    expect(find.text('REGISTER WITH'), findsNothing);
    expect(find.text('Bank number · fastest match'), findsNothing);
    expect(find.text('National ID slip number'), findsNothing);
  });

  testWidgets('KycpagggeWidget renders Tier 2 and Tier 3 tabs with seamless switcher',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final appState = FFAppState();
    appState.tier = '1';

    await tester.pumpWidget(
      ChangeNotifierProvider<FFAppState>.value(
        value: appState,
        child: const MaterialApp(
          home: KycpagggeWidget(targetTier: '2'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify header and switcher
    expect(find.text('Account Upgrade'), findsWidgets);
    expect(find.text('Tier 2 Upgrade'), findsOneWidget);
    expect(find.text('Tier 3 Upgrade'), findsOneWidget);

    // Verify the single, clear action button is present instead of legacy buttons
    expect(find.text('Submit Tier 2 Upgrade'), findsOneWidget);
    expect(find.text('Upgrade tier 2 (Click First)'), findsNothing);
    expect(find.text('Upgrade tier 3 (Click Next)'), findsNothing);

    // Tap Tier 3 tab
    await tester.tap(find.text('Tier 3 Upgrade'));
    await tester.pumpAndSettle();

    // Verify that button switches contextually to Submit Tier 3 Upgrade
    expect(find.text('Submit Tier 3 Upgrade'), findsOneWidget);
  });

  testWidgets('KycpagggeWidget keeps UI clean with silent background proof generation',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final appState = FFAppState();
    appState.tier = '1';

    await tester.pumpWidget(
      ChangeNotifierProvider<FFAppState>.value(
        value: appState,
        child: const MaterialApp(
          home: KycpagggeWidget(targetTier: '2'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify debug inspector, manual proof card, and AI polish button are NOT in customer view
    expect(find.text('API Call Body & Debug Inspector'), findsNothing);
    expect(find.text('✨ AI Generate & Polish Description for 9PSB'), findsNothing);
    expect(find.text('Generate Proof'), findsNothing);
    expect(find.text('Submit Tier 2 Upgrade'), findsOneWidget);

    // Switch to Tier 3 tab
    await tester.tap(find.text('Tier 3 Upgrade'));
    await tester.pumpAndSettle();

    // Verify UI remains clean in Tier 3 as well
    expect(find.text('API Call Body & Debug Inspector'), findsNothing);
    expect(find.text('✨ AI Generate & Polish Description for 9PSB'), findsNothing);
    expect(find.text('Generate Proof'), findsNothing);
    expect(find.text('Submit Tier 3 Upgrade'), findsOneWidget);
  });
}
