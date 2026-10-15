import 'package:flutter_test/flutter_test.dart';
import 'package:streetpay/services/address_verification_helper.dart';
import 'package:streetpay/services/ai_address_verification_service.dart';

void main() {
  group('AiAddressVerificationService & Compliance Tests', () {
    test('synthesizeSmartDescription generates full 9PSB-compliant paragraph', () {
      final desc = AiAddressVerificationService.synthesizeSmartDescription(
        busStop: 'Maryland Bus Stop',
        station: 'TotalEnergies Filling Station',
        building: 'First Bank branch',
        houseNo: '14B',
        color: 'Yellow duplex with black gate',
        street: 'Mobolaji Bank Anthony Way',
        city: 'Ikeja',
        state: 'Lagos',
        userNotes: 'Turn right after the bridge and proceed down the lane',
      );

      print('Synthesized Description:\n$desc');

      // Rule 1: Must begin with landmark / bus stop
      expect(desc.startsWith('Starting from Maryland Bus Stop'), isTrue);

      // Rule 2: Must explain navigation and mention the filling station
      expect(desc.contains('TotalEnergies Filling Station'), isTrue);

      // Rule 3: Must identify house number and street
      expect(desc.contains('14B'), isTrue);

      // Rule 4: Must identify nearest building
      expect(desc.contains('First Bank branch'), isTrue);

      // Rule 5: Must describe house color / structure
      expect(desc.contains('Yellow duplex with black gate'), isTrue);

      // Rule 6: Must conclude with physical sighting verification sentence
      expect(
        desc.endsWith('Premises physically sighted and verified as an occupied residential property.'),
        isTrue,
      );
    });

    test('enhanceUserDraft extracts details from rough text and generates compliant narrative', () async {
      const roughDraft =
          'Live near Maryland Bus Stop, after passing Total station, yellow duplex house 14B beside First Bank';

      final enhanced = await AiAddressVerificationService.enhanceUserDraft(
        roughDraft,
        streetName: 'Mobolaji Bank Anthony Way',
        rawAddress: '14B Mobolaji Bank Anthony Way, Ikeja, Lagos',
      );

      print('Enhanced Draft:\n$enhanced');

      expect(enhanced.toLowerCase().contains('maryland bus stop'), isTrue);
      expect(enhanced.contains('14B'), isTrue);
      expect(enhanced.toLowerCase().contains('yellow duplex'), isTrue);
      expect(
        enhanced.contains('Premises physically sighted and verified as an occupied residential property.'),
        isTrue,
      );
    });

    test('AddressVerificationHelper.buildAiVerificationDescription works seamlessly', () async {
      final result = await AddressVerificationHelper.buildAiVerificationDescription(
        busStopOrLandmark: 'Ikeja Under Bridge',
        fillingStation: 'NNPC Mega Station',
        nearestBuilding: 'Computer Village Plaza',
        houseNumber: '5',
        houseColor: 'White two-storey building',
        streetName: 'Awolowo Way',
        city: 'Ikeja',
        state: 'Lagos',
      );

      print('AddressVerificationHelper result:\n$result');

      expect(result.startsWith('Starting from Ikeja Under Bridge'), isTrue);
      expect(result.contains('NNPC Mega Station'), isTrue);
      expect(result.contains('Computer Village Plaza'), isTrue);
      expect(result.contains('5'), isTrue);
      expect(result.toLowerCase().contains('white'), isTrue);
      expect(
        result.endsWith('Premises physically sighted and verified as an occupied residential property.'),
        isTrue,
      );
    });
  });
}
