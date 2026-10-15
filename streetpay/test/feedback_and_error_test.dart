import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streetpay/components/global_error_screen.dart';
import 'package:streetpay/custom_code/widgets/visit_feedback_generator_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GlobalErrorScreen Tests', () {
    testWidgets('GlobalErrorScreen renders gracefully with error details and actions',
        (WidgetTester tester) async {
      final details = FlutterErrorDetails(
        exception: Exception('Test widget build failure'),
        stack: StackTrace.current,
        library: 'streetpay test suite',
      );

      await tester.pumpWidget(GlobalErrorScreen(details: details));
      await tester.pumpAndSettle();

      expect(find.text('Something Went Wrong'), findsOneWidget);
      expect(find.text('Return to Home'), findsOneWidget);
      expect(find.text('Open Help & Diagnostic Assistant'), findsOneWidget);
      expect(find.text('View technical info'), findsOneWidget);
    });

    testWidgets('GlobalErrorScreen can expand and collapse error details',
        (WidgetTester tester) async {
      final details = FlutterErrorDetails(
        exception: Exception('Specific crash exception message'),
        stack: StackTrace.current,
      );

      await tester.pumpWidget(GlobalErrorScreen(details: details));
      await tester.pumpAndSettle();

      // Initially details are hidden
      expect(find.textContaining('Specific crash exception message'), findsNothing);

      // Tap on expander
      await tester.tap(find.text('View technical info'));
      await tester.pumpAndSettle();

      // Now details are visible
      expect(find.textContaining('Specific crash exception message'), findsOneWidget);
    });
  });

  group('VisitFeedbackGeneratorWidget Tests', () {
    testWidgets('VisitFeedbackGeneratorWidget renders button with custom or default text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VisitFeedbackGeneratorWidget(
              buttonText: 'Auto-Generate Visit Verification',
              customerName: 'John Doe',
              verificationAddress: '123 Victoria Island, Lagos',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Auto-Generate Visit Verification'), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });
  });
}
