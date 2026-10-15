import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img_lib;
import 'visit_feedback_signatures.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/services/address_verification_helper.dart';

String _formatOrdinalDate(DateTime d) {
  final day = d.day;
  String suffix = 'th';
  if (day >= 11 && day <= 13) {
    suffix = 'th';
  } else {
    switch (day % 10) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
        break;
    }
  }
  return '$day$suffix - ${DateFormat("MMMM").format(d)} - ${d.year}';
}

Future<String> _resolveCustomerName(String? name) async {
  String candidate = (name != null && name.trim().isNotEmpty)
      ? name.trim()
      : FFAppState().accountname.trim();

  // If candidate already has multiple names (contains space), it's already a full name
  if (candidate.isNotEmpty && candidate.contains(' ')) {
    return candidate.toUpperCase();
  }

  // If candidate is empty or only a single name, fetch the official full name from APIs:
  // 1. Try Wallet Enquiry first (returns complete banking account name with all names)
  if (FFAppState().accountno.trim().isNotEmpty) {
    try {
      final res = await WalletAsAServiceGroup.walletEnquiryCall.call(
        accountNo: FFAppState().accountno.trim(),
        authToken: FFAppState().bsptoken,
      );
      final raw = WalletAsAServiceGroup.walletEnquiryCall.accountname(res.jsonBody);
      if (raw != null && raw.trim().isNotEmpty) {
        final clean = functions.stripSlash(raw).trim();
        if (clean.contains(' ')) {
          FFAppState().accountname = clean;
          return clean.toUpperCase();
        }
      }
    } catch (_) {}
  }

  // 2. Try ReturnTierProfileCall (Fullname field)
  if (FFAppState().phonenumber.trim().isNotEmpty) {
    try {
      final token = FFAppState().bsptoken.isNotEmpty ? FFAppState().bsptoken : FFAppState().streetauth;
      final cleanPhone = functions.removecode(FFAppState().phonenumber.trim());
      final res = await ReturntierprofileCall.call(
        phoneno: cleanPhone,
        accessToken: token,
      );
      final fn = ReturntierprofileCall.fullname(res.jsonBody ?? '');
      if (fn != null && fn.trim().isNotEmpty && fn.trim().contains(' ')) {
        FFAppState().accountname = fn.trim();
        return fn.trim().toUpperCase();
      }
    } catch (_) {}
  }

  if (candidate.isNotEmpty) {
    return candidate.toUpperCase();
  }
  return 'CUSTOMER';
}

String _resolveVerificationAddress(String? address) {
  if (address != null && address.trim().isNotEmpty) {
    return address.trim();
  }
  final parts = <String>[];
  final houseNo = FFAppState().userHouseNo.trim();
  final street = FFAppState().userStreet.trim();
  final city = FFAppState().userCity.trim();
  final lga = FFAppState().userLGA.trim();
  final state = FFAppState().userState.trim();
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
  if (parts.isNotEmpty) {
    return parts.join(', ');
  }
  return 'Residential Address Not Specified';
}

String _resolveResidentialDescription(String? description, String address) {
  String base;
  if (description != null && description.trim().isNotEmpty) {
    base = description.trim();
  } else if (FFAppState().userLandmarkDesc.trim().isNotEmpty) {
    base = FFAppState().userLandmarkDesc.trim();
  } else if (address.isNotEmpty && address != 'Residential Address Not Specified') {
    base = 'Standard occupied residential premises situated along $address. Building physically sighted and verified as occupied residential property, clearly identifiable within the neighborhood with direct access from the main road';
  } else {
    base = 'Standard residential premises verified and confirmed within the neighborhood with clear street access';
  }
  return base.replaceAll(RegExp(r'\s*\(from the app\)', caseSensitive: false), '').trim();
}

String _resolveLandmarkComment(String? comment) {
  if (comment != null && comment.trim().isNotEmpty) {
    return comment.trim();
  }
  if (FFAppState().userLandmark.trim().isNotEmpty) {
    return FFAppState().userLandmark.trim();
  }
  if (FFAppState().userLandmarkDesc.trim().isNotEmpty) {
    return FFAppState().userLandmarkDesc.trim();
  }
  return '';
}

String _buildAddressDescriptionText({
  String? residentialDescription,
  String? landmarkComment,
  required String address,
}) {
  final res = _resolveResidentialDescription(residentialDescription, address);
  final land = _resolveLandmarkComment(landmarkComment);

  final parts = <String>[];
  if (res.isNotEmpty) {
    parts.add(res.endsWith('.') ? res : '$res.');
  }
  if (land.isNotEmpty && !res.toLowerCase().contains(land.toLowerCase())) {
    final landClean = land.toLowerCase().startsWith('landmark') || land.toLowerCase().startsWith('notable')
        ? land
        : 'Notable Landmark: $land';
    parts.add(landClean.endsWith('.') ? landClean : '$landClean.');
  }

  if (parts.isNotEmpty) {
    return parts.join(' ');
  }

  if (address.isNotEmpty && address != 'Residential Address Not Specified') {
    return 'Standard occupied residential premises situated along $address. Building physically sighted and verified as occupied residential property, clearly identifiable within the neighborhood with direct access from the main road.';
  }

  return 'Standard residential premises verified and confirmed within the neighborhood with clear street access.';
}

Uint8List? _cachedLogoBytes;

Future<Uint8List?> _loadStreetpayLogoBytes() async {
  if (_cachedLogoBytes != null) return _cachedLogoBytes;
  try {
    final file = File('assets/images/Streetpay1.png');
    if (file.existsSync()) {
      _cachedLogoBytes = await file.readAsBytes();
      return _cachedLogoBytes;
    }
  } catch (_) {}
  try {
    final data = await rootBundle.load('assets/images/Streetpay1.png');
    _cachedLogoBytes = data.buffer.asUint8List();
    return _cachedLogoBytes;
  } catch (_) {}
  return null;
}

/// Generates a formal, printable "ADDRESS VERIFICATION FORM" as a genuine PDF document.
Future<FFUploadedFile> generateVisitFeedbackPdf([
  String? customerName,
  String? verificationAddress,
  String? residentialDescription,
  DateTime? dateOfVisit,
  String? customerSignatureBase64,
  String? relationshipManager,
  String? verifierName,
  String? landmarkComment,
  String? popularBusStop,
  String? nearestFillingStation,
  String? nearestBuilding,
  String? houseNumber,
  String? houseColor,
  String? routeDescription,
]) async {
  try {
    final visitDate = dateOfVisit ?? DateTime.now();
    final name = await _resolveCustomerName(customerName);
    final address = _resolveVerificationAddress(verificationAddress);

    final rmName = (relationshipManager != null && relationshipManager.trim().isNotEmpty)
        ? relationshipManager.trim()
        : 'Akinwole Oluleye';

    final vName = (verifierName != null && verifierName.trim().isNotEmpty)
        ? verifierName.trim()
        : 'Abayomi IPADEOLA';

    final resolvedBusStop = AddressVerificationHelper.resolveBusStop(popularBusStop ?? landmarkComment);
    final resolvedStation = AddressVerificationHelper.resolveFillingStation(nearestFillingStation);
    final resolvedBuilding = AddressVerificationHelper.resolveNearestBuilding(nearestBuilding);
    final resolvedHouseNo = AddressVerificationHelper.resolveHouseNumber(houseNumber);
    final resolvedHouseColor = AddressVerificationHelper.resolveHouseColor(houseColor);
    final resolvedRoute = AddressVerificationHelper.resolveRouteDescription(routeDescription);

    final fullAddressDesc = AddressVerificationHelper.buildVerificationDescription(
      busStopOrLandmark: resolvedBusStop,
      fillingStation: resolvedStation,
      nearestBuilding: resolvedBuilding,
      houseNumber: resolvedHouseNo,
      houseColor: resolvedHouseColor,
      routeExplanation: resolvedRoute.isNotEmpty ? resolvedRoute : residentialDescription,
      rawAddress: address,
    );

    final dateStr = DateFormat('dd-MM-yyyy').format(visitDate);
    final visit1Str = '${_formatOrdinalDate(visitDate)} (10am)';

    // 9PSB Compliance Rule: Verifier is required to sign AFTER the Relationship Manager (RM).
    // RM assigns and authorizes prior to verification visit.
    final rmDate = visitDate.subtract(const Duration(days: 2));
    final rmDateStr = _formatOrdinalDate(rmDate);
    final verifierDateStr = _formatOrdinalDate(visitDate);

    final logoBytes = await _loadStreetpayLogoBytes();
    pw.MemoryImage? verifierSigImage;
    try {
      final vBytes = await loadVerifierSignatureBytes();
      if (vBytes.isNotEmpty) verifierSigImage = pw.MemoryImage(vBytes);
    } catch (_) {}
    pw.MemoryImage? rmSigImage;
    try {
      final rmBytes = await loadRMSignatureBytes();
      if (rmBytes.isNotEmpty) rmSigImage = pw.MemoryImage(rmBytes);
    } catch (_) {}

    final pdf = pw.Document(
      title: 'StreetPay Address Verification Form',
      author: 'StreetPay',
    );

    final greenColor = PdfColor.fromHex('#00A651');
    final darkColor = PdfColor.fromHex('#0F172A');
    final slateColor = PdfColor.fromHex('#334155');
    final mutedColor = PdfColor.fromHex('#64748B');
    final cardBorderColor = PdfColor.fromHex('#CBD5E1');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36.0, vertical: 28.0),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ── Header Row: Title & StreetPay Logo Card ─────────────────────
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'ADDRESS VERIFICATION FORM',
                    style: pw.TextStyle(
                      fontSize: 13.5,
                      fontWeight: pw.FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  // Streetpay Logo Card
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8.0)),
                      border: pw.Border.all(color: PdfColor.fromHex('#81C784'), width: 1.2),
                    ),
                    child: pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        if (logoBytes != null)
                          pw.Image(
                            pw.MemoryImage(logoBytes),
                            width: 32.0,
                            height: 24.0,
                            fit: pw.BoxFit.contain,
                          )
                        else
                          pw.Container(
                            width: 28.0,
                            height: 24.0,
                            decoration: pw.BoxDecoration(
                              color: greenColor,
                              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4.0)),
                            ),
                            child: pw.Center(
                              child: pw.CustomPaint(
                                size: const PdfPoint(20, 16),
                                painter: (PdfGraphics g, PdfPoint size) {
                                  g.setColor(PdfColors.white);
                                  g.setLineWidth(2.0);
                                  // Top bar + loop of P
                                  g.moveTo(2, size.y - 3);
                                  g.lineTo(size.x - 5, size.y - 3);
                                  g.curveTo(size.x - 1, size.y - 3, size.x - 1, size.y - 9, size.x - 5, size.y - 9);
                                  g.lineTo(7, size.y - 9);
                                  g.lineTo(7, 2);
                                  g.strokePath();
                                  // Two horizontal bars on left
                                  g.moveTo(2, size.y - 7);
                                  g.lineTo(5, size.y - 7);
                                  g.strokePath();
                                  g.moveTo(2, size.y - 12);
                                  g.lineTo(5, size.y - 12);
                                  g.strokePath();
                                },
                              ),
                            ),
                          ),
                        pw.SizedBox(width: 8.0),
                        pw.Text(
                          'Streetpay',
                          style: pw.TextStyle(
                            fontSize: 15.0,
                            fontWeight: pw.FontWeight.bold,
                            color: greenColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 16.0),

              // ── Basic Info Fields ──────────────────────────────────────────
              _buildPdfFieldRow('Date:', dateStr, darkColor, slateColor),
              pw.SizedBox(height: 6.0),
              _buildPdfDottedField("Customer's Name:", name, darkColor, slateColor),
              pw.SizedBox(height: 6.0),
              _buildPdfDottedField('Verification Address:', address, darkColor, slateColor),
              pw.SizedBox(height: 8.0),

              // Date/Time of Visit 1
              pw.Row(
                children: [
                  pw.Text('Date/Time of Visit 1: ', style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: slateColor)),
                  pw.SizedBox(width: 8.0),
                  pw.Text(visit1Str, style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: darkColor)),
                ],
              ),
              pw.SizedBox(height: 5.0),
              // Visit 2 (indented on its own row below Visit 1)
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 48.0),
                child: pw.Row(
                  children: [
                    pw.Text('Visit 2 ', style: pw.TextStyle(fontSize: 10.5, color: slateColor)),
                    pw.Text('................................................................................................................', style: pw.TextStyle(fontSize: 10.5, color: mutedColor)),
                    pw.Text('(If necessary)', style: pw.TextStyle(fontSize: 9.5, color: mutedColor)),
                  ],
                ),
              ),
              pw.SizedBox(height: 12.0),

              // ── Address Visit Update ───────────────────────────────────────
              pw.Text('Address Visit Update:', style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: darkColor)),
              pw.SizedBox(height: 5.0),
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 12.0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text('a)  Found Address Correct as provided - ', style: pw.TextStyle(fontSize: 10.0, color: slateColor)),
                        pw.Text('YES', style: pw.TextStyle(fontSize: 10.0, fontWeight: pw.FontWeight.bold, color: darkColor, decoration: pw.TextDecoration.underline)),
                        pw.Text(' or NO', style: pw.TextStyle(fontSize: 10.0, color: slateColor)),
                      ],
                    ),
                    pw.SizedBox(height: 6.0),
                    pw.Text('b)  Wrong address and needs to be changed as:', style: pw.TextStyle(fontSize: 10.0, color: slateColor)),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 20.0, top: 4.0),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Text('Residential address:', style: pw.TextStyle(fontSize: 10.0, color: slateColor)),
                              pw.SizedBox(width: 6.0),
                              pw.Text('..................................................................................................................................', style: pw.TextStyle(fontSize: 10.0, color: mutedColor)),
                            ],
                          ),
                          pw.SizedBox(height: 4.0),
                          pw.Row(
                            children: [
                              pw.Text('Landmark:', style: pw.TextStyle(fontSize: 10.0, color: slateColor)),
                              pw.SizedBox(width: 6.0),
                              pw.Text('..................................................................................................................................................', style: pw.TextStyle(fontSize: 10.0, color: mutedColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 6.0),
                    pw.Row(
                      children: [
                        pw.Text('c)  Where Address does not exist, state comment:', style: pw.TextStyle(fontSize: 10.0, color: slateColor)),
                        pw.SizedBox(width: 6.0),
                        pw.Text('....................................................................................', style: pw.TextStyle(fontSize: 10.0, color: mutedColor)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 12.0),

              // ── Met With ──────────────────────────────────────────────────
              pw.Text('Met With (Where address exist/and found correct):', style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: darkColor)),
              pw.SizedBox(height: 5.0),
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 12.0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text('a)  Customer: Name: ', style: pw.TextStyle(fontSize: 10.0, color: slateColor)),
                        pw.Text('........ ', style: pw.TextStyle(fontSize: 10.0, color: mutedColor)),
                        pw.Text(name, style: pw.TextStyle(fontSize: 10.0, fontWeight: pw.FontWeight.bold, color: darkColor)),
                        pw.Text(' .......................................................................', style: pw.TextStyle(fontSize: 10.0, color: mutedColor)),
                      ],
                    ),
                    pw.SizedBox(height: 5.0),
                    pw.Row(
                      children: [
                        pw.Text('b)  Relative: - Name: ', style: pw.TextStyle(fontSize: 10.0, color: slateColor)),
                        pw.Text('............................................................................................................................', style: pw.TextStyle(fontSize: 10.0, color: mutedColor)),
                      ],
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 20.0),
                      child: pw.Row(
                        children: [
                          pw.Text('Relationship:', style: pw.TextStyle(fontSize: 10.0, color: slateColor)),
                          pw.Text(' ............................................... ', style: pw.TextStyle(fontSize: 10.0, color: mutedColor)),
                          pw.Text('Residence Phone:', style: pw.TextStyle(fontSize: 10.0, color: slateColor)),
                          pw.Text(' ..........................................................', style: pw.TextStyle(fontSize: 10.0, color: mutedColor)),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 5.0),
                    pw.Row(
                      children: [
                        pw.Text('c)  Neighbor: - Name: ', style: pw.TextStyle(fontSize: 10.0, color: slateColor)),
                        pw.Text('..........................................................................................................................', style: pw.TextStyle(fontSize: 10.0, color: mutedColor)),
                      ],
                    ),
                    pw.SizedBox(height: 5.0),
                    pw.Text('d)  Could Not meet with Anyone', style: pw.TextStyle(fontSize: 10.0, color: slateColor)),
                  ],
                ),
              ),
              pw.SizedBox(height: 10.0),

              // ── Ease of locating Address ──────────────────────────────────
              pw.Row(
                children: [
                  pw.Text('Ease of locating Address: ', style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: slateColor)),
                  pw.Text('Easy', style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: darkColor, decoration: pw.TextDecoration.underline)),
                  pw.Text(' / Difficult', style: pw.TextStyle(fontSize: 10.5, color: slateColor)),
                ],
              ),
              pw.SizedBox(height: 8.0),

              // ── Address & Landmark Verification Details (9PSB Regulatory Breakdown) ──
              pw.Text('Address & Landmark Verification Details:', style: pw.TextStyle(fontSize: 10.0, fontWeight: pw.FontWeight.bold, color: darkColor)),
              pw.SizedBox(height: 3.0),
              if (resolvedBusStop.isNotEmpty) ...[
                pw.Row(
                  children: [
                    pw.Text('- Popular Bus Stop / Landmark: ', style: pw.TextStyle(fontSize: 9.0, fontWeight: pw.FontWeight.bold, color: slateColor)),
                    pw.Text(resolvedBusStop, style: pw.TextStyle(fontSize: 9.0, color: darkColor)),
                  ],
                ),
                pw.SizedBox(height: 1.5),
              ],
              if (resolvedStation.isNotEmpty) ...[
                pw.Row(
                  children: [
                    pw.Text('- Nearest Filling Station: ', style: pw.TextStyle(fontSize: 9.0, fontWeight: pw.FontWeight.bold, color: slateColor)),
                    pw.Text(resolvedStation, style: pw.TextStyle(fontSize: 9.0, color: darkColor)),
                  ],
                ),
                pw.SizedBox(height: 1.5),
              ],
              if (resolvedBuilding.isNotEmpty) ...[
                pw.Row(
                  children: [
                    pw.Text('- Nearest Building / Structure: ', style: pw.TextStyle(fontSize: 9.0, fontWeight: pw.FontWeight.bold, color: slateColor)),
                    pw.Text(resolvedBuilding, style: pw.TextStyle(fontSize: 9.0, color: darkColor)),
                  ],
                ),
                pw.SizedBox(height: 1.5),
              ],
              if (resolvedHouseNo.isNotEmpty || resolvedHouseColor.isNotEmpty) ...[
                pw.Row(
                  children: [
                    pw.Text('- House Number & Colour: ', style: pw.TextStyle(fontSize: 9.0, fontWeight: pw.FontWeight.bold, color: slateColor)),
                    pw.Text(
                      [
                        if (resolvedHouseNo.isNotEmpty) 'House No: $resolvedHouseNo',
                        if (resolvedHouseColor.isNotEmpty) 'Colour: $resolvedHouseColor',
                      ].join('   |   '),
                      style: pw.TextStyle(fontSize: 9.0, color: darkColor),
                    ),
                  ],
                ),
                pw.SizedBox(height: 1.5),
              ],
              pw.SizedBox(height: 3.0),

              // ── Additional Comments & Description of Address ──────────────
              pw.Text('Additional Comments & Route Description (From Landmark):', style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: slateColor)),
              pw.SizedBox(height: 2.0),
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 8.0),
                child: pw.Text(
                  fullAddressDesc,
                  style: pw.TextStyle(
                    fontSize: 9.0,
                    fontWeight: pw.FontWeight.bold,
                    color: darkColor,
                    lineSpacing: 1.3,
                  ),
                ),
              ),
              pw.SizedBox(height: 12.0),

              // ── Bottom Section: Two Distinct Signature Cards (Corrected Arrangement: RM Signs First, Verifier Signs After RM) ──
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Left Card: Relationship Manager (Authorized FIRST)
                  pw.Container(
                    width: 250.0,
                    padding: const pw.EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10.0)),
                      border: pw.Border.all(color: cardBorderColor, width: 1.2),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Authentic RM signature graphic
                        rmSigImage != null
                            ? pw.Image(
                                rmSigImage,
                                width: 56,
                                height: 36,
                                fit: pw.BoxFit.contain,
                              )
                            : pw.SizedBox(width: 56, height: 36),
                        pw.SizedBox(height: 4.0),
                        pw.Text(
                          '$rmName,',
                          style: pw.TextStyle(
                            fontSize: 10.5,
                            fontWeight: pw.FontWeight.bold,
                            color: darkColor,
                          ),
                        ),
                        pw.SizedBox(height: 2.0),
                        pw.Text(
                          'Relationship Manager',
                          style: pw.TextStyle(
                            fontSize: 9.0,
                            color: slateColor,
                          ),
                        ),
                        pw.SizedBox(height: 3.0),
                        pw.Text(
                          rmDateStr,
                          style: pw.TextStyle(
                            fontSize: 9.0,
                            color: darkColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Card: Verifier Info & Signature (Signed AFTER Relationship Manager)
                  pw.Container(
                    width: 250.0,
                    padding: const pw.EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10.0)),
                      border: pw.Border.all(color: cardBorderColor, width: 1.2),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text('Visit Feedback: ', style: pw.TextStyle(fontSize: 9.5, color: slateColor)),
                            pw.Text('PASS', style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: greenColor)),
                            pw.Text(' / FAIL', style: pw.TextStyle(fontSize: 9.5, color: slateColor)),
                          ],
                        ),
                        pw.SizedBox(height: 6.0),
                        pw.Text("Verifier's Name/Signature/Date", style: pw.TextStyle(fontSize: 9.0, fontWeight: pw.FontWeight.bold, color: darkColor)),
                        pw.SizedBox(height: 4.0),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(vName, style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: darkColor)),
                                pw.SizedBox(height: 2.0),
                                pw.Text(verifierDateStr, style: pw.TextStyle(fontSize: 9.0, color: slateColor)),
                              ],
                            ),
                            // Authentic verifier signature graphic
                            verifierSigImage != null
                                ? pw.Image(
                                    verifierSigImage,
                                    width: 52,
                                    height: 38,
                                    fit: pw.BoxFit.contain,
                                  )
                                : pw.SizedBox(width: 52, height: 38),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();
    final fileName = 'streetpay_address_verification_${DateTime.now().millisecondsSinceEpoch}.pdf';

    return FFUploadedFile(
      name: fileName,
      bytes: pdfBytes,
    );
  } catch (e) {
    debugPrint('Error generating address verification PDF document: $e');
    return FFUploadedFile(bytes: Uint8List(0));
  }
}

pw.Widget _buildPdfFieldRow(String label, String value, PdfColor darkColor, PdfColor slateColor) {
  return pw.Row(
    children: [
      pw.Text('$label ', style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: slateColor)),
      pw.SizedBox(width: 8.0),
      pw.Text(value, style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: darkColor)),
    ],
  );
}

pw.Widget _buildPdfDottedField(String label, String value, PdfColor darkColor, PdfColor slateColor) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('$label ', style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: slateColor)),
      pw.Text('.......... ', style: pw.TextStyle(fontSize: 10.5, color: PdfColor.fromHex('#64748B'))),
      pw.Expanded(
        child: pw.Text(
          value,
          style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: darkColor),
        ),
      ),
    ],
  );
}

/// Generates a high-resolution preview PNG of the Address Verification Form matching the new design.
Future<FFUploadedFile> generateVisitFeedbackJpeg([
  String? customerName,
  String? verificationAddress,
  String? residentialDescription,
  DateTime? dateOfVisit,
  String? customerSignatureBase64,
  String? relationshipManager,
  String? verifierName,
  String? landmarkComment,
  String? popularBusStop,
  String? nearestFillingStation,
  String? nearestBuilding,
  String? houseNumber,
  String? houseColor,
  String? routeDescription,
]) async {
  try {
    const double width = 1024.0;
    const double height = 1448.0; // Standard A4 portrait aspect ratio (1 : 1.414)

    final visitDate = dateOfVisit ?? DateTime.now();
    final name = await _resolveCustomerName(customerName);
    final address = _resolveVerificationAddress(verificationAddress);

    final rmName = (relationshipManager != null && relationshipManager.trim().isNotEmpty)
        ? relationshipManager.trim()
        : 'Akinwole Oluleye';

    final vName = (verifierName != null && verifierName.trim().isNotEmpty)
        ? verifierName.trim()
        : 'Abayomi IPADEOLA';

    final resolvedBusStop = AddressVerificationHelper.resolveBusStop(popularBusStop ?? landmarkComment);
    final resolvedStation = AddressVerificationHelper.resolveFillingStation(nearestFillingStation);
    final resolvedBuilding = AddressVerificationHelper.resolveNearestBuilding(nearestBuilding);
    final resolvedHouseNo = AddressVerificationHelper.resolveHouseNumber(houseNumber);
    final resolvedHouseColor = AddressVerificationHelper.resolveHouseColor(houseColor);
    final resolvedRoute = AddressVerificationHelper.resolveRouteDescription(routeDescription);

    final fullAddressDesc = AddressVerificationHelper.buildVerificationDescription(
      busStopOrLandmark: resolvedBusStop,
      fillingStation: resolvedStation,
      nearestBuilding: resolvedBuilding,
      houseNumber: resolvedHouseNo,
      houseColor: resolvedHouseColor,
      routeExplanation: resolvedRoute.isNotEmpty ? resolvedRoute : residentialDescription,
      rawAddress: address,
    );

    final dateStr = DateFormat('dd-MM-yyyy').format(visitDate);
    final visit1Str = '${_formatOrdinalDate(visitDate)} (10am)';

    // 9PSB Compliance Rule: Verifier is required to sign AFTER the Relationship Manager (RM).
    // RM assigns and authorizes prior to verification visit.
    final rmDate = visitDate.subtract(const Duration(days: 2));
    final rmDateStr = _formatOrdinalDate(rmDate);
    final verifierDateStr = _formatOrdinalDate(visitDate);

    final logoBytes = await _loadStreetpayLogoBytes();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, width, height));

    // 1. Clean crisp white background
    canvas.drawRect(const Rect.fromLTWH(0, 0, width, height), Paint()..color = Colors.white);

    const double lx = 64.0;
    const double rx = width - 64.0;
    const double contentW = rx - lx;
    double y = 56.0;

    // 2. Header Row: Title & Logo Card
    _drawCanvasText(
      canvas,
      'ADDRESS VERIFICATION FORM',
      x: lx,
      y: y + 14,
      size: 22.0,
      bold: true,
      color: const Color(0xFF0F172A),
    );

    // StreetPay Logo Badge (top right)
    const double badgeW = 210.0;
    const double badgeH = 58.0;
    final badgeX = rx - badgeW;
    final badgeRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(badgeX, y, badgeW, badgeH),
      const Radius.circular(12.0),
    );
    canvas.drawRRect(badgeRRect, Paint()..color = Colors.white);
    canvas.drawRRect(
      badgeRRect,
      Paint()
        ..color = const Color(0xFF81C784)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Draw logo image or vector glyph
    if (logoBytes != null) {
      try {
        final codec = await ui.instantiateImageCodec(logoBytes);
        final frame = await codec.getNextFrame();
        final img = frame.image;
        canvas.drawImageRect(
          img,
          Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
          Rect.fromLTWH(badgeX + 12, y + 9, 44, 40),
          Paint(),
        );
      } catch (_) {
        _drawFallbackLogoGlyph(canvas, badgeX + 10, y + 8);
      }
    } else {
      _drawFallbackLogoGlyph(canvas, badgeX + 10, y + 8);
    }

    _drawCanvasText(
      canvas,
      'Streetpay',
      x: badgeX + 64,
      y: y + 14,
      size: 24.0,
      bold: true,
      color: const Color(0xFF00A651),
    );

    y += 90.0;

    // 3. Basic Info Fields
    _drawCanvasField(canvas, 'Date:  ', dateStr, x: lx, y: y);
    y += 42.0;

    final nameH = _drawCanvasWrappedField(
      canvas,
      "Customer's Name: ",
      name,
      x: lx,
      y: y,
      rightMargin: rx,
    );
    y += math.max(42.0, nameH + 14.0);

    // Verification Address: cleanly wrapped with proper margins so text never extends out
    final addrH = _drawCanvasWrappedField(
      canvas,
      'Verification Address: ',
      address,
      x: lx,
      y: y,
      rightMargin: rx,
    );
    y += math.max(44.0, addrH + 16.0);

    // Date/Time of Visit 1
    _drawCanvasText(canvas, 'Date/Time of Visit 1: ', x: lx, y: y, size: 17.5, bold: true, color: const Color(0xFF334155));
    _drawCanvasText(canvas, visit1Str, x: lx + 200, y: y, size: 17.5, bold: true, color: const Color(0xFF0F172A));
    y += 30.0;

    // Visit 2 (indented below Visit 1)
    _drawCanvasText(canvas, 'Visit 2 ', x: lx + 120, y: y, size: 17.0, color: const Color(0xFF334155));
    _drawCanvasDottedLeader(canvas, startX: lx + 185, endX: rx - 105, y: y, size: 17.0);
    _drawCanvasText(canvas, '(If necessary)', x: rx - 100, y: y, size: 15.0, color: const Color(0xFF64748B));
    y += 52.0;

    // 4. Address Visit Update
    _drawCanvasText(canvas, 'Address Visit Update:', x: lx, y: y, size: 18.0, bold: true, color: const Color(0xFF0F172A));
    y += 32.0;

    const double indent1 = lx + 36.0;
    const double indent2 = lx + 70.0;

    // a) Found Address Correct
    _drawCanvasText(canvas, 'a)  Found Address Correct as provided - ', x: indent1, y: y, size: 16.5, color: const Color(0xFF334155));
    _drawCanvasText(canvas, 'YES', x: indent1 + 325, y: y, size: 16.5, bold: true, underline: true, color: const Color(0xFF0F172A));
    _drawCanvasText(canvas, ' or NO', x: indent1 + 368, y: y, size: 16.5, color: const Color(0xFF334155));
    y += 34.0;

    // b) Wrong address
    _drawCanvasText(canvas, 'b)  Wrong address and needs to be changed as:', x: indent1, y: y, size: 16.5, color: const Color(0xFF334155));
    y += 28.0;

    _drawCanvasText(canvas, 'Residential address: ', x: indent2, y: y, size: 16.0, color: const Color(0xFF334155));
    _drawCanvasDottedLeader(canvas, startX: indent2 + 160, endX: rx, y: y);
    y += 26.0;

    _drawCanvasText(canvas, 'Landmark: ', x: indent2, y: y, size: 16.0, color: const Color(0xFF334155));
    _drawCanvasDottedLeader(canvas, startX: indent2 + 90, endX: rx, y: y);
    y += 34.0;

    // c) Where Address does not exist
    _drawCanvasText(canvas, 'c)  Where Address does not exist, state comment: ', x: indent1, y: y, size: 16.5, color: const Color(0xFF334155));
    _drawCanvasDottedLeader(canvas, startX: indent1 + 380, endX: rx, y: y);
    y += 50.0;

    // 5. Met With
    _drawCanvasText(canvas, 'Met With (Where address exist/and found correct):', x: lx, y: y, size: 18.0, bold: true, color: const Color(0xFF0F172A));
    y += 32.0;

    // a) Customer
    _drawCanvasText(canvas, 'a)  Customer: Name: ', x: indent1, y: y, size: 16.5, color: const Color(0xFF334155));
    _drawCanvasText(canvas, '........ ', x: indent1 + 175, y: y, size: 16.5, color: const Color(0xFF64748B));
    _drawCanvasText(canvas, name, x: indent1 + 240, y: y, size: 16.5, bold: true, color: const Color(0xFF0F172A));
    final customerEndDotX = math.min(indent1 + 245 + (name.length * 10.0), rx - 20);
    _drawCanvasDottedLeader(canvas, startX: customerEndDotX, endX: rx, y: y);
    y += 32.0;

    // b) Relative
    _drawCanvasText(canvas, 'b)  Relative: - Name: ', x: indent1, y: y, size: 16.5, color: const Color(0xFF334155));
    _drawCanvasDottedLeader(canvas, startX: indent1 + 175, endX: rx, y: y);
    y += 28.0;

    _drawCanvasText(canvas, 'Relationship: ', x: indent2, y: y, size: 16.0, color: const Color(0xFF334155));
    _drawCanvasDottedLeader(canvas, startX: indent2 + 105, endX: indent2 + 360, y: y);
    _drawCanvasText(canvas, 'Residence Phone: ', x: indent2 + 370, y: y, size: 16.0, color: const Color(0xFF334155));
    _drawCanvasDottedLeader(canvas, startX: indent2 + 510, endX: rx, y: y);
    y += 32.0;

    // c) Neighbor
    _drawCanvasText(canvas, 'c)  Neighbor: - Name: ', x: indent1, y: y, size: 16.5, color: const Color(0xFF334155));
    _drawCanvasDottedLeader(canvas, startX: indent1 + 180, endX: rx, y: y);
    y += 32.0;

    // d) Could Not meet with Anyone
    _drawCanvasText(canvas, 'd)  Could Not meet with Anyone', x: indent1, y: y, size: 16.5, color: const Color(0xFF334155));
    y += 34.0;

    // 6. Ease of locating Address
    _drawCanvasText(canvas, 'Ease of locating Address: ', x: lx, y: y, size: 17.5, bold: true, color: const Color(0xFF334155));
    _drawCanvasText(canvas, 'Easy', x: lx + 230, y: y, size: 17.5, bold: true, underline: true, color: const Color(0xFF0F172A));
    _drawCanvasText(canvas, ' / Difficult', x: lx + 276, y: y, size: 17.5, color: const Color(0xFF334155));
    y += 36.0;

    // 7. Address & Landmark Verification Details (9PSB Regulatory Breakdown)
    _drawCanvasText(
      canvas,
      'Address & Landmark Verification Details:',
      x: lx,
      y: y,
      size: 17.5,
      bold: true,
      color: const Color(0xFF0F172A),
    );
    y += 28.0;

    if (resolvedBusStop.isNotEmpty) {
      _drawCanvasText(canvas, '• Popular Bus Stop / Landmark: ', x: lx + 12, y: y, size: 15.5, bold: true, color: const Color(0xFF334155));
      _drawCanvasText(canvas, resolvedBusStop, x: lx + 270, y: y, size: 15.5, color: const Color(0xFF0F172A));
      y += 24.0;
    }
    if (resolvedStation.isNotEmpty) {
      _drawCanvasText(canvas, '• Nearest Filling Station: ', x: lx + 12, y: y, size: 15.5, bold: true, color: const Color(0xFF334155));
      _drawCanvasText(canvas, resolvedStation, x: lx + 270, y: y, size: 15.5, color: const Color(0xFF0F172A));
      y += 24.0;
    }
    if (resolvedBuilding.isNotEmpty) {
      _drawCanvasText(canvas, '• Nearest Building / Structure: ', x: lx + 12, y: y, size: 15.5, bold: true, color: const Color(0xFF334155));
      _drawCanvasText(canvas, resolvedBuilding, x: lx + 270, y: y, size: 15.5, color: const Color(0xFF0F172A));
      y += 24.0;
    }
    if (resolvedHouseNo.isNotEmpty || resolvedHouseColor.isNotEmpty) {
      final houseDetail = [
        if (resolvedHouseNo.isNotEmpty) 'House No: $resolvedHouseNo',
        if (resolvedHouseColor.isNotEmpty) 'Colour: $resolvedHouseColor',
      ].join('   |   ');
      _drawCanvasText(canvas, '• House Number & Colour: ', x: lx + 12, y: y, size: 15.5, bold: true, color: const Color(0xFF334155));
      _drawCanvasText(canvas, houseDetail, x: lx + 270, y: y, size: 15.5, color: const Color(0xFF0F172A));
      y += 26.0;
    }

    y += 4.0;
    _drawCanvasText(
      canvas,
      'Additional Comments & Route Description (From Landmark):',
      x: lx,
      y: y,
      size: 17.0,
      bold: true,
      color: const Color(0xFF334155),
    );
    y += 26.0;

    final descTextHeight = _drawMultilineCanvasText(
      canvas,
      fullAddressDesc,
      x: lx + 12.0,
      y: y,
      maxWidth: contentW - 24.0,
      size: 15.5,
      color: const Color(0xFF0F172A),
    );
    y += math.max(38.0, descTextHeight + 22.0);

    // 8. Bottom Dual Floating Cards (Corrected Signature Arrangement: RM Signs First, Verifier Signs After RM)
    const double cardW = (contentW - 32.0) / 2.0;
    const double cardH = 175.0;

    // Card 1 (LEFT): Relationship Manager Monogram, Name & Date (1st Signer / Authorization)
    final card1RRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(lx, y, cardW, cardH),
      const Radius.circular(16.0),
    );
    canvas.drawRRect(card1RRect, Paint()..color = Colors.white);
    canvas.drawRRect(
      card1RRect,
      Paint()
        ..color = const Color(0xFFCBD5E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Authentic RM signature
    final rmUiImg = await loadRMSignatureUiImage();
    if (rmUiImg != null) {
      canvas.drawImageRect(
        rmUiImg,
        Rect.fromLTWH(0, 0, rmUiImg.width.toDouble(), rmUiImg.height.toDouble()),
        Rect.fromLTWH(lx + 24.0, y + 16.0, 75.0, 56.0),
        Paint(),
      );
    } else {
      _drawRMCanvasMonogram(canvas, lx + 22, y + 18);
    }

    _drawCanvasText(canvas, '$rmName,', x: lx + 20, y: y + 74, size: 17.0, bold: true, color: const Color(0xFF0F172A));
    _drawCanvasText(canvas, 'Relationship Manager', x: lx + 20, y: y + 100, size: 15.5, color: const Color(0xFF334155));
    _drawCanvasText(canvas, rmDateStr, x: lx + 20, y: y + 126, size: 15.0, bold: true, color: const Color(0xFF0F172A));

    // Card 2 (RIGHT): Verifier Info & Signature (Signed AFTER Relationship Manager)
    final card2X = lx + cardW + 32.0;
    final card2RRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(card2X, y, cardW, cardH),
      const Radius.circular(16.0),
    );
    canvas.drawRRect(card2RRect, Paint()..color = Colors.white);
    canvas.drawRRect(
      card2RRect,
      Paint()
        ..color = const Color(0xFFCBD5E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    _drawCanvasText(canvas, 'Visit Feedback: ', x: card2X + 20, y: y + 20, size: 15.0, color: const Color(0xFF334155));
    _drawCanvasText(canvas, 'PASS', x: card2X + 128, y: y + 20, size: 15.0, bold: true, color: const Color(0xFF00A651));
    _drawCanvasText(canvas, ' / FAIL', x: card2X + 172, y: y + 20, size: 15.0, color: const Color(0xFF334155));

    _drawCanvasText(canvas, "Verifier's Name/Signature/Date", x: card2X + 20, y: y + 54, size: 15.5, bold: true, color: const Color(0xFF0F172A));
    _drawCanvasText(canvas, vName, x: card2X + 20, y: y + 88, size: 16.5, bold: true, color: const Color(0xFF0F172A));
    _drawCanvasText(canvas, verifierDateStr, x: card2X + 20, y: y + 114, size: 15.0, color: const Color(0xFF475569));

    // Verifier authentic signature graphic (right of right card)
    final verifierUiImg = await loadVerifierSignatureUiImage();
    if (verifierUiImg != null) {
      canvas.drawImageRect(
        verifierUiImg,
        Rect.fromLTWH(0, 0, verifierUiImg.width.toDouble(), verifierUiImg.height.toDouble()),
        Rect.fromLTWH(card2X + cardW - 120.0, y + 60.0, 95.0, 95.0),
        Paint(),
      );
    } else {
      _drawVerifierCanvasSignature(canvas, card2X + cardW - 75, y + 105);
    }

    // Finalize recording & render to image at actual full resolution (1024x1448)
    final picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      return FFUploadedFile(bytes: Uint8List(0));
    }

    final rawPngBytes = byteData.buffer.asUint8List();

    // Target strictly <= 150 KB (153,600 bytes) for optimal mobile upload and backend acceptance
    Uint8List outputBytes = rawPngBytes;
    String extension = 'jpg';
    try {
      final decoded = img_lib.decodeImage(rawPngBytes);
      if (decoded != null) {
        const int maxTargetBytes = 150 * 1024; // Strictly <= 150 KB
        Uint8List bestBytes = Uint8List(0);
        // Step down quality from 78 downwards to find the highest-quality JPEG <= 150 KB
        for (final q in [78, 74, 70, 66, 62, 55, 48]) {
          final candidate = Uint8List.fromList(img_lib.encodeJpg(decoded, quality: q));
          bestBytes = candidate;
          if (candidate.length <= maxTargetBytes) {
            break;
          }
        }
        // If still > 150 KB, scale slightly to 900px width and re-encode
        if (bestBytes.isEmpty || bestBytes.length > maxTargetBytes) {
          final resized = img_lib.copyResize(decoded, width: 900);
          for (final q in [76, 70, 62, 52]) {
            final candidate = Uint8List.fromList(img_lib.encodeJpg(resized, quality: q));
            bestBytes = candidate;
            if (candidate.length <= maxTargetBytes) {
              break;
            }
          }
        }
        outputBytes = bestBytes.isNotEmpty ? bestBytes : rawPngBytes;
      }
    } catch (_) {
      extension = 'png';
    }

    final fileName = 'streetpay_address_verification_${DateTime.now().millisecondsSinceEpoch}.$extension';
    return FFUploadedFile(
      name: fileName,
      bytes: outputBytes,
    );
  } catch (e) {
    debugPrint('Error generating visit feedback JPEG: $e');
    return FFUploadedFile(bytes: Uint8List(0));
  }
}

void _drawCanvasText(
  Canvas canvas,
  String text, {
  required double x,
  required double y,
  required double size,
  bool bold = false,
  bool underline = false,
  Color color = const Color(0xFF0F172A),
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'Roboto',
        color: color,
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
      ),
    ),
    textDirection: ui.TextDirection.ltr,
  )..layout();
  painter.paint(canvas, Offset(x, y));
}

void _drawCanvasDottedLeader(
  Canvas canvas, {
  required double startX,
  required double endX,
  required double y,
  Color color = const Color(0xFF64748B),
  double size = 16.0,
}) {
  if (startX >= endX - 10.0) return;
  final width = endX - startX;
  final count = (width / 7.5).floor();
  if (count <= 0) return;
  final dots = '.' * count;
  _drawCanvasText(canvas, dots, x: startX, y: y, size: size, color: color);
}

void _drawCanvasField(
  Canvas canvas,
  String label,
  String value, {
  required double x,
  required double y,
}) {
  _drawCanvasText(canvas, label, x: x, y: y, size: 17.5, bold: true, color: const Color(0xFF334155));
  final labelPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: const TextStyle(fontFamily: 'Roboto', fontSize: 17.5, fontWeight: FontWeight.bold),
    ),
    textDirection: ui.TextDirection.ltr,
  )..layout();
  _drawCanvasText(canvas, value, x: x + labelPainter.width + 12.0, y: y, size: 17.5, bold: true, color: const Color(0xFF0F172A));
}

double _drawCanvasWrappedField(
  Canvas canvas,
  String label,
  String value, {
  required double x,
  required double y,
  required double rightMargin,
  double labelSize = 17.5,
  double valueSize = 16.5,
}) {
  final labelPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: labelSize,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF334155),
      ),
    ),
    textDirection: ui.TextDirection.ltr,
  )..layout();
  labelPainter.paint(canvas, Offset(x, y));

  const dots = '..... ';
  final dotsPainter = TextPainter(
    text: const TextSpan(
      text: dots,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 17.5,
        color: Color(0xFF64748B),
      ),
    ),
    textDirection: ui.TextDirection.ltr,
  )..layout();
  dotsPainter.paint(canvas, Offset(x + labelPainter.width + 4.0, y));

  final valStartX = x + labelPainter.width + dotsPainter.width + 8.0;
  final valMaxWidth = math.max(120.0, rightMargin - valStartX);

  final valPainter = TextPainter(
    text: TextSpan(
      text: value,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: valueSize,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0F172A),
        height: 1.35,
      ),
    ),
    textDirection: ui.TextDirection.ltr,
  )..layout(maxWidth: valMaxWidth);
  valPainter.paint(canvas, Offset(valStartX, y));

  return math.max(labelPainter.height, valPainter.height);
}

double _drawMultilineCanvasText(
  Canvas canvas,
  String text, {
  required double x,
  required double y,
  required double maxWidth,
  required double size,
  Color color = const Color(0xFF0F172A),
  double height = 1.45,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'Roboto',
        color: color,
        fontSize: size,
        height: height,
        fontWeight: FontWeight.w500,
      ),
    ),
    textDirection: ui.TextDirection.ltr,
  )..layout(maxWidth: maxWidth);
  painter.paint(canvas, Offset(x, y));
  return painter.height;
}

void _drawFallbackLogoGlyph(Canvas canvas, double x, double y) {
  final iconRRect = RRect.fromRectAndRadius(
    Rect.fromLTWH(x, y, 42, 42),
    const Radius.circular(8.0),
  );
  canvas.drawRRect(iconRRect, Paint()..color = const Color(0xFF00A651));

  final glyphPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.2
    ..strokeCap = StrokeCap.round;

  canvas.drawLine(Offset(x + 8, y + 14), Offset(x + 34, y + 14), glyphPaint);
  final midPath = Path()
    ..moveTo(x + 8, y + 22)
    ..lineTo(x + 28, y + 22)
    ..arcToPoint(Offset(x + 28, y + 32), radius: const Radius.circular(5.0))
    ..lineTo(x + 8, y + 32);
  canvas.drawPath(midPath, glyphPaint);
}

void _drawVerifierCanvasSignature(Canvas canvas, double x, double y) {
  final paint = Paint()
    ..color = const Color(0xFF0F172A)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.4
    ..strokeCap = StrokeCap.round;

  // Slash
  canvas.drawLine(Offset(x, y - 35), Offset(x + 14, y + 25), paint);
  // Cross strokes
  canvas.drawLine(Offset(x - 20, y - 5), Offset(x + 28, y + 5), paint);
  canvas.drawLine(Offset(x - 14, y + 12), Offset(x + 22, y - 18), paint);
  canvas.drawLine(Offset(x - 10, y - 20), Offset(x + 18, y + 18), paint);
}

void _drawRMCanvasMonogram(Canvas canvas, double x, double y) {
  final paint = Paint()
    ..color = const Color(0xFF0F172A)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.8
    ..strokeCap = StrokeCap.round;

  final path = Path()
    ..moveTo(x + 6, y + 24)
    ..cubicTo(x + 12, y + 4, x + 28, y + 4, x + 24, y + 20)
    ..cubicTo(x + 20, y + 36, x + 4, y + 36, x, y + 20)
    ..moveTo(x + 22, y + 12)
    ..cubicTo(x + 36, y + 6, x + 48, y + 18, x + 38, y + 30)
    ..cubicTo(x + 30, y + 36, x + 42, y + 38, x + 52, y + 34);

  canvas.drawPath(path, paint);
}
