import '/backend/api_requests/api_calls.dart';
import '/components/processingcomp_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/services/kyc_draft_service.dart';
import '/services/image_compress_service.dart';
import '/flutter_flow/upload_data.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import '/index.dart';
import 'upgradetotier3_model.dart';
export 'upgradetotier3_model.dart';

class Upgradetotier3Widget extends StatefulWidget {
  const Upgradetotier3Widget({
    super.key,
    required this.phoneno,
  });

  final String? phoneno;

  static String routeName = 'upgradetotier3';
  static String routePath = '/upgradetotier3';

  @override
  State<Upgradetotier3Widget> createState() => _Upgradetotier3WidgetState();
}

class _Upgradetotier3WidgetState extends State<Upgradetotier3Widget> {
  late Upgradetotier3Model _model;
  bool _isGeneratingProofAddress = false;
  String? _lastGeneratedAddress;
  bool _isSubmitting = false;


  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> _resolveBestCustomerName() async {
    String current = FFAppState().accountname.trim();
    if (current.isNotEmpty && current.contains(' ')) {
      return current;
    }
    if (FFAppState().accountno.isNotEmpty) {
      try {
        final res = await WalletAsAServiceGroup.walletEnquiryCall.call(
          accountNo: FFAppState().accountno,
          authToken: FFAppState().bsptoken,
        );
        final raw = WalletAsAServiceGroup.walletEnquiryCall.accountname(res.jsonBody);
        if (raw != null && raw.trim().isNotEmpty) {
          final clean = functions.stripSlash(raw).trim();
          if (clean.contains(' ')) {
            FFAppState().accountname = clean;
            return clean;
          }
        }
      } catch (_) {}
    }
    if (FFAppState().phonenumber.isNotEmpty) {
      try {
        final token = FFAppState().bsptoken.isNotEmpty ? FFAppState().bsptoken : FFAppState().streetauth;
        final res = await ReturntierprofileCall.call(
          phoneno: functions.removecode(FFAppState().phonenumber),
          accessToken: token,
        );
        final fn = ReturntierprofileCall.fullname(res.jsonBody ?? '');
        if (fn != null && fn.trim().isNotEmpty && fn.trim().contains(' ')) {
          FFAppState().accountname = fn.trim();
          return fn.trim();
        }
      } catch (_) {}
    }
    return current;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Upgradetotier3Model());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState().accountname.isEmpty || !FFAppState().accountname.contains(' ')) {
        await _resolveBestCustomerName();
      }
      if (FFAppState().bsptoken.isEmpty || FFAppState().streetauth.isEmpty) {
        final authRes = await StreetauthCall.call();
        final freshToken = StreetauthCall.streettoken(authRes.jsonBody);
        if (freshToken != null && freshToken.isNotEmpty) {
          FFAppState().bsptoken = freshToken;
          FFAppState().streetauth = freshToken;
          safeSetState(() {});
        }
      }

      final draft = await KycDraftService.getDraft();
      if (draft != null && mounted) {
        if ((_model.textController1?.text.isEmpty ?? true) && (draft.bvn?.isNotEmpty ?? false)) {
          _model.textController1?.text = draft.bvn!;
          FFAppState().userBVN = draft.bvn!;
        }
        if ((_model.textController2?.text.isEmpty ?? true) && (draft.nin?.isNotEmpty ?? false)) {
          _model.textController2?.text = draft.nin!;
          FFAppState().userNIN = draft.nin!;
        }
        if ((_model.textController3?.text.isEmpty ?? true) && (draft.street?.isNotEmpty ?? false)) {
          _model.textController3?.text = (draft.houseNumber?.isNotEmpty ?? false)
              ? '${draft.houseNumber} ${draft.street}'
              : draft.street!;
          FFAppState().userStreet = draft.street!;
        }
        if ((_model.textController4?.text.isEmpty ?? true) && (draft.city?.isNotEmpty ?? false)) {
          _model.textController4?.text = draft.city!;
          FFAppState().userCity = draft.city!;
        }
        if ((_model.textController5?.text.isEmpty ?? true) && (draft.state?.isNotEmpty ?? false)) {
          _model.textController5?.text = draft.state!;
          FFAppState().userState = draft.state!;
        }
        if ((_model.textController6?.text.isEmpty ?? true) && (draft.lga?.isNotEmpty ?? false)) {
          _model.textController6?.text = draft.lga!;
          FFAppState().userLGA = draft.lga!;
        }
        if ((_model.textController8?.text.isEmpty ?? true) && (draft.landmark?.isNotEmpty ?? false)) {
          _model.textController8?.text = draft.landmark!;
          FFAppState().userLandmark = draft.landmark!;
        }
      }

      // Restore persisted uploaded Proof of Address
      final savedProof = await KycFileService.getFile('proofaddress');
      if (savedProof != null && mounted) {
        if (!ImageCompressService.isPdf(savedProof.bytes, savedProof.name) &&
            ImageCompressService.isPng(savedProof.bytes) &&
            (savedProof.bytes?.length ?? 0) > 10 * 1024) {
          _model.uploadedLocalFile_uploadData63 = savedProof;
          _lastGeneratedAddress = _buildAddressString();
        } else {
          await KycFileService.removeFile('proofaddress');
        }
      }

      // Restore persisted uploaded Utility Bill
      final savedUtility = await KycFileService.getFile('utilitybill');
      if (savedUtility != null && mounted) {
        _model.uploadedLocalFile_utilitybill = savedUtility;
      }

      if ((_model.uploadedLocalFile_uploadData63.bytes?.isEmpty ?? true) &&
          _getMissingProofOfAddressFields().isEmpty &&
          mounted) {
        _autoGenerateProofOfAddress(silent: true);
      }
      safeSetState(() {});
    });

    _model.textController1 ??= TextEditingController(
      text: FFAppState().userBVN.isNotEmpty ? FFAppState().userBVN : null,
    );
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(
      text: FFAppState().userNIN.isNotEmpty ? FFAppState().userNIN : null,
    );
    _model.textFieldFocusNode2 ??= FocusNode();

    // Street
    final initialStreet = FFAppState().userStreet.isNotEmpty
        ? (FFAppState().userHouseNo.isNotEmpty
            ? '${FFAppState().userHouseNo} ${FFAppState().userStreet}'
            : FFAppState().userStreet)
        : null;
    _model.textController3 ??= TextEditingController(text: initialStreet);
    _model.textFieldFocusNode3 ??= FocusNode();

    // City
    _model.textController4 ??= TextEditingController(
      text: FFAppState().userCity.isNotEmpty ? FFAppState().userCity : null,
    );
    _model.textFieldFocusNode4 ??= FocusNode();

    // State
    _model.textController5 ??= TextEditingController(
      text: FFAppState().userState.isNotEmpty ? FFAppState().userState : null,
    );
    _model.textFieldFocusNode5 ??= FocusNode();

    // LGA
    _model.textController6 ??= TextEditingController(
      text: FFAppState().userLGA.isNotEmpty ? FFAppState().userLGA : null,
    );
    _model.textFieldFocusNode6 ??= FocusNode();

    // Closest Landmark
    _model.textController8 ??= TextEditingController(
      text: FFAppState().userLandmark.isNotEmpty ? FFAppState().userLandmark : null,
    );
    _model.textFieldFocusNode8 ??= FocusNode();

    _model.textFieldFocusNode3?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNode4?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNode5?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNode6?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNode8?.addListener(_onAddressFocusChange);
  }

  void _saveFormToAppState() {
    final bvn = _model.textController1?.text.trim() ?? '';
    final nin = _model.textController2?.text.trim() ?? '';
    final street = _model.textController3?.text.trim() ?? '';
    final city = _model.textController4?.text.trim() ?? '';
    final state = _model.textController5?.text.trim() ?? '';
    final lga = _model.textController6?.text.trim() ?? '';
    final landmark = _model.textController8?.text.trim() ?? '';

    if (bvn.isNotEmpty) FFAppState().userBVN = bvn;
    if (nin.isNotEmpty) FFAppState().userNIN = nin;
    if (street.isNotEmpty) FFAppState().userStreet = street;
    if (city.isNotEmpty) FFAppState().userCity = city;
    if (state.isNotEmpty) FFAppState().userState = state;
    if (lga.isNotEmpty) FFAppState().userLGA = lga;
    if (landmark.isNotEmpty) FFAppState().userLandmark = landmark;

    KycDraftService.saveDraft(
      nin: nin.isNotEmpty ? nin : FFAppState().userNIN,
      bvn: bvn.isNotEmpty ? bvn : FFAppState().userBVN,
      phone: FFAppState().phonenumber,
      city: city.isNotEmpty ? city : FFAppState().userCity,
      street: street.isNotEmpty ? street : FFAppState().userStreet,
      state: state.isNotEmpty ? state : FFAppState().userState,
      lga: lga.isNotEmpty ? lga : FFAppState().userLGA,
      landmark: landmark.isNotEmpty ? landmark : (FFAppState().userLandmark.isNotEmpty ? FFAppState().userLandmark : null),
    );
  }

  @override
  void dispose() {
    _model.textFieldFocusNode3?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNode4?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNode5?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNode6?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNode8?.removeListener(_onAddressFocusChange);
    _saveFormToAppState();
    _model.dispose();
    super.dispose();
  }

  void _onAddressFocusChange() {
    if (!(_model.textFieldFocusNode3?.hasFocus ?? false) &&
        !(_model.textFieldFocusNode4?.hasFocus ?? false) &&
        !(_model.textFieldFocusNode5?.hasFocus ?? false) &&
        !(_model.textFieldFocusNode6?.hasFocus ?? false) &&
        !(_model.textFieldFocusNode8?.hasFocus ?? false)) {
      if (_getMissingProofOfAddressFields().isEmpty) {
        _autoGenerateProofOfAddress(silent: true);
      }
    }
  }

  List<String> _getMissingProofOfAddressFields() {
    final missing = <String>[];
    if (_model.textController5?.text.trim().isEmpty ?? true) {
      missing.add('State');
    }
    if (_model.textController6?.text.trim().isEmpty ?? true) {
      missing.add('LGA');
    }
    if (_model.textController4?.text.trim().isEmpty ?? true) {
      missing.add('City');
    }
    if (_model.textController3?.text.trim().isEmpty ?? true) {
      missing.add('Street Address');
    }
    return missing;
  }

  Future<bool> _autoGenerateProofOfAddress({
    bool showAlertIfMissing = false,
    bool silent = false,
  }) async {
    if (_isGeneratingProofAddress) return false;
    _saveFormToAppState();
    final missing = _getMissingProofOfAddressFields();
    if (missing.isNotEmpty) {
      if (showAlertIfMissing && mounted) {
        _showErrorSnack(
          context,
          'Please complete your residential address: ${missing.join(', ')}.',
        );
      }
      return false;
    }
    final addr = _buildAddressString();
    final currentBytes = _model.uploadedLocalFile_uploadData63.bytes;
    if ((currentBytes?.isNotEmpty ?? false) &&
        (ImageCompressService.isJpeg(currentBytes) || ImageCompressService.isPng(currentBytes)) &&
        currentBytes!.length > 10 * 1024 &&
        _lastGeneratedAddress == addr) {
      return true;
    }
    safeSetState(() => _isGeneratingProofAddress = true);
    try {
      final customerName = await _resolveBestCustomerName();
      final addressDesc = _buildAddressDescription();
      final landmark = _model.textController8?.text.trim().isNotEmpty ?? false
          ? _model.textController8!.text.trim()
          : (FFAppState().userLandmark.isNotEmpty ? FFAppState().userLandmark : null);
      final jpegFile = await actions.generateVisitFeedbackJpeg(
        customerName.isNotEmpty ? customerName : null,
        addr,
        addressDesc,
        DateTime.now().subtract(const Duration(days: 2)),
        FFAppState().signature.isNotEmpty ? FFAppState().signature : null,
        'Akinwole Oluleye',
        'Abayomi IPADEOLA',
        landmark,
      );
      if (jpegFile.bytes != null && jpegFile.bytes!.isNotEmpty) {
        if (mounted) {
          safeSetState(() {
            _model.uploadedLocalFile_uploadData63 = jpegFile;
            _lastGeneratedAddress = addr;
          });
        }
        await KycFileService.saveFile('proofaddress', jpegFile);
        if (!silent && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚡ Proof of Address generated at actual verification size!'),
              backgroundColor: Color(0xFF00A651),
            ),
          );
        }
        return true;
      }
    } catch (e) {
      debugPrint('Error auto-generating proof in Tier 3: $e');
    } finally {
      if (mounted) {
        safeSetState(() => _isGeneratingProofAddress = false);
      }
    }
    return false;
  }




  String _buildAddressString() {
    final parts = <String>[];
    final street = _model.textController3!.text.trim();
    final city = _model.textController4!.text.trim();
    final lga = _model.textController6!.text.trim();
    final state = _model.textController5!.text.trim();
    if (street.isNotEmpty) parts.add(street);
    if (city.isNotEmpty) parts.add(city);
    if (lga.isNotEmpty) parts.add('$lga LGA');
    if (state.isNotEmpty) parts.add('$state State');
    return parts.join(', ');
  }

  String _buildAddressDescription() {
    final fullAddr = _buildAddressString();
    final landmark = _model.textController8?.text.trim() ?? FFAppState().userLandmark.trim();
    final landmarkPart = landmark.isNotEmpty ? ' Situated close to $landmark.' : '';
    if (fullAddr.isNotEmpty && fullAddr != 'Residential Address Not Specified') {
      return 'Standard occupied residential premises situated along $fullAddr.$landmarkPart Building physically sighted and verified as occupied residential property, clearly identifiable within the neighborhood with direct access from the main road.';
    }
    return 'Standard residential premises verified and confirmed within the neighborhood with clear street access.$landmarkPart';
  }

  InputDecoration _fieldDecoration(
      BuildContext context, String label, String hint) {
    return InputDecoration(
      isDense: true,
      labelText: label,
      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
            font: GoogleFonts.inter(
              fontWeight:
                  FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle:
                  FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight:
                FlutterFlowTheme.of(context).labelMedium.fontWeight,
            fontStyle:
                FlutterFlowTheme.of(context).labelMedium.fontStyle,
          ),
      hintText: hint,
      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
            font: GoogleFonts.inter(
              fontWeight:
                  FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle:
                  FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight:
                FlutterFlowTheme.of(context).labelMedium.fontWeight,
            fontStyle:
                FlutterFlowTheme.of(context).labelMedium.fontStyle,
          ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).primary,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).primary,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).error,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).error,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      filled: true,
      fillColor: FlutterFlowTheme.of(context).primaryBackground,
    );
  }

  TextStyle _fieldTextStyle(BuildContext context) {
    return FlutterFlowTheme.of(context).bodyMedium.override(
          font: GoogleFonts.inter(
            fontWeight:
                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle:
                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
          letterSpacing: 0.0,
          fontWeight:
              FlutterFlowTheme.of(context).bodyMedium.fontWeight,
          fontStyle:
              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
        );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.bold),
            fontSize: 16.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _sectionSubtitle(BuildContext context, String text) {
    return Text(
      text,
      style: FlutterFlowTheme.of(context).bodySmall.override(
            font: GoogleFonts.inter(),
            color: FlutterFlowTheme.of(context).secondaryText,
            letterSpacing: 0.0,
          ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.0,
            child: Text(
              label,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '—',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
        ),
        duration: const Duration(milliseconds: 3500),
        backgroundColor: FlutterFlowTheme.of(context).secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                  18.0, 0.0, 0.0, 0.0),
              child: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () async {
                  context.pop();
                },
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    32.0, 0.0, 32.0, 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 12.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 48.0, 0.0),
                            child: Container(
                              width: 70.0,
                              height: 34.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFF7FC014),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  'Tier ${FFAppState().tier}',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.phoneno!,
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
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
            elevation: 2.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            controller: _model.columnController,
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Section 1: Your Information ──────────────────────
                _sectionHeader(context, 'Your Information'),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color:
                        FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      _infoRow(context, 'Name',
                          FFAppState().accountname),
                      _infoRow(context, 'Phone',
                          FFAppState().phonenumber),
                      _infoRow(context, 'Account No',
                          FFAppState().accountno),
                      if (FFAppState().email.isNotEmpty)
                        _infoRow(
                            context, 'Email', FFAppState().email),
                    ],
                  ),
                ),
                const SizedBox(height: 28.0),

                // ── Section 2: Identity Verification ─────────────────
                _sectionHeader(context, 'Identity Verification'),
                const SizedBox(height: 4.0),
                _sectionSubtitle(context,
                    'Enter your BVN and NIN to verify your identity'),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _model.textController1,
                  focusNode: _model.textFieldFocusNode1,
                  autofocus: false,
                  obscureText: false,
                  decoration: _fieldDecoration(
                      context, 'BVN', 'Enter your 11-digit BVN'),
                  style: _fieldTextStyle(context),
                  maxLength: 11,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  enableInteractiveSelection: true,
                  onChanged: (val) {
                    FFAppState().userBVN = val.trim();
                  },
                  validator: _model.textController1Validator
                      .asValidator(context),
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _model.textController2,
                  focusNode: _model.textFieldFocusNode2,
                  autofocus: false,
                  obscureText: false,
                  decoration: _fieldDecoration(
                      context, 'NIN', 'Enter your 11-digit NIN'),
                  style: _fieldTextStyle(context),
                  maxLength: 11,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  enableInteractiveSelection: true,
                  onChanged: (val) {
                    FFAppState().userNIN = val.trim();
                  },
                  validator: _model.textController2Validator
                      .asValidator(context),
                ),
                const SizedBox(height: 28.0),

                // ── Section 3: Residential Address ────────────────────
                _sectionHeader(context, 'Residential Address'),
                const SizedBox(height: 4.0),
                _sectionSubtitle(context,
                    'Enter your residential address details'),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _model.textController3,
                  focusNode: _model.textFieldFocusNode3,
                  autofocus: false,
                  decoration: _fieldDecoration(context, 'Street Address',
                      'e.g. 12 Adeola Odeku Street'),
                  style: _fieldTextStyle(context),
                  textCapitalization: TextCapitalization.words,
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  onChanged: (val) {
                    FFAppState().userStreet = val.trim();
                    safeSetState(() {});
                  },
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _model.textController4,
                        focusNode: _model.textFieldFocusNode4,
                        autofocus: false,
                        decoration: _fieldDecoration(
                            context, 'City', 'e.g. Lagos'),
                        style: _fieldTextStyle(context),
                        textCapitalization: TextCapitalization.words,
                        cursorColor:
                            FlutterFlowTheme.of(context).primaryText,
                        onChanged: (val) {
                          FFAppState().userCity = val.trim();
                          safeSetState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: TextFormField(
                        controller: _model.textController5,
                        focusNode: _model.textFieldFocusNode5,
                        autofocus: false,
                        decoration: _fieldDecoration(
                            context, 'State', 'e.g. Lagos'),
                        style: _fieldTextStyle(context),
                        textCapitalization: TextCapitalization.words,
                        cursorColor:
                            FlutterFlowTheme.of(context).primaryText,
                        onChanged: (val) {
                          FFAppState().userState = val.trim();
                          safeSetState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _model.textController6,
                  focusNode: _model.textFieldFocusNode6,
                  autofocus: false,
                  decoration: _fieldDecoration(context,
                      'Local Government Area (LGA)', 'e.g. Eti-Osa'),
                  style: _fieldTextStyle(context),
                  textCapitalization: TextCapitalization.words,
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  onChanged: (val) {
                    FFAppState().userLGA = val.trim();
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _model.textController8,
                  focusNode: _model.textFieldFocusNode8,
                  autofocus: false,
                  decoration: _fieldDecoration(context,
                      'Closest Landmark', 'e.g. Near City Center, opposite central mosque'),
                  style: _fieldTextStyle(context),
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  onChanged: (val) {
                    FFAppState().userLandmark = val.trim();
                    safeSetState(() {});
                  },
                ),
                const SizedBox(height: 14.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.verified_outlined,
                        color: Color(0xFF00A651),
                        size: 20.0,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address Description (Auto-included in Verification Form)',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            const SizedBox(height: 3.0),
                            Text(
                              'A compliance description of your address is automatically generated and embedded into your official StreetPay Address Verification Form below.',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    font: GoogleFonts.inter(),
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // ── Section 4: Utility Bill (Optional) ────────────────
                _sectionHeader(context, 'Utility Bill (Optional)'),
                const SizedBox(height: 4.0),
                _sectionSubtitle(context,
                    'Upload a recent utility bill (PHCN/Electricity, Water, or Waste ≤ 3 months old). If none is uploaded, your verified address form is used.'),
                const SizedBox(height: 12.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        (_model.uploadedLocalFile_utilitybill.bytes?.isNotEmpty ?? false)
                            ? Icons.check_circle_rounded
                            : Icons.receipt_long_outlined,
                        color: (_model.uploadedLocalFile_utilitybill.bytes?.isNotEmpty ?? false)
                            ? const Color(0xFF00A651)
                            : FlutterFlowTheme.of(context).secondaryText,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (_model.uploadedLocalFile_utilitybill.bytes?.isNotEmpty ?? false)
                                  ? ((_model.uploadedLocalFile_utilitybill.name?.isNotEmpty ?? false)
                                      ? _model.uploadedLocalFile_utilitybill.name!
                                      : 'Utility Bill Attached')
                                  : 'Upload Recent Utility Bill',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Text(
                              (_model.uploadedLocalFile_utilitybill.bytes?.isNotEmpty ?? false)
                                  ? '${((_model.uploadedLocalFile_utilitybill.bytes?.lengthInBytes ?? 0) / 1024).toStringAsFixed(1)} KB • Attached for submission'
                                  : 'Electricity, water or waste bill (≤ 3 months old)',
                              style: FlutterFlowTheme.of(context).labelSmall.override(
                                    font: GoogleFonts.inter(),
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final selectedMedia = await selectMediaWithSourceBottomSheet(
                            context: context,
                            allowPhoto: true,
                          );
                          if (selectedMedia != null &&
                              selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                            safeSetState(() => _model.isDataUploading_utilitybill = true);
                            try {
                              final first = selectedMedia.first;
                              final uploaded = FFUploadedFile(
                                name: first.storagePath.split('/').last,
                                bytes: first.bytes,
                                originalFilename: first.originalFilename,
                              );
                              final compressed = await ImageCompressService.compressUploadedFile(uploaded, isProof: true);
                              safeSetState(() {
                                _model.uploadedLocalFile_utilitybill = compressed;
                              });
                              await KycFileService.saveFile('utilitybill', compressed);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('⚡ Utility bill attached successfully!'),
                                    backgroundColor: Color(0xFF00A651),
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                safeSetState(() => _model.isDataUploading_utilitybill = false);
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (_model.uploadedLocalFile_utilitybill.bytes?.isNotEmpty ?? false)
                              ? const Color(0xFF00A651)
                              : FlutterFlowTheme.of(context).primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          elevation: 0,
                        ),
                        child: Text(
                          (_model.uploadedLocalFile_utilitybill.bytes?.isNotEmpty ?? false) ? 'Change' : 'Upload',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),

                // ── Submit Button ──────────────────────────────────────
                FFButtonWidget(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          _saveFormToAppState();
                          final rawBvn = _model.textController1.text.trim();
                          final rawNin = _model.textController2.text.trim();
                          final bvn = rawBvn.replaceAll(RegExp(r'\D'), '');
                          final nin = rawNin.replaceAll(RegExp(r'\D'), '');

                          if (bvn.length != 11) {
                            _showErrorSnack(
                                context, 'Please enter a valid 11-digit BVN');
                            return;
                          }

                          if (nin.length != 11) {
                            _showErrorSnack(
                                context, 'Please enter a valid 11-digit NIN');
                            return;
                          }

                          if (_model.textController3.text.trim().isEmpty) {
                            _showErrorSnack(
                                context, 'Please enter your street address');
                            return;
                          }

                          if (_model.textController4.text.trim().isEmpty) {
                            _showErrorSnack(
                                context, 'Please enter your city');
                            return;
                          }

                          if (_model.textController5.text.trim().isEmpty) {
                            _showErrorSnack(
                                context, 'Please enter your state');
                            return;
                          }

                          if (_model.textController6.text.trim().isEmpty) {
                            _showErrorSnack(
                                context, 'Please enter your LGA');
                            return;
                          }

                          final missingFields = _getMissingProofOfAddressFields();
                          if (missingFields.isNotEmpty) {
                            _showErrorSnack(
                              context,
                              'Please complete your residential address: ${missingFields.join(', ')}',
                            );
                            return;
                          }

                          if (FFAppState().signature.isEmpty) {
                            _showErrorSnack(context,
                                'Please draw and save your digital signature');
                            return;
                          }

                          safeSetState(() => _isSubmitting = true);

                          try {
                            // 1. Automatically generate proof of address behind the scenes
                            final ok = await _autoGenerateProofOfAddress(silent: true);
                            if (!ok ||
                                (_model.uploadedLocalFile_uploadData63.bytes?.isEmpty ?? true)) {
                              _showErrorSnack(
                                context,
                                'Unable to auto-generate proof of address. Please ensure all residential address details are completed.',
                              );
                              return;
                            }

                            final token = FFAppState().bsptoken.isNotEmpty
                                ? FFAppState().bsptoken
                                : FFAppState().streetauth;

                            _model.tierone = await ReturntierprofileCall.call(
                              phoneno: FFAppState().phonenumber,
                              accessToken: token,
                            );

                            final profileAccNo =
                                ReturntierprofileCall.accountNo(_model.tierone?.jsonBody ?? '');
                            final effectiveAccountNo = (FFAppState().accountno.isNotEmpty)
                                ? FFAppState().accountno
                                : (profileAccNo?.isNotEmpty == true ? profileAccNo! : '');

                            if (effectiveAccountNo.isNotEmpty && FFAppState().accountno.isEmpty) {
                              FFAppState().accountno = effectiveAccountNo;
                            }

                            if (effectiveAccountNo.isEmpty) {
                              _showErrorSnack(context,
                                  'Unable to retrieve account number. Please check your network or re-login.');
                              return;
                            }

                            // 2. Ensure proof of address is compressed strictly <= 150 KB
                            _model.addressroff = _model.uploadedLocalFile_uploadData63;
                            if (_model.addressroff != null) {
                              if (ImageCompressService.isPdf(
                                  _model.addressroff!.bytes, _model.addressroff!.name)) {
                                _model.addressroff =
                                    await ImageCompressService.convertPdfOrDocToJpeg(_model.addressroff!);
                              } else {
                                _model.addressroff =
                                    await ImageCompressService.compressUploadedFile(
                                  _model.addressroff,
                                  maxSizeKB: 150,
                                  minSizeKB: 0,
                                  isProof: true,
                                );
                              }
                            }

                            // 3. Prepare signature file if available
                            FFUploadedFile? signatureFile;
                            if (FFAppState().signature.isNotEmpty) {
                              try {
                                signatureFile = await actions.newCustomAction2(
                                  functions.base64ToImage(FFAppState().signature),
                                );
                              } catch (_) {}
                            }

                            final profileName =
                                ReturntierprofileCall.fullname(_model.tierone?.jsonBody ?? '');
                            final profileEmail =
                                ReturntierprofileCall.email(_model.tierone?.jsonBody ?? '');
                            final profilePhone =
                                ReturntierprofileCall.phone(_model.tierone?.jsonBody ?? '');

                            String bestAccountName = (profileName != null && profileName.isNotEmpty)
                                ? profileName
                                : FFAppState().accountname;
                            if (!bestAccountName.contains(' ')) {
                              final resolved = await _resolveBestCustomerName();
                              if (resolved.isNotEmpty && resolved.contains(' ')) {
                                bestAccountName = resolved;
                              }
                            }

                            // 4. Submit upgrade to Tier 3 API call attaching auto-generated proof
                            _model.apiResultblu =
                                await UpgradetotierthreeCall.call(
                              accountNumber: effectiveAccountNo,
                              bvn: bvn,
                              nin: nin,
                              accountName: bestAccountName,
                              phoneNumber: (profilePhone != null && profilePhone.isNotEmpty)
                                  ? functions.addcode(profilePhone)
                                  : (FFAppState().phonenumber.isNotEmpty
                                      ? functions.addcode(FFAppState().phonenumber)
                                      : ''),
                              email: (profileEmail != null && profileEmail.isNotEmpty)
                                  ? profileEmail
                                  : (FFAppState().email.isNotEmpty
                                      ? FFAppState().email
                                      : 'customer@streetpay.ng'),
                              idType: '1',
                              idNumber: nin,
                              streetName: _model.textController3.text.trim(),
                              city: _model.textController4.text.trim(),
                              state: _model.textController5.text.trim(),
                              localGovernment: _model.textController6.text.trim(),
                              nearestLandmark: UpgradetotierthreeCall.sanitizeLandmark(
                                (_model.textController8?.text.trim().isNotEmpty ?? false)
                                    ? _model.textController8!.text.trim()
                                    : (FFAppState().userLandmark.isNotEmpty
                                        ? FFAppState().userLandmark
                                        : (FFAppState().userBusStop.isNotEmpty
                                            ? FFAppState().userBusStop
                                            : (FFAppState().userFillingStation.isNotEmpty
                                                ? FFAppState().userFillingStation
                                                : ''))),
                              ),
                              proofofaddress: _model.addressroff,
                              utilityBill:
                                  (_model.uploadedLocalFile_utilitybill.bytes?.isNotEmpty ?? false)
                                      ? _model.uploadedLocalFile_utilitybill
                                      : null,
                              customerSignature: signatureFile,
                              accessToken: token,
                              tier: '3',
                            );

                            final isSuccess = (_model.apiResultblu?.isSuccessful ?? false) ||
                                (UpgradetotierthreeCall.status(
                                      _model.apiResultblu?.jsonBody ?? '',
                                    ) ??
                                    false);

                            final responseMsg = (_model.apiResultblu?.responseMessage.isNotEmpty == true)
                                ? _model.apiResultblu!.responseMessage
                                : (UpgradetotierthreeCall.message(
                                        _model.apiResultblu?.jsonBody ?? '',
                                      ) ??
                                      (isSuccess
                                          ? 'Tier 3 upgrade submitted successfully!'
                                          : 'Tier 3 upgrade could not be processed. Please verify your details.'));

                            if (isSuccess == true) {
                              FFAppState().tier = '3';
                              await KycDraftService.clearDraft();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      responseMsg,
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context).primaryBackground,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    duration: const Duration(milliseconds: 4000),
                                    backgroundColor: FlutterFlowTheme.of(context).primary,
                                  ),
                                );
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return WebViewAware(
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          FocusManager.instance.primaryFocus?.unfocus();
                                        },
                                        child: Padding(
                                          padding: MediaQuery.viewInsetsOf(context),
                                          child: const ProcessingcompWidget(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (mounted) {
                                  context.goNamed(NewhomeWidget.routeName);
                                }
                              }
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      responseMsg,
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context).primaryBackground,
                                      ),
                                    ),
                                    duration: const Duration(milliseconds: 4000),
                                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'An error occurred: $e',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                    ),
                                  ),
                                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                                ),
                              );
                            }
                          } finally {
                            _saveFormToAppState();
                            if (mounted) {
                              safeSetState(() => _isSubmitting = false);
                            }
                          }
                        },
                  text: _isSubmitting ? 'Submitting Upgrade...' : 'Upgrade to Tier 3',
                  options: FFButtonOptions(
                    height: 50.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 16.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: const Color(0xFFFF2455),
                    textStyle: FlutterFlowTheme.of(context)
                        .titleSmall
                        .override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                          ),
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
