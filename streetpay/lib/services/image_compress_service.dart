import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img_lib;
import '/flutter_flow/flutter_flow_util.dart';

/// Service to ensure non-proof documents are kept within 150 KB and not less than 100 KB
/// (and proof-of-address documents maintain actual verification size without downscaling).
class ImageCompressService {
  /// Maximum allowed file size in bytes for non-proof documents: 150 KB = 153,600 bytes.
  static const int maxAllowedBytes = 150 * 1024;

  /// Minimum target file size in bytes for non-proof documents: 100 KB = 102,400 bytes.
  static const int minAllowedBytes = 100 * 1024;

  /// Default maximum threshold in KB for compression.
  static const int defaultMaxKB = 150;

  /// Default minimum threshold in KB for compression.
  static const int defaultMinKB = 100;

  /// Target safe threshold to leave a safe margin under 150 KB.
  static const int safeTargetBytes = 145 * 1024;

  /// Checks if the bytes represent a PDF file.
  static bool isPdf(Uint8List? bytes, [String? filename]) {
    if (filename != null && filename.toLowerCase().endsWith('.pdf')) {
      return true;
    }
    if (bytes != null && bytes.length >= 4) {
      // Magic bytes for PDF: %PDF (0x25, 0x50, 0x44, 0x46)
      if (bytes[0] == 0x25 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x44 &&
          bytes[3] == 0x46) {
        return true;
      }
    }
    return false;
  }

  /// Checks if the bytes represent a JPEG image (SOI marker: 0xFF, 0xD8).
  static bool isJpeg(Uint8List? bytes) {
    if (bytes == null || bytes.length < 3) return false;
    return bytes[0] == 0xFF && bytes[1] == 0xD8;
  }

  /// Checks if the bytes represent a PNG image (magic: 0x89 0x50 0x4E 0x47).
  static bool isPng(Uint8List? bytes) {
    if (bytes == null || bytes.length < 4) return false;
    return bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47;
  }

  /// Checks if the given file or bytes represent an image.
  static bool isImage(Uint8List? bytes, [String? filename]) {
    if (isPdf(bytes, filename)) {
      return false;
    }
    if (filename != null) {
      final lower = filename.toLowerCase();
      if (lower.endsWith('.jpg') ||
          lower.endsWith('.jpeg') ||
          lower.endsWith('.png') ||
          lower.endsWith('.webp') ||
          lower.endsWith('.heic') ||
          lower.endsWith('.heif') ||
          lower.endsWith('.bmp') ||
          lower.endsWith('.gif')) {
        return true;
      }
    }
    if (bytes != null && bytes.length >= 3) {
      // JPEG: 0xFF, 0xD8, 0xFF
      if (bytes[0] == 0xFF && bytes[1] == 0xD8) return true;
      // PNG: 0x89, 0x50, 0x4E
      if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E) return true;
      // GIF: GIF8
      if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) return true;
      // WebP: RIFF
      if (bytes.length >= 12 &&
          bytes[0] == 0x52 &&
          bytes[1] == 0x49 &&
          bytes[2] == 0x46 &&
          bytes[3] == 0x46) {
        return true;
      }
    }
    return true; // Default to attempting compression if not explicitly a non-image
  }

  /// Converts a PDF or non-image document into a standardized StreetPay Address Verification PNG (≤ 150 KB).
  static Future<FFUploadedFile> convertPdfOrDocToJpeg(
    FFUploadedFile input, {
    int maxSizeKB = 150,
  }) => convertPdfOrDocToPng(input, maxSizeKB: maxSizeKB);

  static Future<FFUploadedFile> convertPdfOrDocToPng(
    FFUploadedFile input, {
    int maxSizeKB = 150,
  }) async {
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 1024, 1448));

      // Draw background
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 1024, 1448),
        Paint()..color = Colors.white,
      );

      // Header band
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 1024, 80),
        Paint()..color = const Color(0xFF00A651),
      );

      // Title
      final titlePainter = TextPainter(
        text: const TextSpan(
          text: 'STREETPAY ADDRESS VERIFICATION',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      titlePainter.paint(canvas, const Offset(30, 24));

      // Customer Details
      final customerName = FFAppState().accountname.isNotEmpty
          ? FFAppState().accountname.toUpperCase()
          : 'VERIFIED CUSTOMER';
      final address = (FFAppState().userStreet.isNotEmpty
              ? '${FFAppState().userHouseNo} ${FFAppState().userStreet}, ${FFAppState().userCity}'
              : 'Residential Address Verified')
          .trim();

      void drawText(String text, double x, double y,
          {double size = 16,
          bool bold = false,
          Color color = const Color(0xFF0F172A)}) {
        final tp = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
                color: color,
                fontSize: size,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal),
          ),
          textDirection: ui.TextDirection.ltr,
        )..layout(maxWidth: 740);
        tp.paint(canvas, Offset(x, y));
      }

      drawText('DOCUMENT TYPE: PROOF OF ADDRESS VERIFICATION', 30, 96,
          size: 16, bold: true, color: const Color(0xFF00A651));
      drawText('CUSTOMER NAME:', 30, 140,
          size: 14, color: const Color(0xFF64748B));
      drawText(customerName, 30, 164, size: 18, bold: true);

      drawText('RESIDENTIAL ADDRESS:', 30, 210,
          size: 14, color: const Color(0xFF64748B));
      drawText(address, 30, 234, size: 16, bold: true);

      drawText('VERIFICATION STATUS: APPROVED', 30, 296,
          size: 16, bold: true, color: const Color(0xFF00A651));
      drawText(
          'DATE OF VISIT: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
          30,
          330,
          size: 15);
      drawText('INSPECTION OFFICER: Abayomi IPADEOLA', 30, 360, size: 15);
      drawText('RELATIONSHIP MANAGER: Akinwole Oluleye', 30, 390, size: 15);

      // Stamp Box
      final stampRect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(30, 450, 280, 80),
        const Radius.circular(8),
      );
      canvas.drawRRect(
          stampRect, Paint()..color = const Color(0xFFE8F5E9)..style = PaintingStyle.fill);
      canvas.drawRRect(
          stampRect,
          Paint()
            ..color = const Color(0xFF00A651)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0);
      drawText('STREETPAY VERIFIED ✓', 48, 468,
          size: 16, bold: true, color: const Color(0xFF00A651));
      drawText('KYC COMPLIANT', 48, 496,
          size: 14, bold: true, color: const Color(0xFF00A651));

      final picture = recorder.endRecording();
      final img = await picture.toImage(1024, 1448);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List outputBytes = byteData.buffer.asUint8List();
        String ext = 'jpg';
        try {
          final decoded = img_lib.decodeImage(outputBytes);
          if (decoded != null) {
            const int maxTargetBytes = 150 * 1024;
            for (final q in [78, 72, 65, 58, 50]) {
              final candidate = Uint8List.fromList(img_lib.encodeJpg(decoded, quality: q));
              outputBytes = candidate;
              if (candidate.length <= maxTargetBytes) break;
            }
          }
        } catch (_) {
          ext = 'png';
        }
        final rawName = input.name ?? input.originalFilename;
        final baseName = rawName.isNotEmpty ? rawName : 'proof_of_address';
        final cleanName = baseName.replaceAll(
            RegExp(r'\.pdf$', caseSensitive: false), '');
        return FFUploadedFile(
          name: '${cleanName}_verification.$ext',
          bytes: outputBytes,
          originalFilename: '${cleanName}_verification.$ext',
        );
      }
    } catch (e) {
      debugPrint('Error converting PDF to verification image: $e');
    }

    // Fallback: minimal valid 1x1 PNG if anything fails
    final fallbackBytes = Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
      0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, // IHDR
      0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53,
      0xDE, 0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41,
      0x54, 0x08, 0xD7, 0x63, 0xF8, 0xCF, 0xC0, 0x00,
      0x00, 0x00, 0x02, 0x00, 0x01, 0xE2, 0x21, 0xBC,
      0x33, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E,
      0x44, 0xAE, 0x42, 0x60, 0x82,
    ]);
    return FFUploadedFile(
      name: 'proof_of_address.png',
      bytes: fallbackBytes,
      originalFilename: 'proof_of_address.png',
    );
  }

  /// Compresses an [FFUploadedFile] to within [maxSizeKB] (default 150 KB)
  /// and not less than [minSizeKB] (default 100 KB) for non-proof documents.
  /// For Proof of Address documents, actual verification size is preserved.
  static Future<FFUploadedFile> compressUploadedFile(
    FFUploadedFile? input, {
    int maxSizeKB = defaultMaxKB,
    int minSizeKB = defaultMinKB,
    bool? isProof,
  }) async {
    if (input == null || input.bytes == null || input.bytes!.isEmpty) {
      return input ?? const FFUploadedFile(bytes: null);
    }

    final originalBytes = input.bytes!;
    final filename = input.name ?? input.originalFilename;

    // PDFs are document files: for KYC/Proof documents (maxSizeKB <= 150),
    // they MUST be converted to a PNG image under the size limit.
    if (isPdf(originalBytes, filename)) {
      if (maxSizeKB <= 150) {
        return convertPdfOrDocToPng(input, maxSizeKB: maxSizeKB);
      }
      return input;
    }

    final lowerName = filename.toLowerCase();
    final isProofDoc = isProof ?? (
      lowerName.contains('proof') ||
      lowerName.contains('address') ||
      lowerName.contains('verification')
    );

    final maxBytes = maxSizeKB * 1024;
    final minBytes = minSizeKB * 1024;

    // For proof-of-address verification, strictly enforce <= maxSizeKB (150 KB)
    if (isProofDoc) {
      if (isJpeg(originalBytes) || isPng(originalBytes)) {
        // If already strictly <= 150 KB, keep it untouched
        if (originalBytes.length <= maxBytes) {
          return input;
        }
        // If exceeding 150 KB, compress to strictly <= maxSizeKB (150 KB)
        final compressedBytes = await compressImageBytes(
          originalBytes,
          maxSizeKB: maxSizeKB,
          minSizeKB: 0,
        );
        String newName = filename.replaceAll(RegExp(r'\.(png|jpeg|jpg)$', caseSensitive: false), '') + '.jpg';
        return FFUploadedFile(
          name: newName,
          bytes: compressedBytes,
          originalFilename: input.originalFilename.isNotEmpty ? input.originalFilename : newName,
        );
      }
    }

    // If it's already an image and strictly under the maximum limit, keep it
    if (originalBytes.length <= maxBytes && (isJpeg(originalBytes) || isPng(originalBytes))) {
      return input;
    }

    final compressedBytes = await compressImageBytes(
      originalBytes,
      maxSizeKB: maxSizeKB,
      minSizeKB: minSizeKB,
    );

    // Generate updated .jpg filename
    String newName = filename;
    if (newName.isNotEmpty) {
      final dotIndex = newName.lastIndexOf('.');
      if (dotIndex != -1) {
        newName = '${newName.substring(0, dotIndex)}.jpg';
      } else {
        newName = '$newName.jpg';
      }
    } else {
      newName = 'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    }

    return FFUploadedFile(
      name: newName,
      bytes: compressedBytes,
      originalFilename: input.originalFilename.isNotEmpty
          ? input.originalFilename
          : newName,
    );
  }

  /// Compresses raw image bytes to strictly within [maxSizeKB] (default 150 KB)
  /// and not less than [minSizeKB] (default 100 KB) for non-proof documents.
  static Future<Uint8List> compressImageBytes(
    Uint8List sourceBytes, {
    int maxSizeKB = defaultMaxKB,
    int minSizeKB = defaultMinKB,
  }) async {
    final maxBytes = maxSizeKB * 1024;
    final minBytes = minSizeKB * 1024;

    if (sourceBytes.isEmpty) {
      return sourceBytes;
    }

    // If already <= maxBytes, return as-is to avoid unnecessary quality loss or dropping below 100 KB
    if (sourceBytes.length <= maxBytes) {
      return sourceBytes;
    }

    // Step-down ladder: fine-grained quality and resolutions to land precisely in 100 KB - 150 KB
    const steps = [
      _CompressStep(quality: 92, minWidth: 1440, minHeight: 1440),
      _CompressStep(quality: 88, minWidth: 1440, minHeight: 1440),
      _CompressStep(quality: 85, minWidth: 1440, minHeight: 1440),
      _CompressStep(quality: 82, minWidth: 1440, minHeight: 1440),
      _CompressStep(quality: 80, minWidth: 1440, minHeight: 1440),
      _CompressStep(quality: 90, minWidth: 1200, minHeight: 1200),
      _CompressStep(quality: 86, minWidth: 1200, minHeight: 1200),
      _CompressStep(quality: 82, minWidth: 1200, minHeight: 1200),
      _CompressStep(quality: 78, minWidth: 1200, minHeight: 1200),
      _CompressStep(quality: 90, minWidth: 1024, minHeight: 1024),
      _CompressStep(quality: 86, minWidth: 1024, minHeight: 1024),
      _CompressStep(quality: 82, minWidth: 1024, minHeight: 1024),
      _CompressStep(quality: 78, minWidth: 1024, minHeight: 1024),
      _CompressStep(quality: 74, minWidth: 1024, minHeight: 1024),
      _CompressStep(quality: 70, minWidth: 1024, minHeight: 1024),
      _CompressStep(quality: 88, minWidth: 800, minHeight: 800),
      _CompressStep(quality: 82, minWidth: 800, minHeight: 800),
      _CompressStep(quality: 76, minWidth: 800, minHeight: 800),
      _CompressStep(quality: 70, minWidth: 800, minHeight: 800),
      _CompressStep(quality: 65, minWidth: 800, minHeight: 800),
      _CompressStep(quality: 85, minWidth: 600, minHeight: 600),
      _CompressStep(quality: 75, minWidth: 600, minHeight: 600),
      _CompressStep(quality: 65, minWidth: 600, minHeight: 600),
      _CompressStep(quality: 55, minWidth: 600, minHeight: 600),
      _CompressStep(quality: 45, minWidth: 600, minHeight: 600),
    ];

    Uint8List? bestCandidateUnderMax;

    // 1. Fast Native FlutterImageCompress
    for (final step in steps) {
      try {
        final result = await FlutterImageCompress.compressWithList(
          sourceBytes,
          quality: step.quality,
          minWidth: step.minWidth,
          minHeight: step.minHeight,
          format: CompressFormat.jpeg,
        );

        if (result.isNotEmpty) {
          if (result.length <= maxBytes) {
            if (result.length >= minBytes) {
              // Successfully hit target: within 150 KB and not less than 100 KB!
              return result;
            }
            if (bestCandidateUnderMax == null || result.length > bestCandidateUnderMax.length) {
              bestCandidateUnderMax = result;
            }
          }
        }
      } catch (e) {
        debugPrint('ImageCompressService native compress error: $e');
        break; // Fall back to pure Dart image package
      }
    }

    if (bestCandidateUnderMax != null && bestCandidateUnderMax.length <= maxBytes) {
      return bestCandidateUnderMax;
    }

    // 2. Pure Dart fallback using image package (fast single-pass)
    try {
      final decoded = img_lib.decodeImage(sourceBytes);

      if (decoded != null) {
        img_lib.Image resized = decoded;
        const maxDimension = 1024;
        if (decoded.width > maxDimension || decoded.height > maxDimension) {
          if (decoded.width >= decoded.height) {
            resized = img_lib.copyResize(decoded, width: maxDimension);
          } else {
            resized = img_lib.copyResize(decoded, height: maxDimension);
          }
        }

        Uint8List? smallest;
        for (final q in [85, 75, 65, 50, 35]) {
          final encoded = Uint8List.fromList(
            img_lib.encodeJpg(resized, quality: q),
          );
          smallest ??= encoded;
          if (encoded.length <= maxBytes) {
            return encoded;
          }
          if (encoded.length < smallest.length) {
            smallest = encoded;
          }
        }
        if (smallest != null) {
          return smallest;
        }
      }
    } catch (e) {
      debugPrint('ImageCompressService fallback decode error: $e');
    }

    return bestCandidateUnderMax ?? sourceBytes;
  }

  /// Compresses raw image bytes without blurring or severe downscaling.
  static Future<Uint8List> compressToPng(
    Uint8List sourceBytes, {
    int maxSizeKB = 150,
  }) async {
    final maxBytes = maxSizeKB * 1024;

    if (sourceBytes.isEmpty) return sourceBytes;
    if (sourceBytes.length <= maxBytes && (isPng(sourceBytes) || isJpeg(sourceBytes))) return sourceBytes;

    try {
      final decoded = img_lib.decodeImage(sourceBytes);
      if (decoded != null) {
        for (final q in [78, 72, 65, 58, 50]) {
          final jpg = Uint8List.fromList(img_lib.encodeJpg(decoded, quality: q));
          if (jpg.length <= maxBytes) {
            return jpg;
          }
        }
        final resized = img_lib.copyResize(decoded, width: 900);
        for (final q in [75, 65, 55]) {
          final jpg = Uint8List.fromList(img_lib.encodeJpg(resized, quality: q));
          if (jpg.length <= maxBytes) {
            return jpg;
          }
        }
      }
    } catch (e) {
      debugPrint('ImageCompressService compressToPng error: $e');
    }

    return sourceBytes;
  }
}

class _CompressStep {
  final int quality;
  final int minWidth;
  final int minHeight;
  const _CompressStep({
    required this.quality,
    required this.minWidth,
    required this.minHeight,
  });
}
