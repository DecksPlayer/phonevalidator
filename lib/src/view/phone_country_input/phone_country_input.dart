import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../cellphone_validator.dart';
import '../../utils/masked_text_input_formatter.dart';
import '../../utils/widgets/phone_text_field.dart';

/// A custom [TextInputFormatter] that strips the country's dial code prefix
/// from the entered text if it starts with the dial code (with or without '+').
class PrefixStrippingFormatter extends TextInputFormatter {
  final Country country;

  PrefixStrippingFormatter(this.country);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String text = newValue.text;
    final String dial = country.dialCode;

    if (text.startsWith('+')) {
      final String digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');
      if (digitsOnly.startsWith(dial)) {
        final String cleanText = digitsOnly.substring(dial.length);
        return TextEditingValue(
          text: cleanText,
          selection: TextSelection.collapsed(offset: cleanText.length),
        );
      }
    } else {
      final String digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');
      // Only strip if they typed/pasted the dial code followed by more digits
      if (digitsOnly.length > dial.length && digitsOnly.startsWith(dial)) {
        final String cleanText = digitsOnly.substring(dial.length);
        return TextEditingValue(
          text: cleanText,
          selection: TextSelection.collapsed(offset: cleanText.length),
        );
      }
    }
    return newValue;
  }
}

/// A StatefulWidget that provides a UI for phone number input and validation with a pre-fixed country.
///
/// Unlike [PhoneAutoDetectView], this widget does not switch the country dynamically as the user types.
/// Instead, the country is pre-fixed either by passing a [Country] object or a [countryIsoCode].
@immutable
class PhoneCountryInput extends StatefulWidget {
  /// The [PhoneValidator] instance used for validating phone numbers.
  final PhoneValidator phoneValidator;

  /// The pre-fixed [Country] for this input.
  final Country? country;

  /// The pre-fixed country ISO code (e.g. 'AR', 'US'). Used to resolve the country from [CellPhoneValidator.countries] if [country] is null.
  final String? countryIsoCode;

  /// Creates a [PhoneCountryInput] widget.
  ///
  /// Either [country] or [countryIsoCode] must be non-null.
  const PhoneCountryInput({
    super.key,
    required this.phoneValidator,
    this.country,
    this.countryIsoCode,
  }) : assert(country != null || countryIsoCode != null, 'Either country or countryIsoCode must be provided');

  @override
  State<PhoneCountryInput> createState() => _PhoneCountryInputState();
}

class _PhoneCountryInputState extends State<PhoneCountryInput> {
  final TextEditingController _phoneEditingController = TextEditingController();
  late Country _resolvedCountry;
  final List<Country> _countries = CellPhoneValidator.countries;

  @override
  void initState() {
    super.initState();
    _resolveAndSetCountry();
  }

  void _resolveAndSetCountry() {
    if (widget.country != null) {
      _resolvedCountry = widget.country!;
    } else if (widget.countryIsoCode != null) {
      final code = widget.countryIsoCode!.trim().toUpperCase();
      final found = _countries.firstWhere(
        (c) => c.isoCode.toUpperCase() == code,
        orElse: () => throw ArgumentError('Country ISO code "$code" not found in supported countries.'),
      );
      _resolvedCountry = found;
    }
    widget.phoneValidator.setCountry(_resolvedCountry);
  }

  @override
  void didUpdateWidget(covariant PhoneCountryInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.phoneValidator != oldWidget.phoneValidator ||
        widget.country != oldWidget.country ||
        widget.countryIsoCode != oldWidget.countryIsoCode) {
      _resolveAndSetCountry();
      _onChanged(_phoneEditingController.text);
    }
  }

  @override
  void dispose() {
    _phoneEditingController.dispose();
    super.dispose();
  }

  List<TextInputFormatter> _getInputFormatter(Country country) {
    return [
      PrefixStrippingFormatter(country),
      MaskedTextInputFormatter(mask: country.mask),
    ];
  }

  void _onChanged(String text) {
    widget.phoneValidator.checkPhoneByCountry(text, _resolvedCountry);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.phoneValidator.isValidPhoneNotifier,
        builder: (context, isValid, _) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: phoneTextField(isValid, _resolvedCountry),
          );
        },
      ),
    );
  }

  Widget phoneTextField(bool isValid, Country country) {
    return PhoneTextField(
      controller: _phoneEditingController,
      phoneValidator: widget.phoneValidator,
      country: country,
      onChanged: _onChanged,
      inputFormatters: _getInputFormatter(country),
    );
  }
}
