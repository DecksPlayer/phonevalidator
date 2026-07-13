import 'dart:convert';
import 'dart:io';
import '../scripts/supported_countries/phones.dart';

void main() async {
  final jsonStr = json.encode(mapSupportedCountries);
  final file = File('phones.json');
  await file.writeAsString(jsonStr);
  print('Exported ${mapSupportedCountries.length} countries to phones.json');
}
