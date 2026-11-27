import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:streetpay/autodiscover1/autodiscover1_widget.dart';
import 'package:streetpay/flutter_flow/flutter_flow_theme.dart';
import 'package:streetpay/flutter_flow/flutter_flow_util.dart';
import 'package:streetpay/newhome/newhome_widget.dart';
import 'package:streetpay/pages/bills/airtimeform/airtimeform_widget.dart';
import 'package:streetpay/pages/bills/billnew/billnew_widget.dart';
import 'package:streetpay/pages/manual_payment/manual_payment_widget.dart';

void _seedDemoAppState(FFAppState state) {
  state.isLoggedIn = true;
  state.isRegistered = true;
  state.accountname = 'Alagbe John';
  state.accountno = '1100767497';
  state.avalbal = '142850.00';
  state.biometric = true;
  state.progressvalue = 1.0;
  state.show = true;
  state.hidebal = false;
  state.phonenumber = '08012345678';
  state.email = 'john@streetpay.ng';
}

Widget _wrapPage(Widget child) {
  return ChangeNotifierProvider<FFAppState>.value(
    value: FFAppState(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, useMaterial3: false),
      home: child,
    ),
  );
}

Future<void> _pumpAndCapture(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
  Widget page,
  String name,
) async {
  await tester.pumpWidget(_wrapPage(page));
  for (int i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
  await binding.convertFlutterSurfaceToImage();
  await tester.pump();
  await binding.takeScreenshot(name);
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Capture real StreetPay App Store screenshots', (tester) async {
    final env = FFDevEnvironmentValues();
    await env.initialize();
    await FlutterFlowTheme.initialize();
    _seedDemoAppState(FFAppState());

    await _pumpAndCapture(tester, binding, const NewhomeWidget(), '1_home_wallet');
    await _pumpAndCapture(tester, binding, const ManualPaymentWidget(), '2_transfer_bank');
    await _pumpAndCapture(tester, binding, const BillnewWidget(), '3_bill_requests');
    await _pumpAndCapture(
      tester,
      binding,
      const AirtimeformWidget(phonenumber: '08012345678'),
      '4_buy_airtime',
    );
    await _pumpAndCapture(tester, binding, const Autodiscover1Widget(), '5_nearby_discovery');
  });
}

