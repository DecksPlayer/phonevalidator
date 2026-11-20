import 'dart:convert';

/// A class representing a country with its associated properties.
class Country{
  /// The name of the country.
  final String countryName;
  /// The ISO code of the country (e.g., "US" for United States).
  final String isoCode;
  /// The international dialing code for the country (e.g., "+1" for United States).
  final String dialCode;
  /// A visual representation of the country, often including the dial code and ISO code.
  final String visualText;
  /// A coarse regular expression (mostly length) for the full number,
  /// e.g. `^\+54\d{10,11}$`. Strict validation uses [fixedLinePattern] and
  /// [mobilePattern] when available.
  final String pattern;
  /// A mask pattern used for formatting phone numbers in this country.
  final String mask;
  /// The emoji flag representing the country.
  final String emoji;
  /// Area codes as integers, kept for backward compatibility.
  ///
  /// An `int` can't keep a leading zero, so codes such as `"02"` (Milan) or
  /// `"0549"` (San Marino) appear here as `2` and `549`. Prefer
  /// [areaCodePrefixes], which is what the validator uses.
  final List<int> areaCodes;
  /// Prefixes of the national number that identify valid numbers: landline
  /// area codes and mobile prefixes (e.g. "351", "9351" and "11" for
  /// Argentina). Strings, so leading zeros are kept (e.g. "02" for Milan).
  ///
  /// When not given, it is built from [areaCodes].
  final List<String> areaCodePrefixes;
  /// Official libphonenumber regex for fixed-line national numbers (without
  /// dial code or trunk prefix). Empty if unknown.
  final String fixedLinePattern;
  /// Official libphonenumber regex for mobile national numbers. Empty if
  /// unknown.
  final String mobilePattern;

  /// Creates a [Country] object.
  ///
  /// Pass [areaCodes] (integers, as in previous versions) or
  /// [areaCodePrefixes] (strings, keeps leading zeros); the other one is
  /// derived from it.
  Country({
    required this.countryName,
    required this.isoCode,
    required this.dialCode,
    required this.visualText,
    required this.pattern,
    required this.mask,
    required this.emoji,
    List<int>? areaCodes,
    List<String>? areaCodePrefixes,
    this.fixedLinePattern = '',
    this.mobilePattern = '',
  })  : areaCodePrefixes = areaCodePrefixes ??
            [for (final code in areaCodes ?? const <int>[]) '$code'],
        areaCodes = areaCodes ??
            {
              for (final code in areaCodePrefixes ?? const <String>[])
                int.parse(code)
            }.toList();

  /// Creates a [Country] object from a JSON map.
  /// Provides default values if certain keys are missing or null in the JSON.
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
        countryName: json['countryName'] as String? ?? 'Unknown',
      isoCode: json['isoCode'] as String? ?? '',
      dialCode: json['dialCode'] as String? ?? '',
      visualText: json['visualText'] as String? ?? '',
      pattern: json['pattern'] as String? ?? r'^\d+$',
      mask: json['mask'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '',
      areaCodes: (json['areaCodes'] as List<dynamic>?)
          ?.map((e) => e is int ? e : int.parse(e.toString()))
          .toList(),
      areaCodePrefixes: (json['areaCodePrefixes'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      fixedLinePattern: json['fixedLinePattern'] as String? ?? '',
      mobilePattern: json['mobilePattern'] as String? ?? '',
    );
  }

  /// Converts the [Country] object to a [Map<String, dynamic>].
  Map<String,dynamic> toMap(){
    return {
      'countryName': countryName,
      'isoCode': isoCode,
      'dialCode': dialCode,
      'visualText': visualText,
      'pattern': pattern,
      'mask': mask,
      'emoji': emoji,
      'areaCodes': areaCodes,
      'areaCodePrefixes': areaCodePrefixes,
      'fixedLinePattern': fixedLinePattern,
      'mobilePattern': mobilePattern,
    };
  }

  /// Converts the [Country] object to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  String toString() => '$countryName ($visualText) $emoji';

  /// Returns a default string representation for display purposes,
  /// typically combining the emoji flag and ISO code.
  String getDefaultView(){
    return '$emoji $isoCode';
  }
}
