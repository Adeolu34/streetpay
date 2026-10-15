import '/backend/api_requests/api_calls.dart';
import '/components/onboarding_page_item/onboarding_page_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'onboarding_widget.dart' show OnboardingWidget;
import 'package:flutter/material.dart';

class OnboardingModel extends FlutterFlowModel<OnboardingWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for OnboardingPageItem component.
  late OnboardingPageItemModel onboardingPageItemModel1;
  // Model for OnboardingPageItem component.
  late OnboardingPageItemModel onboardingPageItemModel2;
  // Model for OnboardingPageItem component.
  late OnboardingPageItemModel onboardingPageItemModel3;
  // Stores action output result for [Backend Call - API (streetauth)] action in Button widget.
  ApiCallResponse? authh;
  // Stores action output result for [Custom Action - getappversion] action in Button widget.
  String? appversion;
  // Stores action output result for [Backend Call - API (getUPDATE)] action in Button widget.
  ApiCallResponse? update;
  // Stores action output result for [Custom Action - getdeviceid] action in Button widget.
  String? deviceid;
  // Stores action output result for [Custom Action - getdeviceid] action in Button widget.
  String? deviceid2;

  @override
  void initState(BuildContext context) {
    onboardingPageItemModel1 =
        createModel(context, () => OnboardingPageItemModel());
    onboardingPageItemModel2 =
        createModel(context, () => OnboardingPageItemModel());
    onboardingPageItemModel3 =
        createModel(context, () => OnboardingPageItemModel());
  }

  @override
  void dispose() {
    onboardingPageItemModel1.dispose();
    onboardingPageItemModel2.dispose();
    onboardingPageItemModel3.dispose();
  }
}
