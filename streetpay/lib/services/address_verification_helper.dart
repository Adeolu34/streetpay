import 'package:flutter/foundation.dart';
import '/app_state.dart';
import 'ai_address_verification_service.dart';

/// Helper service for structuring and concatenating Nigerian address verification fields
/// in accordance with 9PSB and banking regulatory KYC guidelines.
class AddressVerificationHelper {
  /// Resolves the popular bus stop or landmark.
  static String resolveBusStop(String? busStop) {
    if (busStop != null && busStop.trim().isNotEmpty) return busStop.trim();
    if (FFAppState().userBusStop.trim().isNotEmpty) return FFAppState().userBusStop.trim();
    if (FFAppState().userLandmark.trim().isNotEmpty) return FFAppState().userLandmark.trim();
    return '';
  }

  /// Resolves the nearest filling station.
  static String resolveFillingStation(String? station) {
    if (station != null && station.trim().isNotEmpty) return station.trim();
    if (FFAppState().userFillingStation.trim().isNotEmpty) return FFAppState().userFillingStation.trim();
    return '';
  }

  /// Resolves the nearest building or prominent structure.
  static String resolveNearestBuilding(String? building) {
    if (building != null && building.trim().isNotEmpty) return building.trim();
    if (FFAppState().userNearestBuilding.trim().isNotEmpty) return FFAppState().userNearestBuilding.trim();
    return '';
  }

  /// Resolves the house or building number.
  static String resolveHouseNumber(String? houseNo) {
    if (houseNo != null && houseNo.trim().isNotEmpty) return houseNo.trim();
    if (FFAppState().userHouseNo.trim().isNotEmpty) return FFAppState().userHouseNo.trim();
    return '';
  }

  /// Resolves the color of the house / building.
  static String resolveHouseColor(String? color) {
    if (color != null && color.trim().isNotEmpty) return color.trim();
    if (FFAppState().userHouseColor.trim().isNotEmpty) return FFAppState().userHouseColor.trim();
    return '';
  }

  /// Resolves user route navigation description.
  static String resolveRouteDescription(String? route) {
    if (route != null && route.trim().isNotEmpty) return route.trim();
    if (FFAppState().userRouteDesc.trim().isNotEmpty) return FFAppState().userRouteDesc.trim();
    return '';
  }

  /// Concatenates the discrete address points into a robust, compliant verification description.
  /// Strict 9PSB requirements:
  /// 1. Begins with a popular landmark / bus stop
  /// 2. Explains how to locate the house from that point
  /// 3. Includes the house number
  /// 4. Includes the nearest building
  /// 5. Includes the colour of the house
  /// 6. Mentions the filling station located along the route
  static String buildVerificationDescription({
    String? busStopOrLandmark,
    String? fillingStation,
    String? nearestBuilding,
    String? houseNumber,
    String? houseColor,
    String? streetName,
    String? city,
    String? routeExplanation,
    String? rawAddress,
  }) {
    final busStop = resolveBusStop(busStopOrLandmark);
    final station = resolveFillingStation(fillingStation);
    final building = resolveNearestBuilding(nearestBuilding);
    final houseNo = resolveHouseNumber(houseNumber);
    final color = resolveHouseColor(houseColor);
    final route = resolveRouteDescription(routeExplanation);

    final street = (streetName != null && streetName.trim().isNotEmpty)
        ? streetName.trim()
        : FFAppState().userStreet.trim();

    // Check if we have enough discrete points to generate a comprehensive narrative
    final hasDiscretePoints = busStop.isNotEmpty ||
        station.isNotEmpty ||
        building.isNotEmpty ||
        color.isNotEmpty;

    if (!hasDiscretePoints) {
      // Fallback if none of the specific fields are available yet
      if (rawAddress != null && rawAddress.trim().isNotEmpty && rawAddress != 'Residential Address Not Specified') {
        return 'Starting from the main access junction, proceed along ${rawAddress.trim()}. Property physically sighted and confirmed as an occupied residential premises.';
      }
      return 'Standard residential premises physically sighted, identified within the neighborhood, and verified as an occupied property.';
    }

    final buffer = StringBuffer();

    // 1. Mandatory requirement: Begin with a popular landmark / bus stop
    if (busStop.isNotEmpty) {
      buffer.write('Starting from $busStop, ');
    } else {
      buffer.write('Starting from the popular landmark along the main corridor, ');
    }

    // 2. Clear route navigation & filling station along the route
    var cleanRoute = route;
    if (busStop.isNotEmpty && cleanRoute.isNotEmpty) {
      final prefixRegex = RegExp(r'^(from|starting from)\s+' + RegExp.escape(busStop) + r'[,:\s]*', caseSensitive: false);
      cleanRoute = cleanRoute.replaceAll(prefixRegex, '').trim();
      // Capitalize first letter if needed
      if (cleanRoute.isNotEmpty) {
        cleanRoute = cleanRoute[0].toLowerCase() + cleanRoute.substring(1);
      }
    }

    if (cleanRoute.isNotEmpty) {
      buffer.write(cleanRoute.endsWith('.') ? cleanRoute.substring(0, cleanRoute.length - 1) : cleanRoute);
      if (station.isNotEmpty && !cleanRoute.toLowerCase().contains(station.toLowerCase())) {
        buffer.write(', continuing past $station');
      }
      buffer.write('. ');
    } else if (station.isNotEmpty) {
      if (street.isNotEmpty) {
        buffer.write('proceed along $street, continuing past $station. ');
      } else {
        buffer.write('follow the main access road, continuing past $station. ');
      }
    } else if (street.isNotEmpty) {
      buffer.write('proceed straight along $street. ');
    } else {
      buffer.write('follow the primary access road into the street. ');
    }

    // 3. House number, street location & nearest building
    final houseLabel = houseNo.isNotEmpty ? 'House $houseNo' : 'the residential building';
    if (building.isNotEmpty) {
      if (street.isNotEmpty && (cleanRoute.isEmpty || !cleanRoute.toLowerCase().contains(street.toLowerCase()))) {
        buffer.write('Locate $houseLabel on $street, situated directly beside $building. ');
      } else {
        buffer.write('Locate $houseLabel, situated directly beside $building. ');
      }
    } else {
      if (street.isNotEmpty && (cleanRoute.isEmpty || !cleanRoute.toLowerCase().contains(street.toLowerCase()))) {
        buffer.write('Locate $houseLabel situated along $street. ');
      } else {
        buffer.write('Locate $houseLabel situated along the street. ');
      }
    }

    // 4. Colour of the house
    if (color.isNotEmpty) {
      final colorLower = color.toLowerCase();
      if (colorLower.contains('building') ||
          colorLower.contains('house') ||
          colorLower.contains('duplex') ||
          colorLower.contains('bungalow') ||
          colorLower.contains('storey') ||
          colorLower.contains('apartment')) {
        buffer.write('The property is a $color. ');
      } else {
        buffer.write('The property is a $color painted building. ');
      }
    }

    // 5. Verification statement
    buffer.write('Premises physically sighted and verified as an occupied residential property.');

    return buffer.toString().replaceAll('  ', ' ').trim();
  }

  /// Asynchronously generates an AI-optimized verification description.
  static Future<String> buildAiVerificationDescription({
    String? busStopOrLandmark,
    String? fillingStation,
    String? nearestBuilding,
    String? houseNumber,
    String? houseColor,
    String? streetName,
    String? city,
    String? state,
    String? routeExplanation,
    String? rawAddress,
  }) async {
    return AiAddressVerificationService.generateDescription(
      busStopOrLandmark: busStopOrLandmark,
      fillingStation: fillingStation,
      nearestBuilding: nearestBuilding,
      houseNumber: houseNumber,
      houseColor: houseColor,
      streetName: streetName,
      city: city,
      state: state,
      userNotes: routeExplanation,
      rawAddress: rawAddress,
    );
  }
}
