// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_version_plus/new_version_plus.dart';
import '../actions/getupdatestatus.dart';

class ForceUpdateOverlay extends StatelessWidget {
  const ForceUpdateOverlay({
    super.key,
    required this.status,
    this.width = double.infinity,
    this.height = double.infinity,
    this.isForceUpdate = false,
    this.onDismiss,
  });

  final VersionStatus? status;
  final double width;
  final double height;
  final bool isForceUpdate;
  final VoidCallback? onDismiss;

  /// Convenience helper to display this update prompt as a modal dialog anywhere in the app.
  static Future<bool?> show(
    BuildContext context, {
    required VersionStatus status,
    bool isForceUpdate = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: !isForceUpdate,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (dialogCtx) {
        return PopScope(
          canPop: !isForceUpdate,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ForceUpdateOverlay(
              status: status,
              isForceUpdate: isForceUpdate,
              onDismiss: () => Navigator.of(dialogCtx).pop(false),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleUpdate() async {
    await launchStoreListing(appStoreLink: status?.appStoreLink);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final localVer = status?.localVersion ?? '2.2.5';
    final storeVer = status?.storeVersion ?? 'Latest';
    final releaseNotes = status?.releaseNotes?.trim();

    return PopScope(
      canPop: !isForceUpdate,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 380,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
                border: Border.all(
                  color: theme.primary.withValues(alpha: 0.18),
                  width: 1.2,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    // Brand Icon with emerald glowing halo
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C853), Color(0xFF007A3B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00A651).withValues(alpha: 0.38),
                            blurRadius: 18,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.system_update_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    Text(
                      isForceUpdate ? 'Update Required' : 'New Update Available',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      isForceUpdate
                          ? 'A mandatory update is required to continue using StreetPay safely with our latest services.'
                          : 'A newer version of StreetPay is ready on Google Play with security improvements and better speed.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: theme.secondaryText,
                        fontSize: 13.5,
                        height: 1.45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Version comparison badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.primaryBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: theme.alternate,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Current
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Installed',
                                style: GoogleFonts.plusJakartaSans(
                                  color: theme.secondaryText,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'v$localVer',
                                style: GoogleFonts.outfit(
                                  color: theme.primaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: theme.primary,
                            ),
                          ),

                          // Store
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Google Play',
                                style: GoogleFonts.plusJakartaSans(
                                  color: theme.primary,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'v$storeVer',
                                    style: GoogleFonts.outfit(
                                      color: theme.primary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 1.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00A651).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'NEW',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF00A651),
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Release notes if available
                    if (releaseNotes != null &&
                        releaseNotes.isNotEmpty &&
                        !releaseNotes.toLowerCase().contains('var ') &&
                        !releaseNotes.contains('http')) ...[
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "What's New:",
                          style: GoogleFonts.plusJakartaSans(
                            color: theme.primaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxHeight: 90),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.primaryBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            releaseNotes,
                            style: GoogleFonts.plusJakartaSans(
                              color: theme.secondaryText,
                              fontSize: 11.5,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Action Button: Update on Play Store
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleUpdate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A651),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: const Color(0xFF00A651).withValues(alpha: 0.45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.play_arrow_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Update on Google Play',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Secondary Button: Remind me later (if not force update)
                    if (!isForceUpdate) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: TextButton(
                          onPressed: () {
                            if (onDismiss != null) {
                              onDismiss!();
                            } else {
                              Navigator.of(context, rootNavigator: true).maybePop(false);
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: theme.secondaryText,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Remind me later',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 8),
                      // Force update exit button
                      TextButton(
                        onPressed: () => exit(0),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.secondaryText,
                        ),
                        child: Text(
                          'Close App',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }
}
