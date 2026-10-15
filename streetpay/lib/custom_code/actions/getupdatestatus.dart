import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const String kPlayStorePackageId = 'com.streetpayngr.smartapp';
const String kPlayStoreWebUrl =
    'https://play.google.com/store/apps/details?id=$kPlayStorePackageId';
const String kPlayStoreMarketUri = 'market://details?id=$kPlayStorePackageId';

/// Checks Google Play Store for newer versions of StreetPay.
/// Returns [VersionStatus] if found, or null on error/timeout.
Future<VersionStatus?> checkAppVersionStatus({
  Duration timeout = const Duration(seconds: 4),
}) async {
  try {
    final newVersion = NewVersionPlus(
      androidId: kPlayStorePackageId,
      iOSId: kPlayStorePackageId,
    );

    final status = await newVersion.getVersionStatus().timeout(
      timeout,
      onTimeout: () {
        debugPrint('[StreetPay Update] Check timed out after ${timeout.inSeconds}s');
        return null;
      },
    );

    if (status != null) {
      debugPrint(
        '[StreetPay Update] Local: ${status.localVersion}, Store: ${status.storeVersion}, CanUpdate: ${status.canUpdate}',
      );
    }

    return status;
  } catch (e) {
    debugPrint('[StreetPay Update] Error checking for updates: $e');
    return null;
  }
}

/// Legacy FlutterFlow action returning boolean update status.
Future<bool> getupdatestatus() async {
  final status = await checkAppVersionStatus();
  return status?.canUpdate ?? false;
}

/// Launches Google Play Store directly in native app, falling back to browser.
Future<bool> launchStoreListing({String? appStoreLink}) async {
  final marketUri = Uri.parse(kPlayStoreMarketUri);
  final webUri = Uri.parse(
    (appStoreLink != null && appStoreLink.isNotEmpty)
        ? appStoreLink
        : kPlayStoreWebUrl,
  );

  try {
    if (await canLaunchUrl(marketUri)) {
      return await launchUrl(marketUri, mode: LaunchMode.externalApplication);
    }
  } catch (_) {}

  try {
    return await launchUrl(webUri, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('[StreetPay Update] Error launching store URL: $e');
    return false;
  }
}
