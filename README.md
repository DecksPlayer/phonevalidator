# Cellphone Validator
A powerful and easy-to-use Flutter package for validating and formatting international phone numbers. Includes a customizable country code picker and provides detailed information for hundreds of countries.
![Screenshot 1](https://raw.githubusercontent.com/DecksPlayer/phonevalidator/main/assets/0.png)
![Screenshot 2](https://raw.githubusercontent.com/DecksPlayer/phonevalidator/main/assets/3.png)
![Screenshot 3](https://raw.githubusercontent.com/DecksPlayer/phonevalidator/main/assets/2.png)
<br />

## Features

*   **Real-time Validation**: Instantly check if a phone number is valid as the user types.
*   **Automatic Formatting**: Applies the correct formatting mask to the phone number automatically.
*   **Integrated Country Picker**: A clean UI widget that combines a country code dropdown with the phone number input field.
*   **Reactive Controller**: Built with a `ValueNotifier`-based controller to easily listen for changes to the phone number's validity and value.
*   **Rich Country Data**: Includes country names (with translations), ISO codes, dial codes, and flag emojis.

## Getting Started

To start using the package, add the `cellphone_validator` dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cellphone_validator: ^<latest-version> # Replace with the latest version
```

Then, run `flutter pub get` in your terminal to install the package.

## Features 

## 🌐 Supported Languages
ar, de, en, es, fr, hi, id, it, ja, ko, pt, ru, ur — and more coming soon.

## 🧩 Widgets


| Widget |Description |
|--------|------------|
| PhoneSummaryView |     A read-only widget that displays a fully formatted phone number, including the country code. Useful for showing validated numbers in a summary or review screen.       | 
| PhoneInputSelectorView |   An interactive widget that allows users to select a country from a dropdown and enter a phone number. Includes input formatting and real-time validation based on the selected country's phone rules.      | 
| PhoneAutoDetectView | An intelligent phone input widget that automatically detects the country based on the dial code entered. It formats the number accordingly and provides real-time validation feedback.|

###  Export List
<details>
<summary>cellphone_validator</summary>

*  path :`package:cellphone_validator/cellphone_validator.dart`  
* **Description:** Main package entry point. Re-exports all core classes, models, and widgets for easy access.
</details>

<details>
<summary>country_manager</summary>

* path :`package:cellphone_validator/src/controllers/country_manager.dart` 
* **Description:** Provides logic for managing and retrieving supported countries.   
</details>

<details>
<summary>country</summary>

* path :`package:cellphone_validator/src/controllers/country_manager.dart`
* **Description:**  Defines the `Country` model, which includes dial codes, masks, and display data.  
</details>

<details>
<summary>phone_validator</summary>

* path :`package:cellphone_validator/src/controllers/phone_validator.dart`
* **Description:**  Core validator logic that checks if phone numbers are valid according to country-specific rules.  
</details>

<details>
<summary>phone_auto_detect_view</summary>

* path :`package:cellphone_validator/src/view/phone_auto_detect_view/phone_auto_detect_view.dart`    
* **Description:**  Widget that auto-detects the country from the phone number and validates it.  
</details>
<details>
<summary>phone_input_selector_view</summary>

* path :`package:cellphone_validator/src/view/phone_input_selector_view/phone_input_selector_view.dart`    
* **Description:**  Widget that allows manual country selection and phone input with validation.  
</details>

<details>
<summary>phone_summary_view</summary>

* path :`package:cellphone_validator/src/view/phone_text_view/phone_summary_view.dart`    
* **Description:**  Widget that displays a phone number with formatting.  
</details>

## How to Use

### 1. Initialize

- import the main package:
  - ```dart
    import 'package:cellphone_validator/cellphone_validator.dart';
    ```
    
### 2. Set Up Your App Widget
   Create your main app widget as usual:
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

```

### 3. Create a PhoneValidator Controller in Your Stateful Widget

Create a PhoneValidator to manage phone validation and state.
```dart
 PhoneValidator phoneValidator = PhoneValidator(lang: 'en');
```
### 4. Build the UI Using Provided Widgets

   Use the package’s widgets like PhoneInputSelectorView, PhoneSummaryView, and PhoneAutoDetectView to build your UI. For example:

```dart
/**
 *  How to use PhoneInputSelectorView
 * **/
PhoneInputSelectorView(phoneValidator: phoneValidator),
```

```dart
/**
 *  How to use PhoneSummaryView
 * **/
PhoneSummaryView(phoneValidator: phoneValidator, fullPhoneNumber: phoneValidator.phone.replaceAll('+', ''),)
```

```dart
/**
 *  How to use PhoneAutoDetectView
 * **/
 
PhoneAutoDetectView(phoneValidator: phoneValidator.value, fullPhoneNumber: ''),
```

* How to check if some value is true or false

```dart 

    ListenableBuilder(
      listenable: phoneValidator.isValidPhoneNotifier,
      builder: (context, _) {
      return phoneValidator.isValidPhoneNotifier.value
        ? 'trueAction'
          :'false action' 
      },
    ),
```

You can listen to the `isValidPhoneNotifier` within the controller to react to changes in the phone number's validity in real-time.


### Summary
- No need to load countries manually: The package handles it internally as a singleton.
- Just initialize once with CellPhoneValidator.init().
- Use the widgets with your PhoneValidator controller.
- Switch languages on the fly using your language dropdown.


<details>
<summary>Testing Numbers</summary>

| Country Code | Phone Number | Expected Validation | Country   |
|--------------|--------------|---------------------|-----------|
| +54          | 1123456789   | Valid               | Argentina |
| +1           | 2025550191   | Valid               | USA       |
| +1           | 4165550123   | Valid               | Canada    |
| +44          | 2079460958   | Valid               | UK        |
| +49          | 30123456     | Valid               | Germany   |
| +33          | 612345678   | Valid               |  France    |
| +34          | 612345678   | Valid               | Spain     |
| +55          | 11912345678  | Valid               | Brasil    |
| +52          | 5512345678   | Valid               | Mexico    |
| +91          | 9123456789   | Valid               | India     |
| +61          | 412345678    | Valid               | Australia |
| +81          | 7012345678   | Valid               | Japan     |
| +82          | 1012345678   | Valid               | South Korea |
| +7           | 9123456789   | Valid               | Russia    |
| +27          | 821234567    | Valid               | South Africa |
| +39          | 3123456789   | Valid               | Italy     |
| +86          | 13812345678  | Valid               | China     |
| +92          | 3001234567   | Valid               | Pakistan  |
| +234         | 8031234567   | Valid               | Nigeria   |
| +880         | 1712345678   | Valid               | Bangladesh |
| +20          | 1001234567   | Valid               | Egypt     |
| +62          | 81234567890  | Valid               | Indonesia |
| +63          | 9171234567   | Valid               | Philippines |
| +66          | 812345678    | Valid               | Thailand  |
| +966         | 501234567    | Valid               | Saudi Arabia |
| +98          | 9123456789   | Valid               | Iran      |
| +60          | 123456789    | Valid               | Malaysia  |
| +31          | 612345678    | Valid               | Netherlands |
| +48          | 500123456    | Valid               | Poland    |
| +40          | 712345678    | Valid               | Romania   |
| +380         | 501234567    | Valid               | Ukraine   |
| +56          | 912345678    | Valid               | Chile     |
| +57          | 3001234567   | Valid               | Colombia  |
| +51          | 912345678    | Valid               | Peru      |
| +58          | 4121234567   | Valid               | Venezuela |
| +213         | 512345678    | Valid               | Algeria   |
| +244         | 912345678    | Valid               | Angola    |
| +229         | 61234567     | Valid               | Benin     |
| +267         | 71234567     | Valid               | Botswana  |
| +226         | 61234567     | Valid               | Burkina Faso |
| +257         | 61234567     | Valid               | Burundi   |
| +237         | 61234567     | Valid               | Cameroon  |
| +238         | 61234567     | Valid               | Cape Verde |
| +242         | 2221234567   | Valid               | Congo     |
| +243         | 81234567     | Valid               | Congo - Kinshasa |
| +253         | 61234567     | Valid               | Djibouti  |
| +236         | 61234567     | Valid               | Central African Republic |
| +240         | 91234567     | Valid               | Equatorial Guinea |
| +291         | 61234567     | Valid               | Eritrea   |
| +251         | 91234567     | Valid               | Ethiopia  |
| +220         | 91234567     | Valid               | Gambia    |
| +233         | 201234567    | Valid               | Ghana     |
| +241         | 61234567     | Valid               | Gabon     |
| +224         | 61234567     | Valid               | Guinea    |
| +245         | 61234567     | Valid               | Guinea-Bissau |
| +254         | 71234567     | Valid               | Kenya     |
| +269         | 61234567     | Valid               | Comoros   |
| +225         | 61234567     | Valid               | Chad      |
| +266         | 61234567     | Valid               | Lesotho   |
| +231         | 61234567     | Valid               | Liberia   |
| +218         | 61234567     | Valid               | Libya     |
| +232         | 61234567     | Valid               | Malawi    |
| +261         | 61234567     | Valid               | Madagascar |
| +265         | 61234567     | Valid               | Maldives  |
| +223         | 61234567     | Valid               | Mali      |



</details>



## Additional Information

*   **Found a Bug or Have a Feature Request?** Please file an issue on our [GitHub repository](https://github.com/DecksPlayer/phonevalidator/issues).
*   **Want to Contribute?** We welcome pull requests! Feel free to fork the repository and submit your changes.
*   **License**: This package is licensed under the Apache 2.0 License. See the `LICENSE` file for more details.

## Help this project
If you find this package helpful and want to support its development, consider making a donation. Thank you for your support!

[![Support via PayPal](https://www.paypalobjects.com/webstatic/en_US/i/buttons/PP_logo_h_150x38.png)](https://www.paypal.com/paypalme/gonojuarez)

### Badges

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/DecksPlayer/phonevalidator)
