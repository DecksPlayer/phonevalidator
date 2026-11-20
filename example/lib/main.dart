import 'package:flutter/material.dart';
import 'package:cellphone_validator/cellphone_validator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ValueNotifier<PhoneValidator> phoneValidator = ValueNotifier(
    PhoneValidator(lang: 'en'),
  );
  String selectedLanguage = 'en'; // Default language
  final List<String> languages = [
    'ar',
    'hi',
    'id',
    'it',
    'ja',
    'pt',
    'en',
    'es',
    'fr',
    'ko',
    'de',
    'ru',
    'ur',
  ]; // Add more languages as needed
  List<Country> countries = [];

  PhoneValidator phoneValidatorEn = PhoneValidator(lang: 'en');
  PhoneValidator phoneValidatorEs = PhoneValidator(lang: 'es');
  PhoneValidator phoneValidatorUr = PhoneValidator(lang: 'ur');

  // Each PhoneSmartDetectView gets its own validator so validity states
  // don't interfere with the other widgets.
  PhoneValidator smartValidator = PhoneValidator(lang: 'es');
  PhoneValidator smartValidatorInitial = PhoneValidator(lang: 'es');
  PhoneDetectionResult? detected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: phoneValidator,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [languageDropdown()],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: PhoneInputSelectorView(
                  phoneValidator: phoneValidator.value!,
                ),
              ),
              ListenableBuilder(
                listenable: phoneValidator!.value.isValidPhoneNotifier,
                builder: (context, _) {
                  return phoneValidator!.value.isValidPhoneNotifier.value
                      ? PhoneSummaryView(
                          phoneValidator: phoneValidator.value!,
                          fullPhoneNumber: phoneValidator.value!.phone
                              .replaceAll('+', ''),
                        )
                      : Text('Invalid phone');
                },
              ),
              PhoneSummaryView(
                phoneValidator: phoneValidatorEs,
                fullPhoneNumber: '34612345678',
              ),
              PhoneAutoDetectView(
                phoneValidator: phoneValidatorEn,
                fullPhoneNumber: '',
              ),
              PhoneAutoDetectView(
                phoneValidator: phoneValidatorEn,
                fullPhoneNumber: '+34612345678',
              ),
              const Divider(),
              const Text('PhoneSmartDetectView (no country needed):'),
              const Text(
                'Type a national number: 3516458468, 0351 645 8468, 1155554444',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: PhoneSmartDetectView(
                  phoneValidator: smartValidator,
                  preferredCountries: const ['AR'],
                  onChanged: (result) => setState(() => detected = result),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  detected == null
                      ? 'No country detected yet'
                      : '${detected!.country.emoji} ${detected!.country.countryName}'
                          ' · ${detected!.nationalNumber}'
                          '${detected!.areaCode != null ? ' · area ${detected!.areaCode}' : ''}'
                          ' · ${detected!.isValid ? 'valid' : 'incomplete'}',
                ),
              ),
              const Text('PhoneSmartDetectView with initial value (3516458468):'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: PhoneSmartDetectView(
                  phoneValidator: smartValidatorInitial,
                  initialPhoneNumber: '3516458468',
                  preferredCountries: const ['AR'],
                ),
              ),
              const Divider(),
              const Text('PhoneCountryInput (Pre-fixed to Argentina):'),
              PhoneCountryInput(
                phoneValidator: phoneValidatorEs,
                countryIsoCode: 'AR',
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton<String> languageDropdown() {
    return DropdownButton<String>(
      value: phoneValidator.value.lang,
      icon: const Icon(Icons.language),
      onChanged: (String? newValue) {
        phoneValidator.value = PhoneValidator(lang: newValue!);
      },
      items: languages.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value.toUpperCase()),
        );
      }).toList(),
    );
  }
}
