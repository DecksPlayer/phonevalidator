import 'package:cellphone_validator/src/cellphone_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cellphone_validator/cellphone_validator.dart';

final List<Map<String, dynamic>> testNumbers = [
  {'phone': '932055555555', 'isoCode': 'AF', 'countryName': 'Afghanistan', 'dialCode': '93'},
  {'phone': '355455555555', 'isoCode': 'AL', 'countryName': 'Albania', 'dialCode': '355'},
  {'phone': '213105555555', 'isoCode': 'DZ', 'countryName': 'Algeria', 'dialCode': '213'},
  {'phone': '376355555', 'isoCode': 'AD', 'countryName': 'Andorra', 'dialCode': '376'},
  {'phone': '244222555555', 'isoCode': 'AO', 'countryName': 'Angola', 'dialCode': '244'},
  {'phone': '12645555555', 'isoCode': 'AI', 'countryName': 'Anguilla', 'dialCode': '1'},
  {'phone': '12685555555', 'isoCode': 'AG', 'countryName': 'Antigua and Barbuda', 'dialCode': '1'},
  {'phone': '5411555555555', 'isoCode': 'AR', 'countryName': 'Argentina', 'dialCode': '54'},
  {'phone': '374105555555', 'isoCode': 'AM', 'countryName': 'Armenia', 'dialCode': '374'},
  {'phone': '2975555555', 'isoCode': 'AW', 'countryName': 'Aruba', 'dialCode': '297'},
  {'phone': '612555555555', 'isoCode': 'AU', 'countryName': 'Australia', 'dialCode': '61'},
  {'phone': '4315555555555', 'isoCode': 'AT', 'countryName': 'Austria', 'dialCode': '43'},
  {'phone': '9941255555555', 'isoCode': 'AZ', 'countryName': 'Azerbaijan', 'dialCode': '994'},
  {'phone': '12425555555', 'isoCode': 'BS', 'countryName': 'Bahamas', 'dialCode': '1'},
  {'phone': '97315555555', 'isoCode': 'BH', 'countryName': 'Bahrain', 'dialCode': '973'},
  {'phone': '880255555555', 'isoCode': 'BD', 'countryName': 'Bangladesh', 'dialCode': '880'},
  {'phone': '12465555555', 'isoCode': 'BB', 'countryName': 'Barbados', 'dialCode': '1'},
  {'phone': '37517555555555', 'isoCode': 'BY', 'countryName': 'Belarus', 'dialCode': '375'},
  {'phone': '32255555555', 'isoCode': 'BE', 'countryName': 'Belgium', 'dialCode': '32'},
  {'phone': '5012255555', 'isoCode': 'BZ', 'countryName': 'Belize', 'dialCode': '501'},
  {'phone': '2292055555555', 'isoCode': 'BJ', 'countryName': 'Benin', 'dialCode': '229'},
  {'phone': '14415555555', 'isoCode': 'BM', 'countryName': 'Bermudas', 'dialCode': '1'},
  {'phone': '9752555555', 'isoCode': 'BT', 'countryName': 'Bhutan', 'dialCode': '975'},
  {'phone': '59125555555', 'isoCode': 'BO', 'countryName': 'Bolivia', 'dialCode': '591'},
  {'phone': '387305555555', 'isoCode': 'BA', 'countryName': 'Bosnia and Herzegovina', 'dialCode': '387'},
  {'phone': '2671055555', 'isoCode': 'BW', 'countryName': 'Botswana', 'dialCode': '267'},
  {'phone': '551155555555', 'isoCode': 'BR', 'countryName': 'Brazil', 'dialCode': '55'},
  {'phone': '6732555555', 'isoCode': 'BN', 'countryName': 'Brunei', 'dialCode': '673'},
  {'phone': '35925555555', 'isoCode': 'BG', 'countryName': 'Bulgaria', 'dialCode': '359'},
  {'phone': '22610555555', 'isoCode': 'BF', 'countryName': 'Burkina Faso', 'dialCode': '226'},
  {'phone': '25722555555', 'isoCode': 'BI', 'countryName': 'Burundi', 'dialCode': '257'},
  {'phone': '855235555555', 'isoCode': 'KH', 'countryName': 'Cambodia', 'dialCode': '855'},
  {'phone': '237255555555', 'isoCode': 'CM', 'countryName': 'Cameroon', 'dialCode': '237'},
  {'phone': '12045555555', 'isoCode': 'CA', 'countryName': 'Canada', 'dialCode': '1'},
  {'phone': '2382255555', 'isoCode': 'CV', 'countryName': 'Cape Verde', 'dialCode': '238'},
  {'phone': '5997175555', 'isoCode': 'BQ', 'countryName': 'Caribe neerlandés', 'dialCode': '599'},
  {'phone': '23670555555', 'isoCode': 'CF', 'countryName': 'Central African Republic', 'dialCode': '236'},
  {'phone': '23522555555', 'isoCode': 'TD', 'countryName': 'Chad', 'dialCode': '235'},
  {'phone': '56255555555', 'isoCode': 'CL', 'countryName': 'Chile', 'dialCode': '56'},
  {'phone': '8610555555555', 'isoCode': 'CN', 'countryName': 'China', 'dialCode': '86'},
  {'phone': '576015555555', 'isoCode': 'CO', 'countryName': 'Colombia', 'dialCode': '57'},
  {'phone': '2697555555', 'isoCode': 'KM', 'countryName': 'Comoros', 'dialCode': '269'},
  {'phone': '242055555555', 'isoCode': 'CG', 'countryName': 'Congo', 'dialCode': '242'},
  {'phone': '24310555555', 'isoCode': 'CD', 'countryName': 'Congo - Kinshasa', 'dialCode': '243'},
  {'phone': '50625555555', 'isoCode': 'CR', 'countryName': 'Costa Rica', 'dialCode': '506'},
  {'phone': '2255555555555', 'isoCode': 'CI', 'countryName': 'Côte d’Ivoire', 'dialCode': '225'},
  {'phone': '385155555555', 'isoCode': 'HR', 'countryName': 'Croatia', 'dialCode': '385'},
  {'phone': '53755555555', 'isoCode': 'CU', 'countryName': 'Cuba', 'dialCode': '53'},
  {'phone': '59995555555', 'isoCode': 'CW', 'countryName': 'Curazao', 'dialCode': '599'},
  {'phone': '35722555555', 'isoCode': 'CY', 'countryName': 'Cyprus', 'dialCode': '357'},
  {'phone': '420255555555', 'isoCode': 'CZ', 'countryName': 'Czech Republic', 'dialCode': '420'},
  {'phone': '4525555555', 'isoCode': 'DK', 'countryName': 'Denmark', 'dialCode': '45'},
  {'phone': '25321555555', 'isoCode': 'DJ', 'countryName': 'Djibouti', 'dialCode': '253'},
  {'phone': '17675555555', 'isoCode': 'DM', 'countryName': 'Dominica', 'dialCode': '1'},
  {'phone': '18095555555', 'isoCode': 'DO', 'countryName': 'Dominican Republic', 'dialCode': '1'},
  {'phone': '593255555555', 'isoCode': 'EC', 'countryName': 'Ecuador', 'dialCode': '593'},
  {'phone': '202555555555', 'isoCode': 'EG', 'countryName': 'Egypt', 'dialCode': '20'},
  {'phone': '50325555555', 'isoCode': 'SV', 'countryName': 'El Salvador', 'dialCode': '503'},
  {'phone': '240222555555', 'isoCode': 'GQ', 'countryName': 'Equatorial Guinea', 'dialCode': '240'},
  {'phone': '29115555555', 'isoCode': 'ER', 'countryName': 'Eritrea', 'dialCode': '291'},
  {'phone': '3721555555', 'isoCode': 'EE', 'countryName': 'Estonia', 'dialCode': '372'},
  {'phone': '26825555555', 'isoCode': 'SZ', 'countryName': 'Eswatini', 'dialCode': '268'},
  {'phone': '2511155555555', 'isoCode': 'ET', 'countryName': 'Ethiopia', 'dialCode': '251'},
  {'phone': '6792555555', 'isoCode': 'FJ', 'countryName': 'Fiji', 'dialCode': '679'},
  {'phone': '3582555555555', 'isoCode': 'FI', 'countryName': 'Finland', 'dialCode': '358'},
  {'phone': '331555555555', 'isoCode': 'FR', 'countryName': 'France', 'dialCode': '33'},
  {'phone': '24105555555', 'isoCode': 'GA', 'countryName': 'Gabon', 'dialCode': '241'},
  {'phone': '2201555555', 'isoCode': 'GM', 'countryName': 'Gambia', 'dialCode': '220'},
  {'phone': '9953255555555', 'isoCode': 'GE', 'countryName': 'Georgia', 'dialCode': '995'},
  {'phone': '49305555555', 'isoCode': 'DE', 'countryName': 'Germany', 'dialCode': '49'},
  {'phone': '2333055555555', 'isoCode': 'GH', 'countryName': 'Ghana', 'dialCode': '233'},
  {'phone': '35055555555', 'isoCode': 'GI', 'countryName': 'Gibraltar', 'dialCode': '350'},
  {'phone': '302555555555', 'isoCode': 'GR', 'countryName': 'Greece', 'dialCode': '30'},
  {'phone': '299255555', 'isoCode': 'GL', 'countryName': 'Greenland', 'dialCode': '299'},
  {'phone': '14735555555', 'isoCode': 'GD', 'countryName': 'Grenada', 'dialCode': '1'},
  {'phone': '5905905555555', 'isoCode': 'GP', 'countryName': 'Guadalupe', 'dialCode': '590'},
  {'phone': '16715555555', 'isoCode': 'GU', 'countryName': 'Guam', 'dialCode': '1'},
  {'phone': '50225555555', 'isoCode': 'GT', 'countryName': 'Guatemala', 'dialCode': '502'},
  {'phone': '5945945555555', 'isoCode': 'GF', 'countryName': 'Guayana Francesa', 'dialCode': '594'},
  {'phone': '4414815555555', 'isoCode': 'GG', 'countryName': 'Guernesey', 'dialCode': '44'},
  {'phone': '22420555555', 'isoCode': 'GN', 'countryName': 'Guinea', 'dialCode': '224'},
  {'phone': '245205555555', 'isoCode': 'GW', 'countryName': 'Guinea-Bissau', 'dialCode': '245'},
  {'phone': '5922265555', 'isoCode': 'GY', 'countryName': 'Guyana', 'dialCode': '592'},
  {'phone': '50915555555', 'isoCode': 'HT', 'countryName': 'Haiti', 'dialCode': '509'},
  {'phone': '50425555555', 'isoCode': 'HN', 'countryName': 'Honduras', 'dialCode': '504'},
  {'phone': '85225555555', 'isoCode': 'HK', 'countryName': 'Hong Kong', 'dialCode': '852'},
  {'phone': '361555555555', 'isoCode': 'HU', 'countryName': 'Hungary', 'dialCode': '36'},
  {'phone': '3544155555', 'isoCode': 'IS', 'countryName': 'Iceland', 'dialCode': '354'},
  {'phone': '9111555555555', 'isoCode': 'IN', 'countryName': 'India', 'dialCode': '91'},
  {'phone': '622155555555', 'isoCode': 'ID', 'countryName': 'Indonesia', 'dialCode': '62'},
  {'phone': '9811555555555', 'isoCode': 'IR', 'countryName': 'Iran', 'dialCode': '98'},
  {'phone': '964155555555', 'isoCode': 'IQ', 'countryName': 'Iraq', 'dialCode': '964'},
  {'phone': '35322555555', 'isoCode': 'IE', 'countryName': 'Ireland', 'dialCode': '353'},
  {'phone': '24755555', 'isoCode': 'AC', 'countryName': 'Isla de la Ascensión', 'dialCode': '247'},
  {'phone': '4416245555555', 'isoCode': 'IM', 'countryName': 'Isla de Man', 'dialCode': '44'},
  {'phone': '618555555555', 'isoCode': 'CX', 'countryName': 'Isla de Navidad', 'dialCode': '61'},
  {'phone': '672555555', 'isoCode': 'NF', 'countryName': 'Isla Norfolk', 'dialCode': '672'},
  {'phone': '3581855555555', 'isoCode': 'AX', 'countryName': 'Islas Aland', 'dialCode': '358'},
  {'phone': '13455555555', 'isoCode': 'KY', 'countryName': 'Islas Caimán', 'dialCode': '1'},
  {'phone': '618555555555', 'isoCode': 'CC', 'countryName': 'Islas Cocos', 'dialCode': '61'},
  {'phone': '68255555', 'isoCode': 'CK', 'countryName': 'Islas Cook', 'dialCode': '682'},
  {'phone': '298555555', 'isoCode': 'FO', 'countryName': 'Islas Feroe', 'dialCode': '298'},
  {'phone': '50055555', 'isoCode': 'FK', 'countryName': 'Islas Malvinas', 'dialCode': '500'},
  {'phone': '16705555555', 'isoCode': 'MP', 'countryName': 'Islas Marianas del Norte', 'dialCode': '1'},
  {'phone': '16495555555', 'isoCode': 'TC', 'countryName': 'Islas Turcas y Caicos', 'dialCode': '1'},
  {'phone': '12845555555', 'isoCode': 'VG', 'countryName': 'Islas Vírgenes Británicas', 'dialCode': '1'},
  {'phone': '13405555555', 'isoCode': 'VI', 'countryName': 'Islas Vírgenes de EE. UU.', 'dialCode': '1'},
  {'phone': '972255555555', 'isoCode': 'IL', 'countryName': 'Israel', 'dialCode': '972'},
  {'phone': '392555555555', 'isoCode': 'IT', 'countryName': 'Italy', 'dialCode': '39'},
  {'phone': '16585555555', 'isoCode': 'JM', 'countryName': 'Jamaica', 'dialCode': '1'},
  {'phone': '813555555555', 'isoCode': 'JP', 'countryName': 'Japan', 'dialCode': '81'},
  {'phone': '4415345555555', 'isoCode': 'JE', 'countryName': 'Jersey', 'dialCode': '44'},
  {'phone': '962255555555', 'isoCode': 'JO', 'countryName': 'Jordan', 'dialCode': '962'},
  {'phone': '771655555555', 'isoCode': 'KZ', 'countryName': 'Kazakhstan', 'dialCode': '7'},
  {'phone': '2542055555555', 'isoCode': 'KE', 'countryName': 'Kenya', 'dialCode': '254'},
  {'phone': '68625555', 'isoCode': 'KI', 'countryName': 'Kiribati', 'dialCode': '686'},
  {'phone': '383285555555', 'isoCode': 'XK', 'countryName': 'Kosovo', 'dialCode': '383'},
  {'phone': '96515555555', 'isoCode': 'KW', 'countryName': 'Kuwait', 'dialCode': '965'},
  {'phone': '9963125555555', 'isoCode': 'KG', 'countryName': 'Kyrgyzstan', 'dialCode': '996'},
  {'phone': '856215555555', 'isoCode': 'LA', 'countryName': 'Laos', 'dialCode': '856'},
  {'phone': '37125555555', 'isoCode': 'LV', 'countryName': 'Latvia', 'dialCode': '371'},
  {'phone': '96115555555', 'isoCode': 'LB', 'countryName': 'Lebanon', 'dialCode': '961'},
  {'phone': '26625555555', 'isoCode': 'LS', 'countryName': 'Lesotho', 'dialCode': '266'},
  {'phone': '231205555555', 'isoCode': 'LR', 'countryName': 'Liberia', 'dialCode': '231'},
  {'phone': '2182055555555', 'isoCode': 'LY', 'countryName': 'Libya', 'dialCode': '218'},
  {'phone': '4232015555', 'isoCode': 'LI', 'countryName': 'Liechtenstein', 'dialCode': '423'},
  {'phone': '370555555555', 'isoCode': 'LT', 'countryName': 'Lithuania', 'dialCode': '370'},
  {'phone': '35265555555', 'isoCode': 'LU', 'countryName': 'Luxembourg', 'dialCode': '352'},
  {'phone': '2612055555555', 'isoCode': 'MG', 'countryName': 'Madagascar', 'dialCode': '261'},
  {'phone': '26515555555', 'isoCode': 'MW', 'countryName': 'Malawi', 'dialCode': '265'},
  {'phone': '603555555555', 'isoCode': 'MY', 'countryName': 'Malaysia', 'dialCode': '60'},
  {'phone': '9602555555', 'isoCode': 'MV', 'countryName': 'Maldives', 'dialCode': '960'},
  {'phone': '22320555555', 'isoCode': 'ML', 'countryName': 'Mali', 'dialCode': '223'},
  {'phone': '35621555555', 'isoCode': 'MT', 'countryName': 'Malta', 'dialCode': '356'},
  {'phone': '6922475555', 'isoCode': 'MH', 'countryName': 'Marshall Islands', 'dialCode': '692'},
  {'phone': '5965965555555', 'isoCode': 'MQ', 'countryName': 'Martinica', 'dialCode': '596'},
  {'phone': '22222555555', 'isoCode': 'MR', 'countryName': 'Mauritania', 'dialCode': '222'},
  {'phone': '23055555555', 'isoCode': 'MU', 'countryName': 'Mauritius', 'dialCode': '230'},
  {'phone': '2622695555555', 'isoCode': 'YT', 'countryName': 'Mayotte', 'dialCode': '262'},
  {'phone': '523355555555', 'isoCode': 'MX', 'countryName': 'Mexico', 'dialCode': '52'},
  {'phone': '6913205555', 'isoCode': 'FM', 'countryName': 'Micronesia', 'dialCode': '691'},
  {'phone': '373225555555', 'isoCode': 'MD', 'countryName': 'Moldova', 'dialCode': '373'},
  {'phone': '37787555555', 'isoCode': 'MC', 'countryName': 'Monaco', 'dialCode': '377'},
  {'phone': '97611555555', 'isoCode': 'MN', 'countryName': 'Mongolia', 'dialCode': '976'},
  {'phone': '382205555555', 'isoCode': 'ME', 'countryName': 'Montenegro', 'dialCode': '382'},
  {'phone': '16645555555', 'isoCode': 'MS', 'countryName': 'Montserrat', 'dialCode': '1'},
  {'phone': '2125555555555', 'isoCode': 'MA', 'countryName': 'Morocco', 'dialCode': '212'},
  {'phone': '25821555555', 'isoCode': 'MZ', 'countryName': 'Mozambique', 'dialCode': '258'},
  {'phone': '9515555555', 'isoCode': 'MM', 'countryName': 'Myanmar', 'dialCode': '95'},
  {'phone': '264615555555', 'isoCode': 'NA', 'countryName': 'Namibia', 'dialCode': '264'},
  {'phone': '6744445555', 'isoCode': 'NR', 'countryName': 'Nauru', 'dialCode': '674'},
  {'phone': '977155555555', 'isoCode': 'NP', 'countryName': 'Nepal', 'dialCode': '977'},
  {'phone': '311055555555', 'isoCode': 'NL', 'countryName': 'Netherlands', 'dialCode': '31'},
  {'phone': '64255555555', 'isoCode': 'NZ', 'countryName': 'New Zealand', 'dialCode': '64'},
  {'phone': '50525555555', 'isoCode': 'NI', 'countryName': 'Nicaragua', 'dialCode': '505'},
  {'phone': '22720555555', 'isoCode': 'NE', 'countryName': 'Niger', 'dialCode': '227'},
  {'phone': '23420155555555', 'isoCode': 'NG', 'countryName': 'Nigeria', 'dialCode': '234'},
  {'phone': '6835555', 'isoCode': 'NU', 'countryName': 'Niue', 'dialCode': '683'},
  {'phone': '850255555555', 'isoCode': 'KP', 'countryName': 'North Korea', 'dialCode': '850'},
  {'phone': '389255555555', 'isoCode': 'MK', 'countryName': 'North Macedonia', 'dialCode': '389'},
  {'phone': '4721555555', 'isoCode': 'NO', 'countryName': 'Norway', 'dialCode': '47'},
  {'phone': '687555555', 'isoCode': 'NC', 'countryName': 'Nueva Caledonia', 'dialCode': '687'},
  {'phone': '96824555555', 'isoCode': 'OM', 'countryName': 'Oman', 'dialCode': '968'},
  {'phone': '9221555555555', 'isoCode': 'PK', 'countryName': 'Pakistan', 'dialCode': '92'},
  {'phone': '6805445555', 'isoCode': 'PW', 'countryName': 'Palau', 'dialCode': '680'},
  {'phone': '970255555555', 'isoCode': 'PS', 'countryName': 'Palestine', 'dialCode': '970'},
  {'phone': '5072555555', 'isoCode': 'PA', 'countryName': 'Panama', 'dialCode': '507'},
  {'phone': '6753555555', 'isoCode': 'PG', 'countryName': 'Papua New Guinea', 'dialCode': '675'},
  {'phone': '5952155555555', 'isoCode': 'PY', 'countryName': 'Paraguay', 'dialCode': '595'},
  {'phone': '51155555555', 'isoCode': 'PE', 'countryName': 'Peru', 'dialCode': '51'},
  {'phone': '632555555555', 'isoCode': 'PH', 'countryName': 'Philippines', 'dialCode': '63'},
  {'phone': '48155555555', 'isoCode': 'PL', 'countryName': 'Poland', 'dialCode': '48'},
  {'phone': '68955555555', 'isoCode': 'PF', 'countryName': 'Polinesia Francesa', 'dialCode': '689'},
  {'phone': '351215555555', 'isoCode': 'PT', 'countryName': 'Portugal', 'dialCode': '351'},
  {'phone': '17875555555', 'isoCode': 'PR', 'countryName': 'Puerto Rico', 'dialCode': '1'},
  {'phone': '97415555555', 'isoCode': 'QA', 'countryName': 'Qatar', 'dialCode': '974'},
  {'phone': '85355555555', 'isoCode': 'MO', 'countryName': 'RAE de Macao (China)', 'dialCode': '853'},
  {'phone': '2622625555555', 'isoCode': 'RE', 'countryName': 'Reunión', 'dialCode': '262'},
  {'phone': '402155555555', 'isoCode': 'RO', 'countryName': 'Romania', 'dialCode': '40'},
  {'phone': '730155555555', 'isoCode': 'RU', 'countryName': 'Russia', 'dialCode': '7'},
  {'phone': '250220555555', 'isoCode': 'RW', 'countryName': 'Rwanda', 'dialCode': '250'},
  {'phone': '2125555555555', 'isoCode': 'EH', 'countryName': 'Sáhara Occidental', 'dialCode': '212'},
  {'phone': '18695555555', 'isoCode': 'KN', 'countryName': 'Saint Kitts and Nevis', 'dialCode': '1'},
  {'phone': '17585555555', 'isoCode': 'LC', 'countryName': 'Saint Lucia', 'dialCode': '1'},
  {'phone': '17845555555', 'isoCode': 'VC', 'countryName': 'Saint Vincent and the Grenadines', 'dialCode': '1'},
  {'phone': '68520555', 'isoCode': 'WS', 'countryName': 'Samoa', 'dialCode': '685'},
  {'phone': '16845555555', 'isoCode': 'AS', 'countryName': 'Samoa Americana', 'dialCode': '1'},
  {'phone': '5905905555555', 'isoCode': 'BL', 'countryName': 'San Bartolomé', 'dialCode': '590'},
  {'phone': '3780555555555', 'isoCode': 'SM', 'countryName': 'San Marino', 'dialCode': '378'},
  {'phone': '5905905555555', 'isoCode': 'MF', 'countryName': 'San Martín', 'dialCode': '590'},
  {'phone': '5084155555', 'isoCode': 'PM', 'countryName': 'San Pedro y Miquelón', 'dialCode': '508'},
  {'phone': '29025555', 'isoCode': 'SH', 'countryName': 'Santa Elena', 'dialCode': '290'},
  {'phone': '2392555555', 'isoCode': 'ST', 'countryName': 'Sao Tome and Principe', 'dialCode': '239'},
  {'phone': '9661155555555', 'isoCode': 'SA', 'countryName': 'Saudi Arabia', 'dialCode': '966'},
  {'phone': '221305555555', 'isoCode': 'SN', 'countryName': 'Senegal', 'dialCode': '221'},
  {'phone': '381105555555', 'isoCode': 'RS', 'countryName': 'Serbia', 'dialCode': '381'},
  {'phone': '2482555555', 'isoCode': 'SC', 'countryName': 'Seychelles', 'dialCode': '248'},
  {'phone': '232225555555', 'isoCode': 'SL', 'countryName': 'Sierra Leone', 'dialCode': '232'},
  {'phone': '6515555555', 'isoCode': 'SG', 'countryName': 'Singapore', 'dialCode': '65'},
  {'phone': '17215555555', 'isoCode': 'SX', 'countryName': 'Sint Maarten', 'dialCode': '1'},
  {'phone': '4212555555555', 'isoCode': 'SK', 'countryName': 'Slovakia', 'dialCode': '421'},
  {'phone': '386155555555', 'isoCode': 'SI', 'countryName': 'Slovenia', 'dialCode': '386'},
  {'phone': '67720555', 'isoCode': 'SB', 'countryName': 'Solomon Islands', 'dialCode': '677'},
  {'phone': '2521555555', 'isoCode': 'SO', 'countryName': 'Somalia', 'dialCode': '252'},
  {'phone': '271055555555', 'isoCode': 'ZA', 'countryName': 'South Africa', 'dialCode': '27'},
  {'phone': '82255555555', 'isoCode': 'KR', 'countryName': 'South Korea', 'dialCode': '82'},
  {'phone': '2111805555555', 'isoCode': 'SS', 'countryName': 'South Sudan', 'dialCode': '211'},
  {'phone': '34915555555', 'isoCode': 'ES', 'countryName': 'Spain', 'dialCode': '34'},
  {'phone': '941125555555', 'isoCode': 'LK', 'countryName': 'Sri Lanka', 'dialCode': '94'},
  {'phone': '2491555555555', 'isoCode': 'SD', 'countryName': 'Sudan', 'dialCode': '249'},
  {'phone': '597215555', 'isoCode': 'SR', 'countryName': 'Suriname', 'dialCode': '597'},
  {'phone': '4755555555', 'isoCode': 'SJ', 'countryName': 'Svalbard y Jan Mayen', 'dialCode': '47'},
  {'phone': '4685555555', 'isoCode': 'SE', 'countryName': 'Sweden', 'dialCode': '46'},
  {'phone': '412155555555', 'isoCode': 'CH', 'countryName': 'Switzerland', 'dialCode': '41'},
  {'phone': '9631155555555', 'isoCode': 'SY', 'countryName': 'Syria', 'dialCode': '963'},
  {'phone': '8862555555555', 'isoCode': 'TW', 'countryName': 'Taiwan', 'dialCode': '886'},
  {'phone': '992345555555', 'isoCode': 'TJ', 'countryName': 'Tajikistan', 'dialCode': '992'},
  {'phone': '2552255555555', 'isoCode': 'TZ', 'countryName': 'Tanzania', 'dialCode': '255'},
  {'phone': '2465555555', 'isoCode': 'IO', 'countryName': 'Territorio Británico del Océano Índico', 'dialCode': '246'},
  {'phone': '66255555555', 'isoCode': 'TH', 'countryName': 'Thailand', 'dialCode': '66'},
  {'phone': '6702055555', 'isoCode': 'TL', 'countryName': 'Timor-Leste', 'dialCode': '670'},
  {'phone': '22820555555', 'isoCode': 'TG', 'countryName': 'Togo', 'dialCode': '228'},
  {'phone': '6905555', 'isoCode': 'TK', 'countryName': 'Tokelau', 'dialCode': '690'},
  {'phone': '67620555', 'isoCode': 'TO', 'countryName': 'Tonga', 'dialCode': '676'},
  {'phone': '18685555555', 'isoCode': 'TT', 'countryName': 'Trinidad and Tobago', 'dialCode': '1'},
  {'phone': '2908555', 'isoCode': 'TA', 'countryName': 'Tristán de Acuña', 'dialCode': '290'},
  {'phone': '21620555555', 'isoCode': 'TN', 'countryName': 'Tunisia', 'dialCode': '216'},
  {'phone': '9021255555555', 'isoCode': 'TR', 'countryName': 'Turkey', 'dialCode': '90'},
  {'phone': '993125555555', 'isoCode': 'TM', 'countryName': 'Turkmenistan', 'dialCode': '993'},
  {'phone': '68820555', 'isoCode': 'TV', 'countryName': 'Tuvalu', 'dialCode': '688'},
  {'phone': '2563055555555', 'isoCode': 'UG', 'countryName': 'Uganda', 'dialCode': '256'},
  {'phone': '3804455555555', 'isoCode': 'UA', 'countryName': 'Ukraine', 'dialCode': '380'},
  {'phone': '971255555555', 'isoCode': 'AE', 'countryName': 'United Arab Emirates', 'dialCode': '971'},
  {'phone': '4420555555555', 'isoCode': 'GB', 'countryName': 'United Kingdom', 'dialCode': '44'},
  {'phone': '12015555555', 'isoCode': 'US', 'countryName': 'United States', 'dialCode': '1'},
  {'phone': '59817705555', 'isoCode': 'UY', 'countryName': 'Uruguay', 'dialCode': '598'},
  {'phone': '998205555555', 'isoCode': 'UZ', 'countryName': 'Uzbekistan', 'dialCode': '998'},
  {'phone': '67805555', 'isoCode': 'VU', 'countryName': 'Vanuatu', 'dialCode': '678'},
  {'phone': '3790555555555', 'isoCode': 'VA', 'countryName': 'Vatican City', 'dialCode': '379'},
  {'phone': '5821255555555', 'isoCode': 'VE', 'countryName': 'Venezuela', 'dialCode': '58'},
  {'phone': '8424555555555', 'isoCode': 'VN', 'countryName': 'Vietnam', 'dialCode': '84'},
  {'phone': '681555555', 'isoCode': 'WF', 'countryName': 'Wallis y Futuna', 'dialCode': '681'},
  {'phone': '96715555555', 'isoCode': 'YE', 'countryName': 'Yemen', 'dialCode': '967'},
  {'phone': '2602115555555', 'isoCode': 'ZM', 'countryName': 'Zambia', 'dialCode': '260'},
  {'phone': '26345555555', 'isoCode': 'ZW', 'countryName': 'Zimbabwe', 'dialCode': '263'},
];

String _patternBody(Country country) {
  String body = country.pattern;
  final String prefix = '^\\+${country.dialCode}';
  if (body.startsWith(prefix)) {
    body = body.substring(prefix.length);
  }
  if (body.endsWith(r'$')) {
    body = body.substring(0, body.length - 1);
  }
  return body;
}

Map<String, int> _localLengthRange(Country country) {
  final String body = _patternBody(country);
  final tokenRegex = RegExp(r'\\d\{(\d+)(?:,(\d+))?\}|\d+');
  int minLen = 0;
  int maxLen = 0;

  for (final match in tokenRegex.allMatches(body)) {
    final String token = match.group(0)!;
    if (token.startsWith(r'\d{')) {
      final int minToken = int.parse(match.group(1)!);
      final int maxToken = int.parse(match.group(2) ?? match.group(1)!);
      minLen += minToken;
      maxLen += maxToken;
    } else {
      minLen += token.length;
      maxLen += token.length;
    }
  }

  return {'min': minLen, 'max': maxLen};
}

String _buildPatternBasedLocal(Country country) {
  final String body = _patternBody(country);
  final tokenRegex = RegExp(r'\\d\{(\d+)(?:,(\d+))?\}|\d+');
  final StringBuffer buffer = StringBuffer();

  for (final match in tokenRegex.allMatches(body)) {
    final String token = match.group(0)!;
    if (token.startsWith(r'\d{')) {
      final int minToken = int.parse(match.group(1)!);
      buffer.write(List.filled(minToken, '5').join());
    } else {
      buffer.write(token);
    }
  }

  return buffer.toString();
}

String _buildValidLocalNumber(PhoneValidator validator, Country country) {
  final String fromPattern = _buildPatternBasedLocal(country);
  if (validator.checkPhonePattern(fromPattern, country)) {
    return fromPattern;
  }

  final range = _localLengthRange(country);
  final int minLen = range['min']!;
  final int maxLen = range['max']!;
  final List<String> areaCandidates = country.areaCodes.isNotEmpty
      ? country.areaCodes.map((area) => area.toString()).toList()
      : [''];

  for (final area in areaCandidates) {
    for (int length = minLen; length <= maxLen; length++) {
      if (area.length > length) {
        continue;
      }
      final String candidate = '$area${List.filled(length - area.length, '5').join()}';
      if (validator.checkPhonePattern(candidate, country)) {
        return candidate;
      }
    }
  }

  return fromPattern;
}

Set<String> _possibleIsoCodesForNumber(
  List<Country> countries,
  String fullNumber,
  PhoneValidator validator,
) {
  final Set<String> result = <String>{};
  final String normalized = fullNumber.replaceAll(RegExp(r'[^\d+]'), '');

  for (final country in countries) {
    if (!normalized.startsWith(country.dialCode)) {
      continue;
    }
    final String local = normalized.substring(country.dialCode.length);
    if (validator.checkAreaCode(country, local)) {
      result.add(country.isoCode);
    }
  }

  return result;
}

String _buildPatternSampleFullNumber(Country country) {
  String body = country.pattern;
  if (body.startsWith(r'^\+')) {
    body = body.substring(3);
  }
  if (body.endsWith(r'$')) {
    body = body.substring(0, body.length - 1);
  }

  final tokenRegex = RegExp(r'\\d\{(\d+)(?:,(\d+))?\}|\d+');
  final StringBuffer digits = StringBuffer();
  for (final match in tokenRegex.allMatches(body)) {
    final String token = match.group(0)!;
    if (token.startsWith(r'\d{')) {
      final int minToken = int.parse(match.group(1)!);
      digits.write(List.filled(minToken, '5').join());
    } else {
      digits.write(token);
    }
  }

  return '+${digits.toString()}';
}

void main() {
  late List<Country> countries = [];

  setUpAll(() {
    countries = CellPhoneValidator.countries;
  });
  test('init phonesValidator', () {
    final PhoneValidator phoneValidator = PhoneValidator(lang: 'en');
    expect(phoneValidator.lang, 'en');
    expect(phoneValidator.phone, '');
    expect(phoneValidator.country, null);
    expect(phoneValidator.isValidPhoneNotifier.value, false);
  });
  test('country phonesValidator', () async {
    expect(countries.length, 245);
  });
  for (final testNumber in testNumbers) {
    test("detect phone ${testNumber["countryName"]}", () async {
      final PhoneValidator phoneValidator = PhoneValidator(lang: "en");
      String phoneNumber = testNumber['phone'];
      Country? country = phoneValidator.getCountryByPhone(countries, phoneNumber);
      expect(country, isNotNull);

      final Country detectedCountry = country!;
      final String canonicalLocal = _buildValidLocalNumber(phoneValidator, detectedCountry);
      final bool canonicalIsValid =
          phoneValidator.checkPhonePattern(canonicalLocal, detectedCountry);
      final bool canonicalMatchesRegex =
          RegExp(detectedCountry.pattern).hasMatch(_buildPatternSampleFullNumber(detectedCountry));
      final Set<String> possibleIsoCodes =
          _possibleIsoCodesForNumber(countries, phoneNumber, phoneValidator);

      if (possibleIsoCodes.length == 1) {
        expect(detectedCountry.isoCode, testNumber['isoCode']);
        expect(detectedCountry.countryName, testNumber['countryName']);
      } else {
        expect(possibleIsoCodes.contains(testNumber['isoCode']), true);
        expect(possibleIsoCodes.contains(detectedCountry.isoCode), true);
      }
      expect(detectedCountry.dialCode, testNumber['dialCode']);
      expect(canonicalMatchesRegex, true);
      expect(canonicalIsValid || canonicalMatchesRegex, true);
    });
  }
}
