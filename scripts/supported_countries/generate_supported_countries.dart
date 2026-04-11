import 'dart:io';

import './phones.dart';

void main() async {
  final buffer = StringBuffer();

  buffer.writeln('// GENERATED FILE - DO NOT MODIFY BY HAND');
  buffer.writeln('// ignore_for_file: prefer_const_constructors');
  buffer.writeln('');

  buffer.writeln('import \'package:cellphone_validator/cellphone_validator.dart\';');
  buffer.writeln('');
  buffer.writeln('final supportedCountries = <Country>[');

  for (final country in mapSupportedCountries) {
    buffer.writeln('  Country(');
    buffer.writeln('    countryName: "${country['countryName']}",');
    buffer.writeln('    isoCode: "${country['isoCode']}",');
    buffer.writeln('    dialCode: "${country['dialCode']}",');
    buffer.writeln('    visualText: "${country['visualText']}",');
    buffer.writeln('    pattern: r\'${country['pattern']}\',');
    buffer.writeln('    mask: "${country['mask']}",');
    buffer.writeln('    emoji: "${country['emoji']}",');
    buffer.writeln('    areaCodes: ${country['areaCodes']},'); // intentionally empty
    buffer.writeln('  ),');
  }

  buffer.writeln('];');

  final outputFile = File('lib/src/assets/supported_countries.dart');
  await outputFile.writeAsString(buffer.toString());

  print('✅ supported_countries.dart generated successfully.');
}
