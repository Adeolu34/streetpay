import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streetpay/flutter_flow/flutter_flow_drop_down.dart';
import 'package:streetpay/flutter_flow/form_field_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

void main() {
  testWidgets('FlutterFlowDropDown renders with non-transparent popup menu even when fillColor is transparent',
      (WidgetTester tester) async {
    final controller = FormFieldController<String>('Option 1');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FlutterFlowDropDown<String>(
              controller: controller,
              options: const ['Option 1', 'Option 2', 'Option 3'],
              onChanged: (val) {},
              width: 200,
              height: 50,
              textStyle: const TextStyle(color: Colors.black, fontSize: 14),
              elevation: 0,
              borderWidth: 1,
              borderRadius: 8,
              borderColor: Colors.grey,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              fillColor: Colors.transparent, // Caller specified transparent
              isSearchable: true,
            ),
          ),
        ),
      ),
    );

    // Initial check: dropdown button is rendered
    expect(find.text('Option 1'), findsOneWidget);

    // Tap to open the dropdown menu
    await tester.tap(find.text('Option 1'));
    await tester.pumpAndSettle();

    // Verify DropdownButton2 internal structure has non-transparent decoration
    final dropdownFinder = find.byType(DropdownButton2<String>);
    expect(dropdownFinder, findsOneWidget);

    final dropdownWidget = tester.widget<DropdownButton2<String>>(dropdownFinder);
    final decoration = dropdownWidget.dropdownStyleData.decoration;

    expect(decoration, isNotNull);
    // Menu color must NOT be transparent
    expect(decoration!.color, isNot(Colors.transparent));
    expect(decoration.color, equals(Colors.white));

    // Options are displayed in the opened menu
    expect(find.text('Option 2'), findsOneWidget);
    expect(find.text('Option 3'), findsOneWidget);
  });
}
