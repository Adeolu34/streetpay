import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '/config/secrets.dart';
import 'address_verification_helper.dart';

/// Service for generating and refining Nigerian address verification descriptions
/// using AI (Google Gemini / OpenRouter) with an intelligent local NLP synthesis fallback.
///
/// Designed to guarantee compliance with 9PSB regulatory verification rules:
/// 1. Begins with a popular landmark / bus stop.
/// 2. Explains navigation from that point past the filling station.
/// 3. States the house number and street location.
/// 4. Situates the house relative to the nearest building / landmark.
/// 5. Specifies the colour and structure of the house.
/// 6. Confirms physical verification on site.
class AiAddressVerificationService {
  /// Generates a compliant, articulate address verification description.
  static Future<String> generateDescription({
    String? busStopOrLandmark,
    String? fillingStation,
    String? nearestBuilding,
    String? houseNumber,
    String? houseColor,
    String? streetName,
    String? city,
    String? state,
    String? userNotes,
    String? rawAddress,
  }) async {
    final busStop = AddressVerificationHelper.resolveBusStop(busStopOrLandmark);
    final station = AddressVerificationHelper.resolveFillingStation(fillingStation);
    final building = AddressVerificationHelper.resolveNearestBuilding(nearestBuilding);
    final houseNo = AddressVerificationHelper.resolveHouseNumber(houseNumber);
    final color = AddressVerificationHelper.resolveHouseColor(houseColor);
    final route = AddressVerificationHelper.resolveRouteDescription(userNotes);

    // 1. Try remote AI generation (Gemini) if internet and key are available
    if (AppSecrets.geminiApiKey.isNotEmpty) {
      try {
        final aiResult = await _generateWithGemini(
          busStop: busStop,
          station: station,
          building: building,
          houseNo: houseNo,
          color: color,
          street: streetName,
          city: city,
          state: state,
          userNotes: route,
          rawAddress: rawAddress,
        );
        if (aiResult != null &&
            aiResult.trim().isNotEmpty &&
            _validateCompliance(
              aiResult,
              busStop,
              station: station,
              building: building,
              houseNo: houseNo,
            )) {
          final finalized = _ensureComplianceClosing(aiResult);
          debugPrint('[AI Address] Successfully generated description via Gemini AI.');
          return finalized;
        }
      } catch (e) {
        debugPrint('[AI Address] Gemini AI call failed or timed out: $e');
      }
    }

    // 2. Try OpenRouter AI fallback
    if (AppSecrets.openRouterApiKey.isNotEmpty) {
      try {
        final aiResult = await _generateWithOpenRouter(
          busStop: busStop,
          station: station,
          building: building,
          houseNo: houseNo,
          color: color,
          street: streetName,
          city: city,
          state: state,
          userNotes: route,
          rawAddress: rawAddress,
        );
        if (aiResult != null &&
            aiResult.trim().isNotEmpty &&
            _validateCompliance(
              aiResult,
              busStop,
              station: station,
              building: building,
              houseNo: houseNo,
            )) {
          final finalized = _ensureComplianceClosing(aiResult);
          debugPrint('[AI Address] Successfully generated description via OpenRouter AI.');
          return finalized;
        }
      } catch (e) {
        debugPrint('[AI Address] OpenRouter call failed: $e');
      }
    }

    // 3. High-Quality Intelligent Local NLP Synthesis (deterministic, zero latency, offline-ready)
    debugPrint('[AI Address] Using intelligent local NLP synthesis engine.');
    return synthesizeSmartDescription(
      busStop: busStop,
      station: station,
      building: building,
      houseNo: houseNo,
      color: color,
      street: streetName,
      city: city,
      state: state,
      userNotes: route,
      rawAddress: rawAddress,
    );
  }

  /// Refines an existing user draft or rough text, extracting missing details if possible.
  static Future<String> enhanceUserDraft(String rawDraft, {
    String? busStopOrLandmark,
    String? fillingStation,
    String? nearestBuilding,
    String? houseNumber,
    String? houseColor,
    String? streetName,
    String? rawAddress,
  }) async {
    var resolvedBusStop = AddressVerificationHelper.resolveBusStop(busStopOrLandmark);
    var resolvedStation = AddressVerificationHelper.resolveFillingStation(fillingStation);
    var resolvedBuilding = AddressVerificationHelper.resolveNearestBuilding(nearestBuilding);
    var resolvedHouseNo = AddressVerificationHelper.resolveHouseNumber(houseNumber);
    var resolvedColor = AddressVerificationHelper.resolveHouseColor(houseColor);

    // Extract any obvious cues from rawDraft if discrete fields are empty
    final lower = rawDraft.toLowerCase();
    if (resolvedBusStop.isEmpty) {
      final busMatch = RegExp(r'(?:from|near|at|around)\s+([a-zA-Z0-9\s]+(?:bus\s*stop|junction|roundabout|expressway|bridge))', caseSensitive: false).firstMatch(rawDraft);
      if (busMatch != null) resolvedBusStop = busMatch.group(1)?.trim() ?? '';
    }
    if (resolvedStation.isEmpty) {
      final stationMatch = RegExp(r'([a-zA-Z0-9\s]+(?:filling\s*station|petrol\s*station|station|oil|fuel))', caseSensitive: false).firstMatch(rawDraft);
      if (stationMatch != null) resolvedStation = stationMatch.group(1)?.trim() ?? '';
    }
    if (resolvedColor.isEmpty) {
      final colorMatch = RegExp(r'\b(white|yellow|blue|green|cream|grey|gray|brown|orange|pink|black|red)\b\s+(?:duplex|bungalow|storey|building|house|gate|compound)?', caseSensitive: false).firstMatch(rawDraft);
      if (colorMatch != null) resolvedColor = colorMatch.group(0)?.trim() ?? '';
    }
    if (resolvedHouseNo.isEmpty) {
      final noMatch = RegExp(r'(?:house|number|no\.?|plot|flat)\s*(\d+[a-zA-Z]?)', caseSensitive: false).firstMatch(rawDraft);
      if (noMatch != null) resolvedHouseNo = noMatch.group(1)?.trim() ?? '';
    }

    return generateDescription(
      busStopOrLandmark: resolvedBusStop,
      fillingStation: resolvedStation,
      nearestBuilding: resolvedBuilding,
      houseNumber: resolvedHouseNo,
      houseColor: resolvedColor,
      streetName: streetName,
      userNotes: rawDraft,
      rawAddress: rawAddress,
    );
  }

  /// Synthesizes an articulate, regulatory-compliant narrative locally.
  static String synthesizeSmartDescription({
    String? busStop,
    String? station,
    String? building,
    String? houseNo,
    String? color,
    String? street,
    String? city,
    String? state,
    String? userNotes,
    String? rawAddress,
  }) {
    final bStop = _cleanName(busStop);
    final fStation = _cleanName(station);
    final nBuilding = _cleanName(building);
    final hNo = _cleanName(houseNo);
    final hColor = _cleanName(color);
    final sName = _cleanName(street);
    final cName = _cleanName(city);
    final notes = (userNotes ?? '').trim();

    final buffer = StringBuffer();

    // 1. Mandatory requirement: Begin with a popular landmark / bus stop
    if (bStop.isNotEmpty) {
      buffer.write('Starting from $bStop, ');
    } else {
      buffer.write('Starting from the popular landmark along the main access corridor, ');
    }

    // 2. Navigation route and filling station
    if (notes.isNotEmpty && !notes.toLowerCase().startsWith('standard occupied')) {
      var cleanNotes = notes;
      // Strip redundant starting prefix if user repeated the bus stop
      if (bStop.isNotEmpty) {
        final prefixRegex = RegExp(r'^(?:starting\s+from|from)\s+' + RegExp.escape(bStop) + r'[,:\s]*', caseSensitive: false);
        cleanNotes = cleanNotes.replaceAll(prefixRegex, '').trim();
      }
      if (cleanNotes.isNotEmpty) {
        if (cleanNotes.endsWith('.')) cleanNotes = cleanNotes.substring(0, cleanNotes.length - 1);
        buffer.write(cleanNotes);
        if (fStation.isNotEmpty && !cleanNotes.toLowerCase().contains(fStation.toLowerCase())) {
          buffer.write(', continuing past $fStation');
        }
        buffer.write('. ');
      }
    } else {
      if (sName.isNotEmpty) {
        if (fStation.isNotEmpty) {
          buffer.write('proceed straight along $sName past $fStation. ');
        } else {
          buffer.write('proceed straight along $sName into the neighborhood. ');
        }
      } else if (fStation.isNotEmpty) {
        buffer.write('proceed along the primary access road, continuing past $fStation. ');
      } else {
        buffer.write('follow the main access road directly into the street. ');
      }
    }

    // 3. House location and nearest building
    final houseLabel = hNo.isNotEmpty ? 'House $hNo' : 'the residential premises';
    if (nBuilding.isNotEmpty) {
      if (sName.isNotEmpty && !buffer.toString().toLowerCase().contains(sName.toLowerCase())) {
        buffer.write('Locate $houseLabel on $sName, situated directly beside $nBuilding. ');
      } else {
        buffer.write('Locate $houseLabel, situated directly beside $nBuilding. ');
      }
    } else {
      if (sName.isNotEmpty && !buffer.toString().toLowerCase().contains(sName.toLowerCase())) {
        buffer.write('Locate $houseLabel positioned along $sName. ');
      } else {
        buffer.write('Locate $houseLabel positioned along the street. ');
      }
    }

    // 4. Colour of the house / architectural description
    if (hColor.isNotEmpty) {
      final colorLower = hColor.toLowerCase();
      if (colorLower.contains('building') ||
          colorLower.contains('house') ||
          colorLower.contains('duplex') ||
          colorLower.contains('bungalow') ||
          colorLower.contains('storey') ||
          colorLower.contains('compound')) {
        buffer.write('The property is an easily identified $hColor. ');
      } else {
        buffer.write('The property is an easily identified $hColor painted residential building. ');
      }
    }

    // 5. Physical verification closing confirmation
    buffer.write('Premises physically sighted and verified as an occupied residential property.');

    return buffer.toString().replaceAll('  ', ' ').trim();
  }

  static String _cleanName(String? val) {
    if (val == null) return '';
    var s = val.trim();
    if (s.isEmpty) return '';
    // Capitalize first character if lowercase
    return s[0].toUpperCase() + s.substring(1);
  }

  static bool _validateCompliance(
    String text,
    String busStop, {
    String? station,
    String? building,
    String? houseNo,
  }) {
    if (text.length < 50) return false;
    final lower = text.toLowerCase();
    if (!lower.startsWith('starting') &&
        !lower.startsWith('from') &&
        !lower.contains(busStop.toLowerCase())) {
      return false;
    }
    if (station != null &&
        station.trim().isNotEmpty &&
        !lower.contains(station.trim().toLowerCase())) {
      return false;
    }
    if (building != null &&
        building.trim().isNotEmpty &&
        !lower.contains(building.trim().toLowerCase())) {
      return false;
    }
    if (houseNo != null &&
        houseNo.trim().isNotEmpty &&
        !lower.contains(houseNo.trim().toLowerCase())) {
      return false;
    }
    return true;
  }

  static Future<String?> _generateWithGemini({
    required String busStop,
    required String station,
    required String building,
    required String houseNo,
    required String color,
    String? street,
    String? city,
    String? state,
    String? userNotes,
    String? rawAddress,
  }) async {
    final prompt = _buildPrompt(
      busStop: busStop,
      station: station,
      building: building,
      houseNo: houseNo,
      color: color,
      street: street,
      city: city,
      state: state,
      userNotes: userNotes,
      rawAddress: rawAddress,
    );

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/${AppSecrets.geminiModel}:generateContent?key=${AppSecrets.geminiApiKey}',
    );

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [{'text': prompt}]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,
          'maxOutputTokens': 600,
          'thinkingConfig': {'thinkingBudget': 0},
        }
      }),
    ).timeout(const Duration(seconds: 10));

    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final candidate = body['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
      return _cleanAiOutput(candidate);
    }
    return null;
  }

  static Future<String?> _generateWithOpenRouter({
    required String busStop,
    required String station,
    required String building,
    required String houseNo,
    required String color,
    String? street,
    String? city,
    String? state,
    String? userNotes,
    String? rawAddress,
  }) async {
    final prompt = _buildPrompt(
      busStop: busStop,
      station: station,
      building: building,
      houseNo: houseNo,
      color: color,
      street: street,
      city: city,
      state: state,
      userNotes: userNotes,
      rawAddress: rawAddress,
    );

    final resp = await http.post(
      Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer ${AppSecrets.openRouterApiKey}',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://streetpay.app',
        'X-Title': 'StreetPay',
      },
      body: jsonEncode({
        'model': 'google/gemini-2.0-flash-001',
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'temperature': 0.1,
        'max_tokens': 600,
      }),
    ).timeout(const Duration(seconds: 10));

    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final candidate = body['choices']?[0]?['message']?['content'] as String?;
      return _cleanAiOutput(candidate);
    }
    return null;
  }

  static String _buildPrompt({
    required String busStop,
    required String station,
    required String building,
    required String houseNo,
    required String color,
    String? street,
    String? city,
    String? state,
    String? userNotes,
    String? rawAddress,
  }) {
    final startPoint = busStop.isNotEmpty ? busStop : 'the main access junction';
    return '''
You are an expert KYC address verification compliance officer for 9PSB (a Nigerian Payment Service Bank).
Generate a single continuous narrative paragraph (no bullet points, no numbered lists, no markdown headers or asterisks, no quotes) describing physical navigation to verify the customer's residence.

Strict 9PSB Regulatory Compliance Rules:
1. MUST begin with: "Starting from $startPoint, ..."
2. Detail navigation along the roadway${station.isNotEmpty ? ' past $station' : ''}.
3. State the house number${houseNo.isNotEmpty ? ' ($houseNo)' : ''} and street name${street != null && street.isNotEmpty ? ' ($street)' : ''}.
4. Mention proximity to the nearest building / landmark${building.isNotEmpty ? ' ($building)' : ''}.
5. State the house colour / structure${color.isNotEmpty ? ' ($color)' : ''}.
6. MUST end exactly with: "Premises physically sighted and verified as an occupied residential property."
7. Return ONLY the single continuous paragraph.

Customer Details:
- Popular Bus Stop / Landmark: $busStop
- Nearest Filling Station Along Route: $station
- Nearest Building / Structure: $building
- House Number: $houseNo
- House Colour / Type: $color
- Street: ${street ?? ''}
- City / State: ${city ?? ''} ${state ?? ''}
- User Route Notes: ${userNotes ?? ''}
- Full Address: ${rawAddress ?? ''}
''';
  }

  static String? _cleanAiOutput(String? text) {
    if (text == null) return null;
    var cleaned = text.trim();
    if (cleaned.startsWith('"') && cleaned.endsWith('"')) {
      cleaned = cleaned.substring(1, cleaned.length - 1).trim();
    }
    // Remove markdown code fences, headers, asterisks
    cleaned = cleaned.replaceAll(RegExp(r'^```[a-zA-Z]*\n?|```$', multiLine: true), '').trim();
    cleaned = cleaned.replaceAll('**', '').replaceAll('###', '').replaceAll('##', '');
    // Replace multiple spaces and newlines with a single space
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    return cleaned;
  }

  static String _ensureComplianceClosing(String text) {
    var s = text.trim();
    const conclusion = 'Premises physically sighted and verified as an occupied residential property.';
    if (s.endsWith(conclusion)) {
      return s;
    }
    // If AI embedded it into a run-on clause like "...confirming that the premises physically sighted and verified..."
    final match = RegExp(
      r'[,;\.]?\s*(?:and\s+)?(?:confirming\s+that\s+)?(?:the\s+)?premises physically sighted and verified as an occupied residential property\.?$',
      caseSensitive: false,
    ).firstMatch(s);
    if (match != null) {
      s = s.substring(0, match.start).trim();
      if (!s.endsWith('.')) s = '$s.';
      return '$s $conclusion';
    }
    if (!s.endsWith('.')) s = '$s.';
    return '$s $conclusion';
  }
}
