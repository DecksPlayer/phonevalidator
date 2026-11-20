/// Kind of phone number, as returned by `PhoneValidator.getNumberType`.
enum PhoneNumberType {
  /// Landline number.
  fixedLine,

  /// Mobile (cell) number.
  mobile,

  /// The country uses the same numbering for both (e.g. United States).
  fixedLineOrMobile,

  /// Valid, but the country has no official fixed/mobile patterns to tell.
  unknown,

  /// Not a valid number for the country.
  invalid,
}
