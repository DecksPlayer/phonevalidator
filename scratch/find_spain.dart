import '../scripts/supported_countries/phones.dart';

void main() {
  print("Total countries in phones.dart: ${mapSupportedCountries.length}");
  final spain = mapSupportedCountries.firstWhere(
    (c) => c['isoCode'] == 'ES',
    orElse: () => {},
  );
  print("Spain in phones.dart: $spain");
}
