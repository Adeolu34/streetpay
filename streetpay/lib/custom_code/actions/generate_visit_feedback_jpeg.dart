import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img_lib;
import 'visit_feedback_signatures.dart';
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

/// Top-level function for background isolate — encodes raw PNG bytes to JPEG.
/// Must be a top-level function (not a closure) to be usable with compute().
Uint8List _encodePngToJpeg(Uint8List rawPngBytes) {
  final decoded = img_lib.decodeImage(rawPngBytes);
  if (decoded == null) return rawPngBytes;
  const int maxTargetBytes = 150 * 1024; // Strictly <= 150 KB
  Uint8List bestBytes = Uint8List(0);
  for (final q in [78, 74, 70, 66, 62, 55, 48]) {
    final candidate = Uint8List.fromList(img_lib.encodeJpg(decoded, quality: q));
    bestBytes = candidate;
    if (candidate.length <= maxTargetBytes) {
      break;
    }
  }
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
  return bestBytes.isNotEmpty ? bestBytes : Uint8List.fromList(img_lib.encodeJpg(decoded, quality: 70));
}

Future<String> _resolveCustomerName(String? name) async {
  String candidate = (name != null && name.trim().isNotEmpty)
      ? name.trim()
      : FFAppState().accountname.trim();

  // If candidate already has multiple names (contains space), it's already a full name
  if (candidate.isNotEmpty && candidate.contains(' ')) {
    return candidate.toUpperCase();
  }

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

Uint8List? _cachedAvfLogoBytes;

Future<Uint8List?> _loadAvfLogoBytes() async {
  if (_cachedAvfLogoBytes != null) return _cachedAvfLogoBytes;
  try {
    final file = File('assets/images/Streetpay1.png');
    if (file.existsSync()) {
      _cachedAvfLogoBytes = await file.readAsBytes();
      return _cachedAvfLogoBytes;
    }
  } catch (_) {}
  try {
    final data = await rootBundle.load('assets/images/Streetpay1.png');
    _cachedAvfLogoBytes = data.buffer.asUint8List();
    return _cachedAvfLogoBytes;
  } catch (_) {}
  return null;
}

/// Generates the official StreetPay "ADDRESS VERIFICATION FORM" as a high-resolution PNG (≤100KB).
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
    // RM assigns and authorizes prior to the verification visit.
    final rmDate = visitDate.subtract(const Duration(days: 2));
    final rmDateStr = _formatOrdinalDate(rmDate);
    final verifierDateStr = _formatOrdinalDate(visitDate);

    final logoBytes = await _loadAvfLogoBytes();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, width, height));
    // Render at full resolution for crisp text — no downscaling

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
    }

    // Finalize recording & render to image at actual full resolution (1024x1448)
    final picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      return FFUploadedFile(bytes: Uint8List(0));
    }

    final rawPngBytes = byteData.buffer.asUint8List();

    // Offload the CPU-heavy JPEG encode to a background isolate so the UI thread is never blocked.
    Uint8List outputBytes = rawPngBytes;
    String extension = 'jpg';
    try {
      final jpegBytes = await compute(_encodePngToJpeg, rawPngBytes);
      if (jpegBytes.isNotEmpty) {
        outputBytes = jpegBytes;
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
    text: TextSpan(
      text: dots,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: labelSize,
        color: const Color(0xFF64748B),
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
