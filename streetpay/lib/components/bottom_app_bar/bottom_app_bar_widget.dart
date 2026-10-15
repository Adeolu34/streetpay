import 'dart:ui';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bottom_app_bar_model.dart';
export 'bottom_app_bar_model.dart';

class BottomAppBarWidget extends StatefulWidget {
  const BottomAppBarWidget({
    super.key,
    this.selectedIndex = 0,
  });

  final int selectedIndex;

  @override
  State<BottomAppBarWidget> createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  late BottomAppBarModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BottomAppBarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = widget.selectedIndex == index;
    final activeColor = const Color(0xFF2F8F3C);
    final inactiveColor = const Color(0xFF7C8A80);
    final color = isSelected ? activeColor : inactiveColor;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          splashColor: const Color(0x1556B84B),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 21.0,
                  color: color,
                ),
                const SizedBox(height: 3.0),
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPayCenterButton() {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            context.pushNamed(
              ManualPaymentWidget.routeName,
              extra: <String, dynamic>{
                '__transition_info__': const TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.bottomToTop,
                  duration: Duration(milliseconds: 250),
                ),
              },
            );
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF0B2018),
                  borderRadius: BorderRadius.circular(14.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x380B2018),
                      blurRadius: 10.0,
                      offset: Offset(0.0, 4.0),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.near_me_rounded,
                  color: Color(0xFF7FD472),
                  size: 20.0,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                'Pay',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0B2018),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.96),
              border: const Border(
                top: BorderSide(
                  color: Color(0xFFE6EAE7),
                  width: 1.0,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 64.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. Home
                    _buildNavItem(
                      index: 0,
                      icon: Icons.home_rounded,
                      label: 'Home',
                      onTap: () async {
                        if (widget.selectedIndex != 0) {
                          _model.streetauth = await StreetauthCall.call();
                          _model.phoneno = await GetphonenCall.call(
                            accountNo: FFAppState().accountno,
                            accessToken: StreetauthCall.streettoken(
                              (_model.streetauth?.jsonBody ?? ''),
                            ),
                          );

                          context.goNamed(
                            NewhomeWidget.routeName,
                            extra: <String, dynamic>{
                              '__transition_info__': const TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 0),
                              ),
                            },
                          );
                        }
                      },
                    ),

                    // 2. Bills
                    _buildNavItem(
                      index: 1,
                      icon: Icons.receipt_long_rounded,
                      label: 'Bills',
                      onTap: () {
                        if (widget.selectedIndex != 1) {
                          context.goNamed(
                            BillnewWidget.routeName,
                            extra: <String, dynamic>{
                              '__transition_info__': const TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 0),
                              ),
                            },
                          );
                        }
                      },
                    ),

                    // 3. Floating Pay (Center)
                    _buildPayCenterButton(),

                    // 4. History / Activity
                    _buildNavItem(
                      index: 3,
                      icon: Icons.access_time_rounded,
                      label: 'Activity',
                      onTap: () {
                        context.pushNamed(
                          TransactionHistoryWidget.routeName,
                          queryParameters: {
                            'accountno': serializeParam(
                              FFAppState().accountno,
                              ParamType.String,
                            ),
                            'accountname': serializeParam(
                              FFAppState().accountname,
                              ParamType.String,
                            ),
                          }.withoutNulls,
                          extra: <String, dynamic>{
                            '__transition_info__': const TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                              duration: Duration(milliseconds: 0),
                            ),
                          },
                        );
                      },
                    ),

                    // 5. Me / Profile
                    _buildNavItem(
                      index: 4,
                      icon: Icons.person_outline_rounded,
                      label: 'Me',
                      onTap: () {
                        context.pushNamed(
                          ProfileWidget.routeName,
                          extra: <String, dynamic>{
                            '__transition_info__': const TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                              duration: Duration(milliseconds: 0),
                            ),
                          },
                        );
                      },
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
