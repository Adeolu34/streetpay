import '/components/autodiscover_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'autodiscover1_model.dart';
export 'autodiscover1_model.dart';

class Autodiscover1Widget extends StatefulWidget {
  const Autodiscover1Widget({super.key});

  static String routeName = 'autodiscover1';
  static String routePath = '/autodiscover1';

  @override
  State<Autodiscover1Widget> createState() => _Autodiscover1WidgetState();
}

class _Autodiscover1WidgetState extends State<Autodiscover1Widget> {
  late Autodiscover1Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Autodiscover1Model());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF6F8F6),
        body: Column(
          children: [
            // ── Dark green header ─────────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF0B2018),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(26),
                  bottomRight: Radius.circular(26),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Nav row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => context.pop(),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Color(0xFF152F23),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0xFFCFE3D6),
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            'Nearby Discovery',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Feature description strip
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1D4331),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.radar_rounded,
                              color: Color(0xFF7FD472),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Find vendors & people near you',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Pay anyone around you instantly using StreetPay',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF8FB3A0),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Live indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF56B84B).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF7FD472),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Live',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF7FD472),
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

            // ── Discovery component ───────────────────────────────────────
            Expanded(
              child: wrapWithModel(
                model: _model.autodiscoverModel,
                updateCallback: () => safeSetState(() {}),
                child: const AutodiscoverWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
