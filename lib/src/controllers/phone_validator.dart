import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../../cellphone_validator.dart';

/// A class responsible for validating phone numbers based on a selected country.
class PhoneValidator{

  /// The language code for localization (e.g., 'en', 'es').
  String lang = '';

  /// Constructs a [PhoneValidator] instance.
  ///
  /// Requires the [lang] for localization and optionally takes a [phone] number.
 PhoneValidator({ required this.lang,this.phone= ''});
  Country? _country;

  /// Sets the current country for phone number validation.
  ///
  /// The [country] parameter is a [Country] object containing information
  /// like the country code, pattern for validation, etc.
  void setCountry(Country country){
    _country = country;
  }
  /// Gets the currently set country.
  Country? get country => _country;
  /// Gets the language code used for localization.
  String get getLanguage=> lang;

  /// The phone number string to be validated.
  String phone = '';

  /// Sets the phone number to be validated.
  void setPhone(String phoneNumber){
    phone = phoneNumber;
  }

  /// A [ValueNotifier] that broadcasts whether the current phone number is valid.
  ///
  /// Clients can listen to this notifier to react to changes in phone number validity.
  final ValueNotifier<bool> isValidPhoneNotifier = ValueNotifier<bool>(false);

  /// Checks if the provided [phoneNumber] is valid for the currently set country.
  ///
  /// Updates the [isValidPhoneNotifier] with the result of the validation.
  /// If no country is set, the phone number is considered invalid.
  void checkPhone(String phoneNumber){
    if(_country == null) {
      isValidPhoneNotifier.value = false;
      return;
    }
    isValidPhoneNotifier.value = checkPhonePattern(phoneNumber,_country!);
  }

  void checkPhoneByCountry(String phoneNumber,Country? country){
    if(country == null) {
      isValidPhoneNotifier.value = false;
      return;
    }
    bool check = checkPhonePattern(phoneNumber,country);
    isValidPhoneNotifier.value = check;
  }

  /// Validates [phoneNumber] (national number, formatting ignored) for
  /// [country] and stores the full number in [phone].
  bool checkPhonePattern(String phoneNumber,Country country){
    final national = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    phone = "${country.visualText}$national";
    return isValidNationalNumber(country, national);
  }

  Map<String,dynamic> checkPhonePattern2(String phoneNumber,Country country){
    String pattern = country.pattern;
    RegExp regExp = RegExp(pattern);
    String fullNumber = "${country.visualText}${phoneNumber.replaceAll(RegExp(r'[^0-9]'), '')}";
    phone = fullNumber;
    String aux = fullNumber.substring(country.visualText.length);
    bool containsAreaCode = checkAreaCode(country,aux);
    if(containsAreaCode) {
      log(fullNumber);
      return {'regExp':regExp,'phoneNumber': fullNumber,'containsAreaCode':true};
    }else{
      return {'regExp':regExp,'phoneNumber': aux};
    }
  }


  /// Returns the country of an international number (dial code included,
  /// `+` optional), or `null` if it can't be determined.
  ///
  /// Like libphonenumber: a dial code used by a single country is enough
  /// (`54...` is Argentina). For dial codes shared by several countries
  /// (`+1`, `+7`, `+44`...) the area code decides (`1264...` is Anguilla).
  Country? getCountryByPhone(List<Country> countries,String fullPhoneNumber){
    final normalized = fullPhoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    // Dial codes are prefix-free, so only one dial code can match.
    String? dialCode;
    for (final country in countries) {
      final code = country.dialCode;
      if (code.isNotEmpty &&
          normalized.startsWith(code) &&
          (dialCode == null || code.length > dialCode.length)) {
        dialCode = code;
      }
    }
    if (dialCode == null) return null;

    final group = countries.where((c) => c.dialCode == dialCode).toList();
    if (group.length == 1) return group.first;

    final national = normalized.substring(dialCode.length);
    Country? best;
    var bestLength = -1;
    for (final country in group) {
      for (final code in country.areaCodePrefixes) {
        if (code.length > bestLength && national.startsWith(code)) {
          best = country;
          bestLength = code.length;
        }
      }
    }
    return best;
  }

  static final Map<String, RegExp> _regExpCache = {};

  static RegExp _fullMatch(String pattern) =>
      _regExpCache.putIfAbsent(pattern, () => RegExp('^(?:$pattern)\$'));

  /// Returns `true` when [nationalNumber] (digits only, no dial code) is a
  /// valid fixed-line or mobile number of [country], according to the
  /// official libphonenumber patterns. Countries without those patterns fall
  /// back to [Country.pattern] and [Country.areaCodePrefixes].
  /// Unlike [checkPhonePattern] it has no side effects.
  bool isValidNationalNumber(Country country, String nationalNumber) {
    return getNumberType(country, nationalNumber) != PhoneNumberType.invalid;
  }

  /// Returns whether [nationalNumber] (digits only, no dial code) is a
  /// fixed-line or a mobile number of [country].
  PhoneNumberType getNumberType(Country country, String nationalNumber) {
    if (nationalNumber.isEmpty) return PhoneNumberType.invalid;
    final fixed = country.fixedLinePattern;
    final mobile = country.mobilePattern;
    if (fixed.isEmpty && mobile.isEmpty) {
      final valid = checkAreaCode(country, nationalNumber) &&
          _regExpCache
              .putIfAbsent(country.pattern, () => RegExp(country.pattern))
              .hasMatch('${country.visualText}$nationalNumber');
      return valid ? PhoneNumberType.unknown : PhoneNumberType.invalid;
    }
    final isFixed = fixed.isNotEmpty && _fullMatch(fixed).hasMatch(nationalNumber);
    final isMobile =
        mobile.isNotEmpty && _fullMatch(mobile).hasMatch(nationalNumber);
    if (isFixed && isMobile) return PhoneNumberType.fixedLineOrMobile;
    if (isMobile) return PhoneNumberType.mobile;
    if (isFixed) return PhoneNumberType.fixedLine;
    return PhoneNumberType.invalid;
  }

  /// Detects which countries [input] can belong to, without the user having
  /// to choose a country first.
  ///
  /// [input] may be written:
  /// * with `+` or `00` (`+34 638 326 870`): only the international reading
  ///   is used;
  /// * with the dial code but no `+` (`34638326870`);
  /// * as a national number (`3516458468`, `0351 645 8468`).
  ///
  /// With [nationalOnly] set, [input] is always read as a national number:
  /// a leading dial code is not recognised (`34638326870` is matched by area
  /// code, e.g. Argentina 3463, never as Spain) and `+`/`00` are ignored.
  ///
  /// A national number is often valid in several countries (`351` is an area
  /// code in Argentina and in the United States), so [preferredCountries]
  /// (ISO codes, most preferred first) decides which one wins.
  ///
  /// Results are sorted most likely first: valid before invalid, then numbers
  /// that included the dial code, then by [preferredCountries], then by the
  /// length of the matched area code. Invalid results
  /// appear only when the input starts with `+`/`00`, so a partially typed
  /// international number can show its country early.
  List<PhoneDetectionResult> detectCountries(
    List<Country> countries,
    String input, {
    List<String> preferredCountries = const [],
    bool nationalOnly = false,
  }) {
    final trimmed = input.trim();
    var digits = trimmed.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return const [];

    var forcedInternational = !nationalOnly && trimmed.startsWith('+');
    if (!nationalOnly && !forcedInternational && digits.startsWith('00')) {
      digits = digits.substring(2);
      forcedInternational = true;
    }

    final results = <String, PhoneDetectionResult>{};
    void add(Country country, String national, bool hasDialCode) {
      final valid = isValidNationalNumber(country, national);
      if (!valid && !(hasDialCode && forcedInternational)) return;
      final key = '${country.isoCode}|$national';
      final existing = results[key];
      // Keep the international reading if both produce the same number.
      if (existing != null && (existing.hasDialCode || !hasDialCode)) return;
      results[key] = PhoneDetectionResult(
        country: country,
        nationalNumber: national,
        isValid: valid,
        hasDialCode: hasDialCode,
        areaCode: _longestAreaCode(country, national),
      );
    }

    for (final country in countries) {
      final dialCode = country.dialCode;
      if (!nationalOnly &&
          dialCode.isNotEmpty &&
          digits.length > dialCode.length &&
          digits.startsWith(dialCode)) {
        add(country, digits.substring(dialCode.length), true);
      }
      if (!forcedInternational) {
        add(country, digits, false);
        if (digits.length > 1 && digits.startsWith('0')) {
          add(country, digits.substring(1), false); // trunk prefix
        }
      }
    }

    final preferred =
        preferredCountries.map((iso) => iso.toUpperCase()).toList();
    int rank(Country c) {
      final index = preferred.indexOf(c.isoCode.toUpperCase());
      return index == -1 ? preferred.length : index;
    }

    final sorted = results.values.toList()
      ..sort((a, b) {
        if (a.isValid != b.isValid) return a.isValid ? -1 : 1;
        if (a.hasDialCode != b.hasDialCode) return a.hasDialCode ? -1 : 1;
        final byPreference = rank(a.country).compareTo(rank(b.country));
        if (byPreference != 0) return byPreference;
        // A matched area code is stronger evidence than a loose length check.
        final byAreaCode = (b.areaCode?.length ?? 0)
            .compareTo(a.areaCode?.length ?? 0);
        if (byAreaCode != 0) return byAreaCode;
        final byDialLength =
            b.country.dialCode.length.compareTo(a.country.dialCode.length);
        if (byDialLength != 0) return byDialLength;
        return a.country.countryName.compareTo(b.country.countryName);
      });
    return sorted;
  }

  /// Returns the most likely country for [input], or `null` if none is valid.
  /// See [detectCountries].
  PhoneDetectionResult? detectCountry(
    List<Country> countries,
    String input, {
    List<String> preferredCountries = const [],
    bool nationalOnly = false,
  }) {
    final results = detectCountries(countries, input,
        preferredCountries: preferredCountries, nationalOnly: nationalOnly);
    if (results.isEmpty || !results.first.isValid) return null;
    return results.first;
  }

  String? _longestAreaCode(Country country, String nationalNumber) {
    String? best;
    for (final code in country.areaCodePrefixes) {
      if (nationalNumber.startsWith(code) &&
          (best == null || code.length > best.length)) {
        best = code;
      }
    }
    return best;
  }

  bool checkAreaCode(Country country,String fullNumber){
    bool containsAreaCode = false;
    if(country.areaCodePrefixes.isNotEmpty){
      for (final areaCode in country.areaCodePrefixes) {
        if (fullNumber.startsWith(areaCode)) {
          containsAreaCode = true;
          break;
        }
      }
    }else{
      containsAreaCode = true;
    }
    return containsAreaCode;
  }

}