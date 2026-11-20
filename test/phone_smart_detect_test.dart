import 'package:cellphone_validator/cellphone_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final countries = CellPhoneValidator.countries;

  group('PhoneValidator.detectCountries', () {
    final validator = PhoneValidator(lang: 'es');

    test('national Argentine number (Córdoba) with AR preferred', () {
      final result = validator.detectCountry(countries, '3516458468',
          preferredCountries: ['AR']);
      expect(result, isNotNull);
      expect(result!.country.isoCode, 'AR');
      expect(result.hasDialCode, isFalse);
      expect(result.areaCode, '351');
      expect(result.e164, '+543516458468');
    });

    test('national number is ambiguous without preference', () {
      final isoCodes = validator
          .detectCountries(countries, '3516458468')
          .where((r) => r.isValid)
          .map((r) => r.country.isoCode);
      expect(isoCodes, containsAll(['AR', 'US']));
      // +351 (Portugal) is too short to be valid.
      expect(isoCodes, isNot(contains('PT')));
    });

    test('preference order decides between ambiguous matches', () {
      final result = validator.detectCountry(countries, '3516458468',
          preferredCountries: ['US', 'AR']);
      expect(result!.country.isoCode, 'US');
    });

    test('number with dial code but no plus (Spain)', () {
      final result = validator.detectCountry(countries, '34638326870',
          preferredCountries: ['AR']);
      expect(result!.country.isoCode, 'ES');
      expect(result.hasDialCode, isTrue);
      expect(result.nationalNumber, '638326870');
    });

    test('trunk prefix 0 is removed', () {
      final result = validator.detectCountry(countries, '0351 645-8468',
          preferredCountries: ['AR']);
      expect(result!.e164, '+543516458468');
    });

    test('plus and 00 force the international reading', () {
      expect(validator.detectCountry(countries, '+351 912 345 678')!
          .country.isoCode, 'PT');
      expect(validator.detectCountry(countries, '0034 638 326 870')!
          .country.isoCode, 'ES');
      expect(validator.detectCountry(countries, '+3516458468'), isNull);
    });

    test('partial international input reports an invalid candidate', () {
      final results = validator.detectCountries(countries, '+34 638');
      expect(results.first.country.isoCode, 'ES');
      expect(results.first.isValid, isFalse);
    });

    test('nationalOnly ignores dial codes, + and 00', () {
      // A Spanish number with dial code is never read as Spain.
      final spainAsNational = validator.detectCountries(
          countries, '34638326870',
          preferredCountries: ['AR'], nationalOnly: true);
      expect(spainAsNational.any((r) => r.country.isoCode == 'ES'), isFalse);
      expect(spainAsNational.every((r) => !r.hasDialCode), isTrue);

      // An Argentine national number starting with "34" (Paraná, 343).
      final parana = validator.detectCountry(countries, '3434123456',
          preferredCountries: ['AR'], nationalOnly: true);
      expect(parana!.country.isoCode, 'AR');
      expect(parana.areaCode, '343');

      final results = validator.detectCountries(countries, '+34 638 326 870',
          nationalOnly: true);
      expect(results.every((r) => !r.hasDialCode), isTrue);
    });

    test('empty input', () {
      expect(validator.detectCountries(countries, '  '), isEmpty);
    });
  });

  group('PhoneSmartDetectView', () {
    Future<PhoneValidator> pump(WidgetTester tester,
        {List<String>? preferred,
        List<Country>? countries,
        ValueChanged<PhoneDetectionResult?>? onChanged}) async {
      final validator = PhoneValidator(lang: 'es');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PhoneSmartDetectView(
            phoneValidator: validator,
            preferredCountries: preferred,
            countries: countries,
            onChanged: onChanged,
          ),
        ),
      ));
      return validator;
    }

    testWidgets('detects Argentina from a national number', (tester) async {
      PhoneDetectionResult? last;
      final validator =
          await pump(tester, preferred: ['AR'], onChanged: (r) => last = r);

      await tester.enterText(find.byType(TextField), '3516458468');
      await tester.pumpAndSettle();

      expect(last?.country.isoCode, 'AR');
      expect(validator.country?.isoCode, 'AR');
      expect(validator.isValidPhoneNotifier.value, isTrue);
      expect(validator.phone, '3516458468');
      expect(find.text('351 6458468'), findsOneWidget);
      // Valid in the preferred country: no alternatives offered.
      expect(find.byType(ChoiceChip), findsNothing);
    });

    testWidgets('shows whether the number is valid or not', (tester) async {
      final validator = await pump(tester, preferred: ['AR']);

      // Empty: no status.
      expect(find.textContaining('Número'), findsNothing);

      await tester.enterText(find.byType(TextField), '35164');
      await tester.pumpAndSettle();
      expect(find.text('Número inválido'), findsOneWidget);
      expect(validator.isValidPhoneNotifier.value, isFalse);

      await tester.enterText(find.byType(TextField), '3516458468');
      await tester.pumpAndSettle();
      expect(find.text('Número inválido'), findsNothing);
      expect(find.text('351 6458468'), findsOneWidget);
      expect(validator.isValidPhoneNotifier.value, isTrue);
    });

    testWidgets('status texts can be customised', (tester) async {
      final validator = PhoneValidator(lang: 'es');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PhoneSmartDetectView(
            phoneValidator: validator,
            preferredCountries: const ['AR'],
            invalidText: 'Revisá el número',
          ),
        ),
      ));
      await tester.enterText(find.byType(TextField), '123');
      await tester.pumpAndSettle();
      expect(find.text('Revisá el número'), findsOneWidget);
    });

    testWidgets('only reads national numbers (no dial code)', (tester) async {
      final validator = await pump(tester, preferred: ['AR']);

      // Would be Spain with a dial code; as an Argentine number it's invalid.
      await tester.enterText(find.byType(TextField), '34638326870');
      await tester.pumpAndSettle();
      expect(validator.country?.isoCode, isNot('ES'));
      expect(validator.isValidPhoneNotifier.value, isFalse);
      expect(find.text('Número inválido'), findsOneWidget);

      // '+' is filtered out of the field.
      await tester.enterText(find.byType(TextField), '+543516458468');
      await tester.pumpAndSettle();
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller!.text, '543516458468');
    });

    testWidgets('trunk prefix 0 is accepted', (tester) async {
      final validator = await pump(tester, preferred: ['AR']);

      await tester.enterText(find.byType(TextField), '0351 645-8468');
      await tester.pumpAndSettle();
      expect(validator.country?.isoCode, 'AR');
      expect(validator.phone, '3516458468');
    });

    testWidgets('alternatives appear when no preferred country matches',
        (tester) async {
      final arAndUs = countries
          .where((c) => c.isoCode == 'AR' || c.isoCode == 'US')
          .toList();
      final validator =
          await pump(tester, preferred: const [], countries: arAndUs);

      await tester.enterText(find.byType(TextField), '3516458468');
      await tester.pumpAndSettle();
      expect(validator.country?.isoCode, 'AR');
      expect(find.byType(ChoiceChip), findsNWidgets(2));

      await tester.tap(find.byKey(const ValueKey('phone-smart-US-3516458468')));
      await tester.pumpAndSettle();
      expect(validator.country?.isoCode, 'US');
      expect(validator.phone, '3516458468');

      // The manual choice is kept while the user keeps editing.
      await tester.enterText(find.byType(TextField), '351 645 8468');
      await tester.pumpAndSettle();
      expect(validator.country?.isoCode, 'US');
    });
  });

  group('Country backward compatibility', () {
    test('Country can still be built with int areaCodes', () {
      final country = Country(
        countryName: 'Argentina',
        isoCode: 'AR',
        dialCode: '54',
        visualText: '+54',
        pattern: r'^\+54\d{10,11}$',
        mask: '',
        emoji: '',
        areaCodes: [11, 351],
      );
      final List<int> codes = country.areaCodes;
      expect(codes, [11, 351]);
      expect(country.areaCodePrefixes, ['11', '351']);
      expect(PhoneValidator(lang: 'es').checkAreaCode(country, '3516458468'),
          isTrue);
    });

    test('generated countries expose both lists', () {
      final italy = countries.firstWhere((c) => c.isoCode == 'IT');
      expect(italy.areaCodePrefixes, contains('02'));
      expect(italy.areaCodes, contains(2));
    });

    test('JSON from previous versions (int areaCodes) still loads', () {
      final country = Country.fromJson({
        'isoCode': 'AR',
        'dialCode': '54',
        'areaCodes': [11, 351],
      });
      expect(country.areaCodes, [11, 351]);
      expect(country.areaCodePrefixes, ['11', '351']);
      final roundTrip = Country.fromJson(country.toMap());
      expect(roundTrip.areaCodePrefixes, ['11', '351']);
    });
  });
}
