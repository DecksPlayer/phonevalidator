import 'package:cellphone_validator/src/utils/RegionalFilters.dart';
import 'package:cellphone_validator/src/utils/widgets/check_animation/check_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../cellphone_validator.dart';
import '../../utils/masked_text_input_formatter.dart';
import '../../utils/textFieldUtils.dart';

/// [PhoneInputSelectorView] is a StatefulWidget that provides a UI for phone number validation.
///
/// It includes a dropdown for country selection and a text field for phone number input.
/// The widget utilizes [PhoneValidator] to handle the validation logic and
/// [CountryManager] to manage country-specific information.
@immutable
class PhoneInputSelectorView extends StatefulWidget {
  final PhoneValidator phoneValidator;
  final Color? dropDownColor;
  final Color? dropdownTextColor;
  final Color? dropdownItemColor;
  PhoneInputSelectorView({
    super.key,
    required this.phoneValidator,
    this.dropDownColor,
    this.dropdownTextColor,
    this.dropdownItemColor,
  });

  @override
  State<PhoneInputSelectorView> createState() => _PhoneInputSelectorView();
}

/// [_PhoneValidatorWidget] is the state class for [PhoneValidatorWidget].
///
/// It manages the state of the widget, including loading status, country list, and input controllers.
class _PhoneInputSelectorView extends State<PhoneInputSelectorView> {
  bool _loading = true;
  TextEditingController _phoneEditingController = TextEditingController();
  List<Country> _countries = CellPhoneValidator.countries;
  bool _regionFilterEnabled = false;
  RegionFilter _selectedRegion = RegionFilter.all;
  Color dropDownColor = Colors.black26;
  Color dropdownTextColor = Colors.white;
  Color dropdownItemColor = Colors.black54;

  List<Country> get _filteredCountries {
    if (!_regionFilterEnabled || _selectedRegion == RegionFilter.all) {
      return _countries;
    }
    final regionCodes = regionIsoMap[_selectedRegion] ?? <String>{};
    return _countries
        .where((country) => regionCodes.contains(country.isoCode))
        .toList();
  }

  String _regionLabel(RegionFilter region) {
    final String lang = widget.phoneValidator.lang.toLowerCase();
    final labels = regionLabelsByLang[lang] ?? regionLabelsByLang['en']!;
    return labels[region] ?? regionLabelsByLang['en']![region]!;
  }

  void _syncCountryWithFilter() {
    final filtered = _filteredCountries;
    if (filtered.isEmpty) {
      return;
    }
    final current = widget.phoneValidator.country;
    final hasCurrent = current != null &&
        filtered.any((country) => country.isoCode == current.isoCode);
    if (!hasCurrent) {
      widget.phoneValidator.setCountry(filtered.first);
      widget.phoneValidator.checkPhone(_phoneEditingController.text);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLanguage();
    if (widget.dropDownColor != null) {
      dropDownColor = widget.dropDownColor!;
    }
    if (widget.dropdownTextColor != null) {
      dropdownTextColor = widget.dropdownTextColor!;
    }
    if (widget.dropdownItemColor != null) {
      dropdownItemColor = widget.dropdownItemColor!;
    }
  }

  /// Loads language-specific country data.
  ///
  /// This method sets the language in [CountryManager], retrieves the list of countries,
  /// and updates the loading state. It also selects the first country by default if available.
  Future<void> loadLanguage() async {
    _loading = false;
    if (widget.phoneValidator.country == null) {
      final filtered = _filteredCountries;
      if (filtered.isNotEmpty) {
        chooseCountry(filtered.first);
      }
    } else {
      _syncCountryWithFilter();
    }
  }

  /// Called when the widget configuration changes.
  ///
  /// If the language in [PhoneValidator] changes, it reloads the language data,
  /// clears the phone input field, and resets the phone validation status.
  /// - [oldWidget]: The old widget configuration.
  @override
  void didUpdateWidget(covariant PhoneInputSelectorView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.phoneValidator.lang != oldWidget.phoneValidator.lang) {
      _loading = true;
      _phoneEditingController.clear();
      widget.phoneValidator.checkPhone('');
      loadLanguage();
      if (widget.dropDownColor != null) {
        dropDownColor = widget.dropDownColor!;
      }
      if (widget.dropdownTextColor != null) {
        dropdownTextColor = widget.dropdownTextColor!;
      }
      if (widget.dropdownItemColor != null) {
        dropdownItemColor = widget.dropdownItemColor!;
      }
    }
  }

  /// Builds the widget tree for the phone validator.
  ///
  /// It displays a loading indicator while data is being fetched, otherwise,
  /// it shows a dropdown for country selection and a text field for phone number input.
  /// - [context]: The build context.
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: CircularProgressIndicator(),
          ));
    }
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    flex: 2,
                    child: SizedBox(height: 50, child: getCountryDropdown())),
                Flexible(
                    flex: 5,
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 15),
                        child: phoneTextField(widget.phoneValidator))),
              ],
            ),
            subtitle: ListTile(
                title: Visibility(
                    visible: _regionFilterEnabled,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(width: 220, child: regionDropdown()),
                      ),
                    )),
                trailing: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: filterToggleButton(),
                ))));
  }

  /// Handles the selection of a country from the dropdown.
  ///
  /// Updates the selected country in [PhoneValidator] and triggers a state update.
  /// - [selected]: The newly selected country.
  Future<void> chooseCountry(Country? selected) async {
    if (selected == null) return;
    setState(() {
      widget.phoneValidator.setCountry(selected);
    });
  }

  /// Retrieves the input formatters for the phone number field.
  ///
  /// Returns a list of [TextInputFormatter] including [MaskedTextInputFormatter] if a country is selected.

  List<TextInputFormatter> getInputFormater() {
    return widget.phoneValidator.country != null
        ? [
            MaskedTextInputFormatter(mask: widget.phoneValidator.country!.mask),
          ]
        : [];
  }

  void insertNumber(String text) {
    widget.phoneValidator.checkPhone(text);
  }

  Widget getCountryDropdown() {
    final filtered = _filteredCountries;
    Country? selectedCountry = widget.phoneValidator.country;
    if (selectedCountry != null &&
        !filtered
            .any((country) => country.isoCode == selectedCountry?.isoCode)) {
      selectedCountry = null;
    }

    return DropdownButton<Country>(
      dropdownColor: dropDownColor,
      style: TextStyle(color: dropdownTextColor),
      isExpanded: true,
      value: selectedCountry,
      onChanged: filtered.isEmpty
          ? null
          : (Country? newValue) async {
              chooseCountry(newValue!);
            },
      items: filtered.map((Country country) {
        return DropdownMenuItem<Country>(
          value: country,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: dropdownItemColor),
              child: Text(country.getDefaultView(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: dropdownTextColor))),
        );
      }).toList(),
    );
  }

  Widget regionDropdown() {
    return DropdownButton<RegionFilter>(
      isExpanded: true,
      value: _selectedRegion,
      onChanged: (RegionFilter? region) {
        if (region == null) return;
        setState(() {
          _selectedRegion = region;
          _syncCountryWithFilter();
        });
      },
      items: RegionFilter.values.map((region) {
        return DropdownMenuItem<RegionFilter>(
          value: region,
          child: Text(_regionLabel(region), overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }

  Widget filterToggleButton() {
    return IconButton(
      tooltip: _regionFilterEnabled
          ? 'Disable region filter'
          : 'Enable region filter',
      icon: Icon(
        Icons.public,
        color: _regionFilterEnabled
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        setState(() {
          _regionFilterEnabled = !_regionFilterEnabled;
          if (!_regionFilterEnabled) {
            _selectedRegion = RegionFilter.all;
          }
          _syncCountryWithFilter();
        });
      },
    );
  }

  TextField phoneTextField(PhoneValidator phoneValidator) {
    return TextField(
      decoration: InputDecoration(
        hintText: getPhovalidatorText(
            phoneValidator.country, 'mask', phoneValidator.lang),
        labelText: getPhovalidatorText(
            phoneValidator.country, 'countryName', phoneValidator.lang),
        prefix: Text(getPhovalidatorText(
            phoneValidator.country, 'visualText', phoneValidator.lang)),
        suffix: CheckAnimation(
            isValidPhoneNotifier: phoneValidator.isValidPhoneNotifier),
      ),
      keyboardType: TextInputType.phone,
      controller: _phoneEditingController,
      inputFormatters: getInputFormater(),
      onChanged: insertNumber,
    );
  }
}
