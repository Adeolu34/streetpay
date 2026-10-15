import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class TelcoMetadata {
  final String key;
  final String displayName;
  final String logoUrl;
  final Color brandColor;
  final Color textColor;
  final Color secondaryColor;

  const TelcoMetadata({
    required this.key,
    required this.displayName,
    required this.logoUrl,
    required this.brandColor,
    required this.textColor,
    required this.secondaryColor,
  });
}

class TelcoLogoService {
  static const Map<String, TelcoMetadata> _telcos = {
    'mtn': TelcoMetadata(
      key: 'mtn',
      displayName: 'MTN',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/MTN_Logo.svg/320px-MTN_Logo.svg.png',
      brandColor: Color(0xFFFFCC00),
      textColor: Color(0xFF101614),
      secondaryColor: Color(0xFF00588D),
    ),
    'airtel': TelcoMetadata(
      key: 'airtel',
      displayName: 'Airtel',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/Airtel_logo.svg/320px-Airtel_logo.svg.png',
      brandColor: Color(0xFFE60000),
      textColor: Colors.white,
      secondaryColor: Color(0xFFB30000),
    ),
    'glo': TelcoMetadata(
      key: 'glo',
      displayName: 'Glo',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Globacom_Logo.svg/320px-Globacom_Logo.svg.png',
      brandColor: Color(0xFF009900),
      textColor: Colors.white,
      secondaryColor: Color(0xFF005E00),
    ),
    'globacom': TelcoMetadata(
      key: 'glo',
      displayName: 'Glo',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Globacom_Logo.svg/320px-Globacom_Logo.svg.png',
      brandColor: Color(0xFF009900),
      textColor: Colors.white,
      secondaryColor: Color(0xFF005E00),
    ),
    '9mobile': TelcoMetadata(
      key: '9mobile',
      displayName: '9mobile',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/e/e0/9mobile_Logo.png/320px-9mobile_Logo.png',
      brandColor: Color(0xFF00573D),
      textColor: Colors.white,
      secondaryColor: Color(0xFF78BE20),
    ),
    'etisalat': TelcoMetadata(
      key: '9mobile',
      displayName: '9mobile',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/e/e0/9mobile_Logo.png/320px-9mobile_Logo.png',
      brandColor: Color(0xFF00573D),
      textColor: Colors.white,
      secondaryColor: Color(0xFF78BE20),
    ),
  };

  static final Map<String, TelcoMetadata> _cache = {};

  static TelcoMetadata? getMetadata(String? network) {
    if (network == null) return null;
    final clean = network.trim().toLowerCase();
    if (_cache.containsKey(clean)) {
      return _cache[clean];
    }
    for (final entry in _telcos.entries) {
      if (clean.contains(entry.key)) {
        _cache[clean] = entry.value;
        return entry.value;
      }
    }
    return null;
  }
}

class TelcoLogoWidget extends StatelessWidget {
  const TelcoLogoWidget({
    super.key,
    required this.network,
    this.size = 32.0,
    this.borderRadius = 8.0,
  });

  final String network;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final meta = TelcoLogoService.getMetadata(network);
    if (meta == null) {
      return _buildGenericBadge();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: size,
        height: size,
        color: meta.brandColor,
        child: CachedNetworkImage(
          imageUrl: meta.logoUrl,
          fit: BoxFit.contain,
          fadeInDuration: const Duration(milliseconds: 150),
          placeholder: (context, url) => _buildFallbackBadge(meta),
          errorWidget: (context, url, error) => _buildFallbackBadge(meta),
        ),
      ),
    );
  }

  Widget _buildFallbackBadge(TelcoMetadata meta) {
    if (meta.key == 'mtn') {
      return Container(
        width: size,
        height: size,
        color: const Color(0xFFFFCC00),
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size * 0.1,
            vertical: size * 0.05,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF101614),
              width: size * 0.06,
            ),
          ),
          child: Text(
            'MTN',
            style: GoogleFonts.plusJakartaSans(
              fontSize: size * 0.28,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF101614),
              letterSpacing: -0.5,
            ),
          ),
        ),
      );
    }

    if (meta.key == 'airtel') {
      return Container(
        width: size,
        height: size,
        color: const Color(0xFFE60000),
        alignment: Alignment.center,
        child: Text(
          'airtel',
          style: GoogleFonts.plusJakartaSans(
            fontSize: size * 0.26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
      );
    }

    if (meta.key == 'glo') {
      return Container(
        width: size,
        height: size,
        color: const Color(0xFF009900),
        alignment: Alignment.center,
        child: Text(
          'glo',
          style: GoogleFonts.plusJakartaSans(
            fontSize: size * 0.32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    // 9mobile fallback
    return Container(
      width: size,
      height: size,
      color: const Color(0xFF00573D),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '9',
            style: GoogleFonts.plusJakartaSans(
              fontSize: size * 0.36,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF78BE20),
            ),
          ),
          Text(
            'm',
            style: GoogleFonts.plusJakartaSans(
              fontSize: size * 0.28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericBadge() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE6EAE7),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.cell_tower_rounded,
        size: 16.0,
        color: Color(0xFF4A5568),
      ),
    );
  }
}
