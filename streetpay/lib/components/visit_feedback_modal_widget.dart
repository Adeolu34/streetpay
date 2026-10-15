import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '/services/image_compress_service.dart';
import '/services/address_verification_helper.dart';
import 'visit_feedback_modal_model.dart';
export 'visit_feedback_modal_model.dart';

class VisitFeedbackModalWidget extends StatefulWidget {
  const VisitFeedbackModalWidget({
    super.key,
    this.customerName,
    this.verificationAddress,
    this.residentialDescription,
    this.landmarkDescription,
    this.dateOfVisit,
    this.customerSignatureBase64,
    this.onGenerated,
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
  final Function(FFUploadedFile)? onGenerated;
  final String? popularBusStop;
  final String? nearestFillingStation;
  final String? nearestBuilding;
  final String? houseNumber;
  final String? houseColor;
  final String? routeDescription;

  @override
  State<VisitFeedbackModalWidget> createState() => _VisitFeedbackModalWidgetState();
}

class _VisitFeedbackModalWidgetState extends State<VisitFeedbackModalWidget> {
  late VisitFeedbackModalModel _model;
  bool _isAiGenerating = false;

  Future<void> _generateWithAi() async {
    setState(() => _isAiGenerating = true);
    try {
      final enhanced = await AddressVerificationHelper.buildAiVerificationDescription(
        busStopOrLandmark: _model.busStopController?.text,
        fillingStation: _model.fillingStationController?.text,
        nearestBuilding: _model.nearestBuildingController?.text,
        houseNumber: _model.houseNoController?.text,
        houseColor: _model.houseColorController?.text,
        routeExplanation: _model.routeController?.text,
        rawAddress: widget.verificationAddress,
      );
      _model.descController?.text = enhanced;
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
    _model = createModel(context, () => VisitFeedbackModalModel());

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

    _model.busStopController = TextEditingController(text: initialBusStop);
    _model.busStopFocusNode = FocusNode();
    _model.fillingStationController = TextEditingController(text: initialStation);
    _model.fillingStationFocusNode = FocusNode();
    _model.nearestBuildingController = TextEditingController(text: initialBuilding);
    _model.nearestBuildingFocusNode = FocusNode();
    _model.houseNoController = TextEditingController(text: initialHouseNo);
    _model.houseNoFocusNode = FocusNode();
    _model.houseColorController = TextEditingController(text: initialColor);
    _model.houseColorFocusNode = FocusNode();
    _model.routeController = TextEditingController(text: initialRoute);
    _model.routeFocusNode = FocusNode();

    _model.landmarkController = TextEditingController(text: initialBusStop);
    _model.landmarkFocusNode = FocusNode();

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
    _model.descController = TextEditingController(text: resolvedInitialDesc);
    _model.descFocusNode = FocusNode();

    // Automatically trigger initial generation
    WidgetsBinding.instance.addPostFrameCallback((_) => _generateForm());
  }

  void _syncDescription() {
    final compiled = AddressVerificationHelper.buildVerificationDescription(
      busStopOrLandmark: _model.busStopController?.text,
      fillingStation: _model.fillingStationController?.text,
      nearestBuilding: _model.nearestBuildingController?.text,
      houseNumber: _model.houseNoController?.text,
      houseColor: _model.houseColorController?.text,
      routeExplanation: _model.routeController?.text,
      rawAddress: widget.verificationAddress,
    );
    _model.descController?.text = compiled;
  }

  void _onFieldChanged() {
    if (_model.busStopController != null) {
      FFAppState().userBusStop = _model.busStopController!.text.trim();
    }
    if (_model.fillingStationController != null) {
      FFAppState().userFillingStation = _model.fillingStationController!.text.trim();
    }
    if (_model.nearestBuildingController != null) {
      FFAppState().userNearestBuilding = _model.nearestBuildingController!.text.trim();
    }
    if (_model.houseNoController != null) {
      FFAppState().userHouseNo = _model.houseNoController!.text.trim();
    }
    if (_model.houseColorController != null) {
      FFAppState().userHouseColor = _model.houseColorController!.text.trim();
    }
    if (_model.routeController != null) {
      FFAppState().userRouteDesc = _model.routeController!.text.trim();
    }
    _syncDescription();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _generateForm() async {
    setState(() {
      _model.isGenerating = true;
    });

    try {
      final pdfFile = await actions.generateVisitFeedbackPdf(
        widget.customerName,
        widget.verificationAddress,
        _model.descController?.text,
        widget.dateOfVisit ?? DateTime.now(),
        widget.customerSignatureBase64,
        'Akinwole Oluleye',
        'Abayomi IPADEOLA',
        _model.busStopController?.text,
        _model.busStopController?.text,
        _model.fillingStationController?.text,
        _model.nearestBuildingController?.text,
        _model.houseNoController?.text,
        _model.houseColorController?.text,
        _model.routeController?.text,
      );

      final previewJpeg = await actions.generateVisitFeedbackJpeg(
        widget.customerName,
        widget.verificationAddress,
        _model.descController?.text,
        widget.dateOfVisit ?? DateTime.now(),
        widget.customerSignatureBase64,
        'Akinwole Oluleye',
        'Abayomi IPADEOLA',
        _model.busStopController?.text,
        _model.busStopController?.text,
        _model.fillingStationController?.text,
        _model.nearestBuildingController?.text,
        _model.houseNoController?.text,
        _model.houseColorController?.text,
        _model.routeController?.text,
      );

      setState(() {
        _model.generatedPdfFile = pdfFile;
        _model.generatedPdfBytes = pdfFile.bytes;
        _model.generatedJpeg = previewJpeg;
        _model.isGenerating = false;
      });
    } catch (e) {
      setState(() {
        _model.isGenerating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate form: $e'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  Future<void> _shareDoc() async {
    final pdfBytes = _model.generatedPdfBytes;
    if (pdfBytes == null || pdfBytes.isEmpty) return;

    try {
      final dir = await getTemporaryDirectory();
      final filename = _model.generatedPdfFile?.name ??
          'streetpay_address_verification_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = await File('${dir.path}/$filename').writeAsBytes(pdfBytes);
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf', name: filename)],
        text: 'StreetPay Address Verification Form Document',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing document: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

              // Title and close button
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

              // Generated Preview Header
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
                      border: Border.all(color: const Color(0xFF00A651), width: 1.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF00A651), size: 14.0),
                        const SizedBox(width: 4.0),
                        Text(
                          'Official Document',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00A651),
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
                    child: _model.isGenerating
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00A651)),
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                'Generating Address Verification PDF...',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.inter(),
                                      color: const Color(0xFF00A651),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          )
                        : (_model.generatedJpeg?.bytes?.isNotEmpty ?? false)
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
                                      _model.generatedJpeg!.bytes!,
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
                controller: _model.busStopController,
                focusNode: _model.busStopFocusNode,
                style: FlutterFlowTheme.of(context).bodySmall,
                onChanged: (_) => _onFieldChanged(),
                decoration: InputDecoration(
                  hintText: 'e.g. Maryland Bus Stop, Ojota Roundabout',
                  hintStyle: FlutterFlowTheme.of(context).labelSmall,
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  prefixIcon: const Icon(Icons.directions_bus_filled_outlined, size: 18.0, color: Color(0xFF00A651)),
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
                          controller: _model.fillingStationController,
                          focusNode: _model.fillingStationFocusNode,
                          style: FlutterFlowTheme.of(context).bodySmall,
                          onChanged: (_) => _onFieldChanged(),
                          decoration: InputDecoration(
                            hintText: 'e.g. TotalEnergies Station',
                            hintStyle: FlutterFlowTheme.of(context).labelSmall,
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                            prefixIcon: const Icon(Icons.local_gas_station_outlined, size: 18.0, color: Color(0xFF00A651)),
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
                          controller: _model.nearestBuildingController,
                          focusNode: _model.nearestBuildingFocusNode,
                          style: FlutterFlowTheme.of(context).bodySmall,
                          onChanged: (_) => _onFieldChanged(),
                          decoration: InputDecoration(
                            hintText: 'e.g. Beside First Bank branch',
                            hintStyle: FlutterFlowTheme.of(context).labelSmall,
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                            prefixIcon: const Icon(Icons.business_outlined, size: 18.0, color: Color(0xFF00A651)),
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
                          controller: _model.houseNoController,
                          focusNode: _model.houseNoFocusNode,
                          style: FlutterFlowTheme.of(context).bodySmall,
                          onChanged: (_) => _onFieldChanged(),
                          decoration: InputDecoration(
                            hintText: 'e.g. Plot 14, Flat 2B',
                            hintStyle: FlutterFlowTheme.of(context).labelSmall,
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                            prefixIcon: const Icon(Icons.tag_outlined, size: 18.0, color: Color(0xFF00A651)),
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
                          controller: _model.houseColorController,
                          focusNode: _model.houseColorFocusNode,
                          style: FlutterFlowTheme.of(context).bodySmall,
                          onChanged: (_) => _onFieldChanged(),
                          decoration: InputDecoration(
                            hintText: 'e.g. Yellow bungalow, Blue gate',
                            hintStyle: FlutterFlowTheme.of(context).labelSmall,
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                            prefixIcon: const Icon(Icons.color_lens_outlined, size: 18.0, color: Color(0xFF00A651)),
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
                controller: _model.routeController,
                focusNode: _model.routeFocusNode,
                maxLines: 2,
                style: FlutterFlowTheme.of(context).bodySmall,
                onChanged: (_) => _onFieldChanged(),
                decoration: InputDecoration(
                  hintText: 'e.g. Head straight along the access road, pass filling station, turn into street, house is on the right',
                  hintStyle: FlutterFlowTheme.of(context).labelSmall,
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  contentPadding: const EdgeInsets.all(12.0),
                  prefixIcon: const Icon(Icons.alt_route_rounded, size: 18.0, color: Color(0xFF00A651)),
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
                    border: Border.all(color: const Color(0xFF00A651), width: 1.2),
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
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00A651)),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'AI Generating Compliant Description...',
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00A651),
                          ),
                        ),
                      ] else ...[
                        const Icon(Icons.auto_awesome, color: Color(0xFF00A651), size: 18.0),
                        const SizedBox(width: 8.0),
                        Text(
                          '✨ AI Generate & Polish Description for 9PSB',
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00A651),
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
                        const Icon(Icons.sync_rounded, color: Color(0xFF00A651), size: 14.0),
                        const SizedBox(width: 4.0),
                        Text(
                          'Re-compile & Update',
                          style: GoogleFonts.inter(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00A651),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                controller: _model.descController,
                focusNode: _model.descFocusNode,
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
                    icon: const Icon(Icons.refresh_rounded, color: Color(0xFF00A651)),
                    tooltip: 'Regenerate document with updated description',
                    onPressed: _generateForm,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Action buttons
              Row(
                children: [
                  // Secondary: Share/Download PDF Document
                  Expanded(
                    flex: 1,
                    child: FFButtonWidget(
                      onPressed: _shareDoc,
                      text: 'Share / Save PDF',
                      icon: const Icon(Icons.share_outlined, size: 18.0),
                      options: FFButtonOptions(
                        height: 48.0,
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),

                  // Primary: Attach as PDF Document
                  Expanded(
                    flex: 2,
                    child: FFButtonWidget(
                      onPressed: () async {
                        var attachFile = (_model.generatedJpeg?.bytes?.isNotEmpty ?? false)
                            ? _model.generatedJpeg
                            : null;
                        if (attachFile != null) {
                          widget.onGenerated?.call(attachFile);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Address Verification Form attached as Proof of Address!'),
                              backgroundColor: Color(0xFF00A651),
                              duration: Duration(milliseconds: 3000),
                            ),
                          );
                        }
                      },
                      text: '⚡ Generate & Attach Proof of Address',
                      icon: const Icon(Icons.check_circle_outline_rounded, size: 18.0),
                      options: FFButtonOptions(
                        height: 48.0,
                        color: const Color(0xFF00A651),
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                              ),
                              color: Colors.white,
                            ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(10.0),
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
