import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'chattt_model.dart';
export 'chattt_model.dart';

/// Create a component Build a modern Chat Component in React using Tailwind
/// and shadcn/ui.
///
/// It should display:
///
/// The agent’s name, avatar, and status (e.g. 🟢 Online) at the top.
///
/// A scrollable message area showing both agent and user messages, each with
/// sender name, text, and timestamp.
///
/// A text input at the bottom for sending messages, limited to 1000
/// characters, with a live counter and a disabled “Send” button when empty or
/// over limit.
///
/// Messages should align left for agent and right for user, update instantly
/// on send, and auto-scroll to the latest message.
/// Use functional React with hooks, export as ChatComponent, and make it
/// responsive with a clean rounded card layout.
class ChatttWidget extends StatefulWidget {
  const ChatttWidget({super.key});

  @override
  State<ChatttWidget> createState() => _ChatttWidgetState();
}

class _ChatttWidgetState extends State<ChatttWidget> {
  late ChatttModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatttModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(1.0, 1.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Container(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 1.0,
          child: custom_widgets.Chattt(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 1.0,
          ),
        ),
      ),
    );
  }
}
