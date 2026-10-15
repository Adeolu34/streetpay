import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streetpay/services/biller_logo_service.dart';

void main() {
  group('BillerLogoService Tests', () {
    test('Resolves official Cable TV brands accurately', () {
      final dstv = BillerLogoService.getMetadata('DSTV', category: 'cabletv');
      expect(dstv.slug, equals('dstv'));
      expect(dstv.brandColor, equals(const Color(0xFF0084C7)));
      expect(dstv.initials, equals('DStv'));

      final gotv = BillerLogoService.getMetadata('GOTV', category: 'cabletv');
      expect(gotv.slug, equals('gotv'));
      expect(gotv.brandColor, equals(const Color(0xFF76BC21)));
      expect(gotv.initials, equals('GOtv'));

      final startimes =
          BillerLogoService.getMetadata('STARTIMES', category: 'cabletv');
      expect(startimes.slug, equals('startimes'));
      expect(startimes.brandColor, equals(const Color(0xFFE85A10)));
      expect(startimes.initials, equals('ST'));

      final showmax =
          BillerLogoService.getMetadata('SHOWMAX', category: 'cabletv');
      expect(showmax.slug, equals('showmax'));
      expect(showmax.brandColor, equals(const Color(0xFFEB0045)));
    });

    test('Resolves official Electricity DisCos accurately', () {
      final ekedc =
          BillerLogoService.getMetadata('EKEDC (Eko)', category: 'electricity');
      expect(ekedc.slug, equals('ekedc'));
      expect(ekedc.initials, equals('EKO'));

      final ikedc = BillerLogoService.getMetadata('IKEDC (Ikeja)',
          category: 'electricity');
      expect(ikedc.slug, equals('ikedc'));
      expect(ikedc.initials, equals('IKJ'));

      final aedc = BillerLogoService.getMetadata('AEDC (Abuja)',
          category: 'electricity');
      expect(aedc.slug, equals('aedc'));
      expect(aedc.initials, equals('AEDC'));

      final apld =
          BillerLogoService.getMetadata('Aba Power', category: 'electricity');
      expect(apld.slug, equals('aba-power'));
      expect(apld.initials, equals('APLE'));
    });

    test('Resolves official Betting platforms accurately', () {
      final bet9ja =
          BillerLogoService.getMetadata('Bet9ja', category: 'betting');
      expect(bet9ja.slug, equals('bet9ja'));
      expect(bet9ja.brandColor, equals(const Color(0xFF00733E)));
      expect(bet9ja.initials, equals('9JA'));

      final sporty =
          BillerLogoService.getMetadata('SportyBet', category: 'betting');
      expect(sporty.slug, equals('sportybet'));
      expect(sporty.brandColor, equals(const Color(0xFFE41B13)));
      expect(sporty.initials, equals('SB'));

      final onex = BillerLogoService.getMetadata('1xBet', category: 'betting');
      expect(onex.slug, equals('1xbet'));
      expect(onex.initials, equals('1X'));
    });

    test('Generates graceful fallbacks for unknown billers', () {
      final unknown = BillerLogoService.getMetadata('Solar Power Inc',
          category: 'electricity');
      expect(unknown.displayName, equals('Solar Power Inc'));
      expect(unknown.initials, equals('SP'));
    });
  });
}
