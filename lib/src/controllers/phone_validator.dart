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

  bool checkPhonePattern(String phoneNumber,Country country){
    String pattern = country.pattern;
    RegExp regExp = RegExp(pattern);
    String fullNumber = "${country.visualText}${phoneNumber.replaceAll(RegExp(r'[^0-9]'), '')}";
    phone = fullNumber;
    String aux = fullNumber.substring(country.visualText.length);
    bool containsAreaCode = checkAreaCode(country,aux);
    if(containsAreaCode) {
      return  regExp.hasMatch(fullNumber);
    }else{
      return false;
    }
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


  Country? getCountryByPhone(List<Country> countries,String fullPhoneNumber){
    String normalized = fullPhoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    countries.sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));
    for (final country in countries) {
      if (normalized.startsWith(country.dialCode)) {
        bool containsAreaCode = false;
        String aux = normalized.substring(country.dialCode.length);
        containsAreaCode = checkAreaCode(country,aux);
        if(containsAreaCode) {
          return country;
        }
      }
    }
    return null;
  }

  bool checkAreaCode(Country country,String fullNumber){
    bool containsAreaCode = false;
    if(country.areaCodes.isNotEmpty){
      for (final areaCode in country.areaCodes) {
        if (fullNumber.startsWith(areaCode.toString())) {
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