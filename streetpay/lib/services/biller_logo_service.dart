import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class BillerMetadata {
  final String slug;
  final String displayName;
  final Color brandColor;
  final Color secondaryColor;
  final Color textColor;
  final String initials;
  final String category;
  final String? logoUrl;

  const BillerMetadata({
    required this.slug,
    required this.displayName,
    required this.brandColor,
    required this.secondaryColor,
    required this.textColor,
    required this.initials,
    required this.category,
    this.logoUrl,
  });
}

class BillerLogoService {
  static const Map<String, BillerMetadata> _billerMap = {
    // ==========================================
    // CABLE TV
    // ==========================================
    'dstv': BillerMetadata(
      slug: 'dstv',
      displayName: 'DStv',
      brandColor: Color(0xFF0084C7),
      secondaryColor: Color(0xFF005A8C),
      textColor: Colors.white,
      initials: 'DStv',
      category: 'cabletv',
      logoUrl: 'https://img.freepik.com/free-icon/television_318-868612.jpg',
    ),
    'gotv': BillerMetadata(
      slug: 'gotv',
      displayName: 'GOtv',
      brandColor: Color(0xFF76BC21),
      secondaryColor: Color(0xFF101614),
      textColor: Colors.white,
      initials: 'GOtv',
      category: 'cabletv',
    ),
    'startimes': BillerMetadata(
      slug: 'startimes',
      displayName: 'StarTimes',
      brandColor: Color(0xFFE85A10),
      secondaryColor: Color(0xFF5C2D91),
      textColor: Colors.white,
      initials: 'ST',
      category: 'cabletv',
    ),
    'showmax': BillerMetadata(
      slug: 'showmax',
      displayName: 'Showmax',
      brandColor: Color(0xFFEB0045),
      secondaryColor: Color(0xFF1F1F1F),
      textColor: Colors.white,
      initials: 'MAX',
      category: 'cabletv',
    ),

    // ==========================================
    // ELECTRICITY DISCOS
    // ==========================================
    'ekedc': BillerMetadata(
      slug: 'ekedc',
      displayName: 'Eko Electric (EKEDC)',
      brandColor: Color(0xFFD32F2F),
      secondaryColor: Color(0xFF1976D2),
      textColor: Colors.white,
      initials: 'EKO',
      category: 'electricity',
    ),
    'ikedc': BillerMetadata(
      slug: 'ikedc',
      displayName: 'Ikeja Electric (IKEDC)',
      brandColor: Color(0xFFF57C00),
      secondaryColor: Color(0xFFD32F2F),
      textColor: Colors.white,
      initials: 'IKJ',
      category: 'electricity',
    ),
    'aedc': BillerMetadata(
      slug: 'aedc',
      displayName: 'Abuja Electric (AEDC)',
      brandColor: Color(0xFF1976D2),
      secondaryColor: Color(0xFF388E3C),
      textColor: Colors.white,
      initials: 'AEDC',
      category: 'electricity',
    ),
    'ibedc': BillerMetadata(
      slug: 'ibedc',
      displayName: 'Ibadan Electric (IBEDC)',
      brandColor: Color(0xFF7B1FA2),
      secondaryColor: Color(0xFFF57C00),
      textColor: Colors.white,
      initials: 'IBD',
      category: 'electricity',
    ),
    'eedc': BillerMetadata(
      slug: 'eedc',
      displayName: 'Enugu Electric (EEDC)',
      brandColor: Color(0xFF2E7D32),
      secondaryColor: Color(0xFF1B5E20),
      textColor: Colors.white,
      initials: 'EEDC',
      category: 'electricity',
    ),
    'phedc': BillerMetadata(
      slug: 'phedc',
      displayName: 'Port Harcourt (PHEDC)',
      brandColor: Color(0xFF0097A7),
      secondaryColor: Color(0xFF006064),
      textColor: Colors.white,
      initials: 'PHED',
      category: 'electricity',
    ),
    'kedco': BillerMetadata(
      slug: 'kedco',
      displayName: 'Kano Electric (KEDCO)',
      brandColor: Color(0xFF0288D1),
      secondaryColor: Color(0xFF01579B),
      textColor: Colors.white,
      initials: 'KANO',
      category: 'electricity',
    ),
    'jedc': BillerMetadata(
      slug: 'jedc',
      displayName: 'Jos Electric (JEDC)',
      brandColor: Color(0xFFE65100),
      secondaryColor: Color(0xFFEF6C00),
      textColor: Colors.white,
      initials: 'JOS',
      category: 'electricity',
    ),
    'kaedco': BillerMetadata(
      slug: 'kaedco',
      displayName: 'Kaduna Electric (KAEDCO)',
      brandColor: Color(0xFF388E3C),
      secondaryColor: Color(0xFF1976D2),
      textColor: Colors.white,
      initials: 'KAD',
      category: 'electricity',
    ),
    'bedc': BillerMetadata(
      slug: 'bedc',
      displayName: 'Benin Electric (BEDC)',
      brandColor: Color(0xFFC2185B),
      secondaryColor: Color(0xFF880E4F),
      textColor: Colors.white,
      initials: 'BEDC',
      category: 'electricity',
    ),
    'yedc': BillerMetadata(
      slug: 'yedc',
      displayName: 'Yola Electric (YEDC)',
      brandColor: Color(0xFFF57F17),
      secondaryColor: Color(0xFFE65100),
      textColor: Colors.white,
      initials: 'YOLA',
      category: 'electricity',
    ),
    'aba power': BillerMetadata(
      slug: 'aba-power',
      displayName: 'Aba Power (APLE)',
      brandColor: Color(0xFF2E7D32),
      secondaryColor: Color(0xFF004D40),
      textColor: Colors.white,
      initials: 'APLE',
      category: 'electricity',
    ),

    // ==========================================
    // BETTING PLATFORMS
    // ==========================================
    'bet9ja': BillerMetadata(
      slug: 'bet9ja',
      displayName: 'Bet9ja',
      brandColor: Color(0xFF00733E),
      secondaryColor: Color(0xFF0B2018),
      textColor: Colors.white,
      initials: '9JA',
      category: 'betting',
    ),
    'sportybet': BillerMetadata(
      slug: 'sportybet',
      displayName: 'SportyBet',
      brandColor: Color(0xFFE41B13),
      secondaryColor: Color(0xFF9E0B05),
      textColor: Colors.white,
      initials: 'SB',
      category: 'betting',
    ),
    '1xbet': BillerMetadata(
      slug: '1xbet',
      displayName: '1xBet',
      brandColor: Color(0xFF135688),
      secondaryColor: Color(0xFF002B49),
      textColor: Colors.white,
      initials: '1X',
      category: 'betting',
    ),
    'betway': BillerMetadata(
      slug: 'betway',
      displayName: 'Betway',
      brandColor: Color(0xFF101614),
      secondaryColor: Color(0xFF282828),
      textColor: Colors.white,
      initials: 'BW',
      category: 'betting',
    ),
    'msport': BillerMetadata(
      slug: 'msport',
      displayName: 'MSport',
      brandColor: Color(0xFFFFD200),
      secondaryColor: Color(0xFF101614),
      textColor: Color(0xFF101614),
      initials: 'MS',
      category: 'betting',
    ),
    'bangbet': BillerMetadata(
      slug: 'bangbet',
      displayName: 'BangBet',
      brandColor: Color(0xFFFF4500),
      secondaryColor: Color(0xFFB22222),
      textColor: Colors.white,
      initials: 'BB',
      category: 'betting',
    ),
    'merrybet': BillerMetadata(
      slug: 'merrybet',
      displayName: 'Merrybet',
      brandColor: Color(0xFF1E7E34),
      secondaryColor: Color(0xFFFF8C00),
      textColor: Colors.white,
      initials: 'MB',
      category: 'betting',
    ),
    'nairabet': BillerMetadata(
      slug: 'nairabet',
      displayName: 'NairaBet',
      brandColor: Color(0xFF0E4D92),
      secondaryColor: Color(0xFFFF6600),
      textColor: Colors.white,
      initials: 'NB',
      category: 'betting',
    ),

    // ==========================================
    // INTERNET PROVIDERS
    // ==========================================
    'spectranet': BillerMetadata(
      slug: 'spectranet',
      displayName: 'Spectranet',
      brandColor: Color(0xFF0072CE),
      secondaryColor: Color(0xFF003882),
      textColor: Colors.white,
      initials: 'SPEC',
      category: 'internet',
    ),
    'smile': BillerMetadata(
      slug: 'smile',
      displayName: 'Smile',
      brandColor: Color(0xFFED1C24),
      secondaryColor: Color(0xFF101614),
      textColor: Colors.white,
      initials: 'SMI',
      category: 'internet',
    ),
    'ipnx': BillerMetadata(
      slug: 'ipnx',
      displayName: 'ipNX',
      brandColor: Color(0xFF00529B),
      secondaryColor: Color(0xFFE5002B),
      textColor: Colors.white,
      initials: 'IPNX',
      category: 'internet',
    ),
    'fibronix': BillerMetadata(
      slug: 'fibronix',
      displayName: 'Fibronix',
      brandColor: Color(0xFF43B02A),
      secondaryColor: Color(0xFF00843D),
      textColor: Colors.white,
      initials: 'FIB',
      category: 'internet',
    ),
    'swift': BillerMetadata(
      slug: 'swift',
      displayName: 'Swift 4G',
      brandColor: Color(0xFFE31B23),
      secondaryColor: Color(0xFF005696),
      textColor: Colors.white,
      initials: 'SWF',
      category: 'internet',
    ),
  };

  static final Map<String, BillerMetadata> _cache = {};

  static BillerMetadata getMetadata(String? billerName, {String category = 'bills'}) {
    if (billerName == null || billerName.trim().isEmpty) {
      return _createFallback('Biller', category);
    }

    final clean = billerName.trim().toLowerCase();
    final cacheKey = '$clean::$category';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    // Exact match
    if (_billerMap.containsKey(clean)) {
      final meta = _billerMap[clean]!;
      _cache[cacheKey] = meta;
      return meta;
    }

    for (final entry in _billerMap.entries) {
      if (clean == entry.key ||
          clean.startsWith(entry.key) ||
          clean.contains(entry.key)) {
        _cache[cacheKey] = entry.value;
        return entry.value;
      }
    }

    final fallback = _createFallback(billerName.trim(), category);
    _cache[cacheKey] = fallback;
    return fallback;
  }

  static BillerMetadata _createFallback(String name, String category) {
    Color bg = const Color(0xFF2F8F3C);
    Color sec = const Color(0xFF1E6328);
    if (category.toLowerCase().contains('cable')) {
      bg = const Color(0xFF0084C7);
      sec = const Color(0xFF005A8C);
    } else if (category.toLowerCase().contains('electric')) {
      bg = const Color(0xFFE65100);
      sec = const Color(0xFFBF360C);
    } else if (category.toLowerCase().contains('bet')) {
      bg = const Color(0xFF00733E);
      sec = const Color(0xFF0B2018);
    }

    final clean = name.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '').trim();
    final parts = clean.split(RegExp(r'\s+'));
    String inits = '?';
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      if (parts.length >= 2 && parts[1].isNotEmpty) {
        inits = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        inits = parts[0].substring(0, parts[0].length >= 3 ? 3 : parts[0].length).toUpperCase();
      }
    }

    return BillerMetadata(
      slug: name.toLowerCase().replaceAll(' ', '-'),
      displayName: name,
      brandColor: bg,
      secondaryColor: sec,
      textColor: Colors.white,
      initials: inits,
      category: category,
    );
  }
}

class BillerLogoWidget extends StatelessWidget {
  final String? billerName;
  final String category;
  final double size;
  final double borderRadius;

  const BillerLogoWidget({
    super.key,
    required this.billerName,
    this.category = 'bills',
    this.size = 36.0,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final meta = BillerLogoService.getMetadata(billerName, category: category);

    Widget fallbackBadge() {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [meta.brandColor, meta.secondaryColor],
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: meta.brandColor.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          meta.initials,
          style: GoogleFonts.plusJakartaSans(
            color: meta.textColor,
            fontSize: meta.initials.length > 3
                ? size * 0.28
                : (meta.initials.length > 2 ? size * 0.32 : size * 0.38),
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
      );
    }

    if (meta.logoUrl != null && meta.logoUrl!.isNotEmpty) {
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
            imageUrl: meta.logoUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) => fallbackBadge(),
            errorWidget: (context, url, error) => fallbackBadge(),
          ),
        ),
      );
    }

    return fallbackBadge();
  }
}
