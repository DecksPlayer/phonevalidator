import 'country.dart';

/// One possible interpretation of a phone number typed without selecting a
/// country, as returned by `PhoneValidator.detectCountries`.
class PhoneDetectionResult {
  /// The country this interpretation belongs to.
  final Country country;

  /// The national significant number (digits only, without dial code or
  /// trunk prefix `0`).
  final String nationalNumber;

  /// Whether [nationalNumber] passes the area-code and pattern validation of
  /// [country].
  final bool isValid;

  /// `true` when the input already contained the country dial code
  /// (e.g. `34638326870` or `+34 638 326 870`), `false` when it was
  /// interpreted as a national number (e.g. `3516458468`).
  final bool hasDialCode;

  /// The longest area code of [country] that [nationalNumber] starts with,
  /// or `null` when the country has no area-code list or none matched.
  final String? areaCode;

  const PhoneDetectionResult({
    required this.country,
    required this.nationalNumber,
    required this.isValid,
    required this.hasDialCode,
    this.areaCode,
  });

  /// Number in E.164 format, e.g. `+543516458468`.
  String get e164 => '${country.visualText}$nationalNumber';

  /// National number formatted for display. Uses the country mask when the
  /// digit count fits it exactly, otherwise separates the area code.
  String get formattedNationalNumber {
    final slots = '#'.allMatches(country.mask).length;
    if (slots == nationalNumber.length) {
      final buffer = StringBuffer();
      var i = 0;
      for (final char in country.mask.split('')) {
        if (char == '#') {
          buffer.write(nationalNumber[i++]);
        } else {
          buffer.write(char);
        }
      }
      return buffer.toString();
    }
    final code = areaCode;
    if (code != null && code.length < nationalNumber.length) {
      return '$code ${nationalNumber.substring(code.length)}';
    }
    return nationalNumber;
  }

  /// International format for display, e.g. `+54 351 6458468`.
  String get formattedInternational =>
      '${country.visualText} $formattedNationalNumber';

  @override
  String toString() =>
      'PhoneDetectionResult(${country.isoCode}, $e164, valid: $isValid, '
      'hasDialCode: $hasDialCode)';
}
