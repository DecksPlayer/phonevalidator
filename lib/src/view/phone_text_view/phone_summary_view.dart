import 'package:cellphone_validator/src/utils/masked_text_editing_controller.dart';
import 'package:flutter/material.dart';

import '../../../cellphone_validator.dart';
import '../../utils/widgets/phone_text_field.dart';

/// A StatefulWidget that provides a UI for phone number validation summary display.
///
/// It displays a read-only structured phone number with a pre-fixed country layout.
@immutable
class PhoneSummaryView extends StatefulWidget {
  final PhoneValidator phoneValidator;
  final String fullPhoneNumber;

  const PhoneSummaryView({super.key, required this.phoneValidator, required this.fullPhoneNumber});

  @override
  State<PhoneSummaryView> createState() => _PhoneSummaryView();
}

class _PhoneSummaryView extends State<PhoneSummaryView> {
  final MaskedTextEditingController _phoneEditingController = MaskedTextEditingController();
  final List<Country> countries = CellPhoneValidator.countries;
  Country? country;

  @override
  void initState() {
    super.initState();
    loadLanguage();
  }

  @override
  void dispose() {
    _phoneEditingController.dispose();
    super.dispose();
  }

  /// Loads language-specific country data.
  ///
  /// This method sets the language in [CountryManager], retrieves the list of countries,
  /// and updates the loading state. It also selects the first country by default if available.
  Future<void> loadLanguage() async {
    country = widget.phoneValidator.getCountryByPhone(countries, widget.fullPhoneNumber.replaceAll('+', ''));
    if (country != null) {
      _phoneEditingController.setMask(country!.mask);
    }
  }

  /// Called when the widget configuration changes.
  ///
  /// If the language in [PhoneValidator] changes, it reloads the language data,
  /// clears the phone input field, and resets the phone validation status.
  /// - [oldWidget]: The old widget configuration.
  @override
  void didUpdateWidget(covariant PhoneSummaryView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.phoneValidator.lang != oldWidget.phoneValidator.lang) {
      _phoneEditingController.clear();
      widget.phoneValidator.checkPhone('');
      loadLanguage();
    }
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
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.phoneValidator.isValidPhoneNotifier,
        builder: (context, isValid, _) {
          if (country != null) {
            String aux = widget.fullPhoneNumber.replaceFirst(country!.dialCode, '');
            _phoneEditingController.text = aux;
          }
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: phoneTextField(country),
          );
        },
      ),
    );
  }

  Widget phoneTextField(Country? country) {
    return PhoneTextField(
      controller: _phoneEditingController,
      phoneValidator: widget.phoneValidator,
      country: country,
      readOnly: true,
      showCheckAnimation: false,
    );
  }
}
