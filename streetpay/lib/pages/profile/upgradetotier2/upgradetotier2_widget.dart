import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/processingcomp_widget.dart';
import '/services/kyc_draft_service.dart';
import '/services/image_compress_service.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'upgradetotier2_model.dart';
export 'upgradetotier2_model.dart';

class Upgradetotier2Widget extends StatefulWidget {
  const Upgradetotier2Widget({
    super.key,
    required this.phoneno,
  });

  final String? phoneno;

  static String routeName = 'upgradetotier2';
  static String routePath = '/upgradetotier2';

  @override
  State<Upgradetotier2Widget> createState() => _Upgradetotier2WidgetState();
}

class _Upgradetotier2WidgetState extends State<Upgradetotier2Widget> {
  late Upgradetotier2Model _model;
  bool _isGeneratingProofAddress = false;
  String? _lastGeneratedAddress;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Upgradetotier2Model());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.apiResult564 = await GetallstatesCall.call();
      FFAppState().allstates = (GetallstatesCall.allstates(
        (_model.apiResult564?.jsonBody ?? ''),
      ) as List?)!
          .map<String>((e) => e.toString())
          .toList()
          .cast<String>()
          .toList()
          .cast<String>();
      safeSetState(() {});
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
        if ((_model.textController1?.text.isEmpty ?? true) && (draft.nin?.isNotEmpty ?? false)) {
          _model.textController1?.text = draft.nin!;
          FFAppState().userNIN = draft.nin!;
        }
        if ((_model.textController3?.text.isEmpty ?? true) && (draft.bvn?.isNotEmpty ?? false)) {
          _model.textController3?.text = draft.bvn!;
          FFAppState().userBVN = draft.bvn!;
        }
        if ((_model.textController4?.text.isEmpty ?? true) && (draft.state?.isNotEmpty ?? false)) {
          _model.textController4?.text = draft.state!;
          FFAppState().userState = draft.state!;
        }
        if ((_model.textController5?.text.isEmpty ?? true) && (draft.lga?.isNotEmpty ?? false)) {
          _model.textController5?.text = draft.lga!;
          FFAppState().userLGA = draft.lga!;
        }
        if ((_model.textController6?.text.isEmpty ?? true) && (draft.city?.isNotEmpty ?? false)) {
          _model.textController6?.text = draft.city!;
          FFAppState().userCity = draft.city!;
        }
        if ((_model.textController7?.text.isEmpty ?? true) && (draft.street?.isNotEmpty ?? false)) {
          _model.textController7?.text = draft.street!;
          FFAppState().userStreet = draft.street!;
        }
        if ((_model.textController8?.text.isEmpty ?? true) && (draft.houseNumber?.isNotEmpty ?? false)) {
          _model.textController8?.text = draft.houseNumber!;
          FFAppState().userHouseNo = draft.houseNumber!;
        }
      }

      // Restore persisted uploaded files
      final savedUserPhoto = await KycFileService.getFile('selfie');
      if (savedUserPhoto != null && mounted) {
        _model.uploadedLocalFile_userphoto = savedUserPhoto;
      }
      final savedNinCard = await KycFileService.getFile('nincard');
      if (savedNinCard != null && mounted) {
        _model.uploadedLocalFile_nincardyy = savedNinCard;
      }
      final savedUtility = await KycFileService.getFile('utilitybill');
      if (savedUtility != null && mounted) {
        if (!ImageCompressService.isPdf(savedUtility.bytes, savedUtility.name)) {
          _model.uploadedLocalFile_utilitybill = savedUtility;
        } else {
          await KycFileService.removeFile('utilitybill');
        }
      }
      final savedProof = await KycFileService.getFile('proofaddress');
      if (savedProof != null && mounted) {
        if (!ImageCompressService.isPdf(savedProof.bytes, savedProof.name) &&
            ImageCompressService.isPng(savedProof.bytes) &&
            (savedProof.bytes?.length ?? 0) > 10 * 1024) {
          _model.uploadedLocalFile_proofaddress = savedProof;
          _lastGeneratedAddress = _buildAddressString();
        } else {
          await KycFileService.removeFile('proofaddress');
        }
      }
      if ((_model.uploadedLocalFile_proofaddress.bytes?.isEmpty ?? true) &&
          _getMissingProofOfAddressFields().isEmpty &&
          mounted) {
        _autoGenerateProofOfAddress(silent: true);
      }
      safeSetState(() {});
    });

    _model.textController1 ??= TextEditingController(
      text: FFAppState().userNIN.isNotEmpty ? FFAppState().userNIN : null,
    );
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(
      text: FFAppState().email.isNotEmpty ? FFAppState().email : null,
    );
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController(
      text: FFAppState().userBVN.isNotEmpty ? FFAppState().userBVN : null,
    );
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController(
      text: FFAppState().userState.isNotEmpty ? FFAppState().userState : null,
    );
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController(
      text: FFAppState().userLGA.isNotEmpty ? FFAppState().userLGA : null,
    );
    _model.textFieldFocusNode5 ??= FocusNode();

    _model.textController6 ??= TextEditingController(
      text: FFAppState().userCity.isNotEmpty ? FFAppState().userCity : null,
    );
    _model.textFieldFocusNode6 ??= FocusNode();

    _model.textController7 ??= TextEditingController(
      text: FFAppState().userStreet.isNotEmpty ? FFAppState().userStreet : null,
    );
    _model.textFieldFocusNode7 ??= FocusNode();

    _model.textController8 ??= TextEditingController(
      text: FFAppState().userHouseNo.isNotEmpty ? FFAppState().userHouseNo : null,
    );
    _model.textFieldFocusNode8 ??= FocusNode();

    _model.textController9 ??= TextEditingController(
      text: FFAppState().userLandmark.isNotEmpty ? FFAppState().userLandmark : null,
    );
    _model.textFieldFocusNode9 ??= FocusNode();

    _model.textController10 ??= TextEditingController(
      text: FFAppState().userLandmarkDesc.isNotEmpty ? FFAppState().userLandmarkDesc : null,
    );
    _model.textFieldFocusNode10 ??= FocusNode();

    _model.textFieldFocusNode4?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNode5?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNode6?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNode7?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNode8?.addListener(_onAddressFocusChange);

    if (FFAppState().userIdIssueDate.isNotEmpty) {
      _model.datePicked ??= DateTime.tryParse(FFAppState().userIdIssueDate);
    }
    if (FFAppState().userIdType.isNotEmpty) {
      _model.dropDownValue1 ??= FFAppState().userIdType;
    }
    if (FFAppState().userPEP.isNotEmpty) {
      _model.dropDownValue3 ??= FFAppState().userPEP;
    }
  }

  void _saveFormToAppState() {
    final nin = _model.textController1?.text.trim() ?? '';
    final email = _model.textController2?.text.trim() ?? '';
    final bvn = _model.textController3?.text.trim() ?? '';
    final state = _model.textController4?.text.trim() ?? '';
    final lga = _model.textController5?.text.trim() ?? '';
    final city = _model.textController6?.text.trim() ?? '';
    final street = _model.textController7?.text.trim() ?? '';
    final houseNo = _model.textController8?.text.trim() ?? '';
    final landmark = _model.textController9?.text.trim() ?? '';
    final landmarkDesc = _model.textController10?.text.trim() ?? '';

    if (nin.isNotEmpty) FFAppState().userNIN = nin;
    if (email.isNotEmpty) FFAppState().email = email;
    if (bvn.isNotEmpty) FFAppState().userBVN = bvn;
    if (state.isNotEmpty) FFAppState().userState = state;
    if (lga.isNotEmpty) FFAppState().userLGA = lga;
    if (city.isNotEmpty) FFAppState().userCity = city;
    if (street.isNotEmpty) FFAppState().userStreet = street;
    if (houseNo.isNotEmpty) FFAppState().userHouseNo = houseNo;
    if (landmark.isNotEmpty) FFAppState().userLandmark = landmark;
    if (landmarkDesc.isNotEmpty) FFAppState().userLandmarkDesc = landmarkDesc;
    if (_model.dropDownValue1 != null) FFAppState().userIdType = _model.dropDownValue1!;
    if (_model.dropDownValue3 != null) FFAppState().userPEP = _model.dropDownValue3!;
    if (_model.datePicked != null) {
      FFAppState().userIdIssueDate = _model.datePicked!.toIso8601String();
    }

    KycDraftService.saveDraft(
      nin: nin.isNotEmpty ? nin : FFAppState().userNIN,
      bvn: bvn.isNotEmpty ? bvn : FFAppState().userBVN,
      phone: FFAppState().phonenumber,
      city: city.isNotEmpty ? city : FFAppState().userCity,
      street: street.isNotEmpty ? street : FFAppState().userStreet,
      houseNumber: houseNo.isNotEmpty ? houseNo : FFAppState().userHouseNo,
      state: state.isNotEmpty ? state : FFAppState().userState,
      lga: lga.isNotEmpty ? lga : FFAppState().userLGA,
      isPep: _model.dropDownValue3 == 'YES',
    );
  }

  @override
  void dispose() {
    _model.textFieldFocusNode4?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNode5?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNode6?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNode7?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNode8?.removeListener(_onAddressFocusChange);
    _saveFormToAppState();
    _model.dispose();
    super.dispose();
  }

  void _onAddressFocusChange() {
    if (!(_model.textFieldFocusNode4?.hasFocus ?? false) &&
        !(_model.textFieldFocusNode5?.hasFocus ?? false) &&
        !(_model.textFieldFocusNode6?.hasFocus ?? false) &&
        !(_model.textFieldFocusNode7?.hasFocus ?? false) &&
        !(_model.textFieldFocusNode8?.hasFocus ?? false)) {
      if (_getMissingProofOfAddressFields().isEmpty) {
        _autoGenerateProofOfAddress(silent: true);
      }
    }
  }

  List<String> _getMissingProofOfAddressFields() {
    final missing = <String>[];
    if (_model.textController4?.text.trim().isEmpty ?? true) {
      missing.add('State');
    }
    if (_model.textController5?.text.trim().isEmpty ?? true) {
      missing.add('LGA');
    }
    if (_model.textController6?.text.trim().isEmpty ?? true) {
      missing.add('City');
    }
    if (_model.textController7?.text.trim().isEmpty ?? true) {
      missing.add('Street');
    }
    if (_model.textController8?.text.trim().isEmpty ?? true) {
      missing.add('House Number');
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
    final currentBytes = _model.uploadedLocalFile_proofaddress.bytes;
    if ((currentBytes?.isNotEmpty ?? false) &&
        (ImageCompressService.isJpeg(currentBytes) || ImageCompressService.isPng(currentBytes)) &&
        currentBytes!.length > 10 * 1024 &&
        _lastGeneratedAddress == addr) {
      return true;
    }
    safeSetState(() => _isGeneratingProofAddress = true);
    try {
      final jpegFile = await actions.generateVisitFeedbackJpeg(
        FFAppState().accountname.isNotEmpty ? FFAppState().accountname : null,
        addr,
        (_model.textController9?.text.trim().isNotEmpty ?? false)
            ? '${_model.textController9!.text.trim()} (from the app)'
            : null,
        _model.datePicked ?? DateTime.now().subtract(const Duration(days: 2)),
        FFAppState().signature.isNotEmpty ? FFAppState().signature : null,
        'Akinwole Oluleye',
        'Abayomi IPADEOLA',
        _model.textController10?.text.trim(),
      );
      if (jpegFile.bytes != null && jpegFile.bytes!.isNotEmpty) {
        if (mounted) {
          safeSetState(() {
            _model.uploadedLocalFile_proofaddress = jpegFile;
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
      debugPrint('Error auto-generating proof in Tier 2: $e');
    } finally {
      if (mounted) {
        safeSetState(() => _isGeneratingProofAddress = false);
      }
    }
    return false;
  }

  String _buildAddressString() {
    final houseNo = _model.textController8!.text.trim();
    final street = _model.textController7!.text.trim();
    final city = _model.textController6!.text.trim();
    final lga = _model.textController5!.text.trim();
    final state = _model.textController4!.text.trim();
    final parts = <String>[];
    if (houseNo.isNotEmpty && street.isNotEmpty) {
      parts.add('$houseNo $street');
    } else if (street.isNotEmpty) {
      parts.add(street);
    } else if (houseNo.isNotEmpty) {
      parts.add(houseNo);
    }
    if (city.isNotEmpty) parts.add(city);
    if (lga.isNotEmpty) parts.add('$lga LGA');
    if (state.isNotEmpty) parts.add('$state State');
    return parts.join(', ');
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
            fontSize: 12.0,
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
            color: const Color(0xFFC4C4C4),
            fontSize: 12.0,
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
          fontSize: 12.0,
          letterSpacing: 0.0,
          fontWeight:
              FlutterFlowTheme.of(context).bodyMedium.fontWeight,
          fontStyle:
              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          lineHeight: 2.0,
        );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.bold),
            fontSize: 15.0,
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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

  Widget _uploadTile(
    BuildContext context, {
    required String label,
    required bool uploaded,
    String? filename,
    bool isLoading = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: 14.0, vertical: 12.0),
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: uploaded
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            if (isLoading)
              const SizedBox(
                width: 16.0,
                height: 16.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              Icon(
                uploaded
                    ? Icons.check_circle_rounded
                    : Icons.cloud_upload_outlined,
                color: uploaded
                    ? Colors.white
                    : FlutterFlowTheme.of(context).primaryText,
                size: 18.0,
              ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                uploaded
                    ? (filename != null
                        ? filename
                        : '$label ✓')
                    : label,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                          fontWeight: FontWeight.w500),
                      color: uploaded
                          ? Colors.white
                          : FlutterFlowTheme.of(context).primaryText,
                      fontSize: 13.0,
                      letterSpacing: 0.0,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (uploaded)
              Icon(
                Icons.edit_outlined,
                color: Colors.white.withValues(alpha: 0.7),
                size: 14.0,
              ),
          ],
        ),
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

    final bool userPhotoUploaded =
        _model.uploadedLocalFile_userphoto.bytes?.isNotEmpty ?? false;
    final bool ninCardUploaded =
        _model.uploadedLocalFile_nincardyy.bytes?.isNotEmpty ?? false;
    final bool proofAddressUploaded =
        _model.uploadedLocalFile_proofaddress.bytes?.isNotEmpty ?? false;
    final bool hasSignature = FFAppState().signature.isNotEmpty;

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
            actions: const [],
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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    20.0, 20.0, 20.0, 130.0),
                child: SingleChildScrollView(
                  primary: false,
                  controller: _model.columnController,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Section 1: Your Information ──────────────
                      _sectionHeader(context, 'Your Information'),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color:
                                FlutterFlowTheme.of(context).alternate,
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // ── Section 2: Identity & ID Details ─────────
                      _sectionHeader(context, 'Identity & ID Details'),
                      const SizedBox(height: 4.0),
                      _sectionSubtitle(context,
                          'Enter your national identification details'),
                      const SizedBox(height: 10.0),
                      FlutterFlowDropDown<String>(
                        controller: _model.dropDownValueController1 ??=
                            FormFieldController<String>(
                          _model.dropDownValue1 ??= (FFAppState().userIdType.isNotEmpty
                              ? FFAppState().userIdType
                              : 'National Id'),
                        ),
                        options: const ['National Id'],
                        onChanged: (val) {
                          safeSetState(() => _model.dropDownValue1 = val);
                          if (val != null) FFAppState().userIdType = val;
                        },
                        width: double.infinity,
                        height: 44.0,
                        textStyle: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                              ),
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                            ),
                        hintText: 'Select ID type...',
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: FlutterFlowTheme.of(context)
                              .secondaryText,
                          size: 24.0,
                        ),
                        fillColor: FlutterFlowTheme.of(context)
                            .primaryBackground,
                        elevation: 2.0,
                        borderColor:
                            FlutterFlowTheme.of(context).primary,
                        borderWidth: 1.0,
                        borderRadius: 8.0,
                        margin: const EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 12.0, 0.0),
                        hidesUnderline: true,
                        isOverButton: false,
                        isSearchable: false,
                        isMultiSelect: false,
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _model.textController1,
                        focusNode: _model.textFieldFocusNode1,
                        autofocus: false,
                        decoration: _fieldDecoration(
                            context, 'NIN', 'Enter your 11-digit NIN'),
                        style: _fieldTextStyle(context),
                        maxLength: 11,
                        maxLengthEnforcement:
                            MaxLengthEnforcement.enforced,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        cursorColor:
                            FlutterFlowTheme.of(context).primaryText,
                        onChanged: (val) {
                          FFAppState().userNIN = val.trim();
                        },
                        validator: _model.textController1Validator
                            .asValidator(context),
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _model.textController3,
                        focusNode: _model.textFieldFocusNode3,
                        autofocus: false,
                        decoration: _fieldDecoration(
                            context, 'BVN', 'Enter your 11-digit BVN'),
                        style: _fieldTextStyle(context),
                        maxLength: 11,
                        maxLengthEnforcement:
                            MaxLengthEnforcement.enforced,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        cursorColor:
                            FlutterFlowTheme.of(context).primaryText,
                        onChanged: (val) {
                          FFAppState().userBVN = val.trim();
                        },
                        validator: _model.textController3Validator
                            .asValidator(context),
                      ),
                      const SizedBox(height: 4.0),
                      FFButtonWidget(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: getCurrentTimestamp,
                            firstDate: DateTime(1900),
                            lastDate: getCurrentTimestamp,
                            builder: (context, child) {
                              return wrapInMaterialDatePickerTheme(
                                context,
                                child!,
                                headerBackgroundColor:
                                    FlutterFlowTheme.of(context).primary,
                                headerForegroundColor: Colors.white,
                                headerTextStyle:
                                    FlutterFlowTheme.of(context)
                                        .headlineLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          fontSize: 32.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                pickerBackgroundColor:
                                    FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                pickerForegroundColor:
                                    FlutterFlowTheme.of(context)
                                        .primaryText,
                                selectedDateTimeBackgroundColor:
                                    FlutterFlowTheme.of(context).primary,
                                selectedDateTimeForegroundColor:
                                    FlutterFlowTheme.of(context).secondary,
                                actionButtonForegroundColor:
                                    FlutterFlowTheme.of(context)
                                        .primaryText,
                                iconSize: 24.0,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            safeSetState(() {
                              _model.datePicked = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                              );
                              FFAppState().userIdIssueDate =
                                  _model.datePicked!.toIso8601String();
                            });
                          } else if (_model.datePicked != null) {
                            safeSetState(() {
                              _model.datePicked = getCurrentTimestamp;
                              FFAppState().userIdIssueDate =
                                  _model.datePicked!.toIso8601String();
                            });
                          }
                        },
                        text: _model.datePicked != null
                            ? dateTimeFormat(
                                'dd-MM-yyyy',
                                _model.datePicked,
                                locale: FFLocalizations.of(context)
                                    .languageCode,
                              )
                            : 'Select ID Issue Date',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 44.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context)
                              .primaryBackground,
                          textStyle: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: _model.datePicked != null
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                                color: _model.datePicked != null
                                    ? FlutterFlowTheme.of(context)
                                        .primaryText
                                    : const Color(0xFFC4C4C4),
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                              ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // ── Section 3: Contact Details ────────────────
                      _sectionHeader(context, 'Contact Details'),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _model.textController2,
                        focusNode: _model.textFieldFocusNode2,
                        autofocus: false,
                        decoration: _fieldDecoration(
                            context, 'Email', 'Enter your email address'),
                        style: _fieldTextStyle(context),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor:
                            FlutterFlowTheme.of(context).primaryText,
                        onChanged: (val) {
                          FFAppState().email = val.trim();
                        },
                        validator: _model.textController2Validator
                            .asValidator(context),
                      ),
                      const SizedBox(height: 24.0),

                      // ── Section 4: Residential Address ────────────
                      _sectionHeader(context, 'Residential Address'),
                      const SizedBox(height: 4.0),
                      _sectionSubtitle(context,
                          'Used to verify and generate your proof of residence'),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          SizedBox(
                            width: 90.0,
                            child: TextFormField(
                              controller: _model.textController8,
                              focusNode: _model.textFieldFocusNode8,
                              autofocus: false,
                              decoration: _fieldDecoration(
                                  context, 'No.', 'e.g. 12'),
                              style: _fieldTextStyle(context),
                              keyboardType: TextInputType.text,
                              cursorColor: FlutterFlowTheme.of(context)
                                  .primaryText,
                              onChanged: (val) {
                                FFAppState().userHouseNo = val.trim();
                                safeSetState(() {});
                              },
                              validator: _model.textController8Validator
                                  .asValidator(context),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              controller: _model.textController7,
                              focusNode: _model.textFieldFocusNode7,
                              autofocus: false,
                              decoration: _fieldDecoration(context,
                                  'Street Name', 'e.g. Adeola Odeku St'),
                              style: _fieldTextStyle(context),
                              textCapitalization:
                                  TextCapitalization.words,
                              cursorColor: FlutterFlowTheme.of(context)
                                  .primaryText,
                              validator: _model.textController7Validator
                                  .asValidator(context),
                              onChanged: (val) {
                                FFAppState().userStreet = val.trim();
                                safeSetState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _model.textController6,
                              focusNode: _model.textFieldFocusNode6,
                              autofocus: false,
                              decoration: _fieldDecoration(
                                  context, 'City', 'e.g. Lagos'),
                              style: _fieldTextStyle(context),
                              textCapitalization:
                                  TextCapitalization.words,
                              cursorColor: FlutterFlowTheme.of(context)
                                  .primaryText,
                              validator: _model.textController6Validator
                                  .asValidator(context),
                              onChanged: (val) {
                                FFAppState().userCity = val.trim();
                                safeSetState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              controller: _model.textController4,
                              focusNode: _model.textFieldFocusNode4,
                              autofocus: false,
                              decoration: _fieldDecoration(
                                  context, 'State', 'e.g. Lagos'),
                              style: _fieldTextStyle(context),
                              textCapitalization:
                                  TextCapitalization.words,
                              cursorColor: FlutterFlowTheme.of(context)
                                  .primaryText,
                              validator: _model.textController4Validator
                                  .asValidator(context),
                              onChanged: (val) {
                                FFAppState().userState = val.trim();
                                safeSetState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _model.textController5,
                        focusNode: _model.textFieldFocusNode5,
                        autofocus: false,
                        decoration: _fieldDecoration(context,
                            'Local Government Area (LGA)', 'e.g. Eti-Osa'),
                        style: _fieldTextStyle(context),
                        textCapitalization: TextCapitalization.words,
                        cursorColor:
                            FlutterFlowTheme.of(context).primaryText,
                        onChanged: (val) {
                          FFAppState().userLGA = val.trim();
                        },
                        validator: _model.textController5Validator
                            .asValidator(context),
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _model.textController9,
                        focusNode: _model.textFieldFocusNode9,
                        autofocus: false,
                        decoration: _fieldDecoration(
                            context,
                            'Residential Description (House Features)',
                            'e.g. Duplex with blue gate, opposite the shop'),
                        style: _fieldTextStyle(context),
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor:
                            FlutterFlowTheme.of(context).primaryText,
                        onChanged: (val) {
                          FFAppState().userLandmark = val.trim();
                        },
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _model.textController10,
                        focusNode: _model.textFieldFocusNode10,
                        autofocus: false,
                        decoration: _fieldDecoration(
                            context,
                            'Landmark Description',
                            'e.g. Near City Center, adjacent to access road'),
                        style: _fieldTextStyle(context),
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor:
                            FlutterFlowTheme.of(context).primaryText,
                        onChanged: (val) {
                          FFAppState().userLandmarkDesc = val.trim();
                        },
                      ),
                      const SizedBox(height: 24.0),

                      // ── Section 5: Document Uploads ───────────────
                      _sectionHeader(context, 'Document Uploads'),
                      const SizedBox(height: 4.0),
                      _sectionSubtitle(context,
                          'Upload clear photos or scans of your documents'),
                      const SizedBox(height: 10.0),

                      // User Photo
                      _uploadTile(
                        context,
                        label: 'Upload Passport Photograph',
                        uploaded: userPhotoUploaded,
                        filename: userPhotoUploaded ? 'Passport Photo ✓' : null,
                        isLoading: _model.isDataUploading_userphoto,
                        onTap: () async {
                          final selectedMedia =
                              await selectMediaWithSourceBottomSheet(
                            context: context,
                            allowPhoto: true,
                          );
                          if (selectedMedia != null &&
                              selectedMedia.every((m) =>
                                  validateFileFormat(
                                      m.storagePath, context))) {
                            safeSetState(() =>
                                _model.isDataUploading_userphoto = true);
                            var selectedUploadedFiles =
                                <FFUploadedFile>[];
                            try {
                              showUploadMessage(context, 'Uploading...',
                                  showLoading: true);
                              selectedUploadedFiles = selectedMedia
                                  .map((m) => FFUploadedFile(
                                        name: m.storagePath.split('/').last,
                                        bytes: m.bytes,
                                        height: m.dimensions?.height,
                                        width: m.dimensions?.width,
                                        blurHash: m.blurHash,
                                        originalFilename:
                                            m.originalFilename,
                                      ))
                                  .toList();
                            } finally {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              _model.isDataUploading_userphoto = false;
                            }
                            if (selectedUploadedFiles.length ==
                                selectedMedia.length) {
                              final rawFile = selectedUploadedFiles.first;
                              final file = await actions.newCustomAction2(rawFile);
                              safeSetState(() {
                                _model.uploadedLocalFile_userphoto = file;
                              });
                              await KycFileService.saveFile('selfie', file);
                              showUploadMessage(context, 'Photo uploaded and compressed!');
                            } else {
                              safeSetState(() {});
                              showUploadMessage(
                                  context, 'Failed to upload photo');
                            }
                          }
                        },
                      ),

                      // NIN / ID Card
                      _uploadTile(
                        context,
                        label: 'Upload ID Card (front image)',
                        uploaded: ninCardUploaded,
                        filename: ninCardUploaded ? 'ID Card ✓' : null,
                        isLoading: _model.isDataUploading_nincardyy,
                        onTap: () async {
                          final selectedMedia =
                              await selectMediaWithSourceBottomSheet(
                            context: context,
                            allowPhoto: true,
                          );
                          if (selectedMedia != null &&
                              selectedMedia.every((m) =>
                                   validateFileFormat(
                                      m.storagePath, context))) {
                            safeSetState(() =>
                                _model.isDataUploading_nincardyy = true);
                            var selectedUploadedFiles =
                                <FFUploadedFile>[];
                            try {
                              showUploadMessage(context, 'Uploading...',
                                  showLoading: true);
                              selectedUploadedFiles = selectedMedia
                                  .map((m) => FFUploadedFile(
                                        name: m.storagePath.split('/').last,
                                        bytes: m.bytes,
                                        height: m.dimensions?.height,
                                        width: m.dimensions?.width,
                                        blurHash: m.blurHash,
                                        originalFilename:
                                            m.originalFilename,
                                      ))
                                  .toList();
                            } finally {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              _model.isDataUploading_nincardyy = false;
                            }
                            if (selectedUploadedFiles.length ==
                                selectedMedia.length) {
                              final rawFile = selectedUploadedFiles.first;
                              final file = await actions.newCustomAction2(rawFile);
                              safeSetState(() {
                                _model.uploadedLocalFile_nincardyy = file;
                              });
                              await KycFileService.saveFile('nincard', file);
                              showUploadMessage(
                                  context, 'ID card uploaded and compressed!');
                            } else {
                              safeSetState(() {});
                              showUploadMessage(
                                  context, 'Failed to upload ID card');
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 24.0),

                      // ── Section 6: Signature ──────────────────────
                      _sectionHeader(context, 'Your Signature'),
                      const SizedBox(height: 4.0),
                      _sectionSubtitle(
                        context,
                        hasSignature
                            ? 'Signature on file — draw below to update'
                            : 'Draw your signature in the field below',
                      ),
                      if (hasSignature)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 6.0, bottom: 4.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF00A651),
                                size: 16.0,
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                'Signature saved',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600),
                                      color: const Color(0xFF00A651),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        height: 200.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: custom_widgets.SignaturePadWidget(
                          width: double.infinity,
                          height: 200.0,
                          onSigned: (sig) {
                            if (sig != null && sig.isNotEmpty) {
                              FFAppState().signature = sig;
                              safeSetState(() {});
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // ── Section 7: Additional Information (PEP) ──
                      _sectionHeader(
                          context, 'Additional Information'),
                      const SizedBox(height: 8.0),
                      FlutterFlowDropDown<String>(
                        controller: _model.dropDownValueController3 ??=
                            FormFieldController<String>(
                          FFAppState().userPEP.isNotEmpty
                              ? FFAppState().userPEP
                              : null,
                        ),
                        options: const ['YES', 'NO'],
                        onChanged: (val) {
                          safeSetState(() => _model.dropDownValue3 = val);
                          if (val != null) FFAppState().userPEP = val;
                        },
                        width: double.infinity,
                        height: 44.0,
                        textStyle: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                              ),
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                            ),
                        hintText: 'Are you politically inclined? (PEP)',
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: FlutterFlowTheme.of(context)
                              .secondaryText,
                          size: 24.0,
                        ),
                        fillColor: FlutterFlowTheme.of(context)
                            .primaryBackground,
                        elevation: 2.0,
                        borderColor:
                            FlutterFlowTheme.of(context).primary,
                        borderWidth: 1.0,
                        borderRadius: 8.0,
                        margin: const EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 12.0, 0.0),
                        hidesUnderline: true,
                        isOverButton: false,
                        isSearchable: false,
                        isMultiSelect: false,
                      ),
                      const SizedBox(height: 30.0),

                      // ── Submit Button ─────────────────────────────
                      FFButtonWidget(
                        onPressed: () async {
                          _saveFormToAppState();
                          final rawNin =
                              _model.textController1.text.trim();
                          final rawBvn =
                              _model.textController3.text.trim();
                          final nin = rawNin.replaceAll(RegExp(r'\D'), '');
                          final bvn = rawBvn.replaceAll(RegExp(r'\D'), '');
                          final email =
                              _model.textController2.text.trim();

                          if (nin.length != 11) {
                            _showErrorSnack(context,
                                'Please enter a valid 11-digit NIN');
                            return;
                          }
                          if (bvn.length != 11) {
                            _showErrorSnack(context,
                                'Please enter a valid 11-digit BVN');
                            return;
                          }
                          if (email.isEmpty || !RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(email)) {
                            _showErrorSnack(
                                context, 'Please enter a valid email address');
                            return;
                          }
                          if (_model.datePicked == null) {
                            _showErrorSnack(
                                context, 'Please select your ID issue date');
                            return;
                          }
                          if (!userPhotoUploaded) {
                            _showErrorSnack(context,
                                'Please upload your passport photograph');
                            return;
                          }
                          if (!ninCardUploaded) {
                            _showErrorSnack(
                                context, 'Please upload your ID card image');
                            return;
                          }
                          final missingAddressFields = _getMissingProofOfAddressFields();
                          if (missingAddressFields.isNotEmpty) {
                            _showErrorSnack(
                              context,
                              'Please complete your residential address: ${missingAddressFields.join(', ')}',
                            );
                            return;
                          }
                          if (!proofAddressUploaded) {
                            final ok = await _autoGenerateProofOfAddress(silent: true);
                            if (!ok || (_model.uploadedLocalFile_proofaddress.bytes?.isEmpty ?? true)) {
                              _showErrorSnack(
                                context,
                                'Proof of address has not been generated. Please complete your residential address details to proceed.',
                              );
                              return;
                            }
                          }
                          if (!hasSignature) {
                            _showErrorSnack(context,
                                'Please draw your signature in the field above');
                            return;
                          }
                          if (_model.textController9.text.trim().isEmpty) {
                            _showErrorSnack(
                                context, 'Please enter your nearest landmark');
                            return;
                          }
                          if (_model.dropDownValue3 == null) {
                            _showErrorSnack(context,
                                'Please select your PEP status');
                            return;
                          }

                          _model.walletenquiry = await WalletAsAServiceGroup
                              .walletEnquiryCall
                              .call(
                            accountNo: FFAppState().accountno,
                            authToken: FFAppState().bsptoken,
                          );

                          _model.tierone1 =
                              await ReturntierprofileCall.call(
                            phoneno: functions
                                .removecode(FFAppState().phonenumber),
                            accessToken: FFAppState().bsptoken,
                          );

                          final effectiveProof = _model.uploadedLocalFile_proofaddress;
                          if (effectiveProof.bytes == null || effectiveProof.bytes!.isEmpty) {
                            _showErrorSnack(
                              context,
                              'Proof of address has not been generated. Please complete your residential address details to proceed.',
                            );
                            return;
                          }
                          final effectiveUtility = (_model.uploadedLocalFile_utilitybill.bytes?.isNotEmpty ?? false)
                              ? _model.uploadedLocalFile_utilitybill
                              : null;

                          // Process documents sequentially to prevent memory exhaustion
                          _model.userphoto = await actions.newCustomAction2(
                            _model.uploadedLocalFile_userphoto,
                            75,
                          );

                          _model.proofaddress = effectiveProof;

                          if (effectiveUtility != null) {
                            _model.utilitybill = await actions.newCustomAction2(
                              effectiveUtility,
                              100,
                            );
                          } else {
                            _model.utilitybill = null;
                          }

                          _model.nincard = await actions.newCustomAction2(
                            _model.uploadedLocalFile_nincardyy,
                            75,
                          );

                          final profileAccNo = ReturntierprofileCall.accountNo(_model.tierone1?.jsonBody ?? '');
                          final effectiveAccountNo = FFAppState().accountno.isNotEmpty
                              ? FFAppState().accountno
                              : (profileAccNo?.isNotEmpty == true ? profileAccNo! : '');
                          if (effectiveAccountNo.isNotEmpty && FFAppState().accountno.isEmpty) {
                            FFAppState().accountno = effectiveAccountNo;
                          }

                          final sigImage2 = functions.base64ToImage(FFAppState().signature);
                          final signatureFile2 = sigImage2 != null
                              ? await actions.newCustomAction2(sigImage2, 50)
                              : null;

                          final validUpgradeToken = FFAppState().bsptoken.isNotEmpty
                              ? FFAppState().bsptoken
                              : FFAppState().streetauth;

                          _model.upgradetwo =
                              await UpgradetoteirtwoCall.call(
                            accountNumber: effectiveAccountNo,
                            bvn: (ReturntierprofileCall.bvn(
                                              (_model.tierone1?.jsonBody ??
                                                  ''),
                                            ) !=
                                            null &&
                                        ReturntierprofileCall.bvn(
                                              (_model.tierone1?.jsonBody ??
                                                  ''),
                                            ) !=
                                            '')
                                ? ReturntierprofileCall.bvn(
                                    (_model.tierone1?.jsonBody ?? ''),
                                  )
                                : bvn,
                            accountName: FFAppState().accountname,
                            phoneNumber:
                                functions.addcode(FFAppState().phonenumber),
                            tier: '2',
                            email: email,
                            userPhoto: _model.userphoto,
                            idType: '1',
                            idNumber: nin,
                            idIssueDate: dateTimeFormat(
                              'yyyy-MM-dd',
                              _model.datePicked,
                              locale:
                                  FFLocalizations.of(context).languageCode,
                            ),
                            idCardFront: _model.nincard,
                            houseNumber:
                                _model.textController8.text.trim(),
                            streetName: _model.textController7.text.trim(),
                            state: _model.textController4.text.trim(),
                            city: _model.textController6.text.trim(),
                            localGovernment:
                                _model.textController5.text.trim(),
                            pep: _model.dropDownValue3,
                            customerSignature: signatureFile2,
                            utilityBill: _model.utilitybill,
                            proofaddress: _model.proofaddress,
                            nearestLandmark:
                                _model.textController9!.text.trim(),
                            accessToken: validUpgradeToken,
                            nin: nin,
                          );

                          _saveFormToAppState();

                          final isTier2Success = (_model.upgradetwo?.isSuccessful ?? false) ||
                              UpgradetoteirtwoCall.status(
                                    (_model.upgradetwo?.jsonBody ?? ''),
                                  ) ==
                                  true;

                          final tier2Msg = (_model.upgradetwo?.responseMessage.isNotEmpty == true)
                              ? _model.upgradetwo!.responseMessage
                              : (UpgradetoteirtwoCall.message(
                                    (_model.upgradetwo?.jsonBody ?? ''),
                                  ) ??
                                  (isTier2Success
                                      ? 'Tier 2 upgrade submitted successfully!'
                                      : 'Tier 2 upgrade request could not be processed.'));

                          if (isTier2Success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  tier2Msg,
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                ),
                                duration:
                                    const Duration(milliseconds: 4000),
                                backgroundColor:
                                    FlutterFlowTheme.of(context).primary,
                              ),
                            );

                            // Also attempt Tier 3 upgrade if BVN + NIN + proof provided
                            if (bvn.isNotEmpty &&
                                nin.isNotEmpty &&
                                proofAddressUploaded &&
                                (_model.proofaddress?.bytes?.isNotEmpty == true ||
                                    _model.uploadedLocalFile_proofaddress.bytes?.isNotEmpty == true)) {
                              _model.apiResultblu =
                                  await UpgradetotierthreeCall.call(
                                accountNumber: effectiveAccountNo,
                                bvn: (ReturntierprofileCall.bvn(
                                                  (_model.tierone1?.jsonBody ??
                                                      ''),
                                                ) !=
                                                null &&
                                            ReturntierprofileCall.bvn(
                                                  (_model.tierone1?.jsonBody ??
                                                      ''),
                                                ) !=
                                                '')
                                    ? ReturntierprofileCall.bvn(
                                        (_model.tierone1?.jsonBody ?? ''),
                                      )
                                    : bvn,
                                nin: nin,
                                accountName: FFAppState().accountname,
                                phoneNumber:
                                    functions.addcode(FFAppState().phonenumber),
                                email: email,
                                idType: '1',
                                idNumber: nin,
                                houseNumber:
                                    _model.textController8.text.trim(),
                                streetName: _model.textController7.text.trim(),
                                state: _model.textController4.text.trim(),
                                city: _model.textController6.text.trim(),
                                localGovernment:
                                    _model.textController5.text.trim(),
                                pep: _model.dropDownValue3,
                                nearestLandmark:
                                    _model.textController9.text.trim(),
                                userPhoto: _model.userphoto,
                                idCardFront: _model.nincard,
                                customerSignature: await actions.newCustomAction2(
                                    functions.base64ToImage(FFAppState().signature)),
                                utilityBill: _model.utilitybill,
                                proofofaddress: _model.proofaddress,
                                accessToken: FFAppState().bsptoken,
                                tier: '3',
                              );

                              final isTier3Success = (_model.apiResultblu?.isSuccessful ?? false) ||
                                  UpgradetotierthreeCall.status(
                                        (_model.apiResultblu?.jsonBody ?? ''),
                                      ) ==
                                      true;

                              final tier3Msg = (_model.apiResultblu?.responseMessage.isNotEmpty == true)
                                  ? _model.apiResultblu!.responseMessage
                                  : (UpgradetotierthreeCall.message(
                                        (_model.apiResultblu?.jsonBody ?? ''),
                                      ) ??
                                      (isTier3Success
                                          ? 'Tier 3 upgrade submitted successfully!'
                                          : 'Tier 3 upgrade request could not be processed.'));

                              if (isTier3Success) {
                                FFAppState().tier = '3';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      tier3Msg,
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                    ),
                                    duration:
                                        const Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).primary,
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
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(
                                                  context),
                                          child:
                                              const ProcessingcompWidget(),
                                        ),
                                      ),
                                    );
                                  },
                                ).then(
                                    (value) => safeSetState(() {}));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      tier3Msg,
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                    ),
                                    duration:
                                        const Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context)
                                            .secondary,
                                  ),
                                );
                              }
                            }

                            if (mounted) {
                              context.pushNamed(NewhomeWidget.routeName);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  tier2Msg,
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                ),
                                duration:
                                    const Duration(milliseconds: 4000),
                                backgroundColor:
                                    FlutterFlowTheme.of(context).secondary,
                              ),
                            );
                          }

                          safeSetState(() {});
                        },
                        text: 'Upgrade to Tier 2',
                        options: FFButtonOptions(
                          height: 50.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(
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
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: wrapWithModel(
                  model: _model.bottomAppBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const BottomAppBarWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
