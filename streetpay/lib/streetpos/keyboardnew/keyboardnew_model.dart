import '/flutter_flow/flutter_flow_util.dart';
import 'keyboardnew_widget.dart' show KeyboardnewWidget;
import 'package:flutter/material.dart';

class KeyboardnewModel extends FlutterFlowModel<KeyboardnewWidget> {
  ///  Local state fields for this page.

  List<String> numbers = [];
  void addToNumbers(String item) => numbers.add(item);
  void removeFromNumbers(String item) => numbers.remove(item);
  void removeAtIndexFromNumbers(int index) => numbers.removeAt(index);
  void insertAtIndexInNumbers(int index, String item) =>
      numbers.insert(index, item);
  void updateNumbersAtIndex(int index, Function(String) updateFn) =>
      numbers[index] = updateFn(numbers[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
