import '/flutter_flow/flutter_flow_util.dart';
import 'keyboard_widget.dart' show KeyboardWidget;
import 'package:flutter/material.dart';

class KeyboardModel extends FlutterFlowModel<KeyboardWidget> {
  ///  Local state fields for this component.

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
