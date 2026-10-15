import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class BankMetadata {
  final String slug;
  final Color brandColor;
  final Color textColor;
  final String initials;
  final String displayName;

  const BankMetadata({
    required this.slug,
    required this.brandColor,
    required this.textColor,
    required this.initials,
    required this.displayName,
  });

  String get logoUrl => 'https://nigerianbanks.xyz/logo/$slug.png';
}

class BankLogoService {
  static const Map<String, BankMetadata> _knownBanks = {
    'streetpay': BankMetadata(
      slug: 'streetpay',
      brandColor: Color(0xFF56B84B),
      textColor: Color(0xFF06210F),
      initials: 'SP',
      displayName: 'StreetPay',
    ),
    'street pay': BankMetadata(
      slug: 'streetpay',
      brandColor: Color(0xFF56B84B),
      textColor: Color(0xFF06210F),
      initials: 'SP',
      displayName: 'StreetPay',
    ),
    '9psb': BankMetadata(
      slug: '9psb',
      brandColor: Color(0xFF0A3B2F),
      textColor: Colors.white,
      initials: '9P',
      displayName: '9PSB',
    ),
    'opay': BankMetadata(
      slug: 'paycom',
      brandColor: Color(0xFF1BB654),
      textColor: Colors.white,
      initials: 'OP',
      displayName: 'OPay',
    ),
    'paycom': BankMetadata(
      slug: 'paycom',
      brandColor: Color(0xFF1BB654),
      textColor: Colors.white,
      initials: 'OP',
      displayName: 'OPay',
    ),
    'paycom(opay)': BankMetadata(
      slug: 'paycom',
      brandColor: Color(0xFF1BB654),
      textColor: Colors.white,
      initials: 'OP',
      displayName: 'OPay',
    ),
    'palmpay': BankMetadata(
      slug: 'palmpay',
      brandColor: Color(0xFF6C24CE),
      textColor: Colors.white,
      initials: 'PP',
      displayName: 'PalmPay',
    ),
    'moniepoint': BankMetadata(
      slug: 'moniepoint-mfb-ng',
      brandColor: Color(0xFF032B69),
      textColor: Colors.white,
      initials: 'MP',
      displayName: 'Moniepoint',
    ),
    'moniepoint mfb': BankMetadata(
      slug: 'moniepoint-mfb-ng',
      brandColor: Color(0xFF032B69),
      textColor: Colors.white,
      initials: 'MP',
      displayName: 'Moniepoint',
    ),
    'kuda': BankMetadata(
      slug: 'kuda-bank',
      brandColor: Color(0xFF40196D),
      textColor: Colors.white,
      initials: 'KU',
      displayName: 'Kuda Bank',
    ),
    'kuda bank': BankMetadata(
      slug: 'kuda-bank',
      brandColor: Color(0xFF40196D),
      textColor: Colors.white,
      initials: 'KU',
      displayName: 'Kuda Bank',
    ),
    'access': BankMetadata(
      slug: 'access-bank',
      brandColor: Color(0xFFF15A24),
      textColor: Colors.white,
      initials: 'AB',
      displayName: 'Access Bank',
    ),
    'access bank': BankMetadata(
      slug: 'access-bank',
      brandColor: Color(0xFFF15A24),
      textColor: Colors.white,
      initials: 'AB',
      displayName: 'Access Bank',
    ),
    'access bank (diamond)': BankMetadata(
      slug: 'access-bank-diamond',
      brandColor: Color(0xFF003882),
      textColor: Colors.white,
      initials: 'DM',
      displayName: 'Diamond Bank',
    ),
    'gtbank': BankMetadata(
      slug: 'guaranty-trust-bank',
      brandColor: Color(0xFFDD4F05),
      textColor: Colors.white,
      initials: 'GT',
      displayName: 'GTBank',
    ),
    'guaranty trust bank': BankMetadata(
      slug: 'guaranty-trust-bank',
      brandColor: Color(0xFFDD4F05),
      textColor: Colors.white,
      initials: 'GT',
      displayName: 'GTBank',
    ),
    'zenith': BankMetadata(
      slug: 'zenith-bank',
      brandColor: Color(0xFFD62828),
      textColor: Colors.white,
      initials: 'ZB',
      displayName: 'Zenith Bank',
    ),
    'zenith bank': BankMetadata(
      slug: 'zenith-bank',
      brandColor: Color(0xFFD62828),
      textColor: Colors.white,
      initials: 'ZB',
      displayName: 'Zenith Bank',
    ),
    'uba': BankMetadata(
      slug: 'united-bank-for-africa',
      brandColor: Color(0xFFD6181F),
      textColor: Colors.white,
      initials: 'UB',
      displayName: 'UBA',
    ),
    'united bank for africa': BankMetadata(
      slug: 'united-bank-for-africa',
      brandColor: Color(0xFFD6181F),
      textColor: Colors.white,
      initials: 'UB',
      displayName: 'UBA',
    ),
    'first bank': BankMetadata(
      slug: 'first-bank-of-nigeria',
      brandColor: Color(0xFF003B65),
      textColor: const Color(0xFFEAA314),
      initials: 'FB',
      displayName: 'First Bank',
    ),
    'first bank of nigeria': BankMetadata(
      slug: 'first-bank-of-nigeria',
      brandColor: Color(0xFF003B65),
      textColor: const Color(0xFFEAA314),
      initials: 'FB',
      displayName: 'First Bank',
    ),
    'fidelity': BankMetadata(
      slug: 'fidelity-bank',
      brandColor: Color(0xFF003C71),
      textColor: Colors.white,
      initials: 'FD',
      displayName: 'Fidelity Bank',
    ),
    'fidelity bank': BankMetadata(
      slug: 'fidelity-bank',
      brandColor: Color(0xFF003C71),
      textColor: Colors.white,
      initials: 'FD',
      displayName: 'Fidelity Bank',
    ),
    'union bank': BankMetadata(
      slug: 'union-bank-of-nigeria',
      brandColor: Color(0xFF0089D0),
      textColor: Colors.white,
      initials: 'UN',
      displayName: 'Union Bank',
    ),
    'union bank of nigeria': BankMetadata(
      slug: 'union-bank-of-nigeria',
      brandColor: Color(0xFF0089D0),
      textColor: Colors.white,
      initials: 'UN',
      displayName: 'Union Bank',
    ),
    'sterling': BankMetadata(
      slug: 'sterling-bank',
      brandColor: Color(0xFF7A1C1D),
      textColor: Colors.white,
      initials: 'SB',
      displayName: 'Sterling Bank',
    ),
    'sterling bank': BankMetadata(
      slug: 'sterling-bank',
      brandColor: Color(0xFF7A1C1D),
      textColor: Colors.white,
      initials: 'SB',
      displayName: 'Sterling Bank',
    ),
    'wema': BankMetadata(
      slug: 'wema-bank',
      brandColor: Color(0xFF8B1953),
      textColor: Colors.white,
      initials: 'WB',
      displayName: 'Wema Bank',
    ),
    'wema bank': BankMetadata(
      slug: 'wema-bank',
      brandColor: Color(0xFF8B1953),
      textColor: Colors.white,
      initials: 'WB',
      displayName: 'Wema Bank',
    ),
    'alat': BankMetadata(
      slug: 'alat-by-wema',
      brandColor: Color(0xFF8B1953),
      textColor: Colors.white,
      initials: 'AL',
      displayName: 'ALAT',
    ),
    'alat by wema': BankMetadata(
      slug: 'alat-by-wema',
      brandColor: Color(0xFF8B1953),
      textColor: Colors.white,
      initials: 'AL',
      displayName: 'ALAT',
    ),
    'fcmb': BankMetadata(
      slug: 'first-city-monument-bank',
      brandColor: Color(0xFF5C1B6E),
      textColor: const Color(0xFFFDB913),
      initials: 'FC',
      displayName: 'FCMB',
    ),
    'first city monument bank': BankMetadata(
      slug: 'first-city-monument-bank',
      brandColor: Color(0xFF5C1B6E),
      textColor: const Color(0xFFFDB913),
      initials: 'FC',
      displayName: 'FCMB',
    ),
    'stanbic ibtc': BankMetadata(
      slug: 'stanbic-ibtc-bank',
      brandColor: Color(0xFF0033A1),
      textColor: Colors.white,
      initials: 'SI',
      displayName: 'Stanbic IBTC',
    ),
    'stanbic ibtc bank': BankMetadata(
      slug: 'stanbic-ibtc-bank',
      brandColor: Color(0xFF0033A1),
      textColor: Colors.white,
      initials: 'SI',
      displayName: 'Stanbic IBTC',
    ),
    'providus': BankMetadata(
      slug: 'providus-bank',
      brandColor: Color(0xFF1B1B1B),
      textColor: const Color(0xFFC59B27),
      initials: 'PB',
      displayName: 'Providus Bank',
    ),
    'providus bank': BankMetadata(
      slug: 'providus-bank',
      brandColor: Color(0xFF1B1B1B),
      textColor: const Color(0xFFC59B27),
      initials: 'PB',
      displayName: 'Providus Bank',
    ),
    'polaris': BankMetadata(
      slug: 'polaris-bank',
      brandColor: Color(0xFF6B1D76),
      textColor: Colors.white,
      initials: 'PL',
      displayName: 'Polaris Bank',
    ),
    'polaris bank': BankMetadata(
      slug: 'polaris-bank',
      brandColor: Color(0xFF6B1D76),
      textColor: Colors.white,
      initials: 'PL',
      displayName: 'Polaris Bank',
    ),
    'keystone': BankMetadata(
      slug: 'keystone-bank',
      brandColor: Color(0xFF004990),
      textColor: Colors.white,
      initials: 'KB',
      displayName: 'Keystone Bank',
    ),
    'keystone bank': BankMetadata(
      slug: 'keystone-bank',
      brandColor: Color(0xFF004990),
      textColor: Colors.white,
      initials: 'KB',
      displayName: 'Keystone Bank',
    ),
    'taj bank': BankMetadata(
      slug: 'taj-bank',
      brandColor: Color(0xFF901A1E),
      textColor: Colors.white,
      initials: 'TB',
      displayName: 'TAJ Bank',
    ),
    'jaiz bank': BankMetadata(
      slug: 'jaiz-bank',
      brandColor: Color(0xFF006838),
      textColor: Colors.white,
      initials: 'JB',
      displayName: 'Jaiz Bank',
    ),
    'paga': BankMetadata(
      slug: 'paga',
      brandColor: Color(0xFFF37023),
      textColor: Colors.white,
      initials: 'PA',
      displayName: 'Paga',
    ),
    'fairmoney': BankMetadata(
      slug: 'fairmoney-microfinance-bank',
      brandColor: Color(0xFF0A7B58),
      textColor: Colors.white,
      initials: 'FM',
      displayName: 'FairMoney',
    ),
    'carbon': BankMetadata(
      slug: 'carbon',
      brandColor: Color(0xFF4A154B),
      textColor: Colors.white,
      initials: 'CB',
      displayName: 'Carbon',
    ),
    'sparkle': BankMetadata(
      slug: 'sparkle-microfinance-bank',
      brandColor: Color(0xFF080808),
      textColor: const Color(0xFFE9F800),
      initials: 'SP',
      displayName: 'Sparkle',
    ),
    'rubies': BankMetadata(
      slug: 'rubies-mfb',
      brandColor: Color(0xFFE02020),
      textColor: Colors.white,
      initials: 'RB',
      displayName: 'Rubies MFB',
    ),
    'vfd': BankMetadata(
      slug: 'vfd',
      brandColor: Color(0xFFC00000),
      textColor: Colors.white,
      initials: 'VF',
      displayName: 'VFD Bank',
    ),
  };

  static final Map<String, BankMetadata> _metadataCache = {};

  static BankMetadata getMetadata(String? bankName) {
    if (bankName == null || bankName.trim().isEmpty) {
      return const BankMetadata(
        slug: 'default',
        brandColor: Color(0xFF10281E),
        textColor: Color(0xFF7FD472),
        initials: 'SP',
        displayName: 'StreetPay',
      );
    }

    final lower = bankName.trim().toLowerCase();
    if (_metadataCache.containsKey(lower)) {
      return _metadataCache[lower]!;
    }

    // Direct exact match
    if (_knownBanks.containsKey(lower)) {
      final meta = _knownBanks[lower]!;
      _metadataCache[lower] = meta;
      return meta;
    }

    // Partial contains match
    for (final entry in _knownBanks.entries) {
      if (lower.contains(entry.key) || entry.key.contains(lower)) {
        _metadataCache[lower] = entry.value;
        return entry.value;
      }
    }

    // Fallback initials generator
    final parts = bankName.trim().split(RegExp(r'\s+'));
    String inits = 'BK';
    if (parts.length >= 2) {
      inits = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      inits = parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }

    // Hash brand color deterministically based on bank name
    final hash = bankName.hashCode.abs();
    final hue = (hash % 360).toDouble();
    final autoColor = HSLColor.fromAHSL(1.0, hue, 0.55, 0.35).toColor();

    final fallbackMeta = BankMetadata(
      slug: lower.replaceAll(RegExp(r'[^a-z0-9]+'), '-'),
      brandColor: autoColor,
      textColor: Colors.white,
      initials: inits,
      displayName: bankName,
    );
    _metadataCache[lower] = fallbackMeta;
    return fallbackMeta;
  }
}

class BankLogoWidget extends StatelessWidget {
  final String? bankName;
  final String? bankCode;
  final double size;
  final double borderRadius;

  const BankLogoWidget({
    super.key,
    this.bankName,
    this.bankCode,
    this.size = 32.0,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final meta = BankLogoService.getMetadata(bankName);

    Widget buildFallback() {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: meta.brandColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        child: Text(
          meta.initials,
          style: GoogleFonts.plusJakartaSans(
            color: meta.textColor,
            fontSize: size * 0.40,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      );
    }

    final cleanName = (bankName ?? '').toLowerCase();
    final isStreetPay = cleanName.contains('streetpay') ||
        cleanName.contains('street pay') ||
        (bankCode != null && bankCode == '120001' && cleanName.contains('street'));

    if (isStreetPay) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(size * 0.10),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF7EE),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: const Color(0xFF56B84B).withValues(alpha: 0.35), width: 1.0),
          ),
          child: Image.asset(
            'assets/images/Streetpay1.png',
            width: size,
            height: size,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => buildFallback(),
          ),
        ),
      );
    }

    final cacheDim = (size * 2).toInt();

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F6F3),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: const Color(0xFFE6EAE7), width: 0.8),
        ),
        child: CachedNetworkImage(
          imageUrl: meta.logoUrl,
          memCacheWidth: cacheDim,
          memCacheHeight: cacheDim,
          fit: BoxFit.cover,
          placeholder: (context, url) => buildFallback(),
          errorWidget: (context, url, error) => buildFallback(),
        ),
      ),
    );
  }
}
