import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streetpay/flutter_flow/flutter_flow_util.dart';
import 'package:streetpay/pages/bills/billlcabletv/billlcabletv_widget.dart';
import 'package:streetpay/pages/bills/billlbetting/billlbetting_widget.dart';
import 'package:streetpay/pages/bills/billlinternet/billlinternet_widget.dart';
import 'package:streetpay/pages/bills/billlexam/billlexam_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await FFAppState().initializePersistedState();
  });

  testWidgets('Cable TV bill widget renders properly with smartcard inputs',
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
        child: MaterialApp(
          home: BilllcabletvWidget(
            id: '2',
            name: 'Cable TV',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Cable TV'), findsOneWidget);
    expect(find.text('CABLE PROVIDER'), findsOneWidget);
    expect(find.text('SMARTCARD / IUC & PHONE'), findsOneWidget);
    expect(find.text('SELECT BOUQUET PACKAGE'), findsOneWidget);
  });

  testWidgets('Betting bill widget renders properly with user ID input',
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
        child: MaterialApp(
          home: BilllbettingWidget(
            id: '6',
            name: 'Betting & Gaming',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Betting & Gaming'), findsOneWidget);
    expect(find.text('BETTING PLATFORM'), findsOneWidget);
    expect(find.text('USER ID / WALLET ID'), findsOneWidget);
    expect(find.text('AMOUNT TO FUND'), findsOneWidget);
    expect(find.text('Fund Betting Wallet'), findsOneWidget);
  });

  testWidgets('Internet bill widget renders properly with account inputs',
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
        child: MaterialApp(
          home: BilllinternetWidget(
            id: '7',
            name: 'Internet',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Internet'), findsOneWidget);
    expect(find.text('INTERNET SERVICE PROVIDER'), findsOneWidget);
    expect(find.text('ACCOUNT / DEVICE ID & PHONE'), findsOneWidget);
    expect(find.text('SELECT INTERNET BUNDLE'), findsOneWidget);
  });

  testWidgets('Exam bill widget renders properly with candidate inputs',
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
        child: MaterialApp(
          home: BilllexamWidget(
            id: '3',
            name: 'Exam PINs',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Exam PINs'), findsOneWidget);
    expect(find.text('EXAMINATION BOARD'), findsOneWidget);
  });
}
