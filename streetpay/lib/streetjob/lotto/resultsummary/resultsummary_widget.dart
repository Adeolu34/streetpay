import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'resultsummary_model.dart';
export 'resultsummary_model.dart';

class ResultsummaryWidget extends StatefulWidget {
  const ResultsummaryWidget({
    super.key,
    required this.timer,
    required this.totalcorrect,
    required this.useroption,
    required this.correctoption,
    required this.position,
  });

  final String? timer;
  final int? totalcorrect;
  final List<String>? useroption;
  final List<String>? correctoption;
  final String? position;

  static String routeName = 'resultsummary';
  static String routePath = '/resultsummary';

  @override
  State<ResultsummaryWidget> createState() => _ResultsummaryWidgetState();
}

class _ResultsummaryWidgetState extends State<ResultsummaryWidget> {
  late ResultsummaryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _resultCardKey = GlobalKey();
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResultsummaryModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String get _shareText {
    final correct = widget.totalcorrect ?? 0;
    final time = widget.timer ?? '—';
    final pos = (widget.position != null && widget.position!.isNotEmpty)
        ? '  |  Position: ${widget.position}'
        : '';
    return 'I got $correct correct on the StreetPay Quiz! 🏆\n'
        'Time: $time$pos\n'
        'Play now on StreetPay! #StreetPay #StreetGame';
  }

  Future<File?> _captureCard() async {
    try {
      final boundary = _resultCardKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      final bytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/streetpay_result.png');
      await file.writeAsBytes(bytes);
      return file;
    } catch (_) {
      return null;
    }
  }

  Future<void> _shareResult() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final file = await _captureCard();
      if (file != null) {
        await Share.shareXFiles([XFile(file.path)], text: _shareText);
      } else {
        await Share.share(_shareText);
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _shareToWhatsApp() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final encoded = Uri.encodeComponent(_shareText);
      final uri = Uri.parse('https://wa.me/?text=$encoded');
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        await Share.share(_shareText);
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _shareToFacebook() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final file = await _captureCard();
      if (file != null) {
        await Share.shareXFiles([XFile(file.path)], text: _shareText);
      } else {
        await launchUrl(
          Uri.parse('https://www.facebook.com'),
          mode: LaunchMode.externalApplication,
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _shareToInstagram() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final file = await _captureCard();
      if (file != null) {
        if (!Platform.isAndroid) {
          final uri = Uri.parse(
              'instagram://library?AssetPath=${Uri.encodeComponent(file.path)}');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
            return;
          }
        }
        await Share.shareXFiles([XFile(file.path)], text: _shareText);
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _shareToTwitter() async {
    final uri = Uri.parse(
        'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(_shareText)}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _socialButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.4 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: FaIcon(icon, color: color, size: 22.0),
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.0,
                color: FlutterFlowTheme.of(context).secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () async {
                context.pushNamed(LottohomeWidget.routeName);
              },
            ),
            title: Text(
              'Quiz Results',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 2.0,
          ),
          body: SafeArea(
            top: true,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 24.0),
              child: SingleChildScrollView(
                controller: _model.columnController,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // ── Result card (wrapped for screenshot capture) ──────────
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: RepaintBoundary(
                        key: _resultCardKey,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8.0,
                                color: Color(0x20000000),
                                offset: Offset(0.0, 4.0),
                              )
                            ],
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF06A00D),
                                FlutterFlowTheme.of(context).primary
                              ],
                              stops: [0.4, 0.9],
                              begin: AlignmentDirectional(1.0, 1.0),
                              end: AlignmentDirectional(-1.0, -1.0),
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Congratulations!',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FlutterFlowTheme.of(context)
                                              .headlineMedium
                                              .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'You\'ve completed the quiz',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: Container(
                                      width: 120.0,
                                      height: 120.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 6.0,
                                            color: Color(0x20000000),
                                            offset: Offset(0.0, 3.0),
                                          )
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            (widget.totalcorrect ?? 0)
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .displayLarge
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w800,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .displayLarge
                                                            .fontStyle,
                                                  ),
                                                  color:
                                                      FlutterFlowTheme.of(context)
                                                          .primary,
                                                  fontSize: 36.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w800,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(context)
                                                          .displayLarge
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          valueOrDefault<String>(
                                            widget.totalcorrect?.toString(),
                                            '0',
                                          ),
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'Correct',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
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
                                      ].divide(SizedBox(height: 4.0)),
                                    ),
                                    Container(
                                      width: 1.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x40FFFFFF),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          valueOrDefault<String>(
                                            widget.timer,
                                            '000',
                                          ),
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'Time Spent',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
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
                                      ].divide(SizedBox(height: 4.0)),
                                    ),
                                    Container(
                                      width: 1.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x40FFFFFF),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          '850',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'Points',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
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
                                      ].divide(SizedBox(height: 4.0)),
                                    ),
                                  ],
                                ),
                                // Brand footer visible in screenshot
                                Divider(
                                  color: Color(0x40FFFFFF),
                                  thickness: 0.5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.bolt_rounded,
                                      color: Colors.white70,
                                      size: 13.0,
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      'StreetPay • Play & Win',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ].divide(SizedBox(height: 12.0)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── Question Summary ──────────────────────────────────────
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                      child: Container(
                        width: 350.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x10000000),
                              offset: Offset(0.0, 2.0),
                            )
                          ],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                child: Text(
                                  'Question Summary',
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  final questionget =
                                      widget.correctoption!.toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: questionget.length,
                                    itemBuilder: (context, questiongetIndex) {
                                      final questiongetItem =
                                          questionget[questiongetIndex];
                                      return Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 16.0),
                                        child: Container(
                                          child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Color(0x10048002),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Question   ${(questiongetIndex + 1).toString()}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleSmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                        Text(
                                                          (widget.useroption
                                                                      ?.elementAtOrNull(
                                                                          questiongetIndex)) ==
                                                                  (widget
                                                                      .correctoption
                                                                      ?.elementAtOrNull(
                                                                          questiongetIndex))
                                                              ? 'Correct'
                                                              : 'Incorrect',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: (widget
                                                                            .useroption
                                                                            ?.elementAtOrNull(
                                                                                questiongetIndex)) ==
                                                                        (widget
                                                                            .correctoption
                                                                            ?.elementAtOrNull(
                                                                                questiongetIndex))
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondary,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      valueOrDefault<String>(
                                                        FFAppState()
                                                            .listofquestion
                                                            .elementAtOrNull(
                                                                questiongetIndex),
                                                        '- - -',
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .check_circle_outlined,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .success,
                                                              size: 20.0,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                valueOrDefault<
                                                                    String>(
                                                                  widget
                                                                      .useroption
                                                                      ?.elementAtOrNull(
                                                                          questiongetIndex),
                                                                  '000',
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .success,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 8.0)),
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 12.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                        ),
                      ),
                    ),

                    // ── View history button ───────────────────────────────────
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(HistoryquizWidget.routeName);
                        },
                        text: 'View all history',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 55.0,
                          padding: EdgeInsets.all(0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          elevation: 2.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                      ),
                    ),

                    // ── Share section ─────────────────────────────────────────
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 28.0, 0.0, 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Divider(
                            color: FlutterFlowTheme.of(context).alternate,
                            thickness: 1.0,
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Share Your Results',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                          ),
                          SizedBox(height: 6.0),
                          Text(
                            'Let your friends know how you did!',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          SizedBox(height: 20.0),
                          // Primary share button
                          FFButtonWidget(
                            onPressed: _isSharing ? null : _shareResult,
                            text: _isSharing ? 'Sharing...' : 'Share Result',
                            icon: Icon(
                              Icons.share_rounded,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 55.0,
                              padding: EdgeInsets.all(0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 8.0, 0.0),
                              color: _isSharing
                                  ? FlutterFlowTheme.of(context).alternate
                                  : FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                          ),
                          SizedBox(height: 24.0),
                          // Platform icons
                          Text(
                            'Or share directly on:',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _socialButton(
                                context,
                                icon: FontAwesomeIcons.whatsapp,
                                color: const Color(0xFF25D366),
                                label: 'WhatsApp',
                                onTap: _isSharing ? null : _shareToWhatsApp,
                              ),
                              SizedBox(width: 20.0),
                              _socialButton(
                                context,
                                icon: FontAwesomeIcons.facebookF,
                                color: const Color(0xFF1877F2),
                                label: 'Facebook',
                                onTap: _isSharing ? null : _shareToFacebook,
                              ),
                              SizedBox(width: 20.0),
                              _socialButton(
                                context,
                                icon: FontAwesomeIcons.instagram,
                                color: const Color(0xFFE1306C),
                                label: 'Instagram',
                                onTap: _isSharing ? null : _shareToInstagram,
                              ),
                              SizedBox(width: 20.0),
                              _socialButton(
                                context,
                                icon: FontAwesomeIcons.xTwitter,
                                color: const Color(0xFF000000),
                                label: 'X',
                                onTap: _isSharing ? null : _shareToTwitter,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
