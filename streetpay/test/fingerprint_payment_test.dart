import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streetpay/app_state.dart';
import 'package:streetpay/custom_code/actions/generateseesionid.dart';
import 'package:streetpay/components/paymentpinverifybill_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async => null,
    );
  });

  group('Fingerprint Payment Authorization Tests', () {
    test('generateseesionid returns non-empty SP- prefixed session ID for biometric verification', () async {
      final sessionId = await generateseesionid();
      expect(sessionId, isNotEmpty);
      expect(sessionId.startsWith('SP-'), isTrue);
    });

    test('FFAppState biometric state updates accurately', () {
      FFAppState().biometric = true;
      expect(FFAppState().biometric, isTrue);

      FFAppState().biometric = false;
      expect(FFAppState().biometric, isFalse);

      FFAppState().biometric = true;
    });

    testWidgets('PaymentpinverifybillWidget renders biometric fingerprint icon when biometric is enabled', (tester) async {
      FFAppState().biometric = true;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaymentpinverifybillWidget(),
          ),
        ),
      );

      // Verify the modal UI elements render
      expect(find.text('Enter Transaction PIN'), findsOneWidget);
      expect(find.text('Authorize utility bill payment'), findsOneWidget);
      expect(find.byIcon(Icons.fingerprint_rounded), findsOneWidget);
    });
  });
}
