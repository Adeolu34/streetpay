import 'dart:io';
import 'dart:convert';
import '/backend/api_requests/api_calls.dart';
import '/components/processingcomp_widget.dart';
import '/services/kyc_draft_service.dart';
import '/services/image_compress_service.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'kycpaggge_model.dart';
import '/services/address_verification_helper.dart';
export 'kycpaggge_model.dart';

class KycpagggeWidget extends StatefulWidget {
  const KycpagggeWidget({
    super.key,
    this.targetTier,
    this.phoneno,
  });

  final String? targetTier;
  final String? phoneno;

  static String routeName = 'kycpaggge';
  static String routePath = '/kycpaggge';

  @override
  State<KycpagggeWidget> createState() => _KycpagggeWidgetState();
}

class _KycpagggeWidgetState extends State<KycpagggeWidget> {
  late KycpagggeModel _model;
  late String _selectedTargetTier;
  bool _isSubmitting = false;
  bool _isGeneratingProofAddress = false;
  bool _isAiGeneratingDescription = false;
  String? _lastGeneratedAddress;
  Future<ApiCallResponse>? _lgaFuture;
  String? _lastLgaState;

  bool _isDebugExpanded = true;
  String? _debugLastRequestBody;
  String? _debugLastResponseBody;
  int? _debugLastStatusCode;
  String? _debugLastError;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _generateAddressDescriptionWithAi() async {
    _saveFormState();
    safeSetState(() => _isAiGeneratingDescription = true);
    try {
      final enhanced = await AddressVerificationHelper.buildAiVerificationDescription(
        busStopOrLandmark: _model.textController8?.text.trim(),
        fillingStation: _model.textControllerFillingStation?.text.trim(),
        nearestBuilding: _model.textControllerNearestBuilding?.text.trim(),
        houseNumber: _model.textController6?.text.trim(),
        houseColor: _model.textControllerHouseColor?.text.trim(),
        streetName: _model.textController5?.text.trim(),
        city: _model.textController4?.text.trim(),
        state: _model.stateValue,
        routeExplanation: _model.textController7?.text.trim(),
        rawAddress: _buildFullAddress(),
      );

      safeSetState(() {
        _model.textController7?.text = enhanced;
        FFAppState().userLandmarkDesc = enhanced;
        FFAppState().userRouteDesc = enhanced;
      });
      _saveFormState();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '✨ AI generated a compliant address verification description!',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color(0xFF00A651),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error generating address description with AI: $e');
    } finally {
      if (mounted) {
        safeSetState(() => _isAiGeneratingDescription = false);
      }
    }
  }

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
    _model = createModel(context, () => KycpagggeModel());
    _selectedTargetTier = widget.targetTier ??
        ((FFAppState().tier == '2') ? '3' : '2');

    // On page load action: fetch states and restore draft / AppState
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState().accountname.isEmpty || !FFAppState().accountname.contains(' ')) {
        await _resolveBestCustomerName();
      }
      _model.statelist = await GetallstatesCall.call();

      final statesData = GetallstatesCall.allstates(
        (_model.statelist?.jsonBody ?? ''),
      );
      if (statesData is List) {
        FFAppState().allstates = statesData
            .map<String>((e) => e.toString())
            .toList();
      }

      final draft = await KycDraftService.getDraft();
      if (draft != null && draft.isNotEmpty && mounted) {
        if (draft.nin != null && draft.nin!.isNotEmpty) {
          _model.textController1?.text = draft.nin!;
        }
        if (draft.bvn != null && draft.bvn!.isNotEmpty) {
          _model.textController2?.text = draft.bvn!;
        }
        if (draft.phone != null && draft.phone!.isNotEmpty) {
          _model.textController3?.text = draft.phone!;
        }
        if (draft.city != null && draft.city!.isNotEmpty) {
          _model.textController4?.text = draft.city!;
        }
        if (draft.street != null && draft.street!.isNotEmpty) {
          _model.textController5?.text = draft.street!;
        }
        if (draft.houseNumber != null && draft.houseNumber!.isNotEmpty) {
          _model.textController6?.text = draft.houseNumber!;
        }
        if (draft.landmark != null && draft.landmark!.isNotEmpty) {
          _model.textController8?.text = draft.landmark!;
          FFAppState().userLandmark = draft.landmark!;
        }
        if (draft.state != null && draft.state!.isNotEmpty) {
          _model.stateValue = draft.state;
          _model.stateValueController?.value = draft.state;
        }
        if (draft.lga != null && draft.lga!.isNotEmpty) {
          _model.localgovernmentValue = draft.lga;
          _model.localgovernmentValueController?.value = draft.lga;
        }
        if (draft.gender != null && draft.gender!.isNotEmpty) {
          _model.genderValue = draft.gender;
          _model.genderValueController?.value = draft.gender;
        }
        if (draft.isPep != null) {
          _model.ispep = draft.isPep!;
        }
        if (draft.dateOfBirth != null) {
          _model.datePicked = DateTime.tryParse(draft.dateOfBirth!);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Restored your saved progress',
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(milliseconds: 2500),
            backgroundColor: Color(0xFF00A651),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // Auto-fill any remaining blank fields directly from persistent FFAppState
      if ((_model.textController1?.text.isEmpty ?? true) && FFAppState().userNIN.isNotEmpty) {
        _model.textController1?.text = FFAppState().userNIN;
      }
      if ((_model.textController2?.text.isEmpty ?? true)) {
        if (FFAppState().userBVN.isNotEmpty) {
          _model.textController2?.text = FFAppState().userBVN;
        } else if (FFAppState().bvn.isNotEmpty) {
          _model.textController2?.text = FFAppState().bvn;
        }
      }
      if ((_model.textController3?.text.isEmpty ?? true) && FFAppState().phonenumber.isNotEmpty) {
        _model.textController3?.text = FFAppState().phonenumber;
      }
      if ((_model.textController4?.text.isEmpty ?? true) && FFAppState().userCity.isNotEmpty) {
        _model.textController4?.text = FFAppState().userCity;
      }
      if ((_model.textController5?.text.isEmpty ?? true) && FFAppState().userStreet.isNotEmpty) {
        _model.textController5?.text = FFAppState().userStreet;
      }
      if ((_model.textController6?.text.isEmpty ?? true) && FFAppState().userHouseNo.isNotEmpty) {
        _model.textController6?.text = FFAppState().userHouseNo;
      }
      if ((_model.textController8?.text.isEmpty ?? true) && FFAppState().userLandmark.isNotEmpty) {
        _model.textController8?.text = FFAppState().userLandmark;
      }
      if ((_model.textController7?.text.isEmpty ?? true)) {
        if (FFAppState().userLandmarkDesc.isNotEmpty) {
          _model.textController7?.text = FFAppState().userLandmarkDesc;
        } else if (FFAppState().userRouteDesc.isNotEmpty) {
          _model.textController7?.text = FFAppState().userRouteDesc;
        }
      }
      if ((_model.textControllerFillingStation?.text.isEmpty ?? true) && FFAppState().userFillingStation.isNotEmpty) {
        _model.textControllerFillingStation?.text = FFAppState().userFillingStation;
      }
      if ((_model.textControllerNearestBuilding?.text.isEmpty ?? true) && FFAppState().userNearestBuilding.isNotEmpty) {
        _model.textControllerNearestBuilding?.text = FFAppState().userNearestBuilding;
      }
      if ((_model.textControllerHouseColor?.text.isEmpty ?? true) && FFAppState().userHouseColor.isNotEmpty) {
        _model.textControllerHouseColor?.text = FFAppState().userHouseColor;
      }
      if ((_model.stateValue == null || _model.stateValue!.isEmpty) && FFAppState().userState.isNotEmpty) {
        _model.stateValue = FFAppState().userState;
        _model.stateValueController?.value = FFAppState().userState;
      }
      if ((_model.localgovernmentValue == null || _model.localgovernmentValue!.isEmpty) && FFAppState().userLGA.isNotEmpty) {
        _model.localgovernmentValue = FFAppState().userLGA;
        _model.localgovernmentValueController?.value = FFAppState().userLGA;
      }
      if ((_model.genderValue == null || _model.genderValue!.isEmpty) && FFAppState().userGender.isNotEmpty) {
        _model.genderValue = FFAppState().userGender;
        _model.genderValueController?.value = FFAppState().userGender;
      }
      if (_model.datePicked == null && FFAppState().userDOB.isNotEmpty) {
        _model.datePicked = DateTime.tryParse(FFAppState().userDOB);
      }
      if (!_model.ispep && FFAppState().userPEP.isNotEmpty) {
        _model.ispep = (FFAppState().userPEP.toLowerCase() == 'yes' || FFAppState().userPEP == 'true');
      }

      // Restore uploaded KYC files from persistent local storage
      final savedNin = await KycFileService.getFile('nincard');
      if (savedNin != null && mounted) {
        _model.uploadedLocalFile_nincard = savedNin;
      }
      final savedSelfie = await KycFileService.getFile('selfie');
      if (savedSelfie != null && mounted) {
        _model.uploadedLocalFile_selfie = savedSelfie;
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
          _model.uploadedLocalFile_proofaddresss = savedProof;
          _lastGeneratedAddress = _buildFullAddress();
        } else {
          await KycFileService.removeFile('proofaddress');
        }
      }

      // If Proof of Address is not yet generated and address fields are already populated, auto-generate in background!
      if ((_model.uploadedLocalFile_proofaddresss.bytes?.isEmpty ?? true) &&
          _getMissingProofOfAddressFields().isEmpty &&
          mounted) {
        _autoGenerateProofOfAddress(silent: true);
      }

      safeSetState(() {});
    });

    _model.textController1 ??= TextEditingController(
      text: FFAppState().userNIN.isNotEmpty ? FFAppState().userNIN : '',
    );
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(
      text: FFAppState().userBVN.isNotEmpty
          ? FFAppState().userBVN
          : (FFAppState().bvn.isNotEmpty ? FFAppState().bvn : ''),
    );
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController(
      text: FFAppState().phonenumber.isNotEmpty ? FFAppState().phonenumber : '',
    );
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController(
      text: FFAppState().userCity.isNotEmpty ? FFAppState().userCity : '',
    );
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController(
      text: FFAppState().userStreet.isNotEmpty ? FFAppState().userStreet : '',
    );
    _model.textFieldFocusNode5 ??= FocusNode();

    _model.textController6 ??= TextEditingController(
      text: FFAppState().userHouseNo.isNotEmpty ? FFAppState().userHouseNo : '',
    );
    _model.textFieldFocusNode6 ??= FocusNode();

    // Description of Address
    _model.textController7 ??= TextEditingController(
      text: FFAppState().userLandmarkDesc.isNotEmpty
          ? FFAppState().userLandmarkDesc
          : '',
    );
    _model.textFieldFocusNode7 ??= FocusNode();

    // Closest Landmark
    _model.textController8 ??= TextEditingController(
      text: FFAppState().userLandmark.isNotEmpty ? FFAppState().userLandmark : '',
    );
    _model.textFieldFocusNode8 ??= FocusNode();

    // Nearest Filling Station
    _model.textControllerFillingStation ??= TextEditingController(
      text: FFAppState().userFillingStation.isNotEmpty ? FFAppState().userFillingStation : '',
    );
    _model.textFieldFocusNodeFillingStation ??= FocusNode();

    // Nearest Building
    _model.textControllerNearestBuilding ??= TextEditingController(
      text: FFAppState().userNearestBuilding.isNotEmpty ? FFAppState().userNearestBuilding : '',
    );
    _model.textFieldFocusNodeNearestBuilding ??= FocusNode();

    // Color of House
    _model.textControllerHouseColor ??= TextEditingController(
      text: FFAppState().userHouseColor.isNotEmpty ? FFAppState().userHouseColor : '',
    );
    _model.textFieldFocusNodeHouseColor ??= FocusNode();

    // Listen to focus changes on address fields to trigger auto-generation when user leaves them
    _model.textFieldFocusNode4?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNode5?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNode6?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNode7?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNode8?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNodeFillingStation?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNodeNearestBuilding?.addListener(_onAddressFocusChange);
    _model.textFieldFocusNodeHouseColor?.addListener(_onAddressFocusChange);

    if (FFAppState().userState.isNotEmpty) {
      _model.stateValue = FFAppState().userState;
      _model.stateValueController?.value = FFAppState().userState;
    }
    if (FFAppState().userLGA.isNotEmpty) {
      _model.localgovernmentValue = FFAppState().userLGA;
      _model.localgovernmentValueController?.value = FFAppState().userLGA;
    }
    if (FFAppState().userGender.isNotEmpty) {
      _model.genderValue = FFAppState().userGender;
      _model.genderValueController?.value = FFAppState().userGender;
    }
    if (FFAppState().userDOB.isNotEmpty) {
      _model.datePicked = DateTime.tryParse(FFAppState().userDOB);
    }
    if (FFAppState().userPEP.isNotEmpty) {
      _model.ispep = (FFAppState().userPEP.toLowerCase() == 'yes' || FFAppState().userPEP == 'true');
    }
  }

  void _saveFormState() {
    final nin = _model.textController1?.text.trim() ?? '';
    final bvn = _model.textController2?.text.trim() ?? '';
    final phone = _model.textController3?.text.trim() ?? '';
    final city = _model.textController4?.text.trim() ?? '';
    final street = _model.textController5?.text.trim() ?? '';
    final houseNo = _model.textController6?.text.trim() ?? '';
    final state = _model.stateValue?.trim() ?? '';
    final lga = _model.localgovernmentValue?.trim() ?? '';
    final gender = _model.genderValue?.trim() ?? '';
    final dob = _model.datePicked?.toIso8601String() ?? '';
    final pep = _model.ispep ? 'Yes' : 'No';

    if (nin.isNotEmpty) FFAppState().userNIN = nin;
    if (bvn.isNotEmpty) {
      FFAppState().userBVN = bvn;
      FFAppState().bvn = bvn;
    }
    if (phone.isNotEmpty) FFAppState().phonenumber = phone;
    if (city.isNotEmpty) FFAppState().userCity = city;
    if (street.isNotEmpty) FFAppState().userStreet = street;
    if (houseNo.isNotEmpty) FFAppState().userHouseNo = houseNo;
    if (state.isNotEmpty) FFAppState().userState = state;
    if (lga.isNotEmpty) FFAppState().userLGA = lga;
    if (gender.isNotEmpty) FFAppState().userGender = gender;
    if (dob.isNotEmpty) FFAppState().userDOB = dob;
    FFAppState().userPEP = pep;

    final landmark = _model.textController8?.text.trim() ?? '';
    if (landmark.isNotEmpty) {
      FFAppState().userLandmark = landmark;
      FFAppState().userBusStop = landmark;
    }

    final fillingStation = _model.textControllerFillingStation?.text.trim() ?? '';
    if (fillingStation.isNotEmpty) {
      FFAppState().userFillingStation = fillingStation;
    }

    final nearestBuilding = _model.textControllerNearestBuilding?.text.trim() ?? '';
    if (nearestBuilding.isNotEmpty) {
      FFAppState().userNearestBuilding = nearestBuilding;
    }

    final houseColor = _model.textControllerHouseColor?.text.trim() ?? '';
    if (houseColor.isNotEmpty) {
      FFAppState().userHouseColor = houseColor;
    }

    final addressDesc = _model.textController7?.text.trim() ?? '';
    if (addressDesc.isNotEmpty) {
      FFAppState().userLandmarkDesc = addressDesc;
      FFAppState().userRouteDesc = addressDesc;
    }

    KycDraftService.saveDraft(
      nin: nin.isNotEmpty ? nin : null,
      bvn: bvn.isNotEmpty ? bvn : null,
      phone: phone.isNotEmpty ? phone : null,
      city: city.isNotEmpty ? city : null,
      street: street.isNotEmpty ? street : null,
      houseNumber: houseNo.isNotEmpty ? houseNo : null,
      state: state.isNotEmpty ? state : null,
      lga: lga.isNotEmpty ? lga : null,
      gender: gender.isNotEmpty ? gender : null,
      isPep: _model.ispep,
      dateOfBirth: dob.isNotEmpty ? dob : null,
      landmark: landmark.isNotEmpty ? landmark : null,
    );
  }

  @override
  void dispose() {
    _model.textFieldFocusNode4?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNode5?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNode6?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNode7?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNode8?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNodeFillingStation?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNodeNearestBuilding?.removeListener(_onAddressFocusChange);
    _model.textFieldFocusNodeHouseColor?.removeListener(_onAddressFocusChange);
    _saveFormState();
    _model.dispose();
    super.dispose();
  }

  void _onAddressFocusChange() {
    if (!(_model.textFieldFocusNode4?.hasFocus ?? false) &&
        !(_model.textFieldFocusNode5?.hasFocus ?? false) &&
        !(_model.textFieldFocusNode6?.hasFocus ?? false) &&
        !(_model.textFieldFocusNode7?.hasFocus ?? false) &&
        !(_model.textFieldFocusNode8?.hasFocus ?? false) &&
        !(_model.textFieldFocusNodeFillingStation?.hasFocus ?? false) &&
        !(_model.textFieldFocusNodeNearestBuilding?.hasFocus ?? false) &&
        !(_model.textFieldFocusNodeHouseColor?.hasFocus ?? false)) {
      if (_getMissingProofOfAddressFields().isEmpty) {
        _autoGenerateProofOfAddress(silent: true);
      }
    }
  }

  List<String> _getMissingProofOfAddressFields() {
    final missing = <String>[];
    if (_model.stateValue == null || _model.stateValue!.trim().isEmpty) {
      missing.add('State');
    }
    if (_model.localgovernmentValue == null || _model.localgovernmentValue!.trim().isEmpty) {
      missing.add('Local Government (LGA)');
    }
    if (_model.textController4?.text.trim().isEmpty ?? true) {
      missing.add('City / Town');
    }
    if (_model.textController5?.text.trim().isEmpty ?? true) {
      missing.add('Street Name');
    }
    if (_model.textController6?.text.trim().isEmpty ?? true) {
      missing.add('House Number');
    }
    return missing;
  }

  Future<bool> _autoGenerateProofOfAddress({
    bool showAlertIfMissing = false,
    bool silent = false,
  }) async {
    if (_isGeneratingProofAddress) return false;

    _saveFormState();
    final missing = _getMissingProofOfAddressFields();
    if (missing.isNotEmpty) {
      if (showAlertIfMissing && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please complete your residential address: ${missing.join(', ')}.',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return false;
    }

    final fullAddress = _buildFullAddress();
    final currentBytes = _model.uploadedLocalFile_proofaddresss.bytes;
    if ((currentBytes?.isNotEmpty ?? false) &&
        (ImageCompressService.isJpeg(currentBytes) || ImageCompressService.isPng(currentBytes)) &&
        currentBytes!.length > 10 * 1024 &&
        _lastGeneratedAddress == fullAddress) {
      return true;
    }

    safeSetState(() {
      _isGeneratingProofAddress = true;
    });

    try {
      final customerName = await _resolveBestCustomerName();
      final busStop = _model.textController8?.text.trim().isNotEmpty ?? false
          ? _model.textController8!.text.trim()
          : (FFAppState().userLandmark.isNotEmpty ? FFAppState().userLandmark : null);
      final fillingStation = _model.textControllerFillingStation?.text.trim().isNotEmpty ?? false
          ? _model.textControllerFillingStation!.text.trim()
          : (FFAppState().userFillingStation.isNotEmpty ? FFAppState().userFillingStation : null);
      final nearestBuilding = _model.textControllerNearestBuilding?.text.trim().isNotEmpty ?? false
          ? _model.textControllerNearestBuilding!.text.trim()
          : (FFAppState().userNearestBuilding.isNotEmpty ? FFAppState().userNearestBuilding : null);
      final houseNo = _model.textController6?.text.trim().isNotEmpty ?? false
          ? _model.textController6!.text.trim()
          : (FFAppState().userHouseNo.isNotEmpty ? FFAppState().userHouseNo : null);
      final houseColor = _model.textControllerHouseColor?.text.trim().isNotEmpty ?? false
          ? _model.textControllerHouseColor!.text.trim()
          : (FFAppState().userHouseColor.isNotEmpty ? FFAppState().userHouseColor : null);
      final routeDesc = _model.textController7?.text.trim().isNotEmpty ?? false
          ? _model.textController7!.text.trim()
          : (FFAppState().userRouteDesc.isNotEmpty ? FFAppState().userRouteDesc : null);

      final jpegFile = await actions.generateVisitFeedbackJpeg(
        customerName.isNotEmpty ? customerName : null,
        fullAddress,
        _buildAddressDescription(),
        DateTime.now().subtract(const Duration(days: 2)),
        FFAppState().signature.isNotEmpty ? FFAppState().signature : null,
        'Akinwole Oluleye',
        'Abayomi IPADEOLA',
        busStop,
        busStop,
        fillingStation,
        nearestBuilding,
        houseNo,
        houseColor,
        routeDesc,
      );

      if (jpegFile.bytes != null && jpegFile.bytes!.isNotEmpty) {
        if (mounted) {
          safeSetState(() {
            _model.uploadedLocalFile_proofaddresss = jpegFile;
            _lastGeneratedAddress = fullAddress;
          });
        }
        await KycFileService.saveFile('proofaddress', jpegFile);
        if (!silent && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '⚡ Proof of Address generated (under 150 KB)!',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Color(0xFF00A651),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return true;
      }
    } catch (e) {
      debugPrint('Error auto-generating proof of address: $e');
      if (showAlertIfMissing && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Auto-generation failed: $e'),
            backgroundColor: const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        safeSetState(() {
          _isGeneratingProofAddress = false;
        });
      }
    }
    return false;
  }

  Future<void> _debugDownloadProofOfAddress() async {
    _saveFormState();

    var currentFile = _model.uploadedLocalFile_proofaddresss;
    if (currentFile.bytes == null || currentFile.bytes!.isEmpty) {
      final missing = _getMissingProofOfAddressFields();
      if (missing.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please complete your address fields first: ${missing.join(', ')}.',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final generated = await _autoGenerateProofOfAddress(showAlertIfMissing: true, silent: true);
      currentFile = _model.uploadedLocalFile_proofaddresss;
      if (!generated || (currentFile.bytes?.isEmpty ?? true)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to generate proof of address form.'),
              backgroundColor: Color(0xFFE53935),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }
    }

    try {
      final proof = currentFile;
      final bytes = proof.bytes;
      if (bytes == null || bytes.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No proof of address image data found.'),
              backgroundColor: Color(0xFFE53935),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      final kb = (bytes.lengthInBytes / 1024).toStringAsFixed(1);
      final filename = (proof.name?.isNotEmpty == true) ? proof.name! : 'proof_of_address.png';

      final tempDir = await getTemporaryDirectory();
      final localFile = File('${tempDir.path}/$filename');
      await localFile.writeAsBytes(bytes, flush: true);

      if (!mounted) return;

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(ctx).secondaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bug_report, color: Color(0xFF00A651), size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Proof of Address Debug',
                        style: FlutterFlowTheme.of(ctx).titleMedium.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF81C784)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Format: PNG | Size: $kb KB (≤ 150 KB limit)',
                        style: const TextStyle(
                          color: Color(0xFF1B5E20),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InteractiveViewer(
                    maxScale: 4.0,
                    child: Center(
                      child: Image.memory(
                        bytes,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await OpenFile.open(localFile.path);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Unable to open file viewer: $e')),
                          );
                        }
                      },
                      icon: const Icon(Icons.open_in_new, size: 18, color: Colors.white),
                      label: const Text('Open / View', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A651),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await Share.shareXFiles(
                            [XFile(localFile.path, mimeType: 'image/png')],
                            text: 'StreetPay Address Verification Form ($kb KB PNG)',
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Unable to share: $e')),
                          );
                        }
                      },
                      icon: const Icon(Icons.share, size: 18, color: Colors.white),
                      label: const Text('Download / Share', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FlutterFlowTheme.of(ctx).primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error in _debugDownloadProofOfAddress: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to prepare proof of address: $e')),
        );
      }
    } finally {
      if (mounted) {
        safeSetState(() => _isGeneratingProofAddress = false);
      }
    }
  }

  String _buildFullAddress() {
    final parts = <String>[];
    if (_model.textController6?.text.trim().isNotEmpty ?? false) {
      parts.add('House ${_model.textController6!.text.trim()}');
    }
    if (_model.textController5?.text.trim().isNotEmpty ?? false) {
      parts.add(_model.textController5!.text.trim());
    }
    if (_model.textController4?.text.trim().isNotEmpty ?? false) {
      parts.add(_model.textController4!.text.trim());
    }
    if (_model.localgovernmentValue?.trim().isNotEmpty ?? false) {
      parts.add(_model.localgovernmentValue!.trim());
    }
    if (_model.stateValue?.trim().isNotEmpty ?? false) {
      parts.add(_model.stateValue!.trim());
    }
    return parts.join(', ');
  }

  String _buildAddressDescription() {
    final customDesc = _model.textController7?.text.trim() ?? '';
    final busStop = _model.textController8?.text.trim().isNotEmpty ?? false
        ? _model.textController8!.text.trim()
        : FFAppState().userLandmark;
    final station = _model.textControllerFillingStation?.text.trim().isNotEmpty ?? false
        ? _model.textControllerFillingStation!.text.trim()
        : FFAppState().userFillingStation;
    final building = _model.textControllerNearestBuilding?.text.trim().isNotEmpty ?? false
        ? _model.textControllerNearestBuilding!.text.trim()
        : FFAppState().userNearestBuilding;
    final houseNo = _model.textController6?.text.trim().isNotEmpty ?? false
        ? _model.textController6!.text.trim()
        : FFAppState().userHouseNo;
    final color = _model.textControllerHouseColor?.text.trim().isNotEmpty ?? false
        ? _model.textControllerHouseColor!.text.trim()
        : FFAppState().userHouseColor;
    final street = _model.textController5?.text.trim().isNotEmpty ?? false
        ? _model.textController5!.text.trim()
        : FFAppState().userStreet;
    final city = _model.textController4?.text.trim().isNotEmpty ?? false
        ? _model.textController4!.text.trim()
        : FFAppState().userCity;

    return AddressVerificationHelper.buildVerificationDescription(
      busStopOrLandmark: busStop,
      fillingStation: station,
      nearestBuilding: building,
      houseNumber: houseNo,
      houseColor: color,
      streetName: street,
      city: city,
      routeExplanation: customDesc.isNotEmpty ? customDesc : FFAppState().userRouteDesc,
      rawAddress: _buildFullAddress(),
    );
  }

  Future<void> _pickNinCardMedia() async {
    final selectedMedia = await selectMediaWithSourceBottomSheet(
      context: context,
      allowPhoto: true,
    );
    if (selectedMedia != null &&
        selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
      safeSetState(() => _model.isDataUploading_nincard = true);
      var selectedUploadedFiles = <FFUploadedFile>[];
      try {
        selectedUploadedFiles = selectedMedia
            .map((m) => FFUploadedFile(
                  name: m.storagePath.split('/').last,
                  bytes: m.bytes,
                  height: m.dimensions?.height,
                  width: m.dimensions?.width,
                  blurHash: m.blurHash,
                  originalFilename: m.originalFilename,
                ))
            .toList();
      } finally {
        _model.isDataUploading_nincard = false;
      }
      if (selectedUploadedFiles.length == selectedMedia.length) {
        final rawFile = selectedUploadedFiles.first;
        final file = await actions.newCustomAction2(rawFile);
        safeSetState(() {
          _model.uploadedLocalFile_nincard = file;
        });
        await KycFileService.saveFile('nincard', file);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '✓ NIN document attached successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF00A651),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _pickSelfieMedia() async {
    final selectedMedia = await selectMediaWithSourceBottomSheet(
      context: context,
      allowPhoto: true,
    );
    if (selectedMedia != null &&
        selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
      safeSetState(() => _model.isDataUploading_selfie = true);
      var selectedUploadedFiles = <FFUploadedFile>[];
      try {
        selectedUploadedFiles = selectedMedia
            .map((m) => FFUploadedFile(
                  name: m.storagePath.split('/').last,
                  bytes: m.bytes,
                  height: m.dimensions?.height,
                  width: m.dimensions?.width,
                  blurHash: m.blurHash,
                  originalFilename: m.originalFilename,
                ))
            .toList();
      } finally {
        _model.isDataUploading_selfie = false;
      }
      if (selectedUploadedFiles.length == selectedMedia.length) {
        final rawFile = selectedUploadedFiles.first;
        final file = await actions.newCustomAction2(rawFile);
        safeSetState(() {
          _model.uploadedLocalFile_selfie = file;
        });
        await KycFileService.saveFile('selfie', file);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '✓ Selfie photo attached successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF00A651),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _pickUtilityBillMedia() async {
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
              content: Text(
                '✓ Utility bill attached successfully!',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xFF00A651),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          safeSetState(() => _model.isDataUploading_utilitybill = false);
        }
      }
    }
  }

  Future<void> _submitUpgrade() async {
    _saveFormState();
    final rawNin = (_model.textController1?.text.trim().isNotEmpty ?? false)
        ? _model.textController1!.text.trim()
        : FFAppState().userNIN.trim();
    final rawBvn = (_model.textController2?.text.trim().isNotEmpty ?? false)
        ? _model.textController2!.text.trim()
        : (FFAppState().userBVN.trim().isNotEmpty
            ? FFAppState().userBVN.trim()
            : FFAppState().bvn.trim());

    final nin = rawNin.replaceAll(RegExp(r'\D'), '');
    final bvn = rawBvn.replaceAll(RegExp(r'\D'), '');

    if (nin.isNotEmpty && _model.textController1 != null) {
      _model.textController1!.text = nin;
      FFAppState().userNIN = nin;
    }
    if (bvn.isNotEmpty && _model.textController2 != null) {
      _model.textController2!.text = bvn;
      FFAppState().userBVN = bvn;
      FFAppState().bvn = bvn;
    }

    void showError(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, style: const TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFFC93B2B),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (nin.length != 11) {
      showError('Please enter a valid 11-digit NIN.');
      return;
    }

    if (bvn.length != 11) {
      showError('Please enter a valid 11-digit BVN.');
      return;
    }

    final phone = _model.textController3?.text.trim() ?? '';
    if (phone.isEmpty || phone.length < 10) {
      showError('Please enter a valid phone number.');
      return;
    }

    if (_model.datePicked == null) {
      showError('Please select your Date of Birth.');
      return;
    }

    if (_model.genderValue == null || _model.genderValue!.isEmpty) {
      showError('Please select your Gender.');
      return;
    }

    final missingAddressFields = _getMissingProofOfAddressFields();
    if (missingAddressFields.isNotEmpty) {
      showError('Please complete your residential address: ${missingAddressFields.join(', ')}.');
      return;
    }

    // Auto-generate proof of address silently in background if not already done
    if (_model.uploadedLocalFile_proofaddresss.bytes?.isEmpty ?? true) {
      final generated = await _autoGenerateProofOfAddress(silent: true);
      if (!generated || (_model.uploadedLocalFile_proofaddresss.bytes?.isEmpty ?? true)) {
        showError('Proof of address has not been generated. Please complete your residential address details to proceed.');
        return;
      }
    }

    if (_model.uploadedLocalFile_nincard.bytes?.isEmpty ?? true) {
      showError('Please upload your NIN card / slip to proceed.');
      return;
    }
    if (_model.uploadedLocalFile_selfie.bytes?.isEmpty ?? true) {
      showError('Please capture your user photo / selfie to proceed.');
      return;
    }

    if (FFAppState().signature.isEmpty) {
      showError('Please draw and save your digital signature.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final authRes = await StreetauthCall.call(forceRefresh: true);
      final freshToken = StreetauthCall.streettoken(authRes.jsonBody);
      final token = (freshToken != null && freshToken.isNotEmpty)
          ? freshToken
          : (FFAppState().bsptoken.isNotEmpty
              ? FFAppState().bsptoken
              : FFAppState().streetauth);
      if (freshToken != null && freshToken.isNotEmpty) {
        FFAppState().bsptoken = freshToken;
        FFAppState().streetauth = freshToken;
      }

      _model.tierone1 = await ReturntierprofileCall.call(
        phoneno: functions.removecode(FFAppState().phonenumber),
        accessToken: token,
      );

      final profileAccNo = ReturntierprofileCall.accountNo(_model.tierone1?.jsonBody ?? '');
      if (profileAccNo != null && profileAccNo.isNotEmpty && FFAppState().accountno.isEmpty) {
        FFAppState().accountno = profileAccNo;
      }
      final effectiveAccountNo = FFAppState().accountno.isNotEmpty
          ? FFAppState().accountno
          : ((profileAccNo != null && profileAccNo.isNotEmpty)
              ? profileAccNo!
              : (FFAppState().walletid.isNotEmpty ? FFAppState().walletid : ''));

      final effectiveProof = _model.uploadedLocalFile_proofaddresss;
      if (effectiveProof.bytes == null || effectiveProof.bytes!.isEmpty) {
        showError('Proof of address has not been generated. Please complete your residential address to proceed.');
        setState(() => _isSubmitting = false);
        return;
      }
      final effectiveUtility = (_model.uploadedLocalFile_utilitybill.bytes?.isNotEmpty ?? false)
          ? _model.uploadedLocalFile_utilitybill
          : null;

      // Process documents sequentially to avoid memory spikes and thread lock
      _model.userphoto = await actions.newCustomAction2(
        _model.uploadedLocalFile_selfie,
        75,
      );

      _model.proofaddress = await ImageCompressService.compressUploadedFile(
        effectiveProof,
        maxSizeKB: 150,
        minSizeKB: 0,
        isProof: true,
      );

      if (effectiveUtility != null) {
        _model.utilitybill = await actions.newCustomAction2(
          effectiveUtility,
          100,
        );
      } else {
        _model.utilitybill = null;
      }

      _model.nincard = await actions.newCustomAction2(
        _model.uploadedLocalFile_nincard,
        75,
      );

      final sigImage = functions.base64ToImage(FFAppState().signature);
      final signatureFile = sigImage != null
          ? await actions.newCustomAction2(sigImage, 50)
          : null;

      await KycDraftService.saveDraft(
        nin: _model.textController1?.text,
        bvn: _model.textController2?.text,
        phone: _model.textController3?.text,
        city: _model.textController4?.text,
        street: _model.textController5?.text,
        houseNumber: _model.textController6?.text,
        state: _model.stateValue,
        lga: _model.localgovernmentValue,
        gender: _model.genderValue,
        isPep: _model.ispep,
        dateOfBirth: _model.datePicked?.toIso8601String(),
      );

      bool isSuccess = false;
      String responseMsg = '';

      if (_selectedTargetTier == '3') {
        _model.upgradethreeCopy = await UpgradetotierthreeCall.call(
          accountNumber: effectiveAccountNo,
          bvn: bvn,
          nin: nin,
          accountName: FFAppState().accountname,
          phoneNumber: functions.addcode(FFAppState().phonenumber),
          email: FFAppState().email,
          idType: '1',
          idNumber: nin,
          idIssueDate: dateTimeFormat(
            "yyyy-MM-dd",
            _model.datePicked ?? DateTime.now(),
            locale: FFLocalizations.of(context).languageCode,
          ),
          idCardFront: _model.nincard,
          userPhoto: _model.userphoto,
          houseNumber: _model.textController6?.text,
          streetName: _model.textController5?.text,
          state: _model.stateValue,
          city: _model.textController4?.text,
          localGovernment: _model.localgovernmentValue ?? _model.textController1?.text,
          pep: _model.ispep ? 'Yes' : 'No',
          nearestLandmark: (_model.textController8?.text.trim().isNotEmpty ?? false)
              ? _model.textController8!.text.trim()
              : (FFAppState().userLandmark.isNotEmpty
                  ? FFAppState().userLandmark
                  : (FFAppState().userBusStop.isNotEmpty
                      ? FFAppState().userBusStop
                      : (FFAppState().userFillingStation.isNotEmpty
                          ? FFAppState().userFillingStation
                          : ''))),
          customerSignature: signatureFile,
          utilityBill: _model.utilitybill,
          proofofaddress: _model.proofaddress,
          accessToken: token,
          tier: '3',
        );
        isSuccess = (_model.upgradethreeCopy?.isSuccessful ?? false) ||
            UpgradetotierthreeCall.status(_model.upgradethreeCopy?.jsonBody ?? '') == true;
        responseMsg = (_model.upgradethreeCopy?.responseMessage.isNotEmpty == true)
            ? _model.upgradethreeCopy!.responseMessage
            : (UpgradetotierthreeCall.message(_model.upgradethreeCopy?.jsonBody ?? '') ??
                (isSuccess
                    ? 'Tier 3 upgrade submitted successfully!'
                    : 'Tier 3 upgrade request could not be processed.'));
        try {
          _debugLastRequestBody = const JsonEncoder.withIndent('  ').convert(
            UpgradetotierthreeCall.lastCallRequestBody ?? _buildCurrentDebugPayload(),
          );
        } catch (_) {
          _debugLastRequestBody =
              (UpgradetotierthreeCall.lastCallRequestBody ?? _buildCurrentDebugPayload()).toString();
        }
        _debugLastResponseBody = UpgradetotierthreeCall.lastCallResponseBody ??
            _model.upgradethreeCopy?.response?.body ??
            _model.upgradethreeCopy?.jsonBody?.toString() ??
            _model.upgradethreeCopy?.responseMessage ??
            'No response body received';
        _debugLastStatusCode = UpgradetotierthreeCall.lastCallStatusCode ?? _model.upgradethreeCopy?.statusCode;
        _debugLastError = isSuccess ? null : responseMsg;
      } else {
        _model.upgradetwo = await UpgradetoteirtwoCall.call(
          accountNumber: effectiveAccountNo,
          bvn: bvn,
          accountName: FFAppState().accountname,
          phoneNumber: functions.addcode(FFAppState().phonenumber),
          tier: _selectedTargetTier,
          email: FFAppState().email,
          userPhoto: _model.userphoto,
          idType: '1',
          idNumber: nin,
          idIssueDate: dateTimeFormat(
            "yyyy-MM-dd",
            _model.datePicked ?? DateTime.now(),
            locale: FFLocalizations.of(context).languageCode,
          ),
          idCardFront: _model.nincard,
          houseNumber: _model.textController6?.text,
          streetName: _model.textController5?.text,
          state: _model.stateValue,
          city: _model.textController4?.text,
          localGovernment: _model.localgovernmentValue ?? _model.textController1?.text,
          pep: _model.ispep ? 'Yes' : 'No',
          customerSignature: signatureFile,
          utilityBill: _model.utilitybill,
          proofaddress: _model.proofaddress,
          nearestLandmark: _model.textController5?.text,
          accessToken: token,
          nin: nin,
        );
        isSuccess = (_model.upgradetwo?.isSuccessful ?? false) ||
            UpgradetoteirtwoCall.status(_model.upgradetwo?.jsonBody ?? '') == true;
        responseMsg = (_model.upgradetwo?.responseMessage.isNotEmpty == true)
            ? _model.upgradetwo!.responseMessage
            : (UpgradetoteirtwoCall.message(_model.upgradetwo?.jsonBody ?? '') ??
                (isSuccess
                    ? 'Tier $_selectedTargetTier upgrade submitted successfully!'
                    : 'Tier $_selectedTargetTier upgrade request could not be processed.'));
        try {
          _debugLastRequestBody = const JsonEncoder.withIndent('  ').convert(
            UpgradetoteirtwoCall.lastCallRequestBody ?? _buildCurrentDebugPayload(),
          );
        } catch (_) {
          _debugLastRequestBody =
              (UpgradetoteirtwoCall.lastCallRequestBody ?? _buildCurrentDebugPayload()).toString();
        }
        _debugLastResponseBody = UpgradetoteirtwoCall.lastCallResponseBody ??
            _model.upgradetwo?.response?.body ??
            _model.upgradetwo?.jsonBody?.toString() ??
            _model.upgradetwo?.responseMessage ??
            'No response body received';
        _debugLastStatusCode = UpgradetoteirtwoCall.lastCallStatusCode ?? _model.upgradetwo?.statusCode;
        _debugLastError = isSuccess ? null : responseMsg;
      }

      if (isSuccess) {
        FFAppState().tier = _selectedTargetTier;
        await KycDraftService.clearDraft();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                responseMsg,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              duration: const Duration(milliseconds: 4000),
              backgroundColor: const Color(0xFF00A651),
              behavior: SnackBarBehavior.floating,
            ),
          );
          if (_selectedTargetTier == '3') {
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
          }
          context.pushNamed(NewhomeWidget.routeName);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                responseMsg,
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(milliseconds: 4000),
              backgroundColor: FlutterFlowTheme.of(context).secondary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      _debugLastError = '$e';
      _debugLastResponseBody = 'Exception: $e';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An unexpected error occurred: $e',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        safeSetState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final cardBg = FlutterFlowTheme.of(context).secondaryBackground;
    final borderColor = FlutterFlowTheme.of(context).alternate;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          elevation: 0.5,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 54.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Upgrade',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18.0,
                    ),
              ),
              Text(
                'Unlock higher limits & full features',
                style: FlutterFlowTheme.of(context).labelSmall.override(
                      font: GoogleFonts.inter(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 11.0,
                    ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A651).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: const Color(0xFF00A651), width: 1.0),
                  ),
                  child: Text(
                    'Current: Tier ${FFAppState().tier.isNotEmpty ? FFAppState().tier : '1'}',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF00A651),
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _model.columnController,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- SEGMENTED TIER SWITCHER ---
                      _buildTierSwitcher(),
                      const SizedBox(height: 16.0),

                      // --- TIER BENEFIT BANNER ---
                      _buildTierBenefitBanner(),
                      const SizedBox(height: 18.0),

                      // --- DYNAMIC FORM CONTENT ---
                      // SECTION 1: PERSONAL & IDENTITY DETAILS
                      _buildPersonalDetailsCard(cardBg, borderColor),
                      const SizedBox(height: 16.0),

                      // SECTION 2: RESIDENTIAL ADDRESS
                      _buildResidentialAddressCard(cardBg, borderColor),
                      const SizedBox(height: 16.0),


                      // UTILITY BILL (PHCN / WATER / WASTE)
                      _buildUtilityBillCard(cardBg, borderColor),
                      const SizedBox(height: 16.0),

                      // SECTION 3: IDENTITY DOCUMENTS & LIVE SELFIE (USER PHOTO)
                      _buildIdentityDocumentsCard(cardBg, borderColor),
                      const SizedBox(height: 16.0),

                      // SECTION 4: DIGITAL SIGNATURE
                      _buildSignatureCard(cardBg, borderColor),


                      const SizedBox(height: 32.0),
                    ],
                  ),
                ),
              ),

              // --- BOTTOM STICKY ACTION BAR ---
              _buildBottomActionBar(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET BUILDERS
  // ==========================================

  Widget _buildTierSwitcher() {
    final isTier2 = _selectedTargetTier == '2';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {
                setState(() => _selectedTargetTier = '2');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: isTier2 ? const Color(0xFF00A651) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: isTier2
                      ? [
                          BoxShadow(
                            color: const Color(0xFF00A651).withValues(alpha: 0.3),
                            blurRadius: 8.0,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      'Tier 2 Upgrade',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: isTier2 ? Colors.white : FlutterFlowTheme.of(context).primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      '₦500k Balance Limit',
                      style: GoogleFonts.inter(
                        color: isTier2 ? Colors.white.withValues(alpha: 0.9) : FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 4.0),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {
                setState(() => _selectedTargetTier = '3');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: !isTier2 ? const Color(0xFF00A651) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: !isTier2
                      ? [
                          BoxShadow(
                            color: const Color(0xFF00A651).withValues(alpha: 0.3),
                            blurRadius: 8.0,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      'Tier 3 Upgrade',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: !isTier2 ? Colors.white : FlutterFlowTheme.of(context).primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'Unlimited Balance',
                      style: GoogleFonts.inter(
                        color: !isTier2 ? Colors.white.withValues(alpha: 0.9) : FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierBenefitBanner() {
    final isTier2 = _selectedTargetTier == '2';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF00A651).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFF00A651).withValues(alpha: 0.25),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF00A651).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.trending_up_rounded,
              color: Color(0xFF00A651),
              size: 20.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTier2 ? 'Tier 2 Account Limits' : 'Tier 3 VIP Limits',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: const Color(0xFF00A651),
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  isTier2
                      ? 'Daily Limit: ₦5,000,000  •  Max Balance: ₦500,000'
                      : 'Daily Limit: Unlimited  •  Max Balance: Unlimited',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsCard(Color cardBg, Color borderColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A651).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.person_outline_rounded, color: Color(0xFF00A651), size: 18.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14.5),
                    ),
                    Text(
                      'Enter your verified identity details',
                      style: GoogleFonts.inter(fontSize: 11.5, color: FlutterFlowTheme.of(context).secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // NIN Number
          Text(
            'National Identity Number (NIN)',
            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6.0),
          TextFormField(
            controller: _model.textController1,
            focusNode: _model.textFieldFocusNode1,
            keyboardType: TextInputType.number,
            maxLength: 11,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            onChanged: (val) {
              FFAppState().userNIN = val;
              _saveFormState();
            },
            decoration: _inputDecoration(
              hint: 'Enter your 11-digit NIN',
              icon: Icons.fingerprint,
            ),
            style: GoogleFonts.inter(fontSize: 14.0),
          ),
          const SizedBox(height: 12.0),

          // BVN Number
          Text(
            'Bank Verification Number (BVN)',
            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6.0),
          TextFormField(
            controller: _model.textController2,
            focusNode: _model.textFieldFocusNode2,
            keyboardType: TextInputType.number,
            maxLength: 11,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            onChanged: (val) {
              FFAppState().userBVN = val;
              FFAppState().bvn = val;
              _saveFormState();
            },
            decoration: _inputDecoration(
              hint: 'Enter your 11-digit BVN',
              icon: Icons.account_balance_outlined,
            ),
            style: GoogleFonts.inter(fontSize: 14.0),
          ),
          const SizedBox(height: 12.0),

          // Date of Birth & Gender
          Row(
            children: [
              // Date of Birth
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date of Birth',
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6.0),
                    InkWell(
                      borderRadius: BorderRadius.circular(10.0),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _model.datePicked ?? DateTime(1998, 1, 1),
                          firstDate: DateTime(1930),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF00A651),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          safeSetState(() => _model.datePicked = pickedDate);
                          FFAppState().userDOB = pickedDate.toIso8601String();
                          _saveFormState();
                        }
                      },
                      child: Container(
                        height: 50.0,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: FlutterFlowTheme.of(context).alternate),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 16.0, color: Color(0xFF00A651)),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                _model.datePicked != null
                                    ? dateTimeFormat("yyyy-MM-dd", _model.datePicked)
                                    : 'Select Date',
                                style: GoogleFonts.inter(
                                  fontSize: 13.0,
                                  color: _model.datePicked != null
                                      ? FlutterFlowTheme.of(context).primaryText
                                      : FlutterFlowTheme.of(context).secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),

              // Gender Dropdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gender',
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6.0),
                    FlutterFlowDropDown<String>(
                      controller: _model.genderValueController ??= FormFieldController<String>(null),
                      options: const ['Male', 'Female'],
                      onChanged: (val) {
                        safeSetState(() => _model.genderValue = val);
                        if (val != null) FFAppState().userGender = val;
                        _saveFormState();
                      },
                      width: double.infinity,
                      height: 50.0,
                      textStyle: GoogleFonts.inter(fontSize: 13.0, color: FlutterFlowTheme.of(context).primaryText),
                      hintText: 'Select',
                      icon: Icon(Icons.keyboard_arrow_down_rounded, color: FlutterFlowTheme.of(context).secondaryText),
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      elevation: 2.0,
                      borderColor: FlutterFlowTheme.of(context).alternate,
                      borderWidth: 1.0,
                      borderRadius: 10.0,
                      margin: const EdgeInsets.symmetric(horizontal: 12.0),
                      hidesUnderline: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14.0),

          // PEP Toggle
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: FlutterFlowTheme.of(context).alternate),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Politically Exposed Person (PEP)',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12.5),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Are you or immediate family an elected or appointed official?',
                        style: GoogleFonts.inter(fontSize: 11.0, color: FlutterFlowTheme.of(context).secondaryText),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _model.ispep,
                  activeThumbColor: const Color(0xFF00A651),
                  onChanged: (val) {
                    safeSetState(() => _model.ispep = val);
                    FFAppState().userPEP = val ? 'Yes' : 'No';
                    _saveFormState();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResidentialAddressCard(Color cardBg, Color borderColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A651).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.home_outlined, color: Color(0xFF00A651), size: 18.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Residential Address',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14.5),
                    ),
                    Text(
                      'Used for official physical address verification',
                      style: GoogleFonts.inter(fontSize: 11.5, color: FlutterFlowTheme.of(context).secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // State Dropdown
          Text(
            'State of Residence',
            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6.0),
          FlutterFlowDropDown<String>(
            controller: _model.stateValueController ??= FormFieldController<String>(null),
            options: FFAppState().allstates.isNotEmpty
                ? FFAppState().allstates
                : const ['Lagos', 'Abuja (FCT)', 'Rivers', 'Oyo', 'Kano', 'Enugu', 'Delta'],
            onChanged: (val) {
              safeSetState(() {
                _model.stateValue = val;
                _model.localgovernmentValue = null;
                _model.localgovernmentValueController?.value = null;
              });
              if (val != null) FFAppState().userState = val;
              _saveFormState();
              if (_getMissingProofOfAddressFields().isEmpty) {
                _autoGenerateProofOfAddress(silent: true);
              }
            },
            width: double.infinity,
            height: 50.0,
            textStyle: GoogleFonts.inter(fontSize: 13.0, color: FlutterFlowTheme.of(context).primaryText),
            hintText: 'Select your state',
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: FlutterFlowTheme.of(context).secondaryText),
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            elevation: 2.0,
            borderColor: FlutterFlowTheme.of(context).alternate,
            borderWidth: 1.0,
            borderRadius: 10.0,
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            hidesUnderline: true,
          ),
          const SizedBox(height: 12.0),

          // LGA Dropdown (Dependent on selected state)
          Text(
            'Local Government Area (LGA)',
            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6.0),
          Builder(
            builder: (context) {
              if (_model.stateValue != _lastLgaState) {
                _lastLgaState = _model.stateValue;
                if (_model.stateValue != null && _model.stateValue!.isNotEmpty) {
                  _lgaFuture = GetlgaCall.call(lga: _model.stateValue);
                } else {
                  _lgaFuture = null;
                }
              }
              return FutureBuilder<ApiCallResponse>(
                future: _lgaFuture,
            builder: (context, snapshot) {
              List<String> lgas = [];
              if (snapshot.hasData && snapshot.data != null) {
                final lgaData = GetlgaCall.lgas(snapshot.data!.jsonBody);
                if (lgaData is List) {
                  lgas = lgaData.map((e) => e.toString()).toList();
                }
              }
              return FlutterFlowDropDown<String>(
                controller: _model.localgovernmentValueController ??= FormFieldController<String>(null),
                options: lgas.isNotEmpty ? lgas : (_model.localgovernmentValue != null ? [_model.localgovernmentValue!] : const []),
                onChanged: (val) {
                  safeSetState(() => _model.localgovernmentValue = val);
                  if (val != null) FFAppState().userLGA = val;
                  _saveFormState();
                  if (_getMissingProofOfAddressFields().isEmpty) {
                    _autoGenerateProofOfAddress(silent: true);
                  }
                },
                width: double.infinity,
                height: 50.0,
                textStyle: GoogleFonts.inter(fontSize: 13.0, color: FlutterFlowTheme.of(context).primaryText),
                hintText: _model.stateValue != null
                    ? (lgas.isNotEmpty ? 'Select Local Government' : 'Loading LGAs...')
                    : 'Select State first',
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: FlutterFlowTheme.of(context).secondaryText),
                fillColor: FlutterFlowTheme.of(context).primaryBackground,
                elevation: 2.0,
                borderColor: FlutterFlowTheme.of(context).alternate,
                borderWidth: 1.0,
                borderRadius: 10.0,
                margin: const EdgeInsets.symmetric(horizontal: 12.0),
                hidesUnderline: true,
              );
            },
          );
        },
      ),
      const SizedBox(height: 12.0),

          // City
          Text(
            'City / Town',
            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6.0),
          TextFormField(
            controller: _model.textController4,
            focusNode: _model.textFieldFocusNode4,
            onChanged: (val) {
              FFAppState().userCity = val;
              _saveFormState();
            },
            decoration: _inputDecoration(
              hint: 'e.g. Ikeja, Lekki, Wuse',
              icon: Icons.location_city_rounded,
            ),
            style: GoogleFonts.inter(fontSize: 14.0),
          ),
          const SizedBox(height: 12.0),

          // Street & House Number in Row
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Street Name',
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6.0),
                    TextFormField(
                      controller: _model.textController5,
                      focusNode: _model.textFieldFocusNode5,
                      onChanged: (val) {
                        FFAppState().userStreet = val;
                        _saveFormState();
                      },
                      decoration: _inputDecoration(
                        hint: 'e.g. Adeniyi Jones Avenue',
                        icon: Icons.edit_road_rounded,
                      ),
                      style: GoogleFonts.inter(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'House / Flat #',
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6.0),
                    TextFormField(
                      controller: _model.textController6,
                      focusNode: _model.textFieldFocusNode6,
                      onChanged: (val) {
                        FFAppState().userHouseNo = val;
                        _saveFormState();
                      },
                      decoration: _inputDecoration(
                        hint: 'e.g. 14B',
                        icon: Icons.numbers_rounded,
                      ),
                      style: GoogleFonts.inter(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Popular Bus Stop Around Address / Closest Landmark
          Text(
            'Popular Bus Stop Around Address / Landmark',
            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6.0),
          TextFormField(
            controller: _model.textController8,
            focusNode: _model.textFieldFocusNode8,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (val) {
              FFAppState().userLandmark = val.trim();
              FFAppState().userBusStop = val.trim();
              _saveFormState();
            },
            decoration: _inputDecoration(
              hint: 'e.g. Maryland Bus Stop, Ojota Roundabout',
              icon: Icons.directions_bus_filled_outlined,
            ),
            style: GoogleFonts.inter(fontSize: 14.0),
          ),
          const SizedBox(height: 12.0),

          // Nearest Filling Station Along Route
          Text(
            'Nearest Filling Station (Along Route)',
            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6.0),
          TextFormField(
            controller: _model.textControllerFillingStation,
            focusNode: _model.textFieldFocusNodeFillingStation,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (val) {
              FFAppState().userFillingStation = val.trim();
              _saveFormState();
            },
            decoration: _inputDecoration(
              hint: 'e.g. TotalEnergies Filling Station',
              icon: Icons.local_gas_station_outlined,
            ),
            style: GoogleFonts.inter(fontSize: 14.0),
          ),
          const SizedBox(height: 12.0),

          // Nearest Building / Structure
          Text(
            'Nearest Building to your House',
            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6.0),
          TextFormField(
            controller: _model.textControllerNearestBuilding,
            focusNode: _model.textFieldFocusNodeNearestBuilding,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (val) {
              FFAppState().userNearestBuilding = val.trim();
              _saveFormState();
            },
            decoration: _inputDecoration(
              hint: 'e.g. Beside First Bank branch, Adjacent to Plaza',
              icon: Icons.business_outlined,
            ),
            style: GoogleFonts.inter(fontSize: 14.0),
          ),
          const SizedBox(height: 12.0),

          // Color of House
          Text(
            'Color of House / Building',
            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6.0),
          TextFormField(
            controller: _model.textControllerHouseColor,
            focusNode: _model.textFieldFocusNodeHouseColor,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (val) {
              FFAppState().userHouseColor = val.trim();
              _saveFormState();
            },
            decoration: _inputDecoration(
              hint: 'e.g. Yellow bungalow, Cream storey building, Blue gate',
              icon: Icons.color_lens_outlined,
            ),
            style: GoogleFonts.inter(fontSize: 14.0),
          ),
          const SizedBox(height: 12.0),

          // Route Explanation: Explain your address from [Bus stop] or [Landmark]
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Explain Address from [Bus stop] or [Landmark]',
                  style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  '9PSB Compliance',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00A651),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          TextFormField(
            controller: _model.textController7,
            focusNode: _model.textFieldFocusNode7,
            maxLines: 2,
            minLines: 1,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (val) {
              FFAppState().userLandmarkDesc = val.trim();
              FFAppState().userRouteDesc = val.trim();
              if (FFAppState().userLandmark.isEmpty) {
                FFAppState().userLandmark = val.trim();
              }
              _saveFormState();
            },
            decoration: _inputDecoration(
              hint: 'e.g. Head along access road, pass TotalEnergies, turn right into street, duplex on the right',
              icon: Icons.alt_route_rounded,
            ),
            style: GoogleFonts.inter(fontSize: 14.0),
          ),

        ],
      ),
    );
  }

  Future<void> _manualGenerateProofOfAddress() async {
    _saveFormState();
    final missing = _getMissingProofOfAddressFields();
    if (missing.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please complete your address first: ${missing.join(', ')}.',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    safeSetState(() => _isGeneratingProofAddress = true);
    try {
      final fullAddress = _buildFullAddress();
      final customerName = await _resolveBestCustomerName();
      final busStop = _model.textController8?.text.trim().isNotEmpty ?? false
          ? _model.textController8!.text.trim()
          : (FFAppState().userLandmark.isNotEmpty ? FFAppState().userLandmark : null);
      final fillingStation = _model.textControllerFillingStation?.text.trim().isNotEmpty ?? false
          ? _model.textControllerFillingStation!.text.trim()
          : (FFAppState().userFillingStation.isNotEmpty ? FFAppState().userFillingStation : null);
      final nearestBuilding = _model.textControllerNearestBuilding?.text.trim().isNotEmpty ?? false
          ? _model.textControllerNearestBuilding!.text.trim()
          : (FFAppState().userNearestBuilding.isNotEmpty ? FFAppState().userNearestBuilding : null);
      final houseNo = _model.textController6?.text.trim().isNotEmpty ?? false
          ? _model.textController6!.text.trim()
          : (FFAppState().userHouseNo.isNotEmpty ? FFAppState().userHouseNo : null);
      final houseColor = _model.textControllerHouseColor?.text.trim().isNotEmpty ?? false
          ? _model.textControllerHouseColor!.text.trim()
          : (FFAppState().userHouseColor.isNotEmpty ? FFAppState().userHouseColor : null);
      final routeDesc = _model.textController7?.text.trim().isNotEmpty ?? false
          ? _model.textController7!.text.trim()
          : (FFAppState().userRouteDesc.isNotEmpty ? FFAppState().userRouteDesc : null);

      final jpegFile = await actions.generateVisitFeedbackJpeg(
        customerName.isNotEmpty ? customerName : null,
        fullAddress,
        _buildAddressDescription(),
        DateTime.now().subtract(const Duration(days: 2)),
        FFAppState().signature.isNotEmpty ? FFAppState().signature : null,
        'Akinwole Oluleye',
        'Abayomi IPADEOLA',
        busStop,
        busStop,
        fillingStation,
        nearestBuilding,
        houseNo,
        houseColor,
        routeDesc,
      );

      if (jpegFile.bytes != null && jpegFile.bytes!.isNotEmpty) {
        if (mounted) {
          safeSetState(() {
            _model.uploadedLocalFile_proofaddresss = jpegFile;
            _lastGeneratedAddress = fullAddress;
          });
        }
        await KycFileService.saveFile('proofaddress', jpegFile);
        if (mounted) {
          final kb = ((jpegFile.bytes?.lengthInBytes ?? 0) / 1024).toStringAsFixed(1);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '⚡ Proof of Address generated ($kb KB, under 150 KB)!',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color(0xFF00A651),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error generating proof: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Generation failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        safeSetState(() => _isGeneratingProofAddress = false);
      }
    }
  }

  // =========================================================================
  // PROOF OF ADDRESS CARD (WITH DEBUG DOWNLOAD & PREVIEW)
  // =========================================================================
  Widget _buildProofOfAddressCard(Color cardBg, Color borderColor) {
    final hasProof = _model.uploadedLocalFile_proofaddresss.bytes?.isNotEmpty ?? false;
    final proofSizeKB = hasProof
        ? ((_model.uploadedLocalFile_proofaddresss.bytes!.lengthInBytes / 1024).toStringAsFixed(1))
        : '0';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A651).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.verified_outlined, color: Color(0xFF00A651), size: 18.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Proof of Address Verification',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      'Official Address Verification Form (PNG ≤ 150 KB)',
                      style: GoogleFonts.inter(fontSize: 11.5, color: FlutterFlowTheme.of(context).secondaryText),
                    ),
                  ],
                ),
              ),
              if (hasProof)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A651).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '✓ $proofSizeKB KB PNG',
                    style: GoogleFonts.inter(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00A651),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            hasProof
                ? 'Your official Address Verification Form has been generated from your address details.'
                : 'Click "Generate Proof of Address" below to generate your official verification form from your residential address.',
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          if (hasProof) ...[
            const SizedBox(height: 12.0),
            GestureDetector(
              onTap: _debugDownloadProofOfAddress,
              child: Container(
                width: double.infinity,
                height: 130.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.memory(
                      _model.uploadedLocalFile_proofaddresss.bytes!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.zoom_in, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('Tap to preview', style: TextStyle(color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 14.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isGeneratingProofAddress ? null : _manualGenerateProofOfAddress,
                  icon: _isGeneratingProofAddress
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(
                          hasProof ? Icons.refresh_rounded : Icons.flash_on_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                  label: Text(
                    _isGeneratingProofAddress
                        ? 'Generating...'
                        : (hasProof ? 'Regenerate' : 'Generate Proof'),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A651),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isGeneratingProofAddress ? null : _debugDownloadProofOfAddress,
                  icon: const Icon(Icons.download_rounded, color: Color(0xFF00A651), size: 18),
                  label: Text(
                    'Download / View',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF00A651),
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF00A651), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  // =========================================================================
  // UTILITY BILL (PHCN / WATER / WASTE BILL)
  // =========================================================================
  Widget _buildUtilityBillCard(Color cardBg, Color borderColor) {
    final hasUtility = _model.uploadedLocalFile_utilitybill.bytes?.isNotEmpty ?? false;
    final utilitySizeKB = hasUtility
        ? (_model.uploadedLocalFile_utilitybill.bytes!.lengthInBytes / 1024).toStringAsFixed(1)
        : '';
    final isUploading = _model.isDataUploading_utilitybill;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A651).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.receipt_long_rounded, color: Color(0xFF00A651), size: 18.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Utility Bill Verification',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      'Electricity (PHCN), Water, or Waste bill (≤ 200 KB)',
                      style: GoogleFonts.inter(fontSize: 11.5, color: FlutterFlowTheme.of(context).secondaryText),
                    ),
                  ],
                ),
              ),
              if (hasUtility)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A651).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '✓ $utilitySizeKB KB',
                    style: GoogleFonts.inter(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00A651),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            hasUtility
                ? 'Your utility bill has been attached. You can preview or tap to replace it.'
                : 'Upload a recent utility bill (PHCN, water, or waste bill not older than 3 months) matching your address.',
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          if (hasUtility) ...[
            const SizedBox(height: 12.0),
            GestureDetector(
              onTap: _pickUtilityBillMedia,
              child: Container(
                width: double.infinity,
                height: 130.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.memory(
                      _model.uploadedLocalFile_utilitybill.bytes!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('Tap to replace', style: TextStyle(color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 14.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isUploading ? null : _pickUtilityBillMedia,
                  icon: isUploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(
                          hasUtility ? Icons.refresh_rounded : Icons.cloud_upload_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                  label: Text(
                    isUploading
                        ? 'Uploading...'
                        : (hasUtility ? 'Change Utility Bill' : 'Upload Utility Bill'),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A651),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              if (hasUtility) ...[
                const SizedBox(width: 10.0),
                OutlinedButton.icon(
                  onPressed: () async {
                    safeSetState(() {
                      _model.uploadedLocalFile_utilitybill = FFUploadedFile(
                        bytes: Uint8List.fromList([]),
                        originalFilename: '',
                      );
                    });
                    await KycFileService.removeFile('utilitybill');
                  },
                  icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFC93B2B), size: 18),
                  label: Text(
                    'Remove',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFC93B2B),
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFC93B2B), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // IDENTITY DOCUMENTS & USER PHOTO (TIER 2 & TIER 3)
  // =========================================================================
  Widget _buildIdentityDocumentsCard(Color cardBg, Color borderColor) {
    final hasNin = _model.uploadedLocalFile_nincard.bytes?.isNotEmpty ?? false;
    final hasSelfie = _model.uploadedLocalFile_selfie.bytes?.isNotEmpty ?? false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A651).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.document_scanner_rounded, color: Color(0xFF00A651), size: 18.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Document & Face Verification',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14.5),
                    ),
                    Text(
                      'Clear photo of your NIN slip & live user photo (selfie)',
                      style: GoogleFonts.inter(fontSize: 11.5, color: FlutterFlowTheme.of(context).secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // TWO UPLOAD BOXES (NIN SLIP & SELFIE)
          Row(
            children: [
              // NIN Slip Upload Box
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: _pickNinCardMedia,
                  child: Container(
                    height: 125.0,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: hasNin
                          ? const Color(0xFF00A651).withValues(alpha: 0.08)
                          : FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: hasNin ? const Color(0xFF00A651) : FlutterFlowTheme.of(context).alternate,
                        width: hasNin ? 1.5 : 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (hasNin && (_model.uploadedLocalFile_nincard.bytes?.isNotEmpty ?? false))
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Image.memory(
                              _model.uploadedLocalFile_nincard.bytes!,
                              width: 34,
                              height: 34,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Icon(
                            hasNin ? Icons.check_circle_rounded : Icons.credit_card_rounded,
                            color: hasNin ? const Color(0xFF00A651) : FlutterFlowTheme.of(context).secondaryText,
                            size: 28.0,
                          ),
                        const SizedBox(height: 6.0),
                        Text(
                          'National ID Slip',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          hasNin ? '✓ Uploaded (Tap to edit)' : 'Tap to upload',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: hasNin ? const Color(0xFF00A651) : FlutterFlowTheme.of(context).secondaryText,
                            fontWeight: hasNin ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),

              // Live Selfie Box (User Photo)
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: _pickSelfieMedia,
                  child: Container(
                    height: 125.0,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: hasSelfie
                          ? const Color(0xFF00A651).withValues(alpha: 0.08)
                          : FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: hasSelfie ? const Color(0xFF00A651) : FlutterFlowTheme.of(context).alternate,
                        width: hasSelfie ? 1.5 : 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (hasSelfie && (_model.uploadedLocalFile_selfie.bytes?.isNotEmpty ?? false))
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Image.memory(
                              _model.uploadedLocalFile_selfie.bytes!,
                              width: 34,
                              height: 34,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Icon(
                            hasSelfie ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
                            color: hasSelfie ? const Color(0xFF00A651) : FlutterFlowTheme.of(context).secondaryText,
                            size: 28.0,
                          ),
                        const SizedBox(height: 6.0),
                        Text(
                          'User Photo (Selfie)',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          hasSelfie ? '✓ Captured (Tap to retake)' : 'Tap to capture',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: hasSelfie ? const Color(0xFF00A651) : FlutterFlowTheme.of(context).secondaryText,
                            fontWeight: hasSelfie ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // DIGITAL SIGNATURE (TIER 2)
  // =========================================================================
  Widget _buildSignatureCard(Color cardBg, Color borderColor) {
    final hasSignature = FFAppState().signature.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A651).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.draw_rounded, color: Color(0xFF00A651), size: 18.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Digital Signature',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14.5),
                    ),
                    Text(
                      'Sign with your finger inside the box below',
                      style: GoogleFonts.inter(fontSize: 11.5, color: FlutterFlowTheme.of(context).secondaryText),
                    ),
                  ],
                ),
              ),
              if (hasSignature)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A651).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '✓ SAVED',
                    style: GoogleFonts.inter(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00A651),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14.0),

          // Signature Pad Canvas
          Container(
            width: double.infinity,
            height: 180.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: hasSignature ? const Color(0xFF00A651) : FlutterFlowTheme.of(context).alternate,
                width: 1.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: custom_widgets.SignaturePadWidget(
                width: double.infinity,
                height: 180.0,
                onSigned: (sig) {
                  safeSetState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // DEBUG API CALL BODY & RESPONSE INSPECTOR
  // =========================================================================
  Map<String, dynamic> _buildCurrentDebugPayload() {
    final effectiveAccountNo = FFAppState().accountno.isNotEmpty
        ? FFAppState().accountno
        : (FFAppState().walletid.isNotEmpty ? FFAppState().walletid : '');
    final bvn = FFAppState().userBVN.isNotEmpty
        ? FFAppState().userBVN
        : (FFAppState().bvn.isNotEmpty
            ? FFAppState().bvn
            : (_model.textController2?.text.trim() ?? ''));
    final nin = FFAppState().userNIN.isNotEmpty
        ? FFAppState().userNIN
        : (_model.textController1?.text.trim() ?? '');
    final proof = _model.uploadedLocalFile_proofaddresss;
    final utility = _model.uploadedLocalFile_utilitybill;
    final selfie = _model.uploadedLocalFile_selfie;
    final nincard = _model.uploadedLocalFile_nincard;
    final hasSig = FFAppState().signature.isNotEmpty;

    return {
      'theKey': '10000',
      'tier': _selectedTargetTier,
      'accountNumber': effectiveAccountNo,
      'bvn': bvn,
      'nin': nin,
      'accountName': FFAppState().accountname,
      'phoneNumber': functions.addcode(FFAppState().phonenumber),
      'email': FFAppState().email,
      'idType': '1',
      'idNumber': nin,
      'houseNumber': _model.textController6?.text.trim() ?? '',
      'streetName': _model.textController5?.text.trim() ?? '',
      'city': _model.textController4?.text.trim() ?? '',
      'state': _model.stateValue ?? '',
      'localGovernment': _model.localgovernmentValue ?? _model.textController1?.text.trim() ?? '',
      'pep': _model.ispep ? 'Yes' : 'No',
      'nearestLandmark': UpgradetotierthreeCall.sanitizeLandmark(
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
      'proofOfAddressVerification': (proof.bytes?.isNotEmpty ?? false)
          ? '[File: ${proof.name ?? "proof.jpg"} (${((proof.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]'
          : '[Not Generated / Missing]',
      'utilityBill': (utility.bytes?.isNotEmpty ?? false)
          ? '[File: ${utility.name ?? "utility.jpg"} (${((utility.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]'
          : '[None Attached]',
      'userPhoto': (selfie.bytes?.isNotEmpty ?? false)
          ? '[File: ${selfie.name ?? "selfie.jpg"} (${((selfie.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]'
          : '[Not Captured / Missing]',
      'idCardFront': (nincard.bytes?.isNotEmpty ?? false)
          ? '[File: ${nincard.name ?? "idcard.jpg"} (${((nincard.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]'
          : '[Not Uploaded / Missing]',
      'customerSignature': hasSig ? '[Signature Captured & Attached]' : '[Missing Signature]',
    };
  }

  Widget _buildDebugCallBodyCard(Color cardBg, Color borderColor) {
    final livePayload = _buildCurrentDebugPayload();
    String requestBodyJson;
    try {
      requestBodyJson = _debugLastRequestBody ??
          const JsonEncoder.withIndent('  ').convert(livePayload);
    } catch (_) {
      requestBodyJson = (_debugLastRequestBody ?? livePayload).toString();
    }
    final hasResponse = _debugLastResponseBody != null && _debugLastResponseBody!.isNotEmpty;
    final statusCode = _debugLastStatusCode;
    final hasError = _debugLastError != null && _debugLastError!.isNotEmpty;

    Color badgeColor = const Color(0xFF3B82F6);
    String badgeText = 'LIVE CALL BODY PREVIEW';
    if (statusCode != null) {
      if (statusCode == 200 && !hasError) {
        badgeColor = const Color(0xFF00A651);
        badgeText = 'HTTP 200 • SUCCESS';
      } else {
        badgeColor = const Color(0xFFEF4444);
        badgeText = 'HTTP $statusCode • ${hasError ? "FAILED" : "ERROR"}';
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0B132B),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: (statusCode != null && (statusCode != 200 || hasError))
              ? const Color(0xFFEF4444)
              : const Color(0xFF00A651).withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              safeSetState(() => _isDebugExpanded = !_isDebugExpanded);
            },
            borderRadius: BorderRadius.circular(16.0),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Icon(Icons.bug_report_rounded, color: badgeColor, size: 20.0),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'API Call Body & Debug Inspector',
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          'theKey: 10000 • Tier $_selectedTargetTier • myhandler',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      badgeText,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Icon(
                    _isDebugExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white70,
                    size: 22.0,
                  ),
                ],
              ),
            ),
          ),

          if (_isDebugExpanded) ...[
            const Divider(color: Color(0xFF1E293B), height: 1.0),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: requestBodyJson));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✓ Request Body JSON copied to clipboard!'),
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Color(0xFF00A651),
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy_rounded, size: 14.0, color: Color(0xFF38BDF8)),
                          label: Text(
                            'Copy Request',
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF38BDF8),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF38BDF8), width: 1.0),
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: hasResponse
                              ? () {
                                  Clipboard.setData(ClipboardData(text: _debugLastResponseBody ?? ''));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('✓ Response Body copied to clipboard!'),
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Color(0xFF00A651),
                                    ),
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.code_rounded, size: 14.0, color: Color(0xFFA78BFA)),
                          label: Text(
                            'Copy Response',
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: hasResponse ? const Color(0xFFA78BFA) : Colors.white38,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: hasResponse ? const Color(0xFFA78BFA) : Colors.white24,
                              width: 1.0,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),

                  // Section Title: REQUEST BODY
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'REQUEST BODY (POST /sp/myhandler):',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF38BDF8),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'theKey: 10000',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11.0,
                          color: const Color(0xFF00A651),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 220.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF030712),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        requestBodyJson,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11.0,
                          color: const Color(0xFFE2E8F0),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14.0),

                  // Section Title: SERVER RESPONSE BODY
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SERVER RESPONSE BODY:',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          color: hasError ? const Color(0xFFEF4444) : const Color(0xFFA78BFA),
                        ),
                      ),
                      if (statusCode != null)
                        Text(
                          'HTTP $statusCode',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11.0,
                            color: statusCode == 200 ? const Color(0xFF00A651) : const Color(0xFFEF4444),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 180.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF030712),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: hasError ? const Color(0xFFEF4444).withValues(alpha: 0.5) : const Color(0xFF1E293B),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        hasResponse
                            ? _debugLastResponseBody!
                            : 'No response yet. Fill fields and tap "Submit Tier 3 Upgrade" to execute call.',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11.0,
                          color: hasResponse
                              ? (hasError ? const Color(0xFFFCA5A5) : const Color(0xFF86EFAC))
                              : const Color(0xFF64748B),
                          height: 1.4,
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
    );
  }

  void _showDebugFailureDialog({
    required BuildContext context,
    required String title,
    required String message,
    required int? statusCode,
    required String responseBody,
    required String requestBody,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0B132B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 24.0),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Error Message:',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8), fontSize: 12.0),
                ),
                const SizedBox(height: 2.0),
                Text(
                  message,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
                if (statusCode != null) ...[
                  const SizedBox(height: 8.0),
                  Text(
                    'Status Code: HTTP $statusCode',
                    style: GoogleFonts.jetBrainsMono(color: const Color(0xFFEF4444), fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                ],
                const SizedBox(height: 12.0),
                Text(
                  'Server Response Body:',
                  style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold, color: const Color(0xFFA78BFA), fontSize: 11.5),
                ),
                const SizedBox(height: 4.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF030712),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: SelectableText(
                    responseBody,
                    style: GoogleFonts.jetBrainsMono(color: const Color(0xFFFCA5A5), fontSize: 11.0),
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Request Body Sent (theKey: 10000):',
                  style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold, color: const Color(0xFF38BDF8), fontSize: 11.5),
                ),
                const SizedBox(height: 4.0),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxHeight: 160.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF030712),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      requestBody,
                      style: GoogleFonts.jetBrainsMono(color: const Color(0xFFE2E8F0), fontSize: 10.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: 'REQUEST:\n$requestBody\n\nRESPONSE (HTTP $statusCode):\n$responseBody'));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✓ Complete Debug Log copied to clipboard!'),
                  backgroundColor: Color(0xFF00A651),
                ),
              );
            },
            icon: const Icon(Icons.copy_rounded, color: Color(0xFF38BDF8), size: 16.0),
            label: Text('Copy All', style: GoogleFonts.inter(color: const Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A651)),
            child: const Text('Dismiss', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // BOTTOM STICKY ACTION BAR
  // =========================================================================
  Widget _buildBottomActionBar() {
    final isTier2 = _selectedTargetTier == '2';
    final buttonLabel = isTier2 ? 'Submit Tier 2 Upgrade' : 'Submit Tier 3 Upgrade';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10.0,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 1.0),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52.0,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitUpgrade,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A651),
            disabledBackgroundColor: const Color(0xFF00A651).withValues(alpha: 0.6),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: _isSubmitting
              ? const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 24.0,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonLabel,
                      style: GoogleFonts.inter(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18.0),
                  ],
                ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 13.0,
        color: FlutterFlowTheme.of(context).secondaryText,
      ),
      counterText: '',
      prefixIcon: Icon(icon, color: const Color(0xFF00A651), size: 18.0),
      filled: true,
      fillColor: FlutterFlowTheme.of(context).primaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xFF00A651),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).error,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).error,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
