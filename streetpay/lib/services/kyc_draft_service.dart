import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/flutter_flow/uploaded_file.dart';

class KycDraftData {
  final String? nin;
  final String? bvn;
  final String? phone;
  final String? city;
  final String? street;
  final String? houseNumber;
  final String? state;
  final String? lga;
  final String? gender;
  final bool? isPep;
  final String? dateOfBirth;
  final String? landmark;
  final DateTime savedAt;

  KycDraftData({
    this.nin,
    this.bvn,
    this.phone,
    this.city,
    this.street,
    this.houseNumber,
    this.state,
    this.lga,
    this.gender,
    this.isPep,
    this.dateOfBirth,
    this.landmark,
    DateTime? savedAt,
  }) : savedAt = savedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'nin': nin,
        'bvn': bvn,
        'phone': phone,
        'city': city,
        'street': street,
        'houseNumber': houseNumber,
        'state': state,
        'lga': lga,
        'gender': gender,
        'isPep': isPep,
        'dateOfBirth': dateOfBirth,
        'landmark': landmark,
        'savedAt': savedAt.toIso8601String(),
      };

  factory KycDraftData.fromJson(Map<String, dynamic> json) => KycDraftData(
        nin: json['nin'],
        bvn: json['bvn'],
        phone: json['phone'],
        city: json['city'],
        street: json['street'],
        houseNumber: json['houseNumber'],
        state: json['state'],
        lga: json['lga'],
        gender: json['gender'],
        isPep: json['isPep'],
        dateOfBirth: json['dateOfBirth'],
        landmark: json['landmark'],
        savedAt: json['savedAt'] != null
            ? DateTime.tryParse(json['savedAt']) ?? DateTime.now()
            : DateTime.now(),
      );

  bool get isEmpty {
    return (nin == null || nin!.trim().isEmpty) &&
        (bvn == null || bvn!.trim().isEmpty) &&
        (city == null || city!.trim().isEmpty) &&
        (street == null || street!.trim().isEmpty) &&
        (state == null || state!.trim().isEmpty) &&
        (landmark == null || landmark!.trim().isEmpty);
  }

  bool get isNotEmpty => !isEmpty;
}

class KycDraftService {
  static const String _storageKey = 'sp_kyc_tier_draft_v1';

  /// Save the current KYC form draft
  static Future<void> saveDraft({
    String? nin,
    String? bvn,
    String? phone,
    String? city,
    String? street,
    String? houseNumber,
    String? state,
    String? lga,
    String? gender,
    bool? isPep,
    String? dateOfBirth,
    String? landmark,
  }) async {
    try {
      final draft = KycDraftData(
        nin: nin,
        bvn: bvn,
        phone: phone,
        city: city,
        street: street,
        houseNumber: houseNumber,
        state: state,
        lga: lga,
        gender: gender,
        isPep: isPep,
        dateOfBirth: dateOfBirth,
        landmark: landmark,
        savedAt: DateTime.now(),
      );

      if (draft.isEmpty) return;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(draft.toJson()));
    } catch (_) {}
  }

  /// Retrieve the saved draft if any
  static Future<KycDraftData?> getDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) return null;

      final map = jsonDecode(raw) as Map<String, dynamic>;
      final draft = KycDraftData.fromJson(map);
      return draft.isNotEmpty ? draft : null;
    } catch (_) {
      return null;
    }
  }

  /// Check if a valid draft exists
  static Future<bool> hasDraft() async {
    final draft = await getDraft();
    return draft != null && draft.isNotEmpty;
  }

  /// Clear the draft and persisted files when tier upgrade is successfully approved
  static Future<void> clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      await KycFileService.clearAllFiles();
    } catch (_) {}
  }
}

/// Service to persist and retrieve uploaded KYC files (ID card, selfie, proof of address, utility bill)
class KycFileService {
  static Future<String> _getDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final kycDir = Directory('${dir.path}/kyc_files');
    if (!await kycDir.exists()) {
      await kycDir.create(recursive: true);
    }
    return kycDir.path;
  }

  /// Save uploaded KYC file to persistent local storage
  static Future<void> saveFile(String key, FFUploadedFile file) async {
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) return;
    try {
      final dir = await _getDir();
      final dataFile = File('$dir/$key.dat');
      await dataFile.writeAsBytes(bytes);

      final metaFile = File('$dir/$key.meta.json');
      final meta = {
        'name': file.name ?? file.originalFilename,
        'originalFilename': file.originalFilename,
        'height': file.height,
        'width': file.width,
        'blurHash': file.blurHash,
      };
      await metaFile.writeAsString(jsonEncode(meta));
    } catch (e) {
      debugPrint('KycFileService.saveFile error: $e');
    }
  }

  /// Retrieve uploaded KYC file from persistent local storage
  static Future<FFUploadedFile?> getFile(String key) async {
    try {
      final dir = await _getDir();
      final dataFile = File('$dir/$key.dat');
      if (!await dataFile.exists()) return null;

      final bytes = await dataFile.readAsBytes();
      if (bytes.isEmpty) return null;

      String name = key;
      String originalFilename = key;
      double? height;
      double? width;
      String? blurHash;

      final metaFile = File('$dir/$key.meta.json');
      if (await metaFile.exists()) {
        try {
          final meta = jsonDecode(await metaFile.readAsString()) as Map<String, dynamic>;
          name = meta['name'] ?? key;
          originalFilename = meta['originalFilename'] ?? name;
          height = (meta['height'] as num?)?.toDouble();
          width = (meta['width'] as num?)?.toDouble();
          blurHash = meta['blurHash'];
        } catch (_) {}
      }

      return FFUploadedFile(
        bytes: bytes,
        name: name,
        originalFilename: originalFilename,
        height: height,
        width: width,
        blurHash: blurHash,
      );
    } catch (e) {
      debugPrint('KycFileService.getFile error: $e');
      return null;
    }
  }

  /// Check if a KYC file exists locally
  static Future<bool> hasFile(String key) async {
    try {
      final dir = await _getDir();
      final dataFile = File('$dir/$key.dat');
      return await dataFile.exists();
    } catch (_) {
      return false;
    }
  }

  /// Delete a single KYC file and its metadata by key
  static Future<void> removeFile(String key) async {
    try {
      final dir = await _getDir();
      final dataFile = File('$dir/$key.dat');
      if (await dataFile.exists()) {
        await dataFile.delete();
      }
      final metaFile = File('$dir/$key.meta.json');
      if (await metaFile.exists()) {
        await metaFile.delete();
      }
    } catch (_) {}
  }

  /// Clear all KYC files once upgrade is successfully submitted
  static Future<void> clearAllFiles() async {
    try {
      final dir = await _getDir();
      final kycDir = Directory(dir);
      if (await kycDir.exists()) {
        await kycDir.delete(recursive: true);
      }
    } catch (_) {}
  }
}
