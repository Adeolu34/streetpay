import '/backend/api_requests/api_calls.dart';
import '/components/errorcomp_widget.dart';
import '/components/sucesss_widget.dart';
import '/components/transerconfirm_widget.dart';
import '/services/beneficiary_service.dart';
import '/services/bank_logo_service.dart';
import '/services/account_lookup_service.dart';
import '/services/bank_detection_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '/config/secrets.dart';
import 'manual_payment_model.dart';
export 'manual_payment_model.dart';

enum _VoiceStage { idle, recording, reviewing, extracting }

class ManualPaymentWidget extends StatefulWidget {
  const ManualPaymentWidget({
    super.key,
    this.prefillAccountNumber,
  });

  final String? prefillAccountNumber;

  static String routeName = 'ManualPayment';
  static String routePath = '/manualPayment';

  @override
  State<ManualPaymentWidget> createState() => _ManualPaymentWidgetState();
}

class _ManualPaymentWidgetState extends State<ManualPaymentWidget> {
  late ManualPaymentModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _userSelectedBankManually = false;
  final Map<String, String> _resolvedBankNames = {};
  List<BeneficiaryItem> _cachedBeneficiaries = [];
  List<BeneficiaryItem> _filteredSuggestions = [];
  bool _showSuggestionFeed = false;
  bool _hasNetworkError = false;
  bool _sessionExpired = false;
  int _lookupRetryCount = 0;
  static const int _maxLookupRetries = 4;
  int _beneficiaryTabIndex = 0; // 0 = Recents, 1 = Favourites
  String _beneficiarySearchQuery = '';
  bool _showBeneficiarySearch = false;
  int _accountLookupSession = 0;

  _VoiceStage _voiceStage = _VoiceStage.idle;
  final AudioRecorder _voiceRecorder = AudioRecorder();
  final AudioPlayer _voicePlayer = AudioPlayer();
  String? _voiceAudioPath;
  int _voiceRecordSecs = 0;
  Timer? _voiceRecordTimer;
  bool _isVoicePlaying = false;
  Duration _voicePosition = Duration.zero;
  Duration _voiceDuration = Duration.zero;
  StreamSubscription? _voicePlayerStateSub;
  StreamSubscription? _voicePlayerDurationSub;
  StreamSubscription? _voicePlayerPositionSub;
  StreamSubscription? _voicePlayerCompleteSub;
  bool _isTranscribingVoice = false;
  final TextEditingController _transcriptCtrl = TextEditingController();
  String? _voiceError;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ManualPaymentModel());

    // Audio player event listeners for voice transfer playback
    _voicePlayerStateSub = _voicePlayer.onPlayerStateChanged.listen((state) {
      if (mounted) safeSetState(() => _isVoicePlaying = state == PlayerState.playing);
    });
    _voicePlayerDurationSub = _voicePlayer.onDurationChanged.listen((dur) {
      if (mounted) safeSetState(() => _voiceDuration = dur);
    });
    _voicePlayerPositionSub = _voicePlayer.onPositionChanged.listen((pos) {
      if (mounted) safeSetState(() => _voicePosition = pos);
    });
    _voicePlayerCompleteSub = _voicePlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        safeSetState(() {
          _isVoicePlaying = false;
          _voicePosition = Duration.zero;
        });
      }
    });

    // Load beneficiaries for live suggestion matching
    BeneficiaryService.getRecentBeneficiaries().then((list) {
      if (mounted) {
        setState(() {
          _cachedBeneficiaries = list;
        });
      }
    });

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.banklist = await WalletAsAServiceGroup.getBankListCall.call(
        authToken: FFAppState().bsptoken,
      );

      final bankListRaw = WalletAsAServiceGroup.getBankListCall
          .bankname(_model.banklist?.jsonBody ?? '');
      if (bankListRaw != null) {
        FFAppState().bankname =
            bankListRaw.toSet().toList().cast<String>();
      }
      FFAppState().allbankjson = WalletAsAServiceGroup.getBankListCall.data(
        (_model.banklist?.jsonBody ?? ''),
      );
      safeSetState(() {});
      if (!mounted) return;
      _model.bottoncolor = FlutterFlowTheme.of(context).primaryBackground;
      safeSetState(() {});

      // Handle deep-linked / clipboard pre-filled account number
      if (widget.prefillAccountNumber != null &&
          widget.prefillAccountNumber!.isNotEmpty) {
        final clean = widget.prefillAccountNumber!.replaceAll(RegExp(r'\D'), '');
        if (clean.isNotEmpty) {
          final toPaste = clean.length > 10 ? clean.substring(0, 10) : clean;
          _model.textController1?.text = toPaste;
          safeSetState(() {});
          if (toPaste.length == 10) {
            await _handleAccountNumberChanged(toPaste);
          }
        }
      }

      // Fetch wallet balance once on page entry (eliminates runaway 5s polling loop)
      _model.wallatbalance = await GetaccountbalanceCall.call(
        phone: FFAppState().phonenumber,
        accessToken: FFAppState().bsptoken,
      );
      if (mounted) {
        final avalBal = GetaccountbalanceCall.avalbal(
          (_model.wallatbalance?.jsonBody ?? ''),
        );
        if (avalBal != null) {
          FFAppState().avalbal = avalBal.toString();
        }
        safeSetState(() {});
      }
    });

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(text: _model.accountname);
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.dropDownValueController ??= FormFieldController<String>(null);
  }

  void _updateSuggestions(String query) {
    final clean = query.trim();
    if (clean.isEmpty || clean.length == 10) {
      if (_showSuggestionFeed) {
        setState(() {
          _showSuggestionFeed = false;
          _filteredSuggestions = [];
        });
      }
      return;
    }

    final matches = _cachedBeneficiaries.where((b) {
      return b.accountNumber.contains(clean) ||
          b.accountName.toLowerCase().contains(clean.toLowerCase());
    }).toList();

    setState(() {
      _filteredSuggestions = matches;
      _showSuggestionFeed = matches.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _voiceRecordTimer?.cancel();
    _voicePlayerStateSub?.cancel();
    _voicePlayerDurationSub?.cancel();
    _voicePlayerPositionSub?.cancel();
    _voicePlayerCompleteSub?.cancel();
    _voicePlayer.dispose();
    _voiceRecorder.dispose();
    _transcriptCtrl.dispose();
    _model.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'SP';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  static final Map<String, String> _dropdownMatchCache = {};

  String? _findMatchingDropdownBank(String candidate) {
    if (candidate.trim().isEmpty) return null;
    final clean = candidate.trim().toLowerCase();
    if (_dropdownMatchCache.containsKey(clean)) {
      return _dropdownMatchCache[clean];
    }
    for (final b in FFAppState().bankname) {
      final bClean = b.trim().toLowerCase();
      if (bClean == clean ||
          (clean.contains('opay') && bClean.contains('opay')) ||
          (clean.contains('palmpay') && bClean.contains('palmpay')) ||
          (clean.contains('moniepoint') && bClean.contains('moniepoint')) ||
          (clean.contains('kuda') && bClean.contains('kuda')) ||
          ((clean.contains('gtb') || clean.contains('guaranty')) &&
              (bClean.contains('gtb') || bClean.contains('guaranty'))) ||
          (clean.contains('zenith') && bClean.contains('zenith')) ||
          (clean.contains('access') && bClean.contains('access')) ||
          ((clean.contains('uba') || clean.contains('united bank for africa')) &&
              (bClean.contains('uba') || bClean.contains('united bank'))) ||
          bClean.contains(clean) || clean.contains(bClean)) {
        _dropdownMatchCache[clean] = b;
        return b;
      }
    }
    return null;
  }

  Future<void> _resolveAccount({String? bankCodeOverride, String? bankNameOverride}) async {
    final acct = _model.textController1?.text.trim() ?? '';
    if (acct.length != 10) return;

    final bCode = bankCodeOverride ?? _model.bankcode;
    if (bCode == null || bCode.isEmpty) return;

    final currentSession = _accountLookupSession;

    // Check fast in-memory cache first (0ms response)
    final cachedName = AccountLookupService.getCachedAccountName(acct, bCode);
    if (cachedName != null && cachedName.isNotEmpty) {
      if (mounted && currentSession == _accountLookupSession) {
        safeSetState(() {
          _model.accountname = cachedName;
          _model.isResolvingAccount = false;
          _hasNetworkError = false;
          _resolvedBankNames[bCode] = cachedName;
        });
      }
      return;
    }

    if (mounted) {
      safeSetState(() {
        _model.isResolvingAccount = true;
        _hasNetworkError = false;
      });
    }

    try {
      final name = await AccountLookupService.resolveAccountName(
        accountNumber: acct,
        bankCode: bCode,
      );
      if (!mounted || currentSession != _accountLookupSession) return;

      safeSetState(() {
        _model.isResolvingAccount = false;
        _hasNetworkError = false;
        if (name != null && name.trim().isNotEmpty) {
          _model.accountname = name.trim();
          _resolvedBankNames[bCode] = name.trim();
          _lookupRetryCount = 0; // success — reset retry counter
        } else {
          _scheduleLookupRetry(); // got response but no name — retry
        }
      });
    } on SessionExpiredException {
      if (mounted && currentSession == _accountLookupSession) {
        safeSetState(() {
          _model.isResolvingAccount = false;
          _sessionExpired = true;
        });
      }
    } catch (e) {
      if (mounted && currentSession == _accountLookupSession) {
        final isNetworkError = e.toString().toLowerCase().contains('socket') ||
            e.toString().toLowerCase().contains('timeout') ||
            e.toString().toLowerCase().contains('connection');
        safeSetState(() {
          _model.isResolvingAccount = false;
          _hasNetworkError = isNetworkError;
        });
        _scheduleLookupRetry(); // network/server error — retry with backoff
      }
    }
  }

  void _scheduleLookupRetry() {
    if (_lookupRetryCount >= _maxLookupRetries) return;
    final delay = Duration(seconds: [4, 8, 15, 25][_lookupRetryCount.clamp(0, 3)]);
    _lookupRetryCount++;
    Future.delayed(delay, () {
      if (!mounted) return;
      final acct = _model.textController1?.text.trim() ?? '';
      final code = _model.bankcode;
      if (acct.length != 10 || code == null || code.isEmpty) return;
      if (_model.accountname != null && _model.accountname!.isNotEmpty) return;
      _resolveAccount();
    });
  }

  void _onBankSelected(String bankName, {String? bankCode, String? accountName}) async {
    final bName = bankName.trim();
    if (bName.isEmpty) return;

    // Advance session to cancel any background probe in-flight
    _accountLookupSession++;

    final resolvedCode = (bankCode != null && bankCode.trim().isNotEmpty)
        ? AccountLookupService.normalizeBankCode(bankCode.trim())
        : BankDetectionService.findBankCodeByName(bName, allBankJson: FFAppState().allbankjson);

    final acct = _model.textController1?.text.trim() ?? '';
    final cachedName = AccountLookupService.getCachedAccountName(acct, resolvedCode);

    final resolvedAcctName = (accountName != null && accountName.trim().isNotEmpty)
        ? accountName.trim()
        : (_resolvedBankNames[resolvedCode] ?? cachedName ?? '');

    safeSetState(() {
      _userSelectedBankManually = true;
      _model.dropDownValue = bName;
      _model.dropDownValueController?.value = bName;
      _model.bankcode = resolvedCode;
      _model.smart = null;
      _model.isSearchingBanks = false;
      if (resolvedAcctName.isNotEmpty) {
        _model.accountname = resolvedAcctName;
        _resolvedBankNames[resolvedCode] = resolvedAcctName;
      } else {
        _model.accountname = null;
      }
    });

    if (acct.length == 10 && resolvedAcctName.isEmpty) {
      await _resolveAccount(
        bankCodeOverride: resolvedCode,
        bankNameOverride: bName,
      );
    }
  }

  void _selectSuggestedBank(Map<dynamic, dynamic> suggestion) async {
    final bName = suggestion['bank_name']?.toString() ??
        suggestion['bankName']?.toString() ??
        '';
    final bCode = suggestion['bank_code']?.toString() ??
        suggestion['bankCode']?.toString() ??
        '';
    final acctName = suggestion['account_name']?.toString() ??
        suggestion['accountName']?.toString() ??
        '';
    _onBankSelected(bName, bankCode: bCode, accountName: acctName);
  }

  void _showBankPickerBottomSheet() {
    FocusScope.of(context).unfocus();
    final allBanks = BankDetectionService.getAllSupportedBankNames(
      dynamicBankNames: FFAppState().bankname,
    );
    const popularBankNames = [
      'StreetPay',
      'OPay',
      'PalmPay',
      'Moniepoint MFB',
      'Kuda Bank',
      'Guaranty Trust Bank',
      'Access Bank',
      'Zenith Bank',
      'United Bank For Africa',
      'First Bank of Nigeria',
    ];

    final candidateBanks = (_model.smart != null && _model.smart!.isNotEmpty)
        ? _model.smart!.cast<Map<dynamic, dynamic>>()
        : <Map<dynamic, dynamic>>[];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final query = searchQuery.trim().toLowerCase();
            final filtered = query.isEmpty
                ? allBanks
                : allBanks.where((b) {
                    final lower = b.toLowerCase();
                    if (lower.contains(query)) return true;
                    if (query.contains('street') && lower.contains('streetpay')) return true;
                    if (query.contains('pay') && lower.contains('streetpay')) return true;
                    if (query.contains('9psb') && lower.contains('streetpay')) return true;
                    if (query.contains('streetpay') && lower.contains('9psb')) return true;
                    return false;
                  }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              decoration: const BoxDecoration(
                color: Color(0xFFF6F8F6),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Drag Handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6DDD8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header with X on left and Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded, color: Color(0xFF101614), size: 24),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Select Bank',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF101614),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: TextField(
                      autofocus: false,
                      onChanged: (val) => setModalState(() => searchQuery = val),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF101614),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search Bank (e.g. StreetPay, OPay, GTB)',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF9EABA2),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF6E7A72), size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF56B84B), width: 1.5),
                        ),
                      ),
                    ),
                  ),

                  // Virtualized Content (High Performance CustomScrollView with Slivers)
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        const SliverToBoxAdapter(child: SizedBox(height: 6)),

                        // SECTION 1: MATCHED BANK
                        if (searchQuery.trim().isEmpty && candidateBanks.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                                    child: Text(
                                      'Matched Bank',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF101614),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFFE6EAE7)),
                                    ),
                                    child: Row(
                                      children: [
                                        for (final cand in candidateBanks.take(2))
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(ctx);
                                                _selectSuggestedBank(cand);
                                              },
                                              borderRadius: BorderRadius.circular(12),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                                child: Column(
                                                  children: [
                                                    BankLogoWidget(
                                                      bankName: cand['bank_name']?.toString() ??
                                                          cand['bankName']?.toString() ??
                                                          '',
                                                      size: 42,
                                                      borderRadius: 21,
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      cand['bank_name']?.toString() ??
                                                          cand['bankName']?.toString() ??
                                                          '',
                                                      style: GoogleFonts.plusJakartaSans(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w700,
                                                        color: const Color(0xFF101614),
                                                      ),
                                                      textAlign: TextAlign.center,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ],

                        // SECTION 2: FREQUENTLY USED BANK (3-column grid)
                        if (searchQuery.trim().isEmpty) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Frequently Used Bank',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF101614),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFFE6EAE7)),
                                    ),
                                    child: GridView.count(
                                      crossAxisCount: 3,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 8,
                                      childAspectRatio: 0.95,
                                      children: popularBankNames.map((name) {
                                        final isSelected = _model.dropDownValue == name;
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pop(ctx);
                                            _onBankSelected(name);
                                          },
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                            decoration: BoxDecoration(
                                              color: isSelected ? const Color(0xFFEDF7EE) : Colors.transparent,
                                              borderRadius: BorderRadius.circular(12),
                                              border: isSelected
                                                  ? Border.all(color: const Color(0xFF56B84B), width: 1.5)
                                                  : null,
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                BankLogoWidget(bankName: name, size: 38, borderRadius: 19),
                                                const SizedBox(height: 6),
                                                Text(
                                                  name,
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 11,
                                                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                                    color: isSelected ? const Color(0xFF1B5E20) : const Color(0xFF101614),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ],

                        // SECTION 3: ALL BANKS LIST HEADER
                        if (searchQuery.trim().isEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child: Text(
                                'All Banks',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF101614),
                                ),
                              ),
                            ),
                          ),

                        if (filtered.isEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: Text(
                                  'No banks found matching "$searchQuery"',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF6E7A72),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, idx) {
                                  final b = filtered[idx];
                                  final isSelected = _model.dropDownValue == b;
                                  final isFirst = idx == 0;
                                  final isLast = idx == filtered.length - 1;

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                        top: isFirst ? const Radius.circular(16) : Radius.zero,
                                        bottom: isLast ? const Radius.circular(16) : Radius.zero,
                                      ),
                                      border: Border(
                                        left: const BorderSide(color: Color(0xFFE6EAE7)),
                                        right: const BorderSide(color: Color(0xFFE6EAE7)),
                                        top: isFirst ? const BorderSide(color: Color(0xFFE6EAE7)) : BorderSide.none,
                                        bottom: isLast
                                            ? const BorderSide(color: Color(0xFFE6EAE7))
                                            : const BorderSide(color: Color(0xFFF0F4F1)),
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(ctx);
                                          _onBankSelected(b);
                                        },
                                        borderRadius: BorderRadius.vertical(
                                          top: isFirst ? const Radius.circular(16) : Radius.zero,
                                          bottom: isLast ? const Radius.circular(16) : Radius.zero,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                          child: Row(
                                            children: [
                                              BankLogoWidget(bankName: b, size: 32, borderRadius: 16),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  b,
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 13.5,
                                                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                                    color: isSelected ? const Color(0xFF1B5E20) : const Color(0xFF101614),
                                                  ),
                                                ),
                                              ),
                                              if (isSelected)
                                                const Icon(Icons.check_circle_rounded, color: Color(0xFF2F8F3C), size: 20)
                                              else
                                                const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFC0CCC2), size: 13),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                childCount: filtered.length,
                              ),
                            ),
                          ),
                        const SliverToBoxAdapter(child: SizedBox(height: 32)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleAccountNumberChanged(String val) async {
    final cleanAcct = val.trim();
    if (cleanAcct.length != 10) {
      _accountLookupSession++; // aborts any pending background probes
      if (_model.smart != null && _model.smart!.isNotEmpty) {
        safeSetState(() {
          _model.smart = null;
          _model.isSearchingBanks = false;
        });
      }
      if (_model.accountname != null && _model.accountname!.isNotEmpty) {
        safeSetState(() => _model.accountname = null);
      }
      return;
    }

    final session = ++_accountLookupSession;

    // 1. If user already selected a bank, do NOT overwrite it! Resolve account directly.
    if (_model.bankcode != null && _model.bankcode!.isNotEmpty) {
      await _resolveAccount();
      return;
    }

    // 2. If a bank name is selected in dropdown/picker but bankcode is missing, resolve it now:
    if (_model.dropDownValue != null && _model.dropDownValue!.isNotEmpty) {
      final code = BankDetectionService.findBankCodeByName(
        _model.dropDownValue!,
        allBankJson: FFAppState().allbankjson,
      );
      if (code.isNotEmpty) {
        _model.bankcode = code;
        await _resolveAccount();
        return;
      }
    }

    // 3. Fast candidate cache hit (0ms — zero background network overhead)
    final cachedResolved = BankDetectionService.getCandidateCache(cleanAcct);
    if (cachedResolved != null && cachedResolved.isNotEmpty) {
      final updatedList = cachedResolved.map((c) => c.toMap()).toList();
      safeSetState(() {
        _model.smart = updatedList;
        _model.isSearchingBanks = false;
      });
      return;
    }

    // 4. Otherwise (no bank selected yet), intelligently predict candidate banks using CBN NUBAN & phone heuristics
    final predicted = BankDetectionService.predictCandidateBanks(cleanAcct);
    final candidateMaps = predicted.map((c) {
      final map = c.toMap();
      final cachedName = AccountLookupService.getCachedAccountName(cleanAcct, c.code);
      if (cachedName != null && cachedName.isNotEmpty) {
        map['account_name'] = cachedName;
        map['accountName'] = cachedName;
        map['is_verified'] = true;
      } else if (_resolvedBankNames.containsKey(c.code)) {
        map['account_name'] = _resolvedBankNames[c.code];
        map['accountName'] = _resolvedBankNames[c.code];
        map['is_verified'] = true;
      }
      return map;
    }).toList();

    safeSetState(() {
      _model.smart = candidateMaps;
      _model.isSearchingBanks = true;
      _hasNetworkError = false;
    });

    // Concurrently probe ONLY top 2 candidates (reduces network requests from 8 down to 2-4)
    try {
      final resolved = await BankDetectionService.detectAndResolveBank(
        cleanAcct,
        authToken: FFAppState().bsptoken,
        maxProbes: 2,
      );

      if (!mounted || session != _accountLookupSession) return;

      // If the user manually selected a bank during async probe, do NOT overwrite their selection!
      if (_userSelectedBankManually && _model.bankcode != null && _model.bankcode!.isNotEmpty) {
        return;
      }

      if (resolved.isNotEmpty) {
        for (final cand in resolved) {
          if (cand.accountName != null && cand.accountName!.isNotEmpty) {
            _resolvedBankNames[cand.code] = cand.accountName!;
          }
        }

        final updatedList = resolved.map((c) => c.toMap()).toList();

        safeSetState(() {
          _model.smart = updatedList;
          _model.isSearchingBanks = false;
        });
      } else {
        safeSetState(() {
          _model.isSearchingBanks = false;
        });
      }
    } catch (_) {
      if (mounted && session == _accountLookupSession) {
        safeSetState(() {
          _model.isSearchingBanks = false;
        });
      }
    }
  }

  String _fmtDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _toggleVoiceInput() async {
    if (_voiceStage == _VoiceStage.idle) {
      await _startVoiceRecording();
    } else if (_voiceStage == _VoiceStage.recording) {
      await _stopVoiceRecording();
    } else if (_voiceStage == _VoiceStage.reviewing) {
      await _voicePlayer.stop();
      safeSetState(() {
        _voiceStage = _VoiceStage.idle;
        _voiceError = null;
      });
    }
  }

  Future<void> _startVoiceRecording() async {
    try {
      await _voicePlayer.stop();
      _voiceRecordTimer?.cancel();
      _transcriptCtrl.clear();
      _voiceAudioPath = null;
      _voiceRecordSecs = 0;
      _voicePosition = Duration.zero;
      _voiceDuration = Duration.zero;
      safeSetState(() {
        _voiceError = null;
        _voiceStage = _VoiceStage.recording;
      });

      if (await _voiceRecorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path =
            '${dir.path}/voice_transfer_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _voiceRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: path,
        );

        _voiceRecordTimer = Timer.periodic(const Duration(seconds: 1), (t) {
          if (!mounted) {
            t.cancel();
            return;
          }
          safeSetState(() => _voiceRecordSecs++);
          if (_voiceRecordSecs >= 30) {
            _stopVoiceRecording();
          }
        });
      } else {
        safeSetState(() {
          _voiceStage = _VoiceStage.idle;
          _voiceError = 'Microphone permission is required for voice transfer.';
        });
      }
    } catch (e) {
      safeSetState(() {
        _voiceStage = _VoiceStage.idle;
        _voiceError = 'Could not start recording: $e';
      });
    }
  }

  Future<void> _stopVoiceRecording() async {
    _voiceRecordTimer?.cancel();
    if (_voiceStage != _VoiceStage.recording) return;

    try {
      final path = await _voiceRecorder.stop();
      if (!mounted) return;

      if (path == null || !File(path).existsSync()) {
        safeSetState(() {
          _voiceStage = _VoiceStage.idle;
          _voiceError = 'Recording failed. Please try again.';
        });
        return;
      }

      if (_voiceRecordSecs < 1) {
        safeSetState(() {
          _voiceStage = _VoiceStage.idle;
          _voiceError = 'Recording was too short. Speak your transfer details and tap stop.';
        });
        return;
      }

      safeSetState(() {
        _voiceAudioPath = path;
        _voiceDuration = Duration(seconds: _voiceRecordSecs);
        _voicePosition = Duration.zero;
        _voiceStage = _VoiceStage.reviewing;
        _isTranscribingVoice = true;
      });

      // Automatically transcribe the recorded audio with Gemini
      await _transcribeVoiceAudio(path);
    } catch (e) {
      safeSetState(() {
        _voiceStage = _VoiceStage.idle;
        _voiceError = 'Error finishing recording: $e';
      });
    }
  }

  Future<void> _toggleVoicePlayback() async {
    if (_voiceAudioPath == null) return;
    try {
      if (_isVoicePlaying) {
        await _voicePlayer.pause();
      } else {
        if (_voicePosition >= _voiceDuration && _voiceDuration > Duration.zero) {
          await _voicePlayer.seek(Duration.zero);
        }
        await _voicePlayer.play(DeviceFileSource(_voiceAudioPath!));
      }
    } catch (e) {
      safeSetState(() => _voiceError = 'Audio playback error: $e');
    }
  }

  Future<void> _transcribeVoiceAudio(String audioPath) async {
    safeSetState(() => _isTranscribingVoice = true);
    try {
      final file = File(audioPath);
      if (!await file.exists()) return;

      final bytes = await file.readAsBytes();
      final base64Audio = base64Encode(bytes);

      final payload = {
        'contents': [
          {
            'parts': [
              {
                'text': 'Provide an accurate, verbatim transcription of this speech for a money transfer command. '
                    'Return ONLY the spoken text with no introductory phrases, explanations, or quotes.'
              },
              {
                'inlineData': {
                  'mimeType': 'audio/mp4',
                  'data': base64Audio,
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.0,
        }
      };

      for (final model in AppSecrets.geminiCandidateModels) {
        final uri = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_geminiApiKey',
        );

        try {
          final resp = await http
              .post(
                uri,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(payload),
              )
              .timeout(const Duration(seconds: 30));

          if (resp.statusCode == 200) {
            final data = jsonDecode(resp.body) as Map<String, dynamic>;
            final parts = data['candidates']?[0]?['content']?['parts'] as List?;
            final text = (parts != null && parts.isNotEmpty)
                ? (parts[0]['text'] ?? '').toString().trim()
                : '';
            if (text.isNotEmpty) {
              _transcriptCtrl.text = text;
              break;
            }
          }
        } catch (_) {}
      }
    } finally {
      if (mounted) {
        safeSetState(() => _isTranscribingVoice = false);
      }
    }
  }

  static const String _geminiApiKey = AppSecrets.geminiApiKey;
  static const String _openRouterKey = AppSecrets.openRouterApiKey;

  Future<void> _extractPaymentDetails(String transcript) async {
    if (transcript.isEmpty) {
      safeSetState(() {
        _voiceStage = _VoiceStage.idle;
        _voiceError = 'Nothing to process. Please try again.';
      });
      return;
    }
    safeSetState(() => _voiceStage = _VoiceStage.extracting);

    Map<String, dynamic>? extracted;

    // 1. Try Gemini AI extraction first (fast, structured JSON, free)
    if (_geminiApiKey.isNotEmpty) {
      final prompt =
          'Extract Nigerian bank transfer details from speech. Return ONLY valid JSON with exactly these keys: '
          '"account_number" (10-digit string, digits only, empty string if not found), '
          '"amount" (numeric string without currency symbols or commas, empty string if not found), '
          '"bank_name" (full Nigerian bank name, empty string if not found).\n\n'
          'Speech: "$transcript"';

      for (final model in AppSecrets.geminiCandidateModels) {
        try {
          final geminiUri = Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_geminiApiKey',
          );

          final resp = await http
              .post(
                geminiUri,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'contents': [
                    {
                      'parts': [{'text': prompt}]
                    }
                  ],
                  'generationConfig': {
                    'temperature': 0.0,
                    'responseMimeType': 'application/json',
                  }
                }),
              )
              .timeout(const Duration(seconds: 10));

          if (resp.statusCode == 200) {
            final body = jsonDecode(resp.body) as Map<String, dynamic>;
            final raw = body['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
            if (raw != null && raw.isNotEmpty) {
              extracted = jsonDecode(raw) as Map<String, dynamic>;
              if ((extracted['account_number'] ?? '').toString().isNotEmpty ||
                  (extracted['amount'] ?? '').toString().isNotEmpty) {
                break;
              }
            }
          }
        } catch (_) {}
      }
    }

    // 2. Try OpenRouter AI extraction fallback
    if (extracted == null ||
        ((extracted['account_number'] ?? '').toString().isEmpty &&
         (extracted['amount'] ?? '').toString().isEmpty)) {
      try {
        final resp = await http
            .post(
              Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
              headers: {
                'Authorization': 'Bearer $_openRouterKey',
                'Content-Type': 'application/json',
                'HTTP-Referer': 'https://streetpay.app',
                'X-Title': 'StreetPay',
              },
              body: jsonEncode({
                'model': 'stealth/union-alpha',
                'messages': [
                  {
                    'role': 'system',
                    'content':
                        'Extract Nigerian bank transfer details from speech. Return ONLY valid JSON with exactly these keys: '
                        '"account_number" (10-digit string, digits only, empty string if not found), '
                        '"amount" (numeric string without currency symbols, empty string if not found), '
                        '"bank_name" (full Nigerian bank name, empty string if not found).',
                  },
                  {'role': 'user', 'content': transcript},
                ],
                'temperature': 0,
              }),
            )
            .timeout(const Duration(seconds: 10));

        if (resp.statusCode == 200) {
          final body = jsonDecode(resp.body) as Map<String, dynamic>;
          final content = body['choices'][0]['message']['content'] as String;
          extracted = jsonDecode(content) as Map<String, dynamic>;
        }
      } catch (_) {
        // Fall through to regex fallback
      }
    }

    if (!mounted) return;

    // Regex fallback if AI unavailable or returned nothing useful
    extracted ??= _regexExtract(transcript);

    final acctNo = (extracted['account_number'] as String? ?? '')
        .replaceAll(RegExp(r'\D'), '');
    final amount = (extracted['amount'] as String? ?? '')
        .replaceAll(RegExp(r'[^0-9.]'), '');
    final bankName = extracted['bank_name'] as String? ?? '';

    if (acctNo.length == 10) {
      _model.textController1?.text = acctNo;
    }
    if (amount.isNotEmpty) {
      _model.textController3?.text = amount;
    }
    if (bankName.isNotEmpty) {
      final matched = _findMatchingDropdownBank(bankName) ?? bankName;
      _onBankSelected(matched);
    }

    safeSetState(() {
      _voiceStage = _VoiceStage.idle;
      _voiceError = acctNo.length == 10
          ? null
          : 'No account number found. Please enter manually.';
    });

    if (acctNo.length == 10) {
      await _handleAccountNumberChanged(acctNo);
    }
  }

  Map<String, dynamic> _regexExtract(String transcript) {
    final acctMatch = RegExp(r'\b(\d{10})\b').firstMatch(transcript);
    final acctNo = acctMatch?.group(1) ?? '';

    String amount = '';
    for (final m
        in RegExp(r'\b(\d[\d,]*(?:\.\d{1,2})?)\b').allMatches(transcript)) {
      final val = (m.group(1) ?? '').replaceAll(',', '');
      if (val != acctNo && val.length < 10) {
        amount = val;
        break;
      }
    }

    const knownBanks = {
      'access': 'Access Bank',
      'gtb': 'Guaranty Trust Bank',
      'gtbank': 'Guaranty Trust Bank',
      'guaranty': 'Guaranty Trust Bank',
      'zenith': 'Zenith Bank',
      'uba': 'United Bank for Africa',
      'first bank': 'First Bank',
      'firstbank': 'First Bank',
      'keystone': 'Keystone Bank',
      'fcmb': 'FCMB',
      'fidelity': 'Fidelity Bank',
      'union bank': 'Union Bank',
      'stanbic': 'Stanbic IBTC',
      'sterling': 'Sterling Bank',
      'heritage': 'Heritage Bank',
      'wema': 'Wema Bank',
      'polaris': 'Polaris Bank',
      'unity': 'Unity Bank',
      'jaiz': 'Jaiz Bank',
      'ecobank': 'Ecobank',
      'opay': 'OPay',
      'palmpay': 'PalmPay',
      'kuda': 'Kuda Bank',
      'moniepoint': 'Moniepoint',
      'providus': 'Providus Bank',
      'rubies': 'Rubies Bank',
      'lotus': 'Lotus Bank',
    };

    String bankName = '';
    final lower = transcript.toLowerCase();
    for (final entry in knownBanks.entries) {
      if (lower.contains(entry.key)) {
        bankName = entry.value;
        break;
      }
    }

    return {
      'account_number': acctNo,
      'amount': amount,
      'bank_name': bankName,
    };
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final balanceFormatted = formatNumber(
      functions.stringtodouble(FFAppState().avalbal),
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
      currency: '₦',
    );

    // _model.receipent is legacy — not actively set; kept for safety
    final _rawApiName =
        GetreceipentCall.accountname(_model.receipent?.jsonBody ?? '');
    final _acctNumForValidation = _model.textController1?.text.trim() ?? '';
    // Reject names that are purely numeric or equal to the account number (API quirk from some banks)
    bool _isValidApiName(String? n) {
      if (n == null || n.trim().isEmpty) return false;
      final t = n.trim();
      if (t == _acctNumForValidation) return false;
      if (RegExp(r'^\d+$').hasMatch(t)) return false;
      return t.length >= 3;
    }
    final apiRecipientName = _isValidApiName(_rawApiName) ? _rawApiName : null;
    final bool isRecipientResolved = (_model.accountname != null &&
            _model.accountname!.trim().isNotEmpty &&
            !RegExp(r'^\d+$').hasMatch(_model.accountname!.trim()) &&
            _model.accountname!.trim() != _acctNumForValidation) ||
        (apiRecipientName != null);

    final String displayName = (isRecipientResolved)
        ? (_model.accountname != null && _model.accountname!.trim().isNotEmpty
            ? _model.accountname!
            : apiRecipientName ?? _acctNumForValidation)
        : _acctNumForValidation.isNotEmpty
            ? _acctNumForValidation
            : 'Unknown Recipient';

    // Has a 10-digit account number and a bank selected
    final String _acctNum = _model.textController1?.text.trim() ?? '';
    final bool hasAccountAndBank = _acctNum.length == 10 &&
        (_model.bankcode != null && _model.bankcode!.isNotEmpty);

    final String displayBank = _model.dropDownValue ??
        _model.choiceChipsValue ??
        'StreetPay Account';

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: PopScope(
        canPop: true,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFFF6F8F6),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(64.0),
            child: Container(
              color: Colors.white,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => context.pop(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F6F3),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE6EAE7)),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF101614),
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Send money',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF101614),
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF7EE),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2F8F3C),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Free · instant',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF2F8F3C),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
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
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              controller: _model.columnController1,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Balance Bar ---
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B2018),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFF12362A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Color(0xFF7FD472),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WALLET BALANCE',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF8FA596),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                balanceFormatted,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            FFAppState().accountno,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF8FA596),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Main Recipient Card (Benchmark Standard: Account Number First -> Select Bank Below) ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE6EAE7)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. RECIPIENT ACCOUNT HEADER & PASTE
                          Row(
                            children: [
                              Text(
                                'Recipient Account',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF101614),
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              if ((_model.textController1?.text.length ?? 0) < 10)
                                InkWell(
                                  onTap: () async {
                                    final data = await Clipboard.getData('text/plain');
                                    if (data?.text != null && data!.text!.isNotEmpty) {
                                      final digits = data.text!.replaceAll(RegExp(r'\D'), '');
                                      if (digits.isNotEmpty) {
                                        final toPaste = digits.length > 10 ? digits.substring(0, 10) : digits;
                                        _model.textController1?.text = toPaste;
                                        safeSetState(() {});
                                        if (toPaste.length == 10) {
                                          await _handleAccountNumberChanged(toPaste);
                                        }
                                      }
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.content_paste_rounded,
                                          size: 13,
                                          color: Color(0xFF2F8F3C),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Paste',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF2F8F3C),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // 2. ACCOUNT NUMBER INPUT FIELD (Top of card per banking standards)
                          TextFormField(
                            controller: _model.textController1,
                            focusNode: _model.textFieldFocusNode1,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            onChanged: (val) {
                              _updateSuggestions(val);
                              EasyDebounce.debounce(
                                '_model.textController1',
                                const Duration(milliseconds: 300),
                                () async {
                                  final text = _model.textController1?.text ?? '';
                                  await _handleAccountNumberChanged(text);
                                },
                              );
                            },
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF101614),
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter 10 digits Account Number',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF9EABA2),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                              suffixIcon: (_model.textController1 != null &&
                                      _model.textController1!.text.isNotEmpty)
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.cancel_rounded,
                                        color: Color(0xFFA0ABA3),
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        _model.textController1?.clear();
                                        setState(() {
                                          _showSuggestionFeed = false;
                                          _filteredSuggestions = [];
                                        });
                                        safeSetState(() {
                                          _model.accountname = null;
                                          _model.smart = null;
                                          _model.isSearchingBanks = false;
                                          _model.isResolvingAccount = false;
                                        });
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: const Color(0xFFFAFCFA),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFF56B84B), width: 1.5),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // 3. SELECT BANK ROW (Directly below account number)
                          InkWell(
                            onTap: () => _showBankPickerBottomSheet(),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAFCFA),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: (_model.dropDownValue != null && _model.dropDownValue!.isNotEmpty)
                                      ? const Color(0xFF56B84B)
                                      : const Color(0xFFE6EAE7),
                                  width: (_model.dropDownValue != null && _model.dropDownValue!.isNotEmpty) ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  if (_model.dropDownValue != null && _model.dropDownValue!.isNotEmpty) ...[
                                    BankLogoWidget(bankName: _model.dropDownValue!, size: 30, borderRadius: 15),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _model.dropDownValue!,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: const Color(0xFF101614),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            'Selected Bank',
                                            style: GoogleFonts.plusJakartaSans(
                                              color: const Color(0xFF2F8F3C),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Change',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF2F8F3C),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF2F8F3C)),
                                  ] else ...[
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEDF7EE),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.account_balance_rounded,
                                        color: Color(0xFF2F8F3C),
                                        size: 17,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Select Bank',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF6E7A72),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Color(0xFF9EAAA0)),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          // 4. INLINE SMART MATCHED BANK CARD (Screenshot 2: pops up cleanly right under Select Bank)
                          if (_model.smart != null &&
                              _model.smart!.isNotEmpty &&
                              (_model.dropDownValue == null || _model.dropDownValue!.isEmpty)) ...[
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF101614),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.auto_awesome_rounded, color: Color(0xFF7FD472), size: 13),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Matched Bank',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF7FD472),
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                        if (_model.isSearchingBanks) ...[
                                          const SizedBox(width: 8),
                                          const SizedBox(
                                            width: 10,
                                            height: 10,
                                            child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFF7FD472)),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  for (final cand in _model.smart!.take(2))
                                    InkWell(
                                      onTap: () => _selectSuggestedBank(cand as Map<dynamic, dynamic>),
                                      borderRadius: BorderRadius.circular(10),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                        child: Row(
                                          children: [
                                            BankLogoWidget(
                                              bankName: cand['bank_name']?.toString() ?? cand['bankName']?.toString() ?? '',
                                              size: 32,
                                              borderRadius: 16,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    cand['bank_name']?.toString() ?? cand['bankName']?.toString() ?? '',
                                                    style: GoogleFonts.plusJakartaSans(
                                                      color: Colors.white,
                                                      fontSize: 13.5,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  if ((cand['account_name']?.toString() ?? cand['accountName']?.toString() ?? '').trim().isNotEmpty) ...[
                                                    const SizedBox(height: 1),
                                                    Text(
                                                      cand['account_name']?.toString() ?? cand['accountName']?.toString() ?? '',
                                                      style: GoogleFonts.plusJakartaSans(
                                                        color: const Color(0xFF7FD472),
                                                        fontSize: 11.5,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            const Icon(Icons.arrow_forward_rounded, color: Color(0xFF7FD472), size: 16),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],

                          // 5. VERIFIED RECIPIENT CARD (Displayed when account name is verified)
                          if (_model.accountname != null && _model.accountname!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDF7EE),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFF56B84B)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF0B2018),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _getInitials(displayName),
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF7FD472),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          displayName,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF101614),
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 1),
                                        Text(
                                          '${_model.textController1?.text ?? ''} · $displayBank',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF2F8F3C),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.check_circle_rounded, color: Color(0xFF2F8F3C), size: 20),
                                ],
                              ),
                            ),
                          ],

                          // 6. RESOLUTION SPINNER
                          if (_model.isResolvingAccount) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDF7EE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF2F8F3C),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Verifying recipient account name...',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF2F8F3C),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // 7. NETWORK ERROR BANNER
                          if (_hasNetworkError) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFFFB74D), width: 1),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.wifi_off_rounded, size: 16, color: Color(0xFFE65100)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Network issue detected. Please check your connection and try again.',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFFE65100),
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  InkWell(
                                    onTap: () async {
                                      safeSetState(() => _hasNetworkError = false);
                                      final text = _model.textController1?.text ?? '';
                                      await _handleAccountNumberChanged(text);
                                    },
                                    borderRadius: BorderRadius.circular(6),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        'Retry',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF2F8F3C),
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // 8. SESSION EXPIRED BANNER
                          if (_sessionExpired) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEBEE),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFEF9A9A), width: 1),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.lock_clock_rounded, size: 16, color: Color(0xFFB71C1C)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Your session has expired. Please sign in again to continue.',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFFB71C1C),
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  InkWell(
                                    onTap: () => context.go('/login'),
                                    borderRadius: BorderRadius.circular(6),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        'Sign In',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFFB71C1C),
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- Amount Card ---
                    InkWell(
                      onTap: () {
                        if (!(_model.textFieldFocusNode3?.hasFocus ?? false)) {
                          _model.textFieldFocusNode3?.requestFocus();
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE6EAE7)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'AMOUNT',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF6E7A72),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Large Tabular Amount Input
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (!(_model.textFieldFocusNode3?.hasFocus ?? false)) {
                                  _model.textFieldFocusNode3?.requestFocus();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '₦',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF101614),
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: (_model.textController3?.text.isEmpty ?? true)
                                        ? 40.0
                                        : (_model.textController3!.text.length * 24.0 + 16.0)
                                            .clamp(40.0, 260.0),
                                    child: TextFormField(
                                      controller: _model.textController3,
                                      focusNode: _model.textFieldFocusNode3,
                                      keyboardType: const TextInputType.numberWithOptions(
                                        decimal: false,
                                        signed: false,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF101614),
                                        fontSize: 36,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -1.2,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '0',
                                        hintStyle: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFFC8D5CC),
                                          fontSize: 36,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -1.2,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                      ),
                                      onChanged: (_) => safeSetState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Daily limit ₦200,000 · Free transfer',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF6E7A72),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Quick Amount Pills
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (final amt in ['5000', '10000', '25000', '50000'])
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: InkWell(
                                      onTap: () {
                                        _model.textController3?.text = amt;
                                        safeSetState(() {});
                                      },
                                      borderRadius: BorderRadius.circular(999),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: _model.textController3?.text == amt
                                              ? const Color(0xFFEDF7EE)
                                              : const Color(0xFFF3F6F3),
                                          borderRadius: BorderRadius.circular(999),
                                          border: Border.all(
                                            color: _model.textController3?.text == amt
                                                ? const Color(0xFF56B84B)
                                                : Colors.transparent,
                                          ),
                                        ),
                                        child: Text(
                                          '₦${formatNumber(double.parse(amt), formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)}',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: _model.textController3?.text == amt
                                                ? const Color(0xFF2F8F3C)
                                                : const Color(0xFF2B3630),
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                    const SizedBox(height: 16),

                    // --- Narration / Note ---
                    InkWell(
                      onTap: () {
                        if (!(_model.textFieldFocusNode4?.hasFocus ?? false)) {
                          _model.textFieldFocusNode4?.requestFocus();
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE6EAE7)),
                        ),
                        child: TextFormField(
                          controller: _model.textController4,
                          focusNode: _model.textFieldFocusNode4,
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF101614),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Add a note (optional)...',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF9EABA2),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: const Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Color(0xFF6E7A72),
                              size: 18,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // --- Continue / Pay CTA Button ---
                    Builder(
                      builder: (context) {
                        final double parsedAmount =
                            functions.stringtodouble(_model.textController3?.text);
                        final double userBal =
                            functions.stringtodouble(FFAppState().avalbal);
                        final double stampDuty = parsedAmount >= 10000.0 ? 50.0 : 0.0;
                        final double totalRequired = parsedAmount + stampDuty;
                        final bool isAmountValid = parsedAmount > 0;
                        final bool isBalanceEnough = userBal >= totalRequired;
                        final bool isSelfTransfer =
                            FFAppState().accountno == _model.textController1?.text;
                        final bool canProceed = hasAccountAndBank &&
                            isAmountValid &&
                            isBalanceEnough &&
                            !isSelfTransfer;

                        return Column(
                          children: [
                            if (isSelfTransfer)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.block_rounded,
                                      color: Color(0xFFD32F2F),
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'You cannot transfer to your own account.',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFFD32F2F),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (!isBalanceEnough && isAmountValid)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Text(
                                  stampDuty > 0
                                      ? 'Insufficient balance. ₦${formatNumber(totalRequired, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)} required (including ₦50 EMTL stamp duty on transfers ≥ ₦10,000). Available: $balanceFormatted'
                                      : 'Insufficient wallet balance (available: $balanceFormatted)',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFFD32F2F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            FFButtonWidget(
                              onPressed: !canProceed
                                  ? null
                                  : () async {
                                      FFAppState().belong = false;
                                      FFAppState().addToListofaccounts(
                                          _model.textController1!.text);

                                      // Save beneficiary
                                      BeneficiaryService.saveBeneficiary(
                                        accountName: displayName,
                                        accountNumber: _model.textController1!.text,
                                        bankName: displayBank,
                                        bankCode: _model.bankcode,
                                      );
                                      safeSetState(() {});

                                      // Generate transaction details
                                      _model.transref =
                                          await actions.generatetransref();
                                      _model.sessionid =
                                          await actions.generateseesionid();

                                      if (!mounted) return;

                                      final cleanBCode = (_model.bankcode == null ||
                                              _model.bankcode!.isEmpty ||
                                              _model.bankcode!.toLowerCase().contains('streetpay') ||
                                              _model.bankcode == '000000')
                                          ? '120001'
                                          : _model.bankcode!;

                                      // Show Unified Confirmation & PIN Bottom Sheet
                                      final bool? transferSuccess =
                                          await showModalBottomSheet<bool>(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        enableDrag: false,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: TranserconfirmWidget(
                                                recipient: displayName,
                                                amount:
                                                    _model.textController3!.text,
                                                transferfee: parsedAmount >= 20000.0
                                                    ? '50.36'
                                                    : '0.00',
                                                receiveraccount:
                                                    _model.textController1!.text,
                                                bankname: displayBank,
                                                bankcode: cleanBCode,
                                                description: valueOrDefault<String>(
                                                  _model.textController4?.text,
                                                  '-',
                                                ),
                                                transref: _model.transref,
                                                sessionid: _model.sessionid,
                                              ),
                                            ),
                                          );
                                        },
                                      );

                                      safeSetState(() =>
                                          _model.payrecipt = transferSuccess == true);

                                      if (transferSuccess == true && mounted) {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          isDismissible: false,
                                          enableDrag: false,
                                          useSafeArea: true,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: SucesssWidget(
                                                sender: FFAppState().accountname,
                                                amount: parsedAmount,
                                                date: dateTimeFormat(
                                                  "dd/MM/yyyy hh:mm a",
                                                  getCurrentTimestamp,
                                                  locale: 'en',
                                                ),
                                                paymentRef: _model.transref ??
                                                    'SP-${DateTime.now().millisecondsSinceEpoch}',
                                                description: valueOrDefault<String>(
                                                  _model.textController4?.text,
                                                  '-',
                                                ),
                                                receiver: displayName,
                                                receiveraccount: functions
                                                        .accountstrip(
                                                            _model.textController1
                                                                ?.text) ??
                                                    (_model.textController1
                                                            ?.text ??
                                                        ''),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return WebViewAware(
                                              child: Padding(
                                                padding: MediaQuery.viewInsetsOf(
                                                    context),
                                                child: const ErrorcompWidget(
                                                  message: 'Insufficient balance',
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                              text: 'Continue',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 54.0,
                                padding: EdgeInsets.zero,
                                iconPadding: EdgeInsets.zero,
                                color: const Color(0xFF56B84B),
                                textStyle: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF06210F),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(16.0),
                                disabledColor: const Color(0xFFC8D5CC),
                                disabledTextColor: const Color(0xFF6E7A72),
                              ),
                              showLoadingIndicator: false,
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // --- Bank Transfer Success Rate Monitor Badge (Screenshot 2 & 3) ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE6EAE7)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEDF7EE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.wifi_tethering_rounded,
                              color: Color(0xFF2F8F3C),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bank Transfer Success Rate Monitor',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF101614),
                                  ),
                                ),
                                Text(
                                  'StreetPay network uptime: 99.9%',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: const Color(0xFF6E7A72),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF9EAAA0)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Recents & Favourites Tabbed Section (Screenshot 2 & 3) ---
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE6EAE7)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tab Header + Search Icon
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () => safeSetState(() => _beneficiaryTabIndex = 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Recents',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 15,
                                          fontWeight: _beneficiaryTabIndex == 0 ? FontWeight.w800 : FontWeight.w600,
                                          color: _beneficiaryTabIndex == 0 ? const Color(0xFF2F8F3C) : const Color(0xFF6E7A72),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (_beneficiaryTabIndex == 0)
                                        Container(
                                          width: 32,
                                          height: 3,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2F8F3C),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                InkWell(
                                  onTap: () => safeSetState(() => _beneficiaryTabIndex = 1),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Favourites',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 15,
                                          fontWeight: _beneficiaryTabIndex == 1 ? FontWeight.w800 : FontWeight.w600,
                                          color: _beneficiaryTabIndex == 1 ? const Color(0xFF2F8F3C) : const Color(0xFF6E7A72),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (_beneficiaryTabIndex == 1)
                                        Container(
                                          width: 32,
                                          height: 3,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2F8F3C),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    safeSetState(() {
                                      _showBeneficiarySearch = !_showBeneficiarySearch;
                                      if (!_showBeneficiarySearch) _beneficiarySearchQuery = '';
                                    });
                                  },
                                  icon: Icon(
                                    _showBeneficiarySearch ? Icons.close_rounded : Icons.search_rounded,
                                    color: const Color(0xFF6E7A72),
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ),

                          // Optional search field
                          if (_showBeneficiarySearch)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                              child: TextField(
                                autofocus: true,
                                onChanged: (val) => safeSetState(() => _beneficiarySearchQuery = val),
                                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF101614)),
                                decoration: InputDecoration(
                                  hintText: 'Search saved recipients...',
                                  hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF9EAAA0)),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  filled: true,
                                  fillColor: const Color(0xFFFAFCFA),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
                                  ),
                                ),
                              ),
                            ),

                          const Divider(height: 1, color: Color(0xFFF0F4F1)),

                          // Beneficiaries List
                          Builder(
                            builder: (context) {
                              var items = _cachedBeneficiaries;
                              if (_beneficiaryTabIndex == 1) {
                                items = items.take(4).toList();
                              }
                              if (_beneficiarySearchQuery.trim().isNotEmpty) {
                                final q = _beneficiarySearchQuery.trim().toLowerCase();
                                items = items.where((b) =>
                                  b.accountName.toLowerCase().contains(q) ||
                                  b.accountNumber.contains(q) ||
                                  b.bankName.toLowerCase().contains(q)
                                ).toList();
                              }

                              if (items.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                  child: Center(
                                    child: Text(
                                      _cachedBeneficiaries.isEmpty
                                          ? 'No saved beneficiaries yet'
                                          : 'No matching recipients found',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: const Color(0xFF9EAAA0),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF6F8F6)),
                                itemBuilder: (context, idx) {
                                  final item = items[idx];
                                  return InkWell(
                                    onTap: () async {
                                      _model.textController1?.text = item.accountNumber;
                                      _onBankSelected(
                                        item.bankName,
                                        bankCode: item.bankCode,
                                        accountName: item.accountName,
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 38,
                                            height: 38,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF0B2018),
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              item.initials,
                                              style: GoogleFonts.plusJakartaSans(
                                                color: const Color(0xFF7FD472),
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.accountName,
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 13.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(0xFF101614),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '${item.accountNumber} · ${item.bankName}',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 11.5,
                                                    color: const Color(0xFF6E7A72),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          BankLogoWidget(bankName: item.bankName, size: 28, borderRadius: 14),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
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
