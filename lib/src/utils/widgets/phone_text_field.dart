import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../cellphone_validator.dart';
import 'check_animation/check_animation.dart';
import '../textFieldUtils.dart';

/// A shared, custom TextField widget that encapsulates the presentation logic,
/// labels, prefixes, and valid/invalid animations for phone inputs.
class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final PhoneValidator phoneValidator;
  final Country? country;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool readOnly;
  final bool showCheckAnimation;

  const PhoneTextField({
    super.key,
    required this.controller,
    required this.phoneValidator,
    this.country,
    this.onChanged,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.showCheckAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasCountry = country != null;
    return TextField(
      enabled: enabled,
      readOnly: readOnly,
      selectionControls: null,
      decoration: hasCountry
          ? InputDecoration(
              suffix: showCheckAnimation
                  ? CheckAnimation(isValidPhoneNotifier: phoneValidator.isValidPhoneNotifier)
                  : null,
              labelText: getPhovalidatorText(country, 'label', phoneValidator.lang),
              prefixText: getPhovalidatorText(country, 'visualText', phoneValidator.lang),
            )
          : InputDecoration(
              hintText: '## ### ###-####',
              suffix: showCheckAnimation
                  ? CheckAnimation(isValidPhoneNotifier: phoneValidator.isValidPhoneNotifier)
                  : null,
            ),
      keyboardType: TextInputType.phone,
      controller: controller,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
    );
  }
}
