import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/emptylistaccess_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'viewmyacces_model.dart';
export 'viewmyacces_model.dart';

class ViewmyaccesWidget extends StatefulWidget {
  const ViewmyaccesWidget({
    super.key,
    required this.phoneno,
  });

  final String? phoneno;

  static String routeName = 'viewmyacces';
  static String routePath = '/viewmyacces';

  @override
  State<ViewmyaccesWidget> createState() => _ViewmyaccesWidgetState();
}

class _ViewmyaccesWidgetState extends State<ViewmyaccesWidget> {
  late ViewmyaccesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  String? _loadingHostPhone;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewmyaccesModel());

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
        final authRes = await StreetauthCall.call();
        token = StreetauthCall.streettoken(authRes.jsonBody ?? '') ?? '';
      }

      final rawPhone = (widget.phoneno != null && widget.phoneno!.isNotEmpty)
          ? widget.phoneno!
          : FFAppState().phonenumber;
      final formattedPhone = functions.removecode(rawPhone) ?? rawPhone;
      final raw10 = rawPhone.length >= 10
          ? rawPhone.substring(rawPhone.length - 10)
          : rawPhone;

      _model.listhost = await ListhostprofileCall.call(
        guestphone: formattedPhone,
        accessToken: token,
      );

      var hosts = (ListhostprofileCall.hostprofile(
            (_model.listhost?.jsonBody ?? ''),
          ) ??
          []).toList().cast<String>();

      if (hosts.isEmpty && raw10.isNotEmpty) {
        final altRes = await ListhostprofileCall.call(
          guestphone: '0$raw10',
          accessToken: token,
        );
        final altHosts = (ListhostprofileCall.hostprofile(
              (altRes.jsonBody ?? ''),
            ) ??
            []).toList().cast<String>();
        if (altHosts.isNotEmpty) {
          hosts = altHosts;
          _model.listhost = altRes;
        }
      }

      FFAppState().hostprofile = hosts;
    } catch (e) {
      debugPrint('Error in Viewmyacces _refreshData: $e');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openHostTransactions(String hostPhone) async {
    setState(() {
      _loadingHostPhone = hostPhone;
    });

    try {
      String token = (FFAppState().bsptoken.isNotEmpty)
          ? FFAppState().bsptoken
          : (FFAppState().streetauth.isNotEmpty ? FFAppState().streetauth : '');
      if (token.isEmpty) {
        final authRes = await StreetauthCall.call();
        token = StreetauthCall.streettoken(authRes.jsonBody ?? '') ?? '';
      }

      final cleanHost = functions.removecode(hostPhone) ?? hostPhone;

      _model.returnprofile = await ReturntierprofileCall.call(
        phoneno: cleanHost,
        accessToken: token,
      );

      if ((_model.returnprofile?.succeeded ?? true) && mounted) {
        final accountNo = ReturntierprofileCall.accountNo(
          (_model.returnprofile?.jsonBody ?? ''),
        );
        final accountName = ReturntierprofileCall.fullname(
          (_model.returnprofile?.jsonBody ?? ''),
        );

        context.pushNamed(
          TransactionHistorybatchesWidget.routeName,
          queryParameters: {
            'accountno': serializeParam(
              accountNo,
              ParamType.String,
            ),
            'accountname': serializeParam(
              accountName,
              ParamType.String,
            ),
          }.withoutNulls,
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to load account details for this host.',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: const Color(0xFFC93B2B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error loading host transactions: $e',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: const Color(0xFFC93B2B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingHostPhone = null;
        });
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

    final hostList = FFAppState().hostprofile.toList();
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
            'Accounts Delegated to Me',
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
                                Icons.storefront_rounded,
                                color: Color(0xFF56B84B),
                                size: 20.0,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              'DELEGATED CASHIER WORKSPACES',
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
                          'Operate on Behalf of Merchants',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'These are merchant and business accounts that have designated you as an authorized cashier. You can inspect batches and review transactions recorded under their terminal.',
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
                              GrantAccessWidget.routeName,
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
                                  Icons.badge_outlined,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                                const SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    'Grant Cashier Access to Others',
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

                  const SizedBox(height: 24.0),

                  // Section Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DELEGATED ACCOUNTS (${hostList.length})'
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

                  // Host List / Empty State
                  if (hostList.isEmpty)
                    const EmptylistaccessWidget(
                      title: 'No Delegated Accounts Found',
                      message:
                          'You have not been added as a cashier to any merchant accounts yet. Once a store grants you cashier access, it will show up here.',
                      icon: Icons.storefront_outlined,
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: hostList.length,
                      itemBuilder: (context, index) {
                        final hostPhone = hostList[index];
                        final isItemLoading = _loadingHostPhone == hostPhone;

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
                              phoneno: functions.removecode(hostPhone) ?? hostPhone,
                              accessToken: (FFAppState().bsptoken.isNotEmpty)
                                  ? FFAppState().bsptoken
                                  : FFAppState().streetauth,
                            ),
                            builder: (context, snapshot) {
                              String hostName = 'Merchant ($hostPhone)';
                              if (snapshot.hasData) {
                                final name = valueOrDefault<String>(
                                  ReturntierprofileCall.fullname(
                                    snapshot.data!.jsonBody,
                                  ),
                                  '',
                                );
                                if (name.trim().isNotEmpty && name != '- - -') {
                                  hostName = name;
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
                                    child: const Center(
                                      child: Icon(
                                        Icons.store_rounded,
                                        color: Color(0xFF2F8F3C),
                                        size: 22.0,
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
                                          hostName,
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
                                              hostPhone,
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
                                                'Merchant',
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
                                  ElevatedButton(
                                    onPressed: isItemLoading
                                        ? null
                                        : () =>
                                            _openHostTransactions(hostPhone),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF0B2018),
                                      disabledBackgroundColor:
                                          const Color(0xFF0B2018)
                                              .withValues(alpha: 0.6),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 7.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: isItemLoading
                                        ? const SizedBox(
                                            width: 14.0,
                                            height: 14.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation<
                                                      Color>(Colors.white),
                                            ),
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'View',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(width: 4.0),
                                              const Icon(
                                                Icons.arrow_forward_rounded,
                                                color: Colors.white,
                                                size: 13.0,
                                              ),
                                            ],
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
