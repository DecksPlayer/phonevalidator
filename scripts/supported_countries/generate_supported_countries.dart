import 'dart:convert';
import 'dart:io';

import './phones.dart';

/// Generates lib/src/assets/supported_countries.dart.
///
/// Names, masks, emoji and the coarse `pattern` come from phones.dart.
/// `areaCodes`, `fixedLinePattern` and `mobilePattern` come from
/// libphonenumber_data.json, produced by extract_libphonenumber_data.js from
/// Google's libphonenumber metadata (the `areaCodes` in phones.dart are
/// ignored).
///
/// Run from the repo root:
///   node scripts/supported_countries/extract_libphonenumber_data.js
///   dart run scripts/supported_countries/generate_supported_countries.dart
void main() async {
  final libData = jsonDecode(
    await File('scripts/supported_countries/libphonenumber_data.json')
        .readAsString(),
  ) as Map<String, dynamic>;
  final libCountries = libData['countries'] as Map<String, dynamic>;

  final buffer = StringBuffer();

  buffer.writeln('// GENERATED FILE - DO NOT MODIFY BY HAND');
  buffer.writeln('// Area codes and patterns from ${libData['source']}.');
  buffer.writeln('// ignore_for_file: prefer_const_constructors');
  buffer.writeln('');

  buffer.writeln('import \'package:cellphone_validator/cellphone_validator.dart\';');
  buffer.writeln('');
  buffer.writeln('final supportedCountries = <Country>[');

  final missing = <String>[];
  for (final country in mapSupportedCountries) {
    final iso = country['isoCode'] as String;
    final lib = libCountries[iso] as Map<String, dynamic>?;
    if (lib == null) missing.add(iso);

    final areaCodes = (lib?['areaCodes'] as List<dynamic>? ?? const [])
        .map((code) => '"$code"')
        .join(', ');

    buffer.writeln('  Country(');
    buffer.writeln('    countryName: "${country['countryName']}",');
    buffer.writeln('    isoCode: "$iso",');
    buffer.writeln('    dialCode: "${country['dialCode']}",');
    buffer.writeln('    visualText: "${country['visualText']}",');
    buffer.writeln('    pattern: r\'${country['pattern']}\',');
    buffer.writeln('    mask: "${country['mask']}",');
    buffer.writeln('    emoji: "${country['emoji']}",');
    buffer.writeln('    areaCodePrefixes: [$areaCodes],');
    buffer.writeln('    fixedLinePattern: r\'${lib?['fixedLinePattern'] ?? ''}\',');
    buffer.writeln('    mobilePattern: r\'${lib?['mobilePattern'] ?? ''}\',');
    buffer.writeln('  ),');
  }

  buffer.writeln('];');

  final outputFile = File('lib/src/assets/supported_countries.dart');
  await outputFile.writeAsString(buffer.toString());

  if (missing.isNotEmpty) {
    print('⚠️  Not in libphonenumber data (kept without patterns): $missing');
  }
  print('✅ supported_countries.dart generated successfully.');
}
