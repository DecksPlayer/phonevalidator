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
    return
      MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:MyHomePage(title: 'Flutter Demo Home Page')
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
  ValueNotifier<PhoneValidator> phoneValidator = ValueNotifier(PhoneValidator(lang: 'en'));
  String selectedLanguage = 'en'; // Default language
  final List<String> languages = ['ar','hi','id','it','ja','pt','en', 'es', 'fr','ko','de','ru', 'ur']; // Add more languages as needed
  List<Country> countries = [];

  PhoneValidator phoneValidatorEn = PhoneValidator(lang: 'ur');
  PhoneValidator phoneValidatorEs = PhoneValidator(lang: 'es');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: phoneValidator, builder: (context,_)=>
        Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          languageDropdown()
        ],
      ),
      body: Center(
        child: Column(
          children: [
            FractionallySizedBox(
                widthFactor: 1,
                child: PhoneInputSelectorView(phoneValidator: phoneValidator.value!)),
            ListenableBuilder(
                listenable: phoneValidator!.value.isValidPhoneNotifier,
                builder: (context, _) {
                  return phoneValidator!.value.isValidPhoneNotifier.value
                      ? PhoneSummaryView(
                          phoneValidator: phoneValidator.value!,
                          fullPhoneNumber: phoneValidator.value!.phone.replaceAll('+', ''),)
                      : Text('Invalid phone');
                }),
            PhoneSummaryView(
              phoneValidator: phoneValidatorEs,
              fullPhoneNumber: '34612345678',),
            PhoneAutoDetectView(phoneValidator: phoneValidatorEn, fullPhoneNumber: '',)
          ],

        ),
      ),
    ));
  }

  DropdownButton <String> languageDropdown(){
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




