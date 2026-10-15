import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '/flutter_flow/flutter_flow_util.dart';
import '/config/secrets.dart';

// SendBaba MyYarns Live Chat Endpoints
const String _kSendBabaBaseUrl = 'https://app.myyarns.sendbaba.com';
const String _kSendBabaWsUrl = 'wss://app.myyarns.sendbaba.com';

/// Represents a single message in the MyYarns conversation
class ChatMessage {
  final String id;
  final String text;
  final String sender; // 'visitor', 'ai', 'agent'
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> j) {
    return ChatMessage(
      id: j['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: j['content']?.toString() ?? j['text']?.toString() ?? '',
      sender: j['sender_type']?.toString() ?? j['sender']?.toString() ?? 'ai',
      timestamp: j['created_at'] != null || j['timestamp'] != null
          ? DateTime.tryParse(j['created_at']?.toString() ?? j['timestamp']?.toString() ?? '')?.toLocal() ??
              DateTime.now()
          : DateTime.now(),
    );
  }

  bool get isVisitor => sender == 'visitor';
}

/// Remote configuration fetched for the widget key
class WidgetConfig {
  final String name;
  final String greeting;
  final Color color;
  final bool aiEnabled;

  WidgetConfig({
    required this.name,
    required this.color,
    required this.greeting,
    required this.aiEnabled,
  });

  factory WidgetConfig.fromJson(Map<String, dynamic> j) {
    final hex = (j['color']?.toString() ?? '#56B84B').replaceAll('#', '');
    Color parsedColor;
    try {
      parsedColor = Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      parsedColor = const Color(0xFF56B84B);
    }

    return WidgetConfig(
      name: j['name']?.toString() ?? 'StreetPay Support',
      color: parsedColor,
      greeting: j['greeting']?.toString() ??
          'Hello! Welcome to StreetPay live support. How can we help you today?',
      aiEnabled: j['ai_enabled'] == true,
    );
  }
}

/// Controller managing the SendBaba WebSocket and REST lifecycle
class YarnChatController extends ChangeNotifier {
  final String widgetKey;
  String? visitorName;
  String? visitorEmail;
  String? visitorPhone;

  late final String _sessionId;
  io.WebSocket? _socket;
  Timer? _reconnectTimer;
  Timer? _typingTimer;

  List<ChatMessage> messages = [];
  WidgetConfig? config;
  bool connected = false;
  bool isConnecting = false;
  bool isTyping = false;
  bool isOpen = false;
  int unreadCount = 0;
  String? ratingSubmitted;

  YarnChatController({
    String? widgetKey,
    this.visitorName,
    this.visitorEmail,
    this.visitorPhone,
  }) : widgetKey = (widgetKey == null || widgetKey.trim().isEmpty)
            ? AppSecrets.sendBabaWidgetKey
            : widgetKey.trim() {
    _sessionId = 'flutter_sp_${DateTime.now().millisecondsSinceEpoch}';
    _init();
  }

  void updateVisitorEmail(String email) {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty) return;
    visitorEmail = cleanEmail;
    try {
      FFAppState().email = cleanEmail;
    } catch (_) {}
    notifyListeners();
    if (connected) {
      _send({
        'type': 'visitor_info',
        'page': 'streetpay-app',
        'device': 'mobile-flutter',
        'email': cleanEmail,
        if (visitorName != null && visitorName!.isNotEmpty) 'name': visitorName,
        if (visitorPhone != null && visitorPhone!.isNotEmpty) 'phone': visitorPhone,
      });
    }
  }

  Future<void> _init() async {
    await Future.wait([_loadConfig(), _loadHistory()]);
    _connect();
  }

  Future<void> _loadConfig() async {
    try {
      final res = await http.get(
        Uri.parse('$_kSendBabaBaseUrl/api/widgets/key/$widgetKey'),
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        if (j is Map && j['success'] == true && j['widget'] is Map) {
          config = WidgetConfig.fromJson(j['widget']);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('SendBaba config load notice: $e');
    }
  }

  Future<void> _loadHistory() async {
    try {
      final res = await http.get(
        Uri.parse('$_kSendBabaBaseUrl/api/conversations/session/$_sessionId/messages'),
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        if (j is Map && j['success'] == true && j['messages'] is List) {
          final historyList = (j['messages'] as List)
              .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
              .toList();

          for (final hm in historyList) {
            final exists = messages.any((m) =>
                m.id == hm.id ||
                (m.isVisitor == hm.isVisitor &&
                    m.text.trim() == hm.text.trim() &&
                    hm.timestamp.difference(m.timestamp).abs().inSeconds < 10));
            if (!exists) {
              messages.add(hm);
            }
          }
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('SendBaba history load notice: $e');
    }
  }

  void _connect() {
    if (_socket != null) {
      try {
        _socket!.close();
      } catch (_) {}
      _socket = null;
    }

    isConnecting = true;
    notifyListeners();

    final wsUri = Uri.parse('$_kSendBabaWsUrl/ws/$widgetKey/$_sessionId');
    io.WebSocket.connect(wsUri.toString())
        .timeout(const Duration(seconds: 10))
        .then((socket) {
      _socket = socket;
      connected = true;
      isConnecting = false;
      notifyListeners();

      // Send visitor identification to SendBaba MyYarns
      _send({
        'type': 'visitor_info',
        'page': 'streetpay-login-screen',
        'device': 'mobile-flutter',
        if (visitorName != null && visitorName!.isNotEmpty) 'name': visitorName,
        if (visitorEmail != null && visitorEmail!.isNotEmpty) 'email': visitorEmail,
        if (visitorPhone != null && visitorPhone!.isNotEmpty) 'phone': visitorPhone,
      });

      _socket!.listen(
        (data) => _onMessage(data),
        onDone: _onDisconnect,
        onError: (_) => _onDisconnect(),
        cancelOnError: true,
      );
    }).catchError((err) {
      debugPrint('SendBaba WebSocket connect error: $err');
      _onDisconnect();
    });
  }

  void _onMessage(dynamic raw) {
    try {
      final text = raw is String ? raw : utf8.decode(raw as List<int>);
      final msg = jsonDecode(text) as Map<String, dynamic>;
      final type = msg['type']?.toString();

      if (type == 'message') {
        final newMsg = ChatMessage.fromJson({
          'id': msg['id'],
          'content': msg['content'] ?? msg['text'],
          'sender_type': msg['sender'] ?? 'ai',
          'created_at': msg['timestamp'] ?? msg['created_at'],
        });

        // 1. Prevent duplicate message by exact ID
        if (messages.any((m) => m.id == newMsg.id)) {
          return;
        }

        // 2. When SendBaba echoes back the visitor's message, reconcile with local pending message
        if (newMsg.isVisitor) {
          final pendingIndex = messages.lastIndexWhere((m) =>
              (m.id.startsWith('local_') || m.id == newMsg.id) &&
              m.isVisitor &&
              m.text.trim() == newMsg.text.trim());

          if (pendingIndex != -1) {
            // Replace the optimistic local bubble with the server confirmed message
            messages[pendingIndex] = newMsg;
            notifyListeners();
            return;
          }

          // If identical visitor message already exists recently, ignore duplicate echo
          final isRecentDuplicate = messages.any((m) =>
              m.isVisitor &&
              m.text.trim() == newMsg.text.trim() &&
              newMsg.timestamp.difference(m.timestamp).abs().inSeconds < 15);
          if (isRecentDuplicate) {
            return;
          }
        }

        messages.add(newMsg);
        if (!isOpen) {
          unreadCount++;
        }
        _typingTimer?.cancel();
        isTyping = false;
        notifyListeners();
      } else if (type == 'typing') {
        isTyping = true;
        notifyListeners();
        _typingTimer?.cancel();
        _typingTimer = Timer(const Duration(seconds: 3), () {
          isTyping = false;
          notifyListeners();
        });
      } else if (type == 'rating_received') {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('SendBaba message parse error: $e');
    }
  }

  void _onDisconnect() {
    connected = false;
    isConnecting = false;
    notifyListeners();

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (_socket == null || !connected) {
        _connect();
      }
    });
  }

  void _send(Map<String, dynamic> data) {
    try {
      if (_socket != null && connected) {
        _socket!.add(jsonEncode(data));
      }
    } catch (e) {
      debugPrint('SendBaba send error: $e');
    }
  }

  void sendMessage(String text) {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    final clientMsg = ChatMessage(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      text: cleanText,
      sender: 'visitor',
      timestamp: DateTime.now(),
    );

    messages.add(clientMsg);
    notifyListeners();

    _send({
      'type': 'message',
      'content': cleanText,
    });
  }

  void sendRating(String value) {
    if (ratingSubmitted != null) return;
    ratingSubmitted = value;
    notifyListeners();
    _send({
      'type': 'rating',
      'value': value,
    });
  }

  void open() {
    isOpen = true;
    unreadCount = 0;
    notifyListeners();
  }

  void close() {
    isOpen = false;
    notifyListeners();
  }

  void reconnect() {
    _connect();
  }

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    _typingTimer?.cancel();
    try {
      _socket?.close();
    } catch (_) {}
    super.dispose();
  }
}

/// Standalone or embeddable YarnChat Widget for StreetPay
class YarnChatWidget extends StatefulWidget {
  final String? widgetKey;
  final String? visitorName;
  final String? visitorEmail;
  final String? visitorPhone;
  final bool isFullScreen;
  final VoidCallback? onClose;

  const YarnChatWidget({
    super.key,
    this.widgetKey,
    this.visitorName,
    this.visitorEmail,
    this.visitorPhone,
    this.isFullScreen = false,
    this.onClose,
  });

  @override
  State<YarnChatWidget> createState() => _YarnChatWidgetState();
}

class _YarnChatWidgetState extends State<YarnChatWidget> {
  late final YarnChatController _ctrl;
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _quickTopics = [
    'Forgotten login PIN',
    'OTP not received',
    'Device change help',
    'BVN / KYC verification',
  ];

  @override
  void initState() {
    super.initState();
    final effectiveEmail = (widget.visitorEmail != null && widget.visitorEmail!.isNotEmpty)
        ? widget.visitorEmail
        : (FFAppState().email.isNotEmpty ? FFAppState().email : null);
    final effectivePhone = (widget.visitorPhone != null && widget.visitorPhone!.isNotEmpty)
        ? widget.visitorPhone
        : (FFAppState().phonenumber.isNotEmpty ? FFAppState().phonenumber : null);
    final effectiveName = (widget.visitorName != null && widget.visitorName!.isNotEmpty)
        ? widget.visitorName
        : (FFAppState().accountname.isNotEmpty ? FFAppState().accountname : null);

    _ctrl = YarnChatController(
      widgetKey: widget.widgetKey,
      visitorName: effectiveName,
      visitorEmail: effectiveEmail,
      visitorPhone: effectivePhone,
    );
    _emailController.text = effectiveEmail ?? '';
    _ctrl.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onControllerUpdate);
    _ctrl.dispose();
    _inputController.dispose();
    _emailController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? prefilled]) {
    final text = prefilled ?? _inputController.text;
    if (text.trim().isEmpty) return;
    if (_ctrl.visitorEmail == null || _ctrl.visitorEmail!.isEmpty) {
      if (_emailController.text.trim().contains('@')) {
        _ctrl.updateVisitorEmail(_emailController.text.trim());
      } else if (FFAppState().email.isNotEmpty) {
        _ctrl.updateVisitorEmail(FFAppState().email);
      }
    }
    _ctrl.sendMessage(text.trim());
    if (prefilled == null) {
      _inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryBg = Color(0xFF0B2018);
    const cardBg = Color(0xFF112B20);
    const accentGreen = Color(0xFF56B84B);
    const textGreen = Color(0xFF7FD472);
    const mutedGreen = Color(0xFF7F9A89);

    final title = _ctrl.config?.name ?? 'StreetPay Live Support';
    final greeting = _ctrl.config?.greeting ??
        'Hi there! Welcome to StreetPay 24/7 AI & Live Support. How can we help you sign in or manage your account?';

    return Container(
      color: primaryBg,
      child: SafeArea(
        child: Column(
          children: [
            // Top App Bar / Support Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: const BoxDecoration(
                color: Color(0xFF10261D),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF1E4230),
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (widget.onClose != null || widget.isFullScreen)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                      onPressed: () {
                        if (widget.onClose != null) {
                          widget.onClose!();
                        } else {
                          Navigator.of(context).maybePop();
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  if (widget.onClose != null || widget.isFullScreen)
                    const SizedBox(width: 12.0),

                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF153325),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF28543E), width: 1.5),
                        ),
                        child: const Center(
                          child: Icon(Icons.headset_mic_rounded, color: accentGreen, size: 22),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _ctrl.connected ? const Color(0xFF4ADE80) : const Color(0xFFFBBF24),
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryBg, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12.0),

                  // Title and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A402E),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'SendBaba',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: textGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2.0),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _ctrl.connected ? const Color(0xFF4ADE80) : const Color(0xFFFBBF24),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _ctrl.connected
                                  ? 'Online · Replies instantly'
                                  : (_ctrl.isConnecting ? 'Connecting to live agent...' : 'Reconnecting...'),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: _ctrl.connected ? const Color(0xFF86EFAC) : const Color(0xFFFDE68A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Manual reconnect button if disconnected
                  if (!_ctrl.connected)
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: textGreen, size: 20),
                      onPressed: _ctrl.reconnect,
                      tooltip: 'Reconnect',
                    ),
                ],
              ),
            ),

            // Email Connection / Identification Banner
            Container(
              margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 2.0),
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E4230)),
              ),
              child: (_ctrl.visitorEmail != null && _ctrl.visitorEmail!.isNotEmpty)
                  ? Row(
                      children: [
                        const Icon(Icons.mark_email_read_rounded, size: 16, color: accentGreen),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Email: ${_ctrl.visitorEmail}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFA5C4B0),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _emailController.text = _ctrl.visitorEmail ?? '';
                            setState(() => _ctrl.visitorEmail = null);
                          },
                          child: Text(
                            'Change',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: textGreen,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        const Icon(Icons.email_outlined, size: 16, color: textGreen),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your email for live replies',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 12.0,
                                color: mutedGreen,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (val) {
                              if (val.trim().contains('@')) {
                                _ctrl.updateVisitorEmail(val.trim());
                              }
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            final val = _emailController.text.trim();
                            if (val.contains('@')) {
                              _ctrl.updateVisitorEmail(val);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: accentGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Save',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF04190C),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            // Quick Topic Suggestion Chips
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _quickTopics.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final topic = _quickTopics[index];
                  return InkWell(
                    onTap: () => _sendMessage(topic),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF1E4230)),
                      ),
                      child: Center(
                        child: Text(
                          topic,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: textGreen,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Chat Feed Body
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF091A14),
                ),
                child: _ctrl.messages.isEmpty
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF1E4230), width: 1.5),
                                ),
                                child: const Center(
                                  child: Icon(Icons.bolt_rounded, color: accentGreen, size: 36),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                'StreetPay Assistant',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                greeting,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: mutedGreen,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF112B20),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF1E4230)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.lock_outline_rounded, size: 16, color: accentGreen),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Direct encrypted connection to live agent',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFA5C4B0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _ctrl.messages.length + (_ctrl.isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Typing Indicator Row
                          if (_ctrl.isTyping && index == _ctrl.messages.length) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1E4230),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.smart_toy_outlined, color: textGreen, size: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                                    decoration: BoxDecoration(
                                      color: cardBg,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                        bottomLeft: Radius.circular(4),
                                      ),
                                      border: Border.all(color: const Color(0xFF1E4230)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Agent is replying',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            color: mutedGreen,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          '● ● ●',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: accentGreen,
                                            letterSpacing: 2.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final m = _ctrl.messages[index];
                          final isMe = m.isVisitor;
                          final timeStr =
                              '${m.timestamp.hour.toString().padLeft(2, '0')}:${m.timestamp.minute.toString().padLeft(2, '0')}';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isMe) ...[
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1E4230),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.support_agent_rounded, color: textGreen, size: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                ],
                                Flexible(
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.sizeOf(context).width * 0.76,
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 11.0),
                                    decoration: BoxDecoration(
                                      color: isMe ? accentGreen : cardBg,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(18),
                                        topRight: const Radius.circular(18),
                                        bottomLeft: Radius.circular(isMe ? 18 : 4),
                                        bottomRight: Radius.circular(isMe ? 4 : 18),
                                      ),
                                      border: isMe
                                          ? null
                                          : Border.all(color: const Color(0xFF1E4230), width: 1.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          m.text,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: isMe ? const Color(0xFF04190C) : Colors.white,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          timeStr,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w500,
                                            color: isMe
                                                ? const Color(0xFF04190C).withValues(alpha: 0.7)
                                                : mutedGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),

            // Rating widget if conversation has started
            if (_ctrl.messages.length >= 2 && _ctrl.ratingSubmitted == null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                color: const Color(0xFF0D2319),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Was this helpful?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: mutedGreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _ctrl.sendRating('up'),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: cardBg,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.thumb_up_alt_rounded, size: 14, color: accentGreen),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _ctrl.sendRating('down'),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: cardBg,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.thumb_down_alt_rounded, size: 14, color: mutedGreen),
                      ),
                    ),
                  ],
                ),
              ),

            // Bottom Input Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
              decoration: const BoxDecoration(
                color: Color(0xFF10261D),
                border: Border(
                  top: BorderSide(
                    color: Color(0xFF1E4230),
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF091A14),
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: const Color(0xFF1E4230)),
                      ),
                      child: TextField(
                        controller: _inputController,
                        maxLines: null,
                        maxLength: 500,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type your question...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 14.0,
                            color: mutedGreen,
                          ),
                          counterText: '',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  InkWell(
                    onTap: () => _sendMessage(),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: accentGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send_rounded,
                          color: Color(0xFF04190C),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer branding
            Container(
              color: const Color(0xFF10261D),
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Center(
                child: Text(
                  'Powered by MyYarns · SendBaba',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5A7565),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating launcher widget matching the official MyYarns SDK specification:
/// `Stack(children: [YourApp(), MyYarnsWidget(widgetKey: 'sb_chat_xxxx')])`
class MyYarnsWidget extends StatefulWidget {
  final String? widgetKey;
  final String? visitorName;
  final String? visitorEmail;
  final String? visitorPhone;
  final double? bottom;
  final double? right;

  const MyYarnsWidget({
    super.key,
    this.widgetKey,
    this.visitorName,
    this.visitorEmail,
    this.visitorPhone,
    this.bottom,
    this.right,
  });

  @override
  State<MyYarnsWidget> createState() => _MyYarnsWidgetState();
}

class _MyYarnsWidgetState extends State<MyYarnsWidget> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    const accentGreen = Color(0xFF56B84B);

    return Stack(
      children: [
        if (_isOpen)
          Positioned.fill(
            child: YarnChatWidget(
              widgetKey: widget.widgetKey,
              visitorName: widget.visitorName,
              visitorEmail: widget.visitorEmail,
              visitorPhone: widget.visitorPhone,
              isFullScreen: true,
              onClose: () => setState(() => _isOpen = false),
            ),
          ),
        if (!_isOpen)
          Positioned(
            bottom: widget.bottom ?? 24.0,
            right: widget.right ?? 24.0,
            child: GestureDetector(
              onTap: () => setState(() => _isOpen = true),
              child: Container(
                width: 58.0,
                height: 58.0,
                decoration: BoxDecoration(
                  color: accentGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accentGreen.withValues(alpha: 0.4),
                      blurRadius: 16.0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.chat_bubble_rounded,
                    color: Color(0xFF04190C),
                    size: 26.0,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
