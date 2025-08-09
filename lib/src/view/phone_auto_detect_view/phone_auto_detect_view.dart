import 'package:cellphone_validator/src/utils/widgets/check_animation/check_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../cellphone_validator.dart';
import '../../utils/masked_text_input_formatter.dart';
import '../../utils/textFieldUtils.dart';

/// A StatefulWidget that provides a UI for phone number input and validation.
///
/// It includes a dropdown for country selection and a text field for phone number input.
/// The widget utilizes [PhoneValidator] to handle the validation logic and
/// [CountryManager] to manage country-specific information.
@immutable
class PhoneAutoDetectView extends StatefulWidget {
  /// The [PhoneValidator] instance used for validating phone numbers.
  final PhoneValidator phoneValidator;

  /// The initial full phone number to be displayed and validated.
  /// This can include the country code.
  final String fullPhoneNumber;

  /// Creates a [PhoneTextField] widget.
  ///
  /// Requires a [phoneValidator] for validation logic and a [fullPhoneNumber] as the initial value.
  PhoneAutoDetectView({super.key, required this.phoneValidator, required this.fullPhoneNumber});

  @override
  State<PhoneAutoDetectView> createState() => _PhoneAutoDetectView();
}

/// [_PhoneValidatorWidget] is the state class for [PhoneValidatorWidget].
///
/// It manages the state of the widget, including loading status, country list, and input controllers.
class _PhoneAutoDetectView extends State<PhoneAutoDetectView> {
  TextEditingController _phoneEditingController = TextEditingController();
  List<Country> countries = CellPhoneValidator.countries;

  ValueNotifier<Country?> _country = ValueNotifier<Country?>(null);



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  
  /// Builds the widget tree for the phone validator.
  ///
  /// It displays a loading indicator while data is being fetched, otherwise,
  /// it shows a dropdown for country selection and a text field for phone number input.
  /// - [context]: The build context.
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child:
        ValueListenableBuilder<bool>(
            valueListenable: widget.phoneValidator.isValidPhoneNotifier,
            builder: (context, isValid, _) {
              Country? country = widget.phoneValidator.getCountryByPhone(countries,_phoneEditingController.value.text);
              if(country!=null)
                widget.phoneValidator.setCountry(country!);
              return  Padding(
                  padding:
                  const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: phoneTextField(isValid,country));
            })
    );
  }


  /// Retrieves the input formatters for the phone number field.
  ///
  /// Returns a list of [TextInputFormatter] including [MaskedTextInputFormatter] if a country is selected.

  List<TextInputFormatter> getInputFormater(Country? country) {
    return country != null
        ? [
      MaskedTextInputFormatter(mask:country.mask),
    ]
        : [];
  }

 

  void insertNumber(String text){
    if(_country.value==null||text.isEmpty) {
      _country.value = widget.phoneValidator.getCountryByPhone(countries, text);
      if (_country.value != null) {
        String aux = _phoneEditingController.value.text;
        aux = aux.replaceFirst(_country.value!.dialCode, '');
        _phoneEditingController.text = aux;
        _phoneEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: aux.length)
        );
      }
    }else{
      widget.phoneValidator.checkPhoneByCountry(_phoneEditingController.text, _country.value);
    }
  }
  
  Widget phoneTextField(bool isValid,Country? country) {
    return ValueListenableBuilder(valueListenable: _country, builder:(context,country,_){
      return TextField(

        enabled: true,
        selectionControls: null,
        decoration:country!=null?InputDecoration(
          suffix: CheckAnimation(isValidPhoneNotifier: widget.phoneValidator.isValidPhoneNotifier),
          labelText: getPhovalidatorText(country, 'label', widget.phoneValidator.lang),
          prefixText: getPhovalidatorText(country, 'visualText', widget.phoneValidator.lang),
        ):InputDecoration(
            hintText: '## ### ###-####',
          suffix:   CheckAnimation(isValidPhoneNotifier: widget.phoneValidator.isValidPhoneNotifier,)
        ),
        keyboardType: TextInputType.phone,
        controller: _phoneEditingController,
        onChanged: insertNumber,
        inputFormatters: getInputFormater(country),
      );
    });
  }
  
}
