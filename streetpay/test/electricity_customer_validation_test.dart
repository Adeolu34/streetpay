import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streetpay/flutter_flow/flutter_flow_util.dart';
import 'package:streetpay/pages/bills/billlelectricity/billlelectricity_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await FFAppState().initializePersistedState();
  });

  testWidgets('BilllelectricityWidget renders Disco selector, meter field, and meter type',
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
          home: BilllelectricityWidget(
            id: '1',
            name: 'Electricity',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify main components render
    expect(find.text('Electricity'), findsOneWidget);
    expect(find.text('DISTRIBUTION COMPANY'), findsOneWidget);
    expect(find.text('METER & RECIPIENT DETAILS'), findsOneWidget);
    expect(find.text('METER TYPE'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2)); // meter number & phone number
  });
}
