import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:streetpay/custom_code/widgets/force_update_overlay.dart';

void main() {
  group('Play Store Update Tests', () {
    test('VersionStatus comparison test', () {
      // Test case 1: store version higher than local
      final status1 = VersionStatus(
        localVersion: '2.2.2',
        storeVersion: '2.2.3',
        appStoreLink:
            'https://play.google.com/store/apps/details?id=com.streetpayngr.smartapp',
      );
      expect(status1.canUpdate, isTrue);

      // Test case 2: store version equal to local
      final status2 = VersionStatus(
        localVersion: '2.2.3',
        storeVersion: '2.2.3',
        appStoreLink:
            'https://play.google.com/store/apps/details?id=com.streetpayngr.smartapp',
      );
      expect(status2.canUpdate, isFalse);

      // Test case 3: store version lower than local (e.g. testing dev build)
      final status3 = VersionStatus(
        localVersion: '2.2.4',
        storeVersion: '2.2.3',
        appStoreLink:
            'https://play.google.com/store/apps/details?id=com.streetpayngr.smartapp',
      );
      expect(status3.canUpdate, isFalse);
    });

    testWidgets('ForceUpdateOverlay renders update details and handles dismiss',
        (tester) async {
      tester.view.physicalSize = const Size(400, 850);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final status = VersionStatus(
        localVersion: '2.2.2',
        storeVersion: '2.2.3',
        releaseNotes: 'Performance improvements and bug fixes',
        appStoreLink:
            'https://play.google.com/store/apps/details?id=com.streetpayngr.smartapp',
      );

      bool dismissed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForceUpdateOverlay(
              status: status,
              isForceUpdate: false,
              onDismiss: () => dismissed = true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify UI elements
      expect(find.text('New Update Available'), findsOneWidget);
      expect(find.text('v2.2.2'), findsOneWidget);
      expect(find.text('v2.2.3'), findsOneWidget);
      expect(find.text('Update on Google Play'), findsOneWidget);
      expect(find.text('Remind me later'), findsOneWidget);
      expect(find.text('Performance improvements and bug fixes'), findsOneWidget);

      // Tap 'Remind me later'
      await tester.tap(find.text('Remind me later'));
      await tester.pump();

      expect(dismissed, isTrue);
    });

    testWidgets('ForceUpdateOverlay renders mandatory update state',
        (tester) async {
      tester.view.physicalSize = const Size(400, 850);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final status = VersionStatus(
        localVersion: '1.9.0',
        storeVersion: '2.2.3',
        appStoreLink:
            'https://play.google.com/store/apps/details?id=com.streetpayngr.smartapp',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForceUpdateOverlay(
              status: status,
              isForceUpdate: true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Update Required'), findsOneWidget);
      expect(find.text('Remind me later'), findsNothing);
      expect(find.text('Close App'), findsOneWidget);
    });
  });
}
