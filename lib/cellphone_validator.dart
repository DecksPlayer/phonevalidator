library cellphone_validator;

import 'package:cellphone_validator/src/cellphone_validator.dart';

export 'src/models/country.dart';
export 'src/controllers/phone_validator.dart';
export 'cellphone_validator.dart';

export 'src/view/phone_auto_detect_view/phone_auto_detect_view.dart';
export 'src/view/phone_input_selector_view/phone_input_selector_view.dart';
export 'src/view/phone_text_view/phone_summary_view.dart';
export 'src/view/phone_country_input/phone_country_input.dart';




final CellphoneValidatorCore CellPhoneValidator = CellphoneValidatorImpl();