import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../cellphone_validator.dart';
import '../../utils/masked_text_input_formatter.dart';
import '../../utils/widgets/phone_text_field.dart';

/// A StatefulWidget that provides a UI for phone number input and validation.
///
/// It includes a text field for phone number input. As the user types,
/// it automatically detects the country based on the dial code prefix.
/// The widget utilizes [PhoneValidator] to handle the validation logic.
@immutable
class PhoneAutoDetectView extends StatefulWidget {
  /// The [PhoneValidator] instance used for validating phone numbers.
  final PhoneValidator phoneValidator;

  /// The initial full phone number to be displayed and validated.
  /// This can include the country code.
  final String fullPhoneNumber;

  /// Creates a [PhoneAutoDetectView] widget.
  ///
  /// Requires a [phoneValidator] for validation logic and a [fullPhoneNumber] as the initial value.
  const PhoneAutoDetectView(
      {super.key, required this.phoneValidator, required this.fullPhoneNumber});

  @override
  State<PhoneAutoDetectView> createState() => _PhoneAutoDetectView();
}

class _PhoneAutoDetectView extends State<PhoneAutoDetectView> {
  final TextEditingController _phoneEditingController = TextEditingController();
  final List<Country> countries = CellPhoneValidator.countries;

  final ValueNotifier<Country?> _country = ValueNotifier<Country?>(null);

  @override
  void initState() {
    super.initState();
    _initializePhoneNumber();
  }

  void _initializePhoneNumber() {
    if (widget.fullPhoneNumber.isNotEmpty) {
      _country.value = widget.phoneValidator
          .getCountryByPhone(countries, widget.fullPhoneNumber);
      if (_country.value != null) {
        final normalized = widget.fullPhoneNumber.replaceAll(RegExp(r'[^\d]'), '');
        final phoneWithoutDialCode = normalized.substring(_country.value!.dialCode.length);
        
        final formatter = MaskedTextInputFormatter(mask: _country.value!.mask);
        final formattedText = formatter.formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: phoneWithoutDialCode),
        ).text;

        _phoneEditingController.text = formattedText;
        widget.phoneValidator
            .checkPhoneByCountry(_phoneEditingController.text, _country.value);
      }
    } else {
      _country.value = null;
      _phoneEditingController.clear();
    }
  }

  @override
  void didUpdateWidget(covariant PhoneAutoDetectView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fullPhoneNumber != oldWidget.fullPhoneNumber) {
      _initializePhoneNumber();
    }
  }

  @override
  void dispose() {
    _phoneEditingController.dispose();
    _country.dispose();
    super.dispose();
  }

  /// Retrieves the input formatters for the phone number field.
  ///
  /// Returns a list of [TextInputFormatter] including [MaskedTextInputFormatter] if a country is selected.
  List<TextInputFormatter> getInputFormater(Country? country) {
    return country != null
        ? [
            MaskedTextInputFormatter(mask: country.mask),
          ]
        : [];
  }

  void insertNumber(String text) {
    if (_country.value == null || text.isEmpty) {
      _country.value = widget.phoneValidator.getCountryByPhone(countries, text);
      if (_country.value != null) {
        final cleanText = _phoneEditingController.value.text.replaceAll(RegExp(r'[^\d]'), '');
        String aux = cleanText;
        if (cleanText.startsWith(_country.value!.dialCode)) {
          aux = cleanText.substring(_country.value!.dialCode.length);
        }
        
        final formatter = MaskedTextInputFormatter(mask: _country.value!.mask);
        final formattedText = formatter.formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: aux),
        ).text;

        _phoneEditingController.text = formattedText;
        _phoneEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: formattedText.length),
        );
      }
    } else {
      widget.phoneValidator
          .checkPhoneByCountry(_phoneEditingController.text, _country.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.phoneValidator.isValidPhoneNotifier,
        builder: (context, isValid, _) {
          Country? country = widget.phoneValidator
              .getCountryByPhone(countries, _phoneEditingController.value.text);
          if (country != null) {
            widget.phoneValidator.setCountry(country);
          }
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: phoneTextField(isValid, country),
          );
        },
      ),
    );
  }

  Widget phoneTextField(bool isValid, Country? country) {
    return ValueListenableBuilder<Country?>(
      valueListenable: _country,
      builder: (context, currentCountry, _) {
        return PhoneTextField(
          controller: _phoneEditingController,
          phoneValidator: widget.phoneValidator,
          country: currentCountry,
          onChanged: insertNumber,
          inputFormatters: getInputFormater(currentCountry),
        );
      },
    );
  }
}
