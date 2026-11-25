import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/emptylistaccess_widget.dart';
import '/components/grantaccess/grantaccess_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'grant_access_model.dart';
export 'grant_access_model.dart';

class GrantAccessWidget extends StatefulWidget {
  const GrantAccessWidget({
    super.key,
    required this.phoneno,
  });

  final String? phoneno;

  static String routeName = 'grant_access';
  static String routePath = '/grantAccess';

  @override
  State<GrantAccessWidget> createState() => _GrantAccessWidgetState();
}

class _GrantAccessWidgetState extends State<GrantAccessWidget> {
  late GrantAccessModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GrantAccessModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _refreshData();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String token = (FFAppState().bsptoken.isNotEmpty)
          ? FFAppState().bsptoken
          : (FFAppState().streetauth.isNotEmpty ? FFAppState().streetauth : '');

      if (token.isEmpty) {
        _model.streetauth = await StreetauthCall.call();
        token = StreetauthCall.streettoken(
              (_model.streetauth?.jsonBody ?? ''),
            ) ??
            '';
      }

      final rawPhone = (widget.phoneno != null && widget.phoneno!.isNotEmpty)
          ? widget.phoneno!
          : FFAppState().phonenumber;
      final formattedPhone = functions.removecode(rawPhone) ?? rawPhone;
      final raw10 = rawPhone.length >= 10
          ? rawPhone.substring(rawPhone.length - 10)
          : rawPhone;

      // Query guest profiles
      _model.guestprofile = await ListguestprofileCall.call(
        hostphone: formattedPhone,
        accessToken: token,
      );

      var guests = (ListguestprofileCall.guests(
            (_model.guestprofile?.jsonBody ?? ''),
          ) ??
          []).toList().cast<String>();

      if (guests.isEmpty && raw10.isNotEmpty) {
        final altRes = await ListguestprofileCall.call(
          hostphone: '0$raw10',
          accessToken: token,
        );
        final altGuests = (ListguestprofileCall.guests(
              (altRes.jsonBody ?? ''),
            ) ??
            []).toList().cast<String>();
        if (altGuests.isNotEmpty) {
          guests = altGuests;
          _model.guestprofile = altRes;
        }
      }

      // Query host profiles
      _model.hostprofile = await ListhostprofileCall.call(
        guestphone: formattedPhone,
        accessToken: token,
      );

      var hosts = (ListhostprofileCall.hostprofile(
            (_model.hostprofile?.jsonBody ?? ''),
          ) ??
          []).toList().cast<String>();

      if (hosts.isEmpty && raw10.isNotEmpty) {
        final altHostRes = await ListhostprofileCall.call(
          guestphone: '0$raw10',
          accessToken: token,
        );
        final altHosts = (ListhostprofileCall.hostprofile(
              (altHostRes.jsonBody ?? ''),
            ) ??
            []).toList().cast<String>();
        if (altHosts.isNotEmpty) {
          hosts = altHosts;
          _model.hostprofile = altHostRes;
        }
      }

      FFAppState().guestprofile = guests;
      FFAppState().hostprofile = hosts;
    } catch (e) {
      debugPrint('Error in GrantAccess _refreshData: $e');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmRevoke(String guestPhone, String guestName) async {
    final shouldRevoke = await showDialog<bool>(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Revoke Cashier Access?',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF0B2018),
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
            ),
          ),
          content: Text(
            'Are you sure you want to remove cashier access for $guestName ($guestPhone)? They will immediately lose access to receive payments or log sales on your account.',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF6B7F72),
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
              height: 1.4,
            ),
          ),
          actionsPadding:
              const EdgeInsets.only(right: 16.0, bottom: 16.0, top: 8.0),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertDialogContext, false),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF6B7F72),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(alertDialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
              ),
              child: Text(
                'Revoke Access',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldRevoke == true) {
      await _executeRevoke(guestPhone);
    }
  }

  Future<void> _executeRevoke(String guestPhone) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Revoking access for $guestPhone...',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF0B2018),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final rawPhone = (widget.phoneno != null && widget.phoneno!.isNotEmpty)
        ? widget.phoneno!
        : FFAppState().phonenumber;
    final hostPhone = functions.removecode(rawPhone) ?? rawPhone;
    final cleanGuest = functions.removecode(guestPhone) ?? guestPhone;

    String token = (FFAppState().bsptoken.isNotEmpty)
        ? FFAppState().bsptoken
        : (FFAppState().streetauth.isNotEmpty ? FFAppState().streetauth : '');
    if (token.isEmpty) {
      _model.streetauth = await StreetauthCall.call();
      token = StreetauthCall.streettoken(
            (_model.streetauth?.jsonBody ?? ''),
          ) ??
          '';
    }

    _model.apiResultcde = await RevokeguestCall.call(
      hostphone: hostPhone,
      guestphone: cleanGuest,
      accessToken: token,
    );

    if ((_model.apiResultcde?.succeeded ?? true)) {
      FFAppState().guestprofile.remove(guestPhone);
      safeSetState(() {});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$guestPhone has been removed successfully',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            duration: const Duration(milliseconds: 3500),
            backgroundColor: const Color(0xFF2F8F3C),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _model.apiResultcde?.responseMessage.isNotEmpty == true
                  ? _model.apiResultcde!.responseMessage
                  : 'Unable to revoke access. Please try again.',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            duration: const Duration(milliseconds: 4000),
            backgroundColor: const Color(0xFFC93B2B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final guestList = FFAppState().guestprofile.toList();
    final rawPhone = (widget.phoneno != null && widget.phoneno!.isNotEmpty)
        ? widget.phoneno!
        : FFAppState().phonenumber;
    final safeHostNo = functions.removecode(rawPhone) ?? rawPhone;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF6F8F6),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B2018),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 22.0,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Staff & Cashier Access',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 22.0,
              ),
              onPressed: _refreshData,
              tooltip: 'Refresh list',
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _refreshData,
                color: const Color(0xFF2F8F3C),
                child: SingleChildScrollView(
                  controller: _model.columnController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  // Hero informational card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0B2018), Color(0xFF163C2E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF0B2018).withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF56B84B)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const Icon(
                                Icons.shield_outlined,
                                color: Color(0xFF56B84B),
                                size: 20.0,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              'SECURE CASHIER DELEGATION',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF56B84B),
                                fontSize: 11.0,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          'Manage Sales Staff & Cashiers',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Authorize staff to receive payments and log sales under your store terminal without revealing your master wallet PIN or balance.',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFFC4D5C9),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        InkWell(
                          onTap: () {
                            context.pushNamed(
                              ViewmyaccesWidget.routeName,
                              queryParameters: {
                                'phoneno': serializeParam(
                                  safeHostNo,
                                  ParamType.String,
                                ),
                              }.withoutNulls,
                            );
                          },
                          borderRadius: BorderRadius.circular(12.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.storefront_rounded,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                                const SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    'Accounts Delegated to Me (${FFAppState().hostprofile.length})',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6.0),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 14.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18.0),

                  // Grant Access Form Component
                  wrapWithModel(
                    model: _model.grantaccessModel,
                    updateCallback: () => safeSetState(() {}),
                    child: GrantaccessWidget(
                      hostno: safeHostNo,
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // Active Cashiers Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ACTIVE CASHIERS (${guestList.length})'
                            .toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF8FA596),
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      if (_isLoading)
                        const SizedBox(
                          width: 14.0,
                          height: 14.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF2F8F3C)),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12.0),

                  // Cashier List / Empty State
                  if (guestList.isEmpty)
                    const EmptylistaccessWidget(
                      title: 'No Cashiers Added Yet',
                      message:
                          'Staff members you authorize will appear here. You can revoke their cashier access anytime with one tap.',
                      icon: Icons.badge_outlined,
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: guestList.length,
                      itemBuilder: (context, index) {
                        final guestPhone = guestList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border:
                                Border.all(color: const Color(0xFFE6EAE7)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: FutureBuilder<ApiCallResponse>(
                            future: ReturntierprofileCall.call(
                              phoneno: functions.removecode(guestPhone) ?? guestPhone,
                              accessToken: (FFAppState().bsptoken.isNotEmpty)
                                  ? FFAppState().bsptoken
                                  : StreetauthCall.streettoken(
                                      (_model.streetauth?.jsonBody ?? ''),
                                    ),
                            ),
                            builder: (context, snapshot) {
                              String cashierName = 'Staff Cashier ($guestPhone)';
                              if (snapshot.hasData) {
                                final name = valueOrDefault<String>(
                                  ReturntierprofileCall.fullname(
                                    snapshot.data?.jsonBody,
                                  ),
                                  '',
                                );
                                if (name.trim().isNotEmpty && name != '- - -') {
                                  cashierName = name;
                                }
                              }

                              return Row(
                                children: [
                                  Container(
                                    width: 44.0,
                                    height: 44.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDF7EE),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        cashierName.isNotEmpty
                                            ? cashierName[0].toUpperCase()
                                            : 'S',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF2F8F3C),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cashierName,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF0B2018),
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 3.0),
                                        Wrap(
                                          spacing: 6.0,
                                          runSpacing: 2.0,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Text(
                                              guestPhone,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                color: const Color(0xFF6B7F72),
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6.0,
                                                      vertical: 2.0),
                                              decoration: BoxDecoration(
                                                color:
                                                    const Color(0xFFE8F5E9),
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                              child: Text(
                                                'Active',
                                                style: GoogleFonts
                                                    .plusJakartaSans(
                                                  color:
                                                      const Color(0xFF2F8F3C),
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  InkWell(
                                    onTap: () => _confirmRevoke(
                                        guestPhone, cashierName),
                                    borderRadius:
                                        BorderRadius.circular(8.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 6.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEE2E2),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.delete_outline_rounded,
                                            color: Color(0xFFDC2626),
                                            size: 14.0,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            'Revoke',
                                            style:
                                                GoogleFonts.plusJakartaSans(
                                              color: const Color(0xFFDC2626),
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          // Fixed Glassmorphic Bottom Navigation Dock
          wrapWithModel(
            model: _model.bottomAppBarModel,
            updateCallback: () => safeSetState(() {}),
            child: const BottomAppBarWidget(selectedIndex: 4),
          ),
        ],
      ),
    ),
  ),
);
}
}
