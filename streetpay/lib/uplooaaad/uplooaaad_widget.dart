import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import '/components/visit_feedback_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'uplooaaad_model.dart';
export 'uplooaaad_model.dart';

/// Here is a refined mockup prompt under 1000 characters:
///
/// ---
///
/// Design a premium fintech “Upload Required Documents” and “Signature”
/// section for a KYC upgrade page.
///
/// Use a soft light gray background (#F6F8FB) and a centered white card with
/// 24px padding, 20px radius, and subtle shadow.
///
/// Add a bold header “Upload Required Documents” with small helper text below
/// it.
///
/// Create a responsive grid of elegant upload tiles (2–4 per row). Each tile
/// should have soft background (#F9FBFD), 18px rounded corners, light dashed
/// border, centered minimal icon, bold document title, small helper text, and
/// a green “Uploaded” status with check icon. When uploaded, show a preview
/// thumbnail and floating green check badge.
///
/// Below, add a “Signature” section with a bordered signature pad (light
/// background, dashed border, rounded corners). Under it, place a ghost
/// “Clear” button and a green pill-shaped “Save Signature” button. Clean
/// spacing, premium, modern banking UI.
class UplooaaadWidget extends StatefulWidget {
  const UplooaaadWidget({super.key});

  static String routeName = 'uplooaaad';
  static String routePath = '/uplooaaad';

  @override
  State<UplooaaadWidget> createState() => _UplooaaadWidgetState();
}

class _UplooaaadWidgetState extends State<UplooaaadWidget> {
  late UplooaaadModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UplooaaadModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Color(0xFFF6F8FB),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 22.0,
            borderWidth: 1.0,
            buttonSize: 44.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF222B45),
              size: 22.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            'KYC Verification',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                  ),
                  color: Color(0xFF222B45),
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            controller: _model.columnController,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18.0,
                          color: Color(0x1A000000),
                          offset: Offset(
                            0.0,
                            4.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upload Required Documents',
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF222B45),
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                'Please upload clear, legible copies of the following documents to complete your KYC verification.',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF8F9BB3),
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ].divide(SizedBox(height: 6.0)),
                          ),
                          GridView(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.0,
                              mainAxisSpacing: 12.0,
                              childAspectRatio: 0.60,
                            ),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF9FBFD),
                                      borderRadius: BorderRadius.circular(18.0),
                                      border: Border.all(
                                        color: Color(0xFFD0D9E8),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 52.0,
                                            height: 52.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFEAF1FF),
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Icon(
                                                Icons.badge_outlined,
                                                color: Color(0xFF3D7EFF),
                                                size: 26.0,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 10.0, 0.0, 4.0),
                                            child: Text(
                                              'National ID',
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFF222B45),
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            'Front & back sides',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF8F9BB3),
                                                  fontSize: 11.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 8.0, 0.0, 0.0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 32.0,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFE8F5E9),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .check_circle_rounded,
                                                      color: Color(0xFF2E7D32),
                                                      size: 14.0,
                                                    ),
                                                    Text(
                                                      'Uploaded',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .labelSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Color(
                                                                0xFF2E7D32),
                                                            fontSize: 11.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(width: 4.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(1.0, -1.0),
                                    child: Container(
                                      width: 22.0,
                                      height: 22.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF43A047),
                                        borderRadius:
                                            BorderRadius.circular(11.0),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 11.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                               Stack(
                                 children: [
                                   Container(
                                     width: double.infinity,
                                     decoration: BoxDecoration(
                                       color: Color(0xFFF9FBFD),
                                       borderRadius: BorderRadius.circular(18.0),
                                       border: Border.all(
                                         color: (_model.uploadedLocalFile_proofaddresss.bytes?.isNotEmpty ?? false)
                                             ? Color(0xFF00A651)
                                             : Color(0xFFD0D9E8),
                                         width: 1.5,
                                       ),
                                     ),
                                     child: Padding(
                                       padding: EdgeInsets.all(12.0),
                                       child: Column(
                                         mainAxisSize: MainAxisSize.max,
                                         mainAxisAlignment:
                                             MainAxisAlignment.center,
                                         crossAxisAlignment:
                                             CrossAxisAlignment.center,
                                         children: [
                                           Container(
                                             width: 46.0,
                                             height: 46.0,
                                             decoration: BoxDecoration(
                                               color: Color(0xFFFFF3E0),
                                               borderRadius:
                                                   BorderRadius.circular(14.0),
                                             ),
                                             child: Align(
                                               alignment: AlignmentDirectional(
                                                   0.0, 0.0),
                                               child: Icon(
                                                 Icons.home_outlined,
                                                 color: Color(0xFFF57C00),
                                                 size: 24.0,
                                               ),
                                             ),
                                           ),
                                           Padding(
                                             padding:
                                                 EdgeInsetsDirectional.fromSTEB(
                                                     0.0, 8.0, 0.0, 3.0),
                                             child: Text(
                                               'Utility Bill',
                                               textAlign: TextAlign.center,
                                               style: FlutterFlowTheme.of(
                                                       context)
                                                   .titleSmall
                                                   .override(
                                                     font: GoogleFonts.inter(
                                                       fontWeight:
                                                           FontWeight.bold,
                                                       fontStyle:
                                                           FlutterFlowTheme.of(
                                                                   context)
                                                               .titleSmall
                                                               .fontStyle,
                                                     ),
                                                     color: Color(0xFF222B45),
                                                     fontSize: 13.0,
                                                     letterSpacing: 0.0,
                                                     fontWeight: FontWeight.bold,
                                                     fontStyle:
                                                         FlutterFlowTheme.of(
                                                                 context)
                                                             .titleSmall
                                                             .fontStyle,
                                                   ),
                                             ),
                                           ),
                                           Text(
                                             'Utility bill or bank statement',
                                             textAlign: TextAlign.center,
                                             style: FlutterFlowTheme.of(context)
                                                 .bodySmall
                                                 .override(
                                                   font: GoogleFonts.inter(
                                                     fontWeight:
                                                         FlutterFlowTheme.of(
                                                                 context)
                                                             .bodySmall
                                                             .fontWeight,
                                                     fontStyle:
                                                         FlutterFlowTheme.of(
                                                                 context)
                                                             .bodySmall
                                                             .fontStyle,
                                                   ),
                                                   color: Color(0xFF8F9BB3),
                                                   fontSize: 10.5,
                                                   letterSpacing: 0.0,
                                                   fontWeight:
                                                       FlutterFlowTheme.of(
                                                               context)
                                                           .bodySmall
                                                           .fontWeight,
                                                   fontStyle:
                                                       FlutterFlowTheme.of(
                                                               context)
                                                           .bodySmall
                                                           .fontStyle,
                                                 ),
                                           ),
                                           if (_model.uploadedLocalFile_proofaddresss.bytes?.isEmpty ?? true) ...[
                                             Padding(
                                               padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                                               child: InkWell(
                                                 onTap: () async {
                                                   final selectedMedia = await selectMediaWithSourceBottomSheet(
                                                     context: context,
                                                     allowPhoto: true,
                                                   );
                                                   if (selectedMedia != null &&
                                                       selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                                                     safeSetState(() => _model.isDataUploading_proofaddresss = true);
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
                                                       _model.isDataUploading_proofaddresss = false;
                                                     }
                                                     if (selectedUploadedFiles.length == selectedMedia.length) {
                                                       safeSetState(() {
                                                         _model.uploadedLocalFile_proofaddresss = selectedUploadedFiles.first;
                                                       });
                                                     }
                                                   }
                                                 },
                                                 child: Container(
                                                   width: double.infinity,
                                                   height: 28.0,
                                                   decoration: BoxDecoration(
                                                     color: Color(0xFFF0F4FF),
                                                     borderRadius: BorderRadius.circular(6.0),
                                                   ),
                                                   child: Row(
                                                     mainAxisSize: MainAxisSize.max,
                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       Icon(
                                                         Icons.cloud_upload_outlined,
                                                         color: Color(0xFF3D7EFF),
                                                         size: 14.0,
                                                       ),
                                                       SizedBox(width: 4.0),
                                                       Text(
                                                         'Tap to upload',
                                                         style: FlutterFlowTheme.of(context).labelSmall.override(
                                                               font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                               color: Color(0xFF3D7EFF),
                                                               fontSize: 10.5,
                                                             ),
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                               ),
                                             ),
                                             Padding(
                                               padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                                               child: InkWell(
                                                 onTap: () async {
                                                   final fullAddress = [
                                                     if (FFAppState().allstates.isNotEmpty) FFAppState().allstates,
                                                   ].join(', ');
                                                   await showModalBottomSheet(
                                                     isScrollControlled: true,
                                                     backgroundColor: Colors.transparent,
                                                     context: context,
                                                     builder: (context) {
                                                       return Padding(
                                                         padding: MediaQuery.viewInsetsOf(context),
                                                         child: VisitFeedbackModalWidget(
                                                           customerName: FFAppState().accountname.isNotEmpty ? FFAppState().accountname : null,
                                                           verificationAddress: fullAddress.isNotEmpty ? fullAddress : null,
                                                           customerSignatureBase64: FFAppState().signature.isNotEmpty ? FFAppState().signature : null,
                                                           dateOfVisit: DateTime.now(),
                                                           onGenerated: (file) {
                                                             safeSetState(() {
                                                               _model.uploadedLocalFile_proofaddresss = file;
                                                             });
                                                           },
                                                         ),
                                                       );
                                                     },
                                                   );
                                                 },
                                                 child: Container(
                                                   width: double.infinity,
                                                   padding: EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
                                                   decoration: BoxDecoration(
                                                     color: Color(0xFFE8F5E9),
                                                     borderRadius: BorderRadius.circular(6.0),
                                                     border: Border.all(
                                                       color: Color(0xFF00A651),
                                                       width: 1.0,
                                                     ),
                                                   ),
                                                   child: Row(
                                                     mainAxisSize: MainAxisSize.max,
                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       Icon(
                                                         Icons.auto_awesome,
                                                         color: Color(0xFF00A651),
                                                         size: 13.0,
                                                       ),
                                                       SizedBox(width: 4.0),
                                                       Flexible(
                                                         child: Text(
                                                           '⚡ Generate Proof of Address',
                                                           textAlign: TextAlign.center,
                                                           maxLines: 1,
                                                           overflow: TextOverflow.ellipsis,
                                                           style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                 font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                                 color: Color(0xFF00A651),
                                                                 fontSize: 10.0,
                                                               ),
                                                         ),
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ] else ...[
                                             Padding(
                                               padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                                               child: Container(
                                                 width: double.infinity,
                                                 height: 28.0,
                                                 decoration: BoxDecoration(
                                                   color: Color(0xFFE8F5E9),
                                                   borderRadius: BorderRadius.circular(6.0),
                                                 ),
                                                 child: Row(
                                                   mainAxisSize: MainAxisSize.max,
                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                   children: [
                                                     Icon(
                                                       Icons.check_circle_rounded,
                                                       color: Color(0xFF2E7D32),
                                                       size: 14.0,
                                                     ),
                                                     SizedBox(width: 4.0),
                                                     Text(
                                                       'Uploaded',
                                                       style: FlutterFlowTheme.of(context).labelSmall.override(
                                                             font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                             color: Color(0xFF2E7D32),
                                                             fontSize: 10.5,
                                                           ),
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                             ),
                                             Padding(
                                               padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                               child: InkWell(
                                                 onTap: () async {
                                                   final fullAddress = [
                                                     if (FFAppState().allstates.isNotEmpty) FFAppState().allstates,
                                                   ].join(', ');
                                                   await showModalBottomSheet(
                                                     isScrollControlled: true,
                                                     backgroundColor: Colors.transparent,
                                                     context: context,
                                                     builder: (context) {
                                                       return Padding(
                                                         padding: MediaQuery.viewInsetsOf(context),
                                                         child: VisitFeedbackModalWidget(
                                                           customerName: FFAppState().accountname.isNotEmpty ? FFAppState().accountname : null,
                                                           verificationAddress: fullAddress.isNotEmpty ? fullAddress : null,
                                                           customerSignatureBase64: FFAppState().signature.isNotEmpty ? FFAppState().signature : null,
                                                           dateOfVisit: DateTime.now(),
                                                           onGenerated: (file) {
                                                             safeSetState(() {
                                                               _model.uploadedLocalFile_proofaddresss = file;
                                                             });
                                                           },
                                                         ),
                                                       );
                                                     },
                                                   );
                                                 },
                                                 child: Container(
                                                   width: double.infinity,
                                                   padding: EdgeInsetsDirectional.fromSTEB(6.0, 5.0, 6.0, 5.0),
                                                   decoration: BoxDecoration(
                                                     color: Colors.white,
                                                     borderRadius: BorderRadius.circular(6.0),
                                                     border: Border.all(
                                                       color: Color(0xFF81C784),
                                                       width: 1.0,
                                                     ),
                                                   ),
                                                   child: Row(
                                                     mainAxisSize: MainAxisSize.max,
                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       Icon(
                                                         Icons.refresh_rounded,
                                                         color: Color(0xFF2E7D32),
                                                         size: 13.0,
                                                       ),
                                                       SizedBox(width: 4.0),
                                                       Text(
                                                         'Re-generate Proof',
                                                         style: FlutterFlowTheme.of(context).labelSmall.override(
                                                               font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                               color: Color(0xFF2E7D32),
                                                               fontSize: 10.0,
                                                             ),
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ],
                                         ],
                                       ),
                                     ),
                                   ),
                                   if (_model.uploadedLocalFile_proofaddresss.bytes?.isNotEmpty ?? false)
                                     Align(
                                       alignment: AlignmentDirectional(1.0, -1.0),
                                       child: Container(
                                         width: 22.0,
                                         height: 22.0,
                                         decoration: BoxDecoration(
                                           color: Color(0xFF43A047),
                                           borderRadius:
                                               BorderRadius.circular(11.0),
                                           border: Border.all(
                                             color: Colors.white,
                                             width: 2.0,
                                           ),
                                         ),
                                         child: Align(
                                           alignment:
                                               AlignmentDirectional(0.0, 0.0),
                                           child: Icon(
                                             Icons.check_rounded,
                                             color: Colors.white,
                                             size: 11.0,
                                           ),
                                         ),
                                       ),
                                     ),
                                 ],
                               ),
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF9FBFD),
                                      borderRadius: BorderRadius.circular(18.0),
                                      border: Border.all(
                                        color: Color(0xFF3D7EFF),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 52.0,
                                            height: 52.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFEDE7F6),
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Icon(
                                                Icons.account_balance_outlined,
                                                color: Color(0xFF7B1FA2),
                                                size: 26.0,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 10.0, 0.0, 4.0),
                                            child: Text(
                                              'Bank Statement',
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFF222B45),
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            'Last 3 months',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF8F9BB3),
                                                  fontSize: 11.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 8.0, 0.0, 0.0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 32.0,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFEEF2FF),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .cloud_upload_outlined,
                                                      color: Color(0xFF3D7EFF),
                                                      size: 14.0,
                                                    ),
                                                    Text(
                                                      'Tap to Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .labelSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Color(
                                                                0xFF3D7EFF),
                                                            fontSize: 11.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(width: 4.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF9FBFD),
                                      borderRadius: BorderRadius.circular(18.0),
                                      border: Border.all(
                                        color: Color(0xFFD0D9E8),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 52.0,
                                            height: 52.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFCE4EC),
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Icon(
                                                Icons.person_outlined,
                                                color: Color(0xFFC62828),
                                                size: 26.0,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 10.0, 0.0, 4.0),
                                            child: Text(
                                              'Selfie Photo',
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFF222B45),
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            'Clear face photo',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF8F9BB3),
                                                  fontSize: 11.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 8.0, 0.0, 0.0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 32.0,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFEEF2FF),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .cloud_upload_outlined,
                                                      color: Color(0xFF3D7EFF),
                                                      size: 14.0,
                                                    ),
                                                    Text(
                                                      'Tap to Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .labelSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Color(
                                                                0xFF3D7EFF),
                                                            fontSize: 11.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(width: 4.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: 1.0,
                            decoration: BoxDecoration(
                              color: Color(0xFFEDF1F7),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Signature',
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF222B45),
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                'Please sign in the box below using your finger or stylus.',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF8F9BB3),
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(height: 6.0)),
                          ),
                          Container(
                            width: double.infinity,
                            height: 200.0,
                            decoration: BoxDecoration(
                              color: Color(0xFFF9FBFD),
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: Color(0xFFB0BEC5),
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.draw_outlined,
                                    color: Color(0xFFCFD8DC),
                                    size: 32.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 8.0, 0.0, 0.0),
                                    child: Text(
                                      'Sign here',
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFFCFD8DC),
                                            fontSize: 13.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 44.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22.0),
                                  border: Border.all(
                                    color: Color(0xFFD0D9E8),
                                    width: 1.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.refresh_rounded,
                                        color: Color(0xFF8F9BB3),
                                        size: 16.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            6.0, 0.0, 6.0, 0.0),
                                        child: Text(
                                          'Clear',
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF8F9BB3),
                                                fontSize: 13.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 44.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF2ECC71),
                                      Color(0xFF27AE60)
                                    ],
                                    stops: [0.0, 1.0],
                                    begin: AlignmentDirectional(1.0, -1.0),
                                    end: AlignmentDirectional(-1.0, 1.0),
                                  ),
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      28.0, 0.0, 28.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            6.0, 0.0, 6.0, 0.0),
                                        child: Text(
                                          'Save Signature',
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                fontSize: 13.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ].divide(SizedBox(height: 16.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    height: 56.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12.0,
                          color: Color(0x403D7EFF),
                          offset: Offset(
                            0.0,
                            4.0,
                          ),
                        )
                      ],
                      gradient: LinearGradient(
                        colors: [Color(0xFF3D7EFF), Color(0xFF2563EB)],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(1.0, -1.0),
                        end: AlignmentDirectional(-1.0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.verified_outlined,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          Text(
                            'Submit for Verification',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                          ),
                        ].divide(SizedBox(width: 8.0)),
                      ),
                    ),
                  ),
                ),
              ]
                  .addToStart(SizedBox(height: 20.0))
                  .addToEnd(SizedBox(height: 40.0)),
            ),
          ),
        ),
      ),
    );
  }
}
