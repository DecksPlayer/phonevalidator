import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../cellphone_validator.dart';
import '../../utils/textFieldUtils.dart';
import '../../utils/widgets/check_animation/check_animation.dart';

/// A phone input for national (internal) numbers that detects the country
/// from the area code, with no country selector.
///
/// The user types the number as dialled inside the country, without the
/// international dial code: `3516458468` or `0351 645 8468` (Córdoba,
/// Argentina). A leading dial code is not interpreted, so `34638326870` is
/// read as Argentina area 3463, not as Spain.
///
/// The number is returned in national format too: `PhoneValidator.phone` is
/// set to the national number (`3516458468`) and [onChanged] receives a
/// [PhoneDetectionResult] whose `nationalNumber` holds the same value.
///
/// While the number is invalid it shows "Número inválido" under the field
/// (see [invalidText]); once valid, it shows the formatted number instead.
///
/// The number is validated against [preferredCountries] (by default the
/// device's country): a number is valid only if it's a valid internal number
/// there. If several preferred countries match, or [preferredCountries] is
/// empty and the number fits several countries, the matches appear as chips
/// the user can tap.
@immutable
class PhoneSmartDetectView extends StatefulWidget {
  /// Validator that receives the detected country and validity state.
  final PhoneValidator phoneValidator;

  /// Initial value of the field.
  final String initialPhoneNumber;

  /// ISO codes of the countries the number is validated against, most
  /// preferred first, e.g. `['AR', 'UY']`. When `null`, the device locale's
  /// country is used. Pass an empty list to accept any supported country.
  final List<String>? preferredCountries;

  /// Countries to search. Defaults to every supported country.
  final List<Country>? countries;

  /// Called whenever the detected interpretation changes (or becomes `null`).
  final ValueChanged<PhoneDetectionResult?>? onChanged;

  /// Whether to show alternative countries when the number is ambiguous.
  final bool showAlternatives;

  /// Maximum number of alternative countries shown as chips.
  final int maxAlternatives;

  /// Hint shown while the field is empty.
  final String? hintText;

  /// Text shown under the field when the number is invalid. Defaults to a
  /// translation of "Invalid number" for `phoneValidator.lang`.
  final String? invalidText;

  const PhoneSmartDetectView({
    super.key,
    required this.phoneValidator,
    this.initialPhoneNumber = '',
    this.preferredCountries,
    this.countries,
    this.onChanged,
    this.showAlternatives = true,
    this.maxAlternatives = 4,
    this.hintText,
    this.invalidText,
  });

  @override
  State<PhoneSmartDetectView> createState() => _PhoneSmartDetectViewState();
}

class _PhoneSmartDetectViewState extends State<PhoneSmartDetectView> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialPhoneNumber);

  List<PhoneDetectionResult> _candidates = const [];
  PhoneDetectionResult? _selected;

  /// ISO code the user picked from the alternatives, kept while it remains
  /// a valid match for what they type.
  String? _userChoice;

  List<Country> get _countries =>
      widget.countries ?? CellPhoneValidator.countries;

  List<String> get _preferred {
    if (widget.preferredCountries != null) return widget.preferredCountries!;
    final code =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode;
    return code == null ? const [] : [code];
  }

  @override
  void initState() {
    super.initState();
    _detect(_controller.text, notify: false);
  }

  @override
  void didUpdateWidget(covariant PhoneSmartDetectView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPhoneNumber != oldWidget.initialPhoneNumber) {
      _controller.text = widget.initialPhoneNumber;
      _userChoice = null;
      _detect(_controller.text);
    } else if (widget.preferredCountries != oldWidget.preferredCountries ||
        widget.countries != oldWidget.countries) {
      _detect(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _detect(String text, {bool notify = true}) {
    // Internal numbers: with preferred countries, only those are considered,
    // so a number is valid only if it's valid in one of them.
    final preferred = _preferred.map((iso) => iso.toUpperCase()).toSet();
    final countries = preferred.isEmpty
        ? _countries
        : _countries
            .where((c) => preferred.contains(c.isoCode.toUpperCase()))
            .toList();
    final candidates = widget.phoneValidator.detectCountries(
      countries,
      text,
      preferredCountries: _preferred,
      nationalOnly: true,
    );

    PhoneDetectionResult? selected;
    if (_userChoice != null) {
      for (final c in candidates) {
        if (c.isValid && c.country.isoCode == _userChoice) {
          selected = c;
          break;
        }
      }
    }
    selected ??= candidates.isEmpty ? null : candidates.first;

    _apply(candidates, selected, notify: notify);
  }

  void _apply(List<PhoneDetectionResult> candidates,
      PhoneDetectionResult? selected,
      {bool notify = true}) {
    final validator = widget.phoneValidator;
    if (selected != null) {
      validator.setCountry(selected.country);
      validator.setPhone(selected.nationalNumber);
    }
    validator.isValidPhoneNotifier.value = selected?.isValid ?? false;

    final changed = selected?.e164 != _selected?.e164 ||
        selected?.isValid != _selected?.isValid;
    void update() {
      _candidates = candidates;
      _selected = selected;
    }

    if (notify) {
      setState(update);
    } else {
      update();
    }
    if (changed) widget.onChanged?.call(selected);
  }

  static const Map<String, String> _invalidTexts = {
    'en': 'Invalid number',
    'es': 'Número inválido',
    'pt': 'Número inválido',
    'fr': 'Numéro invalide',
    'it': 'Numero non valido',
    'de': 'Ungültige Nummer',
  };

  String _invalidText(String lang) =>
      _invalidTexts[lang] ?? _invalidTexts['en']!;

  void _choose(PhoneDetectionResult result) {
    _userChoice = result.country.isoCode;
    _apply(_candidates, result);
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.phoneValidator.lang;
    final selected = _selected;
    final hasText = _controller.text.trim().isNotEmpty;
    final isValid = selected != null && selected.isValid;
    final alternatives = _candidates
        .where((c) => c.isValid)
        .take(widget.maxAlternatives)
        .toList();
    // Keep a manually chosen country visible even if it ranks lower.
    if (selected != null &&
        selected.isValid &&
        !alternatives.contains(selected) &&
        alternatives.isNotEmpty) {
      alternatives[alternatives.length - 1] = selected;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-().]')),
          ],
          onChanged: _detect,
          decoration: InputDecoration(
            hintText: widget.hintText ?? '351 645 8468',
            labelText: selected == null
                ? null
                : getPhovalidatorText(selected.country, 'label', lang),
            helperText:
                hasText && isValid ? selected.formattedNationalNumber : null,
            errorText: hasText && !isValid
                ? widget.invalidText ?? _invalidText(lang)
                : null,
            suffixIcon: hasText
                ? CheckAnimation(
                    isValidPhoneNotifier:
                        widget.phoneValidator.isValidPhoneNotifier)
                : null,
          ),
        ),
        if (widget.showAlternatives && alternatives.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final option in alternatives)
                  ChoiceChip(
                    key: ValueKey('phone-smart-${option.country.isoCode}'
                        '-${option.nationalNumber}'),
                    label: Text(
                        '${option.country.emoji} ${getPhovalidatorText(option.country, 'countryName', lang)}'),
                    tooltip: option.formattedNationalNumber,
                    selected: identical(option, selected),
                    onSelected: (_) => _choose(option),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
