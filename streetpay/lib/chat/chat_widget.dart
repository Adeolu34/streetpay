import '/components/yarnchat/widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'chat_model.dart';
export 'chat_model.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  static String routeName = 'chat';
  static String routePath = '/chat';

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF0B2018),
      body: YarnChatWidget(
        visitorName: FFAppState().accountname.isNotEmpty ? FFAppState().accountname : null,
        visitorEmail: FFAppState().email.isNotEmpty ? FFAppState().email : null,
        visitorPhone: FFAppState().phonenumber.isNotEmpty ? FFAppState().phonenumber : null,
        isFullScreen: true,
        onClose: () => context.safePop(),
      ),
    );
  }
}
