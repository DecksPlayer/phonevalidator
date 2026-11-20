## Unreleased
- Add `PhoneSmartDetectView`: input for national numbers (`3516458468`, `0351 645 8468`) that detects the country from the area code, with no country selector. Shows "Invalid number" under the field while the number is not valid (customisable with `invalidText`). Numbers are validated against `preferredCountries` (defaults to the device locale); when several countries match, alternatives are shown as chips.
- Add `PhoneValidator.detectCountries` / `detectCountry` (with optional `nationalOnly`) and the `PhoneDetectionResult` model.
- Validation now uses Google libphonenumber's official fixed-line and mobile patterns (new `Country.fixedLinePattern` / `Country.mobilePattern`). Previously mobile numbers were rejected in 89 countries (e.g. France, Germany, UK, Australia) and partially in 56 more; Italian landlines and Dominican Republic, Jamaica and Puerto Rico numbers were also rejected.
- Add `PhoneValidator.getNumberType` and `PhoneNumberType` (fixed line / mobile).
- Area codes regenerated from libphonenumber, including mobile prefixes (`scripts/supported_countries/extract_libphonenumber_data.js`).
- `getCountryByPhone` follows libphonenumber: a dial code used by one country is enough; shared dial codes (+1, +7, +44…) are resolved by area code.
- Add `Country.areaCodePrefixes` (`List<String>`), which keeps leading zeros (e.g. `"02"` for Milan) and is used by the validator. `Country.areaCodes` stays `List<int>` and the `Country` constructor accepts either one, so existing code keeps working.
- Nigerian 8/9-digit landlines are no longer valid (Nigeria moved to 10 digits).

## 2.1.7
- Add customization options `dropDownColor`, `dropdownTextColor`, and `dropdownItemColor` to `PhoneInputSelectorView`.
- Improve flag and dropdown styling options.

## 1.0.0

- Country Selector DropDown Widget
- Real-time phone number validation
- Multilingual support for countries: 
  - ar *arabic*
  - de *German*
  - en *english*
  - es *Spanish*
  - fr *French*
  - hi *Hindi*
  - id *Indonesian*
  - it *Italian*
  - ja *Japanese*
  - ko *Korean*
  - pt *Portuguese*
  - ru *russian*
  - tr *Turkish*
  - zh *Chinese*
- Configurable phone validator

## 1.0.1
- Fix Documentation

## 1.0.2
- Fix Documentation

## 1.0.3
- Fix Documentation
## 1.0.4
- Fix Documentation

## 1.0.5
- add coments
- Fix Documentation

## 1.0.6
- fix documentation

## 1.0.7
- fix documentation
- bugs fixed
- improvements the code

## 1.0.8
- import bugs fixed

## 1.0.9
- fix the documentation
- add an scale animation when widget is valid or not
- add a new method to get the country code from the phone number
- add test cases for phone validator widget
- add test cases for phone validator controller
- add numbers to test cases
- improve the documentation

## 1.0.10
- fix the documentation
- define final widgets
- improve the library

## 1.0.11
- fix the documentation
- add mask in the phone_summary_view
- add test cases for phone_auto_detect_view

## 1.0.12
- fix the documentation
- remove unused variable
- minor bugs fixed

## 2.0.0-dev.1
- add documentation
- remove the init method

## 2.0.0
- fix documentation
- add support for the countries.
- improve the documentation

## 2.0.0-dev.1
- add documentation
- remove the init method

## 2.0.0
- fix documentation
- add support for the countries.

## 2.0.1
- Test all Countries
- Fixed Countries mask

## 2.0.2
- Save Country in PhoneValidator when it is a valid number in PhoneAutoDetectView

## 2.0.3
- Fixed a Production bug

## 2.1.3
- Add Countries
- Fix Minors bugs

## 2.1.4
- add Regions

## 2.1.5
- add Phone_Country_Input widget

## 2.1.6
- Fix initial phone number parsing and formatting in `PhoneCountryInput`
- Handle optional/null initial phone number transitions safely
- Update documentation and instructions

## 2.1.8
- Fix some Countries RegEx patterns

## 2.1.9
- Update Countries Support
- Add autocomplete number in AutodetectImput

## 2.1.10
- Hotfix AutodetectInput bug in edit mode

## 2.1.11
- Minor bug fix in PhoneAutoDetectView

## 2.1.12
- Hotfix in PhoneAutoDetectView

## 2.1.13
- Hotfix South Africa Area Code bug