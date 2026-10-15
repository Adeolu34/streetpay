import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'earnwithus_widget.dart' show EarnwithusWidget;
import 'package:flutter/material.dart';

class EarnwithusModel extends FlutterFlowModel<EarnwithusWidget> {
  ///  Local state fields for this page.

  List<dynamic> pointse = [];
  void addToPointse(dynamic item) => pointse.add(item);
  void removeFromPointse(dynamic item) => pointse.remove(item);
  void removeAtIndexFromPointse(int index) => pointse.removeAt(index);
  void insertAtIndexInPointse(int index, dynamic item) =>
      pointse.insert(index, item);
  void updatePointseAtIndex(int index, Function(dynamic) updateFn) =>
      pointse[index] = updateFn(pointse[index]);

  bool issearch = false;

  List<dynamic> cashbackss = [];
  void addToCashbackss(dynamic item) => cashbackss.add(item);
  void removeFromCashbackss(dynamic item) => cashbackss.remove(item);
  void removeAtIndexFromCashbackss(int index) => cashbackss.removeAt(index);
  void insertAtIndexInCashbackss(int index, dynamic item) =>
      cashbackss.insert(index, item);
  void updateCashbackssAtIndex(int index, Function(dynamic) updateFn) =>
      cashbackss[index] = updateFn(cashbackss[index]);

  bool issearchcash = false;

  bool mycash = false;

  bool allwinner = false;

  List<dynamic> myycash = [];
  void addToMyycash(dynamic item) => myycash.add(item);
  void removeFromMyycash(dynamic item) => myycash.remove(item);
  void removeAtIndexFromMyycash(int index) => myycash.removeAt(index);
  void insertAtIndexInMyycash(int index, dynamic item) =>
      myycash.insert(index, item);
  void updateMyycashAtIndex(int index, Function(dynamic) updateFn) =>
      myycash[index] = updateFn(myycash[index]);

  List<dynamic> cashbacksearch = [];
  void addToCashbacksearch(dynamic item) => cashbacksearch.add(item);
  void removeFromCashbacksearch(dynamic item) => cashbacksearch.remove(item);
  void removeAtIndexFromCashbacksearch(int index) =>
      cashbacksearch.removeAt(index);
  void insertAtIndexInCashbacksearch(int index, dynamic item) =>
      cashbacksearch.insert(index, item);
  void updateCashbacksearchAtIndex(int index, Function(dynamic) updateFn) =>
      cashbacksearch[index] = updateFn(cashbacksearch[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getpoints)] action in earnwithus widget.
  ApiCallResponse? points;
  // Stores action output result for [Backend Call - API (getcashbackall)] action in earnwithus widget.
  ApiCallResponse? cashbackalll;
  // Stores action output result for [Backend Call - API (geturl)] action in Button widget.
  ApiCallResponse? geturl;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (savewhatsapp)] action in Button widget.
  ApiCallResponse? whatsapp;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  // Stores action output result for [Backend Call - API (getpoints)] action in Button widget.
  ApiCallResponse? searchlist;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // State field(s) for Column widget.
  ScrollController? columnController3;
  // State field(s) for Column widget.
  ScrollController? columnController4;
  // Stores action output result for [Backend Call - API (getcashback)] action in Button widget.
  ApiCallResponse? cashbackall;
  // State field(s) for DropDown widget.
  String? dropDownValue3;
  FormFieldController<String>? dropDownValueController3;
  // State field(s) for DropDown widget.
  String? dropDownValue4;
  FormFieldController<String>? dropDownValueController4;
  // Stores action output result for [Backend Call - API (getcashback)] action in Button widget.
  ApiCallResponse? searchlistcash;
  // Stores action output result for [Backend Call - API (getcashbackall)] action in Button widget.
  ApiCallResponse? allcash;
  // State field(s) for Column widget.
  ScrollController? columnController5;
  // State field(s) for Column widget.
  ScrollController? columnController6;
  // State field(s) for Column widget.
  ScrollController? columnController7;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    columnController3 = ScrollController();
    columnController4 = ScrollController();
    columnController5 = ScrollController();
    columnController6 = ScrollController();
    columnController7 = ScrollController();
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    tabBarController?.dispose();
    columnController1?.dispose();
    columnController2?.dispose();
    columnController3?.dispose();
    columnController4?.dispose();
    columnController5?.dispose();
    columnController6?.dispose();
    columnController7?.dispose();
  }
}
