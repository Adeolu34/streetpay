import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'biometriccomp_model.dart';
export 'biometriccomp_model.dart';

class BiometriccompWidget extends StatefulWidget {
  const BiometriccompWidget({super.key});

  @override
  State<BiometriccompWidget> createState() => _BiometriccompWidgetState();
}

class _BiometriccompWidgetState extends State<BiometriccompWidget> {
  late BiometriccompModel _model;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BiometriccompModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _handleEnable() async {
    setState(() => _isLoading = true);
    final localAuth = LocalAuthentication();
    bool supported = await localAuth.isDeviceSupported();

    if (supported) {
      try {
        _model.biometric = await localAuth.authenticate(
          localizedReason:
              'Please authenticate to use biometric for transaction processing',
        );
      } on PlatformException {
        _model.biometric = false;
      }
      safeSetState(() {});
    }

    setState(() => _isLoading = false);

    if (_model.biometric) {
      FFAppState().biometric = true;
      safeSetState(() {});
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biometric authentication enabled.'),
          backgroundColor: Color(0xFF56B84B),
        ),
      );
    } else {
      FFAppState().biometric = false;
      safeSetState(() {});
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not enable biometric. Please try again.'),
          backgroundColor: Color(0xFFB53434),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D2419),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF2A4A38),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 28),

          // Fingerprint icon with glow ring
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF56B84B).withValues(alpha: 0.08),
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF56B84B).withValues(alpha: 0.14),
                ),
              ),
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1E4230),
                  border: Border.all(
                    color: const Color(0xFF56B84B).withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.fingerprint_rounded,
                  color: Color(0xFF56B84B),
                  size: 34,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            'Enable Biometric Login',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Use your fingerprint or face ID to sign in and approve transactions instantly.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8FA596),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          // Feature list
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF112B20),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E4230)),
            ),
            child: Column(
              children: [
                _featureRow(
                  icon: Icons.lock_rounded,
                  iconColor: const Color(0xFF56B84B),
                  iconBg: const Color(0xFF1A3A28),
                  title: 'Secure Login',
                  subtitle: 'Sign in instantly without typing your PIN.',
                ),
                _featureDivider(),
                _featureRow(
                  icon: Icons.verified_rounded,
                  iconColor: const Color(0xFF7FD472),
                  iconBg: const Color(0xFF1A3A28),
                  title: 'Transaction Approval',
                  subtitle: 'Authorise transfers with a single touch.',
                ),
                _featureDivider(),
                _featureRow(
                  icon: Icons.shield_rounded,
                  iconColor: const Color(0xFF56B84B),
                  iconBg: const Color(0xFF1A3A28),
                  title: 'Privacy Protected',
                  subtitle: 'Your biometric data never leaves your device.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Enable button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleEnable,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF56B84B),
                foregroundColor: const Color(0xFF06210F),
                disabledBackgroundColor: const Color(0xFF1E4230),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF06210F)),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.fingerprint_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Enable Biometric',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF06210F),
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 12),

          // Maybe later
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Maybe later',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6D8577),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8FA596),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureDivider() => Container(
        height: 1,
        margin: const EdgeInsets.only(left: 72),
        color: const Color(0xFF1E4230),
      );
}
