// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/api_requests/api_calls.dart';
import '/components/chatmessage_widget.dart';
import '/components/nochart_widget.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/config/secrets.dart';

class Chattt extends StatefulWidget {
  const Chattt({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<Chattt> createState() => _ChatttState();
}

class _ChatttState extends State<Chattt> {
  static const _geminiApiKey = AppSecrets.geminiApiKey;

  List<dynamic> _messages = [];
  bool _isLoading = true;
  bool _isAgentTyping = false;
  Timer? _pollingTimer;
  ScrollController? _scrollController;
  FocusNode? _textFieldFocusNode;
  TextEditingController? _textController;
  bool _isInitialLoad = true;

  String get _agentName {
    for (final msg in _messages.reversed) {
      final name = getJsonField(msg, r'''$.AgentName''')?.toString().trim() ?? '';
      if (name.isNotEmpty) return name;
    }
    return 'Support Agent';
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textController = TextEditingController();
    _textFieldFocusNode = FocusNode();

    // Load messages initially
    _loadMessages();

    // Start polling for new messages every 15 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _loadMessages();
    });
  }

  void _scrollToBottom({bool smooth = true, int retries = 0}) {
    if (_scrollController != null && _messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController != null && _scrollController!.hasClients) {
          final maxScroll = _scrollController!.position.maxScrollExtent;
          if (smooth) {
            _scrollController!.animateTo(
              maxScroll,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeOut,
            );
          } else {
            _scrollController!.jumpTo(maxScroll);
          }
        } else if (retries < 3 && _scrollController != null) {
          // Retry if controller not attached yet (for initial load)
          Future.delayed(Duration(milliseconds: 50), () {
            _scrollToBottom(smooth: smooth, retries: retries + 1);
          });
        }
      });
    }
  }

  Future<void> _loadMessages() async {
    try {
      final response = await GetmessageCall.call(
        accessToken: FFAppState().bsptoken,
        tempid: FFAppState().deviceid,
      );

      if (mounted) {
        final previousMessageCount = _messages.length;
        final newMessages =
            GetmessageCall.messages(response.jsonBody)?.toList() ?? [];

        if (_isLoading || newMessages.length != previousMessageCount) {
          setState(() {
            _messages = newMessages;
            _isLoading = false;
          });

          // Auto-scroll to bottom when messages are loaded
          if (_messages.isNotEmpty) {
            // For initial load, wait a bit longer to ensure scroll view is ready
            if (_isInitialLoad) {
              _isInitialLoad = false;
              // Wait for the widget tree to be fully built
              Future.delayed(Duration(milliseconds: 100), () {
                _scrollToBottom(smooth: true);
              });
            } else if (_messages.length != previousMessageCount) {
              // New messages arrived, scroll smoothly
              _scrollToBottom(smooth: true);
            }
          }
        }
      }
    } catch (e) {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendGeminiResponse() async {
    if (!mounted) return;
    setState(() => _isAgentTyping = true);
    _scrollToBottom(smooth: true);

    try {
      // Build conversation history (last 12 messages for context)
      final contextMessages = _messages.length > 12
          ? _messages.sublist(_messages.length - 12)
          : List<dynamic>.from(_messages);

      final rawHistory = <Map<String, dynamic>>[];
      for (final msg in contextMessages) {
        final sender = getJsonField(msg, r'''$.Sender''')?.toString() ?? '';
        final text = getJsonField(msg, r'''$.MessageText''')?.toString() ?? '';
        if (text.trim().isEmpty) continue;
        final role = sender == 'Agent' ? 'model' : 'user';
        rawHistory.add({'role': role, 'text': text.trim()});
      }

      if (rawHistory.isEmpty) return;

      // Gemini requires strictly alternating user/model turns.
      // Merge consecutive same-role messages into one.
      final merged = <Map<String, dynamic>>[];
      for (final turn in rawHistory) {
        if (merged.isNotEmpty && merged.last['role'] == turn['role']) {
          merged.last['text'] = '${merged.last['text']}\n${turn['text']}';
        } else {
          merged.add(Map<String, dynamic>.from(turn));
        }
      }

      // Gemini must start with a user turn
      if (merged.first['role'] != 'user') merged.removeAt(0);
      if (merged.isEmpty) return;

      // Gemini must end with a user turn
      if (merged.last['role'] != 'user') return;

      final contents = merged
          .map((t) => {
                'role': t['role'],
                'parts': [
                  {'text': t['text']}
                ]
              })
          .toList();

      const systemPrompt =
          'You are a helpful and friendly customer support agent for StreetPay, '
          'a Nigerian fintech platform for payments and transfers. '
          'Help users with account issues, payments, transfers, and troubleshooting. '
          'Be concise, professional, and empathetic. '
          'If unsure about something specific to StreetPay, advise the user to contact support directly.';

      final requestBody = jsonEncode({
        'system_instruction': {
          'parts': [
            {'text': systemPrompt}
          ]
        },
        'contents': contents,
        'generationConfig': {'maxOutputTokens': 300, 'temperature': 0.7},
      });

      final geminiResponse = await http
          .post(
            Uri.parse(
                'https://generativelanguage.googleapis.com/v1beta/models/${AppSecrets.geminiModel}:generateContent?key=$_geminiApiKey'),
            headers: {'Content-Type': 'application/json'},
            body: requestBody,
          )
          .timeout(const Duration(seconds: 25));

      if (geminiResponse.statusCode == 200) {
        final data = jsonDecode(geminiResponse.body) as Map<String, dynamic>;
        final aiText = data['candidates']?[0]?['content']?['parts']?[0]
            ?['text'] as String?;

        if (aiText != null && aiText.trim().isNotEmpty) {
          await SendmessageCall.call(
            accessToken: FFAppState().bsptoken,
            tempid: FFAppState().deviceid,
            messagetext: aiText.trim(),
            sender: 'Agent',
            messagetype: 'Message',
            regphone: FFAppState().phonenumber,
          );
          await _loadMessages();
        }
      } else {
        final errorBody = geminiResponse.body;
        debugPrint('Gemini ${geminiResponse.statusCode}: $errorBody');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Agent error (${geminiResponse.statusCode}) — please try again'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ));
        }
      }
    } catch (e) {
      debugPrint('_sendGeminiResponse error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Agent unavailable: ${e.toString()}'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 4),
        ));
      }
    } finally {
      if (mounted) setState(() => _isAgentTyping = false);
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _scrollController?.dispose();
    _textFieldFocusNode?.dispose();
    _textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: AlignmentDirectional(1.0, 1.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 670.2,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 8.0,
                color: Color(0x33000000),
                offset: Offset(
                  0.0,
                  2.0,
                ),
                spreadRadius: 0.0,
              )
            ],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent2,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).secondary,
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2.0, 2.0, 2.0, 2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24.0),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1728112265403-a4aebd5859a5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjIwMzk2MDF8&ixlib=rb-4.1.0&q=80&w=1080',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _agentName,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '🟢',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    'Online',
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                            ].divide(SizedBox(height: 4.0)),
                          ),
                        ),
                      ].divide(SizedBox(width: 12.0)),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                    child: _isLoading && _messages.isEmpty
                        ? Center(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: SpinKitDoubleBounce(
                                color: FlutterFlowTheme.of(context).warning,
                                size: 50.0,
                              ),
                            ),
                          )
                        : _messages.isEmpty
                            ? NochartWidget()
                            : SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ...List.generate(_messages.length,
                                        (messagesIndex) {
                                      final messagesItem =
                                          _messages[messagesIndex];
                                      return ChatmessageWidget(
                                        key: Key(
                                            'Key6a3_${messagesIndex}_of_${_messages.length}'),
                                        sendermessage: getJsonField(
                                          messagesItem,
                                          r'''$.MessageText''',
                                        ).toString(),
                                        agentmessage: getJsonField(
                                          messagesItem,
                                          r'''$.MessageText''',
                                        ).toString(),
                                        agentname: getJsonField(
                                          messagesItem,
                                          r'''$.AgentName''',
                                        ).toString(),
                                        sendertime: getJsonField(
                                          messagesItem,
                                          r'''$.DateSent''',
                                        ).toString(),
                                        agenttime: getJsonField(
                                          messagesItem,
                                          r'''$.DateSent''',
                                        ).toString(),
                                        isagent: functions.getuser(getJsonField(
                                                  messagesItem,
                                                  r'''$.Sender''',
                                                ).toString()) ==
                                                true
                                            ? true
                                            : false,
                                      );
                                    }),
                                    if (_isAgentTyping)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 14.0,
                                                  vertical: 10.0),
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(
                                                        context)
                                                    .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SpinKitThreeBounce(
                                                    color:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText,
                                                    size: 16.0,
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Text(
                                                    'Agent is typing...',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Type your message...',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _textController,
                                focusNode: _textFieldFocusNode,
                                autofocus: false,
                                textInputAction: TextInputAction.done,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'Type your message...',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                maxLines: 3,
                                minLines: 3,
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                final messageText = _textController?.text ?? '';
                                if (messageText.trim().isEmpty) return;

                                try {
                                  final response = await SendmessageCall.call(
                                    accessToken: FFAppState().bsptoken,
                                    tempid: FFAppState().deviceid,
                                    messagetext: messageText,
                                    sender: 'User',
                                    messagetype: 'Message',
                                    regphone: FFAppState().phonenumber,
                                  );

                                  // Check if message was sent successfully
                                  final success =
                                      SendmessageCall.status(response.jsonBody);
                                  if (success == true) {
                                    setState(() {
                                      _textController?.clear();
                                    });

                                    // Immediately refresh messages after sending
                                    await _loadMessages();

                                    // Fire Gemini AI response (unawaited — runs in background)
                                    _sendGeminiResponse();
                                  } else {
                                    // Show error message if failed
                                    final errorMsg =
                                        SendmessageCall.msg(response.jsonBody);
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(errorMsg ??
                                              'Failed to send message'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  // Handle any errors
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Error sending message: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              text: 'Send',
                              options: FFButtonOptions(
                                width: 80.0,
                                height: 40.0,
                                padding: EdgeInsets.all(8.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                  ),
                ),
              ].divide(SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}
