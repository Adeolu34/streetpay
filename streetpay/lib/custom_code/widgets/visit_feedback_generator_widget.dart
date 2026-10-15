// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '/services/image_compress_service.dart';
import '/services/address_verification_helper.dart';

class VisitFeedbackGeneratorWidget extends StatefulWidget {
  const VisitFeedbackGeneratorWidget({
    super.key,
    this.width,
    this.height,
    this.customerName,
    this.verificationAddress,
    this.residentialDescription,
    this.landmarkDescription,
    this.dateOfVisit,
    this.customerSignatureBase64,
    this.buttonText,
    this.popularBusStop,
    this.nearestFillingStation,
    this.nearestBuilding,
    this.houseNumber,
    this.houseColor,
    this.routeDescription,
  });

  final double? width;
  final double? height;
  final String? customerName;
  final String? verificationAddress;
  final String? residentialDescription;
  final String? landmarkDescription;
  final DateTime? dateOfVisit;
  final String? customerSignatureBase64;
  final String? buttonText;
  final String? popularBusStop;
  final String? nearestFillingStation;
  final String? nearestBuilding;
  final String? houseNumber;
  final String? houseColor;
  final String? routeDescription;

  @override
  State<VisitFeedbackGeneratorWidget> createState() =>
      _VisitFeedbackGeneratorWidgetState();
}

class _VisitFeedbackGeneratorWidgetState
    extends State<VisitFeedbackGeneratorWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF00A651);

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: _isLoading
          ? null
          : () async {
              setState(() => _isLoading = true);
              try {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (ctx) {
                    return Padding(
                      padding: MediaQuery.viewInsetsOf(ctx),
                      child: _VisitFeedbackModalSheet(
                        customerName: widget.customerName ??
                            (FFAppState().accountname.isNotEmpty
                                ? FFAppState().accountname
                                : null),
                        verificationAddress: widget.verificationAddress,
                        residentialDescription: widget.residentialDescription,
                        landmarkDescription: widget.landmarkDescription,
                        dateOfVisit: widget.dateOfVisit ?? DateTime.now(),
                        customerSignatureBase64: widget.customerSignatureBase64,
                        popularBusStop: widget.popularBusStop,
                        nearestFillingStation: widget.nearestFillingStation,
                        nearestBuilding: widget.nearestBuilding,
                        houseNumber: widget.houseNumber,
                        houseColor: widget.houseColor,
                        routeDescription: widget.routeDescription,
                      ),
                    );
                  },
                );
              } finally {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              }
            },
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 46.0,
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: brandGreen,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading) ...[
              const SizedBox(
                width: 16.0,
                height: 16.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(brandGreen),
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                'Opening Verification Form...',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: brandGreen,
                  fontSize: 12.0,
                ),
              ),
            ] else ...[
              const Icon(
                Icons.verified_rounded,
                color: brandGreen,
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                widget.buttonText ??
                    '⚡ Auto-Generate Address Verification (PDF)',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: brandGreen,
                  fontSize: 12.0,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VisitFeedbackModalSheet extends StatefulWidget {
  const _VisitFeedbackModalSheet({
    this.customerName,
    this.verificationAddress,
    this.residentialDescription,
    this.landmarkDescription,
    this.dateOfVisit,
    this.customerSignatureBase64,
    this.popularBusStop,
    this.nearestFillingStation,
    this.nearestBuilding,
    this.houseNumber,
    this.houseColor,
    this.routeDescription,
  });

  final String? customerName;
  final String? verificationAddress;
  final String? residentialDescription;
  final String? landmarkDescription;
  final DateTime? dateOfVisit;
  final String? customerSignatureBase64;
  final String? popularBusStop;
  final String? nearestFillingStation;
  final String? nearestBuilding;
  final String? houseNumber;
  final String? houseColor;
  final String? routeDescription;

  @override
  State<_VisitFeedbackModalSheet> createState() =>
      _VisitFeedbackModalSheetState();
}

class _VisitFeedbackModalSheetState extends State<_VisitFeedbackModalSheet> {
  late TextEditingController _descController;
  late FocusNode _descFocusNode;
  late TextEditingController _landmarkController;
  late FocusNode _landmarkFocusNode;

  late TextEditingController _busStopController;
  late FocusNode _busStopFocusNode;
  late TextEditingController _fillingStationController;
  late FocusNode _fillingStationFocusNode;
  late TextEditingController _nearestBuildingController;
  late FocusNode _nearestBuildingFocusNode;
  late TextEditingController _houseNoController;
  late FocusNode _houseNoFocusNode;
  late TextEditingController _houseColorController;
  late FocusNode _houseColorFocusNode;
  late TextEditingController _routeController;
  late FocusNode _routeFocusNode;

  bool _isGenerating = false;
  bool _isAiGenerating = false;
  FFUploadedFile? _generatedPdfFile;
  FFUploadedFile? _generatedJpeg;

  Future<void> _generateWithAi() async {
    if (!mounted) return;
    setState(() => _isAiGenerating = true);
    try {
      final enhanced = await AddressVerificationHelper.buildAiVerificationDescription(
        busStopOrLandmark: _busStopController.text,
        fillingStation: _fillingStationController.text,
        nearestBuilding: _nearestBuildingController.text,
        houseNumber: _houseNoController.text,
        houseColor: _houseColorController.text,
        routeExplanation: _routeController.text,
        rawAddress: widget.verificationAddress,
      );
      _descController.text = enhanced;
      _onFieldChanged();
      await _generateForm();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✨ AI generated a compliant description for 9PSB!'),
            backgroundColor: Color(0xFF00A651),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      debugPrint('AI generation error: $e');
    } finally {
      if (mounted) {
        setState(() => _isAiGenerating = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final initialBusStop = AddressVerificationHelper.resolveBusStop(
        widget.popularBusStop ?? widget.landmarkDescription);
    final initialStation = AddressVerificationHelper.resolveFillingStation(
        widget.nearestFillingStation);
    final initialBuilding = AddressVerificationHelper.resolveNearestBuilding(
        widget.nearestBuilding);
    final initialHouseNo = AddressVerificationHelper.resolveHouseNumber(
        widget.houseNumber);
    final initialColor = AddressVerificationHelper.resolveHouseColor(
        widget.houseColor);
    final initialRoute = AddressVerificationHelper.resolveRouteDescription(
        widget.routeDescription);

    _busStopController = TextEditingController(text: initialBusStop);
    _busStopFocusNode = FocusNode();
    _fillingStationController = TextEditingController(text: initialStation);
    _fillingStationFocusNode = FocusNode();
    _nearestBuildingController = TextEditingController(text: initialBuilding);
    _nearestBuildingFocusNode = FocusNode();
    _houseNoController = TextEditingController(text: initialHouseNo);
    _houseNoFocusNode = FocusNode();
    _houseColorController = TextEditingController(text: initialColor);
    _houseColorFocusNode = FocusNode();
    _routeController = TextEditingController(text: initialRoute);
    _routeFocusNode = FocusNode();

    _landmarkController = TextEditingController(text: initialBusStop);
    _landmarkFocusNode = FocusNode();

    final initialDesc = (widget.residentialDescription != null &&
            widget.residentialDescription!.trim().isNotEmpty)
        ? widget.residentialDescription!.trim()
        : AddressVerificationHelper.buildVerificationDescription(
            busStopOrLandmark: initialBusStop,
            fillingStation: initialStation,
            nearestBuilding: initialBuilding,
            houseNumber: initialHouseNo,
            houseColor: initialColor,
            routeExplanation: initialRoute,
            rawAddress: widget.verificationAddress,
          );

    final resolvedInitialDesc = initialDesc.contains('from the app')
        ? initialDesc.replaceAll(RegExp(r'\s*\(from the app\)', caseSensitive: false), '')
        : initialDesc;
    _descController = TextEditingController(text: resolvedInitialDesc);
    _descFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => _generateForm());
  }

  void _syncDescription() {
    final compiled = AddressVerificationHelper.buildVerificationDescription(
      busStopOrLandmark: _busStopController.text,
      fillingStation: _fillingStationController.text,
      nearestBuilding: _nearestBuildingController.text,
      houseNumber: _houseNoController.text,
      houseColor: _houseColorController.text,
      routeExplanation: _routeController.text,
      rawAddress: widget.verificationAddress,
    );
    _descController.text = compiled;
  }

  void _onFieldChanged() {
    FFAppState().userBusStop = _busStopController.text.trim();
    FFAppState().userFillingStation = _fillingStationController.text.trim();
    FFAppState().userNearestBuilding = _nearestBuildingController.text.trim();
    FFAppState().userHouseNo = _houseNoController.text.trim();
    FFAppState().userHouseColor = _houseColorController.text.trim();
    FFAppState().userRouteDesc = _routeController.text.trim();
    _syncDescription();
  }

  @override
  void dispose() {
    _descController.dispose();
    _descFocusNode.dispose();
    _landmarkController.dispose();
    _landmarkFocusNode.dispose();
    _busStopController.dispose();
    _busStopFocusNode.dispose();
    _fillingStationController.dispose();
    _fillingStationFocusNode.dispose();
    _nearestBuildingController.dispose();
    _nearestBuildingFocusNode.dispose();
    _houseNoController.dispose();
    _houseNoFocusNode.dispose();
    _houseColorController.dispose();
    _houseColorFocusNode.dispose();
    _routeController.dispose();
    _routeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _generateForm() async {
    if (!mounted) return;
    setState(() => _isGenerating = true);

    try {
      final pdfFile = await generateVisitFeedbackPdf(
        widget.customerName,
        widget.verificationAddress,
        _descController.text,
        widget.dateOfVisit ?? DateTime.now(),
        widget.customerSignatureBase64,
        'Akinwole Oluleye',
        'Abayomi IPADEOLA',
        _busStopController.text,
        _busStopController.text,
        _fillingStationController.text,
        _nearestBuildingController.text,
        _houseNoController.text,
        _houseColorController.text,
        _routeController.text,
      );

      final previewFile = await generateVisitFeedbackJpeg(
        widget.customerName,
        widget.verificationAddress,
        _descController.text,
        widget.dateOfVisit ?? DateTime.now(),
        widget.customerSignatureBase64,
        'Akinwole Oluleye',
        'Abayomi IPADEOLA',
        _busStopController.text,
        _busStopController.text,
        _fillingStationController.text,
        _nearestBuildingController.text,
        _houseNoController.text,
        _houseColorController.text,
        _routeController.text,
      );

      if (mounted) {
        setState(() {
          _generatedPdfFile = pdfFile;
          _generatedJpeg = previewFile;
          _isGenerating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate form: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _sharePdf() async {
    if (_generatedPdfFile == null ||
        _generatedPdfFile!.bytes == null ||
        _generatedPdfFile!.bytes!.isEmpty) {
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      final filename = _generatedPdfFile!.name ??
          'streetpay_address_verification_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = await File('${dir.path}/$filename').writeAsBytes(_generatedPdfFile!.bytes!);
      await Share.shareXFiles(
        [
          XFile(file.path, mimeType: 'application/pdf', name: filename),
        ],
        text: 'StreetPay Address Verification Form Document',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing certificate: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF00A651);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 48.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address Verification Form',
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                ),
                                letterSpacing: 0.0,
                              ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Official PDF Proof of Address document for Tier Upgrade',
                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                font: GoogleFonts.inter(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 24.0,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 24.0),

              // Preview Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Document Preview (PDF)',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(color: brandGreen, width: 1.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.picture_as_pdf_rounded, color: brandGreen, size: 14.0),
                        const SizedBox(width: 4.0),
                        Text(
                          'Official Document',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: brandGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),

              // Portrait Document Preview Card
              Container(
                width: double.infinity,
                height: 380.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: const Color(0xFF81C784),
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11.0),
                  child: Center(
                    child: _isGenerating
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(brandGreen),
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                'Generating Address Verification PDF...',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.inter(),
                                      color: brandGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          )
                        : (_generatedJpeg?.bytes?.isNotEmpty ?? false)
                            ? Container(
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x18000000),
                                      blurRadius: 8.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: AspectRatio(
                                    aspectRatio: 1024 / 1448,
                                    child: Image.memory(
                                      _generatedJpeg!.bytes!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  'No preview generated yet.',
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ),
                  ),
                ),
              ),
              // 9PSB Regulatory Compliance Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: const Color(0xFF81C784)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user_outlined, color: Color(0xFF2E7D32), size: 18.0),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        '9PSB Compliance: Address verification requires discrete landmark, filling station, house features, and strictly ordered signatures.',
                        style: GoogleFonts.inter(
                          fontSize: 11.0,
                          color: const Color(0xFF1B5E20),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14.0),

              // 1. Popular Bus Stop Around Address (Starting Point)
              Text(
                '1. Popular Bus Stop Around Address (Starting Point)',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                controller: _busStopController,
                focusNode: _busStopFocusNode,
                style: FlutterFlowTheme.of(context).bodySmall,
                onChanged: (_) => _onFieldChanged(),
                decoration: InputDecoration(
                  hintText: 'e.g. Maryland Bus Stop, Ojota Roundabout',
                  hintStyle: FlutterFlowTheme.of(context).labelSmall,
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  prefixIcon: const Icon(Icons.directions_bus_filled_outlined, size: 18.0, color: brandGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),

              // 2. Nearest Filling Station & Nearest Building Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '2. Nearest Filling Station',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _fillingStationController,
                          focusNode: _fillingStationFocusNode,
                          style: FlutterFlowTheme.of(context).bodySmall,
                          onChanged: (_) => _onFieldChanged(),
                          decoration: InputDecoration(
                            hintText: 'e.g. TotalEnergies Station',
                            hintStyle: FlutterFlowTheme.of(context).labelSmall,
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                            prefixIcon: const Icon(Icons.local_gas_station_outlined, size: 18.0, color: brandGreen),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3. Nearest Building / Structure',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _nearestBuildingController,
                          focusNode: _nearestBuildingFocusNode,
                          style: FlutterFlowTheme.of(context).bodySmall,
                          onChanged: (_) => _onFieldChanged(),
                          decoration: InputDecoration(
                            hintText: 'e.g. Beside First Bank branch',
                            hintStyle: FlutterFlowTheme.of(context).labelSmall,
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                            prefixIcon: const Icon(Icons.business_outlined, size: 18.0, color: brandGreen),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              // 4. House Number & Color of House Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '4. House / Building Number',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _houseNoController,
                          focusNode: _houseNoFocusNode,
                          style: FlutterFlowTheme.of(context).bodySmall,
                          onChanged: (_) => _onFieldChanged(),
                          decoration: InputDecoration(
                            hintText: 'e.g. Plot 14, Flat 2B',
                            hintStyle: FlutterFlowTheme.of(context).labelSmall,
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                            prefixIcon: const Icon(Icons.tag_outlined, size: 18.0, color: brandGreen),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '5. Color of House',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _houseColorController,
                          focusNode: _houseColorFocusNode,
                          style: FlutterFlowTheme.of(context).bodySmall,
                          onChanged: (_) => _onFieldChanged(),
                          decoration: InputDecoration(
                            hintText: 'e.g. Yellow bungalow, Blue gate',
                            hintStyle: FlutterFlowTheme.of(context).labelSmall,
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                            prefixIcon: const Icon(Icons.color_lens_outlined, size: 18.0, color: brandGreen),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              // 6. Route Navigation from Bus Stop / Landmark
              Text(
                '6. Explain Address from [Bus stop] or [Landmark]',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                controller: _routeController,
                focusNode: _routeFocusNode,
                maxLines: 2,
                style: FlutterFlowTheme.of(context).bodySmall,
                onChanged: (_) => _onFieldChanged(),
                decoration: InputDecoration(
                  hintText: 'e.g. Head straight along the access road, pass filling station, turn into street, house is on the right',
                  hintStyle: FlutterFlowTheme.of(context).labelSmall,
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  contentPadding: const EdgeInsets.all(12.0),
                  prefixIcon: const Icon(Icons.alt_route_rounded, size: 18.0, color: brandGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
                  ),
                ),
              ),
              const SizedBox(height: 14.0),

              // AI Description Generator Button
              InkWell(
                onTap: _isAiGenerating ? null : _generateWithAi,
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8E9),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: brandGreen, width: 1.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isAiGenerating) ...[
                        const SizedBox(
                          width: 16.0,
                          height: 16.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(brandGreen),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'AI Generating Compliant Description...',
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: brandGreen,
                          ),
                        ),
                      ] else ...[
                        const Icon(Icons.auto_awesome, color: brandGreen, size: 18.0),
                        const SizedBox(width: 8.0),
                        Text(
                          '✨ AI Generate & Polish Description for 9PSB',
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: brandGreen,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12.0),

              // 7. Auto-Concatenated Verification Narrative & Document Re-generator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Compiled Verification Narrative (Auto-Concatenated)',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _syncDescription();
                      _generateForm();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.sync_rounded, color: brandGreen, size: 14.0),
                        const SizedBox(width: 4.0),
                        Text(
                          'Re-compile & Update',
                          style: GoogleFonts.inter(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: brandGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                controller: _descController,
                focusNode: _descFocusNode,
                maxLines: 3,
                style: FlutterFlowTheme.of(context).bodySmall,
                decoration: InputDecoration(
                  hintText: 'Combined narrative compiled from above fields...',
                  hintStyle: FlutterFlowTheme.of(context).labelSmall,
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  contentPadding: const EdgeInsets.all(12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh_rounded, color: brandGreen),
                    tooltip: 'Regenerate document with updated description',
                    onPressed: _generateForm,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton.icon(
                      onPressed: _sharePdf,
                      icon: const Icon(Icons.share_outlined, size: 18.0),
                      label: Text(
                        'Share / Save PDF',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.0,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48.0),
                        side: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        var attach = (_generatedJpeg?.bytes?.isNotEmpty ?? false)
                            ? _generatedJpeg
                            : null;
                        if (attach != null &&
                            (attach.bytes?.isNotEmpty ?? false)) {
                          Navigator.of(context).pop(attach);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Address Verification Form attached as Proof of Address!'),
                              backgroundColor: brandGreen,
                              duration: Duration(milliseconds: 3000),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.check_circle_outline_rounded,
                          size: 18.0, color: Colors.white),
                      label: Text(
                        '⚡ Attach Proof of Address',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGreen,
                        minimumSize: const Size.fromHeight(48.0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }
}
