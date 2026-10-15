import '/components/yarnchat/widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'yarnchat_page_model.dart';
export 'yarnchat_page_model.dart';

class YarnChatPageWidget extends StatefulWidget {
  final String? phoneNumber;
  final String? email;
  final String? name;
  final String? widgetKey;

  const YarnChatPageWidget({
    super.key,
    this.phoneNumber,
    this.email,
    this.name,
    this.widgetKey,
  });

  static String routeName = 'YarnChat';
  static String routePath = '/yarnchat';

  @override
  State<YarnChatPageWidget> createState() => _YarnChatPageWidgetState();
}

class _YarnChatPageWidgetState extends State<YarnChatPageWidget> {
  late YarnChatPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => YarnChatPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectivePhone = (widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty)
        ? widget.phoneNumber
        : (FFAppState().phonenumber.isNotEmpty ? FFAppState().phonenumber : null);

    final effectiveEmail = (widget.email != null && widget.email!.isNotEmpty)
        ? widget.email
        : (FFAppState().email.isNotEmpty ? FFAppState().email : null);

    final effectiveName = (widget.name != null && widget.name!.isNotEmpty)
        ? widget.name
        : (FFAppState().accountname.isNotEmpty ? FFAppState().accountname : null);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF0B2018),
      body: YarnChatWidget(
        widgetKey: widget.widgetKey,
        visitorName: effectiveName,
        visitorEmail: effectiveEmail,
        visitorPhone: effectivePhone,
        isFullScreen: true,
        onClose: () => context.safePop(),
      ),
    );
  }
}
