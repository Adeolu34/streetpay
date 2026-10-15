import '/backend/api_requests/api_calls.dart';
import '/components/emptylistdiscovery_widget.dart';
import '/components/noresultfound_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'autodiscover_model.dart';
export 'autodiscover_model.dart';

class AutodiscoverWidget extends StatefulWidget {
  const AutodiscoverWidget({super.key});

  @override
  State<AutodiscoverWidget> createState() => _AutodiscoverWidgetState();
}

class _AutodiscoverWidgetState extends State<AutodiscoverWidget>
    with TickerProviderStateMixin {
  late AutodiscoverModel _model;
  LatLng? currentUserLocationValue;
  bool _isScanning = false;
  bool _isAccountLookup = false;
  bool _isSearching = false;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AutodiscoverModel());
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _scanNearby() async {
    if (_isScanning) return;
    setState(() => _isScanning = true);
    HapticFeedback.mediumImpact();
    try {
      currentUserLocationValue = await getCurrentUserLocation(
        defaultLocation: const LatLng(0.0, 0.0),
      );
      _model.location2 = await actions.getlocationpermission();
      _model.getlocation = await LocationdetectCall.call(
        phoneno: functions.removecode(FFAppState().phonenumber),
        lat: functions.getlat(currentUserLocationValue),
        longi: functions.getlang(currentUserLocationValue),
        accessToken: FFAppState().bsptoken,
      );
      FFAppState().connectionoff = true;
      final data = LocationdetectCall.fulldata(
        (_model.getlocation?.jsonBody ?? ''),
      );
      if (data != null) {
        FFAppState().discoveredphone = data.toList().cast<dynamic>();
      }
    } catch (_) {}
    if (mounted) setState(() => _isScanning = false);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF6F8F6),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD6DDD8),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF7EE),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.radar_rounded,
                    color: Color(0xFF2F8F3C),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find Nearby',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF101614),
                      ),
                    ),
                    Text(
                      'StreetPay users around you',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6E7A72),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tab bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE6EAE7)),
              ),
              child: TabBar(
                controller: _model.tabBarController,
                indicator: BoxDecoration(
                  color: const Color(0xFF0B2018),
                  borderRadius: BorderRadius.circular(11),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelPadding: EdgeInsets.zero,
                padding: const EdgeInsets.all(3),
                tabs: [
                  _buildTabLabel(Icons.near_me_rounded, 'Nearby', 0),
                  _buildTabLabel(Icons.search_rounded, 'Search', 1),
                ],
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Tab content
          SizedBox(
            height: 460,
            child: TabBarView(
              controller: _model.tabBarController,
              children: [
                _buildNearbyTab(),
                _buildSearchTab(),
              ],
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTabLabel(IconData icon, String label, int index) {
    final selected = (_model.tabBarController?.index ?? 0) == index;
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 15,
            color: selected ? Colors.white : const Color(0xFF6E7A72),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : const Color(0xFF6E7A72),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Nearby Tab ───────────────────────────────────────────────────────────

  Widget _buildNearbyTab() {
    final hasScan = FFAppState().connectionoff;
    final discovered = FFAppState().discoveredphone;

    if (!hasScan) return _buildScanPrompt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: _buildRefreshBar(discovered.length),
        ),
        if (discovered.isEmpty)
          const Expanded(child: EmptylistdiscoveryWidget())
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              itemCount: discovered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = discovered[index];
                if (item == null) return const SizedBox.shrink();
                final itemAccountNo =
                    getJsonField(item, r'''$.AccountNo''')?.toString() ?? '—';
                final isSelf = itemAccountNo == FFAppState().accountno;
                final userCard = _buildUserCard(
                  name: getJsonField(item, r'''$.Othernames''')?.toString() ??
                      'StreetPay User',
                  accountNo: itemAccountNo,
                  onTap: isSelf
                      ? () {}
                      : () {
                          context.pushNamed(
                            PaymentWidget.routeName,
                            queryParameters: {
                              'walletBalance': serializeParam(
                                  FFAppState().avalbal, ParamType.String),
                              'receiveraccountname': serializeParam(
                                getJsonField(item, r'''$.Othernames''')
                                    .toString(),
                                ParamType.String,
                              ),
                              'receiveraccountnumber': serializeParam(
                                itemAccountNo,
                                ParamType.String,
                              ),
                              'receiverbankname':
                                  serializeParam('StreetPay', ParamType.String),
                              'sender': serializeParam(
                                  FFAppState().accountname, ParamType.String),
                              'senderaccountnumber': serializeParam(
                                  FFAppState().accountno, ParamType.String),
                              'sendersbank':
                                  serializeParam('StreetPay', ParamType.String),
                              'phoneno': serializeParam(
                                functions.addcode(FFAppState().phonenumber),
                                ParamType.String,
                              ),
                            }.withoutNulls,
                          );
                        },
                );
                if (isSelf) {
                  return Column(
                    children: [userCard, _selfTransferBanner()],
                  );
                }
                return userCard;
              },
            ),
          ),
      ],
    );
  }

  Widget _buildScanPrompt() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF7EE),
              borderRadius: BorderRadius.circular(26),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.radar_rounded,
                color: Color(0xFF56B84B), size: 44),
          ),
          const SizedBox(height: 18),
          Text(
            'Discover nearby users',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF101614),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find verified StreetPay users around you and send money instantly.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6E7A72),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _isScanning ? null : _scanNearby,
              icon: _isScanning
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.white),
                    )
                  : const Icon(Icons.near_me_rounded,
                      size: 18, color: Color(0xFF06210F)),
              label: Text(
                _isScanning ? 'Scanning...' : 'Find Nearby Users',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _isScanning ? Colors.white : const Color(0xFF06210F),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF56B84B),
                disabledBackgroundColor: const Color(0xFF56B84B).withValues(alpha: 0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshBar(int count) {
    return Row(
      children: [
        Text(
          count == 0
              ? 'No users found nearby'
              : '$count user${count == 1 ? '' : 's'} nearby',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF6E7A72),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: _isScanning ? null : _scanNearby,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF7EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _isScanning
                    ? const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Color(0xFF2F8F3C)),
                      )
                    : const Icon(Icons.refresh_rounded,
                        size: 14, color: Color(0xFF2F8F3C)),
                const SizedBox(width: 5),
                Text(
                  _isScanning ? 'Scanning' : 'Refresh',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2F8F3C),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Search Tab ───────────────────────────────────────────────────────────

  Widget _buildSearchTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE6EAE7)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x05000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: _model.textController,
              focusNode: _model.textFieldFocusNode,
              onChanged: (val) {
                // Show searching immediately when user types something
                safeSetState(() {
                  _isSearching = val.trim().isNotEmpty;
                  if (val.trim().isEmpty) FFAppState().searchid = false;
                });
                EasyDebounce.debounce(
                  '_model.textController',
                  const Duration(milliseconds: 1200),
                  () async {
                    final input = _model.textController.text.trim();
                    if (input.isEmpty) {
                      safeSetState(() => _isSearching = false);
                      return;
                    }
                    final isAcctNo = RegExp(r'^\d{10}$').hasMatch(input);

                    if (isAcctNo) {
                      // Account number lookup — resolve via walletEnquiry
                      safeSetState(() => _isAccountLookup = true);
                      _model.walletEnquiryResult =
                          await WalletAsAServiceGroup.walletEnquiryCall.call(
                        accountNo: input,
                        authToken: FFAppState().bsptoken,
                      );
                      final name = WalletAsAServiceGroup.walletEnquiryCall
                          .accountname(_model.walletEnquiryResult?.jsonBody ?? '');
                      FFAppState().searchid =
                          (name != null && name.trim().isNotEmpty);
                    } else {
                      // Wallet ID lookup
                      safeSetState(() => _isAccountLookup = false);
                      _model.streetaut = await StreetauthCall.call();
                      _model.retrievewallet =
                          await RetriveaccountfromwalletidCall.call(
                        accessToken: FFAppState().bsptoken,
                        walletid: input,
                      );
                      FFAppState().searchid =
                          RetriveaccountfromwalletidCall.success(
                                (_model.retrievewallet?.jsonBody ?? ''),
                              ) ==
                              true;
                    }
                    safeSetState(() => _isSearching = false);
                  },
                );
              },
              decoration: InputDecoration(
                hintText: 'Enter Wallet ID or Account No',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: const Color(0xFF9EAAA0),
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: Color(0xFF9EAAA0), size: 20),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
              ),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF101614),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final query = _model.textController?.text ?? '';

    if (_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFF56B84B)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Searching...',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF56B84B),
              ),
            ),
          ],
        ),
      );
    }

    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F2),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.manage_search_rounded,
                  color: Color(0xFFB0BDB5), size: 32),
            ),
            const SizedBox(height: 14),
            Text(
              'Find a StreetPay user',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9EAAA0),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Search by Wallet ID or enter a 10-digit account number',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFB0BDB5),
              ),
            ),
          ],
        ),
      );
    }

    if (FFAppState().searchid) {
      String fullName;
      String accountNo;

      if (_isAccountLookup) {
        // Account number path — resolved via walletEnquiry
        final rawName = WalletAsAServiceGroup.walletEnquiryCall
                .accountname(_model.walletEnquiryResult?.jsonBody ?? '') ??
            '';
        fullName = functions.stripSlash(rawName);
        accountNo = query; // the 10-digit number the user typed
      } else {
        // Wallet ID path
        final surname = RetriveaccountfromwalletidCall.surname(
                (_model.retrievewallet?.jsonBody ?? '')) ??
            '';
        final othername = RetriveaccountfromwalletidCall.othername(
                (_model.retrievewallet?.jsonBody ?? '')) ??
            '';
        fullName = '$surname $othername'.trim();
        accountNo = RetriveaccountfromwalletidCall.accountno(
                (_model.retrievewallet?.jsonBody ?? '')) ??
            '—';
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Search result',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6E7A72),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF7EE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _isAccountLookup ? 'Account No' : 'Wallet ID',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2F8F3C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildUserCard(
            name: fullName.isEmpty ? 'StreetPay User' : fullName,
            accountNo: accountNo,
            onTap: accountNo == FFAppState().accountno
                ? () {}
                : () {
              context.pushNamed(
                PaymentWidget.routeName,
                queryParameters: {
                  'walletBalance':
                      serializeParam(FFAppState().avalbal, ParamType.String),
                  'receiveraccountname':
                      serializeParam(fullName, ParamType.String),
                  'receiveraccountnumber':
                      serializeParam(accountNo, ParamType.String),
                  'receiverbankname':
                      serializeParam('StreetPay', ParamType.String),
                  'sender': serializeParam(
                      FFAppState().accountname, ParamType.String),
                  'senderaccountnumber':
                      serializeParam(FFAppState().accountno, ParamType.String),
                  'sendersbank':
                      serializeParam('StreetPay', ParamType.String),
                  'phoneno': serializeParam(
                    functions.addcode(FFAppState().phonenumber),
                    ParamType.String,
                  ),
                }.withoutNulls,
              );
            },
          ),
          if (accountNo == FFAppState().accountno) _selfTransferBanner(),
        ],
      );
    }

    return wrapWithModel(
      model: _model.noresultfoundModel,
      updateCallback: () => safeSetState(() {}),
      child: const NoresultfoundWidget(),
    );
  }

  // ─── Shared User Card ─────────────────────────────────────────────────────

  Widget _selfTransferBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.block_rounded, color: Color(0xFFD32F2F), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'You cannot transfer to your own account.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFD32F2F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard({
    required String name,
    required String accountNo,
    required VoidCallback onTap,
  }) {
    final words = name.trim().split(' ').where((w) => w.isNotEmpty).toList();
    final initials = words
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    const avatarColors = [
      Color(0xFF1D4331),
      Color(0xFF2C6045),
      Color(0xFF1A5C38),
      Color(0xFF0B3D26),
      Color(0xFF2F8F3C),
    ];
    final avatarColor = avatarColors[name.length % avatarColors.length];

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6EAE7)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: avatarColor,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                initials.isEmpty ? 'SP' : initials,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Name + account
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF101614),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        accountNo,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6E7A72),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF7EE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'StreetPay',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2F8F3C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Send CTA
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF0B2018),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.send_rounded,
                color: Color(0xFF7FD472),
                size: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
