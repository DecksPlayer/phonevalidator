import 'package:cellphone_validator/src/cellphone_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cellphone_validator/cellphone_validator.dart';

final List<Map<String, dynamic>> testNumbers = [
  {'phone': '541123456789', 'isoCode': 'AR', 'countryName': 'Argentina', 'dialCode': '54'},
  // Argentina
  {'phone': '12025550191', 'isoCode': 'US', 'countryName': 'United States', 'dialCode': '1'},
  // USA
  {'phone': '14165550123', 'isoCode': 'CA', 'countryName': 'Canada', 'dialCode': '1'},
  // Canada
  {'phone': '442079460958', 'isoCode': 'GB', 'countryName': 'United Kingdom', 'dialCode': '44'},
  // UK
  {'phone': '493012345689', 'isoCode': 'DE', 'countryName': 'Germany', 'dialCode': '49'},
  // Germany
  {'phone': '33612345678', 'isoCode': 'FR', 'countryName': 'France', 'dialCode': '33'},
  // France
  {'phone': '34612345678', 'isoCode': 'ES', 'countryName': 'Spain', 'dialCode': '34'},
  // Spain
  {'phone': '5511912345678', 'isoCode': 'BR', 'countryName': 'Brazil', 'dialCode': '55'},
  // Brazil
  {'phone': '525512345678', 'isoCode': 'MX', 'countryName': 'Mexico', 'dialCode': '52'},
  // Mexico
  {'phone': '919123456789', 'isoCode': 'IN', 'countryName': 'India', 'dialCode': '91'},
  // India
  {'phone': '61412345678', 'isoCode': 'AU', 'countryName': 'Australia', 'dialCode': '61'},
  // Australia
  {'phone': '817012345678', 'isoCode': 'JP', 'countryName': 'Japan', 'dialCode': '81'},
  // Japan
  {'phone': '79123456789', 'isoCode': 'RU', 'countryName': 'Russia', 'dialCode': '7'},
  // Russia
  {'phone': '27821234567', 'isoCode': 'ZA', 'countryName': 'South Africa', 'dialCode': '27'},
  // South Africa
  {'phone': '393123456789', 'isoCode': 'IT', 'countryName': 'Italy', 'dialCode': '39'},
  // Italy
  {'phone': '8613812345678', 'isoCode': 'CN', 'countryName': 'China', 'dialCode': '86'},
  // China
  {'phone': '923001234567', 'isoCode': 'PK', 'countryName': 'Pakistan', 'dialCode': '92'},
  // Pakistan
  {'phone': '2348031234567', 'isoCode': 'NG', 'countryName': 'Nigeria', 'dialCode': '234'},
  // Nigeria
  {'phone': '8801712345678', 'isoCode': 'BD', 'countryName': 'Bangladesh', 'dialCode': '880'},
  // Bangladesh
  {'phone': '201001234567', 'isoCode': 'EG', 'countryName': 'Egypt', 'dialCode': '20'},
  // Egypt
  {'phone': '84912345678', 'isoCode': 'VN', 'countryName': 'Vietnam', 'dialCode': '84'},
  // Vietnam
  {'phone': '905123456789', 'isoCode': 'TR', 'countryName': 'Turkey', 'dialCode': '90'},
  // Turkey
  {'phone': '6281234567890', 'isoCode': 'ID', 'countryName': 'Indonesia', 'dialCode': '62'},
  // Indonesia
  {'phone': '639171234567', 'isoCode': 'PH', 'countryName': 'Philippines', 'dialCode': '63'},
  // Philippines
  {'phone': '66812345678', 'isoCode': 'TH', 'countryName': 'Thailand', 'dialCode': '66'},
  // Thailand
  {'phone': '966501234567', 'isoCode': 'SA', 'countryName': 'Saudi Arabia', 'dialCode': '966'},
  // Saudi Arabia
  {'phone': '989123456789', 'isoCode': 'IR', 'countryName': 'Iran', 'dialCode': '98'},
  // Iran
  {'phone': '60123456789', 'isoCode': 'MY', 'countryName': 'Malaysia', 'dialCode': '60'},
  // Malaysia
  {'phone': '31612345678', 'isoCode': 'NL', 'countryName': 'Netherlands', 'dialCode': '31'},
  // Netherlands
  {'phone': '48500123456', 'isoCode': 'PL', 'countryName': 'Poland', 'dialCode': '48'},
  // Poland
  {'phone': '40712345678', 'isoCode': 'RO', 'countryName': 'Romania', 'dialCode': '40'},
  // Romania
  {'phone': '380501234567', 'isoCode': 'UA', 'countryName': 'Ukraine', 'dialCode': '380'},
  // Ukraine
  {'phone': '56912345678', 'isoCode': 'CL', 'countryName': 'Chile', 'dialCode': '56'},
  // Chile
  {'phone': '5730012345678', 'isoCode': 'CO', 'countryName': 'Colombia', 'dialCode': '57'},
  // Colombia
  {'phone': '51912345678', 'isoCode': 'PE', 'countryName': 'Peru', 'dialCode': '51'},
  // Peru
  {'phone': '584121234567', 'isoCode': 'VE', 'countryName': 'Venezuela', 'dialCode': '58'},
  // Venezuela
  {'phone': '213512345678', 'isoCode': 'DZ', 'countryName': 'Algeria', 'dialCode': '213'},
  // Algeria
  {'phone': '244912345678', 'isoCode': 'AO', 'countryName': 'Angola', 'dialCode': '244'},
  // Angola
  {'phone': '355671234567', 'isoCode': 'AL', 'countryName': 'Albania', 'dialCode': '355'},
  // Albania
  {'phone': '22961234567', 'isoCode': 'BJ', 'countryName': 'Benin', 'dialCode': '229'},
  // Benin
  {'phone': '26771234567', 'isoCode': 'BW', 'countryName': 'Botswana', 'dialCode': '267'},
  // Botswana
  {'phone': '22661234567', 'isoCode': 'BF', 'countryName': 'Burkina Faso', 'dialCode': '226'},
  // Burkina Faso
  {'phone': '25761234567', 'isoCode': 'BI', 'countryName': 'Burundi', 'dialCode': '257'},
  // Burundi
  {'phone': '2389123456', 'isoCode': 'CV', 'countryName': 'Cape Verde', 'dialCode': '238'},
  // Cape Verde
  {'phone': '237612345678', 'isoCode': 'CM', 'countryName': 'Cameroon', 'dialCode': '237'},
  // Cameroon
  {'phone': '23670123456', 'isoCode': 'CF', 'countryName': 'Central African Republic', 'dialCode': '236'},
  // Central African Republic
  {'phone': '23560123456', 'isoCode': 'TD', 'countryName': 'Chad', 'dialCode': '235'},
  // Chad
  {'phone': '2693123456', 'isoCode': 'KM', 'countryName': 'Comoros', 'dialCode': '269'},
  // Comoros
  {'phone': '242051234567', 'isoCode': 'CG', 'countryName': 'Congo', 'dialCode': '242'},
  // Congo - Brazzaville
  {'phone': '243812345678', 'isoCode': 'CD', 'countryName': 'Congo - Kinshasa', 'dialCode': '243'},
  // Congo - Kinshasa
  {'phone': '25377123456', 'isoCode': 'DJ', 'countryName': 'Djibouti', 'dialCode': '253'},
  // Djibouti
  {'phone': '240222123456', 'isoCode': 'GQ', 'countryName': 'Equatorial Guinea', 'dialCode': '240'},
  // Equatorial Guinea
  {'phone': '2917123456', 'isoCode': 'ER', 'countryName': 'Eritrea', 'dialCode': '291'},
  // Eritrea
  {'phone': '251912345678', 'isoCode': 'ET', 'countryName': 'Ethiopia', 'dialCode': '251'},
  // Ethiopia
  {'phone': '24101234567', 'isoCode': 'GA', 'countryName': 'Gabon', 'dialCode': '241'},
  // Gabon
  {'phone': '2207123456', 'isoCode': 'GM', 'countryName': 'Gambia', 'dialCode': '220'},
  // Gambia
  {'phone': '233201234567', 'isoCode': 'GH', 'countryName': 'Ghana', 'dialCode': '233'},
  // Ghana
  {'phone': '224620123456', 'isoCode': 'GN', 'countryName': 'Guinea', 'dialCode': '224'},
  // Guinea
  {'phone': '245951234567', 'isoCode': 'GW', 'countryName': 'Guinea-Bissau', 'dialCode': '245'},
  // Guinea-Bissau
  {'phone': '254712345678', 'isoCode': 'KE', 'countryName': 'Kenya', 'dialCode': '254'},
  // Kenya
  {'phone': '26651234567', 'isoCode': 'LS', 'countryName': 'Lesotho', 'dialCode': '266'},
  // Lesotho
  {'phone': '231771234567', 'isoCode': 'LR', 'countryName': 'Liberia', 'dialCode': '231'},
  // Liberia
  {'phone': '218912345678', 'isoCode': 'LY', 'countryName': 'Libya', 'dialCode': '218'},
  // Libya
  {'phone': '261321234567', 'isoCode': 'MG', 'countryName': 'Madagascar', 'dialCode': '261'},
  // Madagascar
  {'phone': '265881234567', 'isoCode': 'MW', 'countryName': 'Malawi', 'dialCode': '265'},
  // Malawi
  {'phone': '22370123456', 'isoCode': 'ML', 'countryName': 'Mali', 'dialCode': '223'},
  // Mali
  {'phone': '22220123456', 'isoCode': 'MR', 'countryName': 'Mauritania', 'dialCode': '222'},
  // Mauritania
  {'phone': '23051234567', 'isoCode': 'MU', 'countryName': 'Mauritius', 'dialCode': '230'},
  // Mauritius
  {'phone': '212612345678', 'isoCode': 'MA', 'countryName': 'Morocco', 'dialCode': '212'},
  // Morocco
  {'phone': '258821234567', 'isoCode': 'MZ', 'countryName': 'Mozambique', 'dialCode': '258'},
  // Mozambique
  {'phone': '264811234567', 'isoCode': 'NA', 'countryName': 'Namibia', 'dialCode': '264'},
  // Namibia
  {'phone': '22790123456', 'isoCode': 'NE', 'countryName': 'Niger', 'dialCode': '227'},
  // Niger
  {'phone': '250781234567', 'isoCode': 'RW', 'countryName': 'Rwanda', 'dialCode': '250'},
  // Rwanda
  {'phone': '2399912345', 'isoCode': 'ST', 'countryName': 'Sao Tome and Principe', 'dialCode': '239'},
  // São Tomé & Príncipe
  {'phone': '221771234567', 'isoCode': 'SN', 'countryName': 'Senegal', 'dialCode': '221'},
  // Senegal
  {'phone': '2482512345', 'isoCode': 'SC', 'countryName': 'Seychelles', 'dialCode': '248'},
  // Seychelles
  {'phone': '2327613456', 'isoCode': 'SL', 'countryName': 'Sierra Leone', 'dialCode': '232'},
  // Sierra Leone
  {'phone': '25290123456', 'isoCode': 'SO', 'countryName': 'Somalia', 'dialCode': '252'},
  // Somalia
  {'phone': '27821234567', 'isoCode': 'ZA', 'countryName': 'South Africa', 'dialCode': '27'},
  // South Africa (duplicate, covered earlier)
  {'phone': '211912345678', 'isoCode': 'SS', 'countryName': 'South Sudan', 'dialCode': '211'},
  // South Sudan
  {'phone': '249912345678', 'isoCode': 'SD', 'countryName': 'Sudan', 'dialCode': '249'},
  // Sudan
  {'phone': '255751234567', 'isoCode': 'TZ', 'countryName': 'Tanzania', 'dialCode': '255'},
  // Tanzania
  {'phone': '22890123456', 'isoCode': 'TG', 'countryName': 'Togo', 'dialCode': '228'},
  // Togo
  {'phone': '21620123456', 'isoCode': 'TN', 'countryName': 'Tunisia', 'dialCode': '216'},
  // Tunisia
  {'phone': '256701234567', 'isoCode': 'UG', 'countryName': 'Uganda', 'dialCode': '256'},
  // Uganda
  {'phone': '260951234567', 'isoCode': 'ZM', 'countryName': 'Zambia', 'dialCode': '260'},
  // Zambia
  {'phone': '263771234567', 'isoCode': 'ZW', 'countryName': 'Zimbabwe', 'dialCode': '263'},
  // Zimbabwe
  {'phone': '93701234567', 'isoCode': 'AF', 'countryName': 'Afghanistan', 'dialCode': '93'},
  // Afghanistan
  {'phone': '37491234567', 'isoCode': 'AM', 'countryName': 'Armenia', 'dialCode': '374'},
  // Armenia
  {'phone': '994501234567', 'isoCode': 'AZ', 'countryName': 'Azerbaijan', 'dialCode': '994'},
  // Azerbaijan
  {'phone': '97331234567', 'isoCode': 'BH', 'countryName': 'Bahrain', 'dialCode': '973'},
  // Bahrain
  {'phone': '97517123456', 'isoCode': 'BT', 'countryName': 'Bhutan', 'dialCode': '975'},
  // Bhutan
  {'phone': '6738123456', 'isoCode': 'BN', 'countryName': 'Brunei', 'dialCode': '673'},
  // Brunei
  {'phone': '85510123456', 'isoCode': 'KH', 'countryName': 'Cambodia', 'dialCode': '855'},
  // Cambodia
  {'phone': '35799123456', 'isoCode': 'CY', 'countryName': 'Cyprus', 'dialCode': '357'},
  // Cyprus
  {'phone': '995512345678', 'isoCode': 'GE', 'countryName': 'Georgia', 'dialCode': '995'},
  // Georgia
  {'phone': '962771234567', 'isoCode': 'JO', 'countryName': 'Jordan', 'dialCode': '962'},
  // Jordan
  {'phone': '77012345678', 'isoCode': 'KZ', 'countryName': 'Kazakhstan', 'dialCode': '7'},
  // Kazakhstan (Note: shares dial code with Russia)
  {'phone': '96550123456', 'isoCode': 'KW', 'countryName': 'Kuwait', 'dialCode': '965'},
  // Kuwait
  {'phone': '996500123456', 'isoCode': 'KG', 'countryName': 'Kyrgyzstan', 'dialCode': '996'},
  // Kyrgyzstan
  {'phone': '8562012345678', 'isoCode': 'LA', 'countryName': "Laos", 'dialCode': '856'},
  // Laos
  {'phone': '96170123456', 'isoCode': 'LB', 'countryName': 'Lebanon', 'dialCode': '961'},
  // Lebanon
  {'phone': '9607123456', 'isoCode': 'MV', 'countryName': 'Maldives', 'dialCode': '960'},
  // Maldives
  {'phone': '97688123456', 'isoCode': 'MN', 'countryName': 'Mongolia', 'dialCode': '976'},
  // Mongolia
  {'phone': '95912345678', 'isoCode': 'MM', 'countryName': 'Myanmar', 'dialCode': '95'},
  // Myanmar
  {'phone': '9779801234567', 'isoCode': 'NP', 'countryName': 'Nepal', 'dialCode': '977'},
  // Nepal
  {'phone': '8501912345678', 'isoCode': 'KP', 'countryName': 'North Korea', 'dialCode': '850'},
  // North Korea
  {'phone': '96891234567', 'isoCode': 'OM', 'countryName': 'Oman', 'dialCode': '968'},
  // Oman
  {'phone': '970591234567', 'isoCode': 'PS', 'countryName': 'Palestine', 'dialCode': '970'},
  // Palestine
  {'phone': '97455123456', 'isoCode': 'QA', 'countryName': 'Qatar', 'dialCode': '974'},
  // Qatar
  {'phone': '6581234567', 'isoCode': 'SG', 'countryName': 'Singapore', 'dialCode': '65'},
  // Singapore
  {'phone': '821012345678', 'isoCode': 'KR', 'countryName': 'South Korea', 'dialCode': '82'},
  // South Korea
  {'phone': '94712345678', 'isoCode': 'LK', 'countryName': 'Sri Lanka', 'dialCode': '94'},
  // Sri Lanka
  {'phone': '963912345678', 'isoCode': 'SY', 'countryName': 'Syria', 'dialCode': '963'},
  // Syria
  {'phone': '886912345678', 'isoCode': 'TW', 'countryName': 'Taiwan', 'dialCode': '886'},
  // Taiwan
  {'phone': '992912345678', 'isoCode': 'TJ', 'countryName': 'Tajikistan', 'dialCode': '992'},
  // Tajikistan
  {'phone': '67071234567', 'isoCode': 'TL', 'countryName': 'Timor-Leste', 'dialCode': '670'},
  // Timor-Leste
  {'phone': '99361234567', 'isoCode': 'TM', 'countryName': 'Turkmenistan', 'dialCode': '993'},
  // Turkmenistan
  {'phone': '971501234567', 'isoCode': 'AE', 'countryName': 'United Arab Emirates', 'dialCode': '971'},
  // UAE
  {'phone': '998901234567', 'isoCode': 'UZ', 'countryName': 'Uzbekistan', 'dialCode': '998'},
  // Uzbekistan
  {'phone': '967701234567', 'isoCode': 'YE', 'countryName': 'Yemen', 'dialCode': '967'},
  // Yemen
  {'phone': '353831234567', 'isoCode': 'IE', 'countryName': 'Ireland', 'dialCode': '353'},
  // Ireland
  {'phone': '32460123456', 'isoCode': 'BE', 'countryName': 'Belgium', 'dialCode': '32'},
  // Belgium
  {'phone': '351912345678', 'isoCode': 'PT', 'countryName': 'Portugal', 'dialCode': '351'},
  // Portugal
  {'phone': '41761234567', 'isoCode': 'CH', 'countryName': 'Switzerland', 'dialCode': '41'},
  // Switzerland
  {'phone': '436601234567', 'isoCode': 'AT', 'countryName': 'Austria', 'dialCode': '43'},
  // Austria
  {'phone': '4520123456', 'isoCode': 'DK', 'countryName': 'Denmark', 'dialCode': '45'},
  // Denmark
  {'phone': '46701234567', 'isoCode': 'SE', 'countryName': 'Sweden', 'dialCode': '46'},
  // Sweden
  {'phone': '4790123456', 'isoCode': 'NO', 'countryName': 'Norway', 'dialCode': '47'},
  // Norway
  {'phone': '358401234567', 'isoCode': 'FI', 'countryName': 'Finland', 'dialCode': '358'},
  // Finland
  {'phone': '306912345678', 'isoCode': 'GR', 'countryName': 'Greece', 'dialCode': '30'},
  // Greece
  {'phone': '36201234567', 'isoCode': 'HU', 'countryName': 'Hungary', 'dialCode': '36'},
  // Hungary
  {'phone': '420601234567', 'isoCode': 'CZ', 'countryName': 'Czech Republic', 'dialCode': '420'},
  // Czech Republic
  {'phone': '421901234567', 'isoCode': 'SK', 'countryName': 'Slovakia', 'dialCode': '421'},
  // Slovakia
  {'phone': '359871234567', 'isoCode': 'BG', 'countryName': 'Bulgaria', 'dialCode': '359'},
  // Bulgaria
  {'phone': '385912345678', 'isoCode': 'HR', 'countryName': 'Croatia', 'dialCode': '385'},
  // Croatia
  {'phone': '381601234567', 'isoCode': 'RS', 'countryName': 'Serbia', 'dialCode': '381'},
  // Serbia
  {'phone': '38630123456', 'isoCode': 'SI', 'countryName': 'Slovenia', 'dialCode': '386'},
  // Slovenia
  {'phone': '37061234567', 'isoCode': 'LT', 'countryName': 'Lithuania', 'dialCode': '370'},
  // Lithuania
  {'phone': '37120123456', 'isoCode': 'LV', 'countryName': 'Latvia', 'dialCode': '371'},
  // Latvia
  {'phone': '37250123456', 'isoCode': 'EE', 'countryName': 'Estonia', 'dialCode': '372'},
  // Estonia
  {'phone': '352621123456', 'isoCode': 'LU', 'countryName': 'Luxembourg', 'dialCode': '352'},
  // Luxembourg
  {'phone': '35677123456', 'isoCode': 'MT', 'countryName': 'Malta', 'dialCode': '356'},
  // Malta
  {'phone': '3546123456', 'isoCode': 'IS', 'countryName': 'Iceland', 'dialCode': '354'},
  // Iceland
  {'phone': '37793123456', 'isoCode': 'MC', 'countryName': 'Monaco', 'dialCode': '377'},
  // Monaco
  {'phone': '376312345', 'isoCode': 'AD', 'countryName': 'Andorra', 'dialCode': '376'},
  // Andorra
  {'phone': '37866123456', 'isoCode': 'SM', 'countryName': 'San Marino', 'dialCode': '378'},
  // San Marino
  {'phone': '37900123456', 'isoCode': 'VA', 'countryName': 'Vatican City', 'dialCode': '379'},
  // Vatican City (Note: Often uses Italian numbers)
  {'phone': '38344123456', 'isoCode': 'XK', 'countryName': 'Kosovo', 'dialCode': '383'},
  // Kosovo
  {'phone': '38760123456', 'isoCode': 'BA', 'countryName': 'Bosnia and Herzegovina', 'dialCode': '387'},
  // Bosnia and Herzegovina
  {'phone': '38970123456', 'isoCode': 'MK', 'countryName': 'North Macedonia', 'dialCode': '389'},
  // North Macedonia
  {'phone': '375251234567', 'isoCode': 'BY', 'countryName': 'Belarus', 'dialCode': '375'},
  // Belarus
  {'phone': '37360123456', 'isoCode': 'MD', 'countryName': 'Moldova', 'dialCode': '373'},
  // Moldova
  {'phone': '299501234', 'isoCode': 'GL', 'countryName': 'Greenland', 'dialCode': '299'},
  // Greenland
  {'phone': '12641234567', 'isoCode': 'AI', 'countryName': 'Anguilla', 'dialCode': '1'},
  {'phone': '12681234567', 'isoCode': 'AG', 'countryName': 'Antigua and Barbuda', 'dialCode': '1'},
  {'phone': '12421234567', 'isoCode': 'BS', 'countryName': 'Bahamas', 'dialCode': '1'},
  {'phone': '12461234567', 'isoCode': 'BB', 'countryName': 'Barbados', 'dialCode': '1'},
  {'phone': '5012234567', 'isoCode': 'BZ', 'countryName': 'Belize', 'dialCode': '501'},
  {'phone': '59112345678', 'isoCode': 'BO', 'countryName': 'Bolivia', 'dialCode': '591'},
  {'phone': '50622345678', 'isoCode': 'CR', 'countryName': 'Costa Rica', 'dialCode': '506'},
  {'phone': '5352345678', 'isoCode': 'CU', 'countryName': 'Cuba', 'dialCode': '53'},
  {'phone': '17671234567', 'isoCode': 'DM', 'countryName': 'Dominica', 'dialCode': '1'},
  {'phone': '18091234567', 'isoCode': 'DO', 'countryName': 'Dominican Republic', 'dialCode': '1'},
  {'phone': '59312345678', 'isoCode': 'EC', 'countryName': 'Ecuador', 'dialCode': '593'},
  {'phone': '50312345678', 'isoCode': 'SV', 'countryName': 'El Salvador', 'dialCode': '503'},
  {'phone': '26812345678', 'isoCode': 'SZ', 'countryName': 'Eswatini', 'dialCode': '268'},
  {'phone': '67912345678', 'isoCode': 'FJ', 'countryName': 'Fiji', 'dialCode': '679'},
  {'phone': '14731234567', 'isoCode': 'GD', 'countryName': 'Grenada', 'dialCode': '1'},
  {'phone': '50212345678', 'isoCode': 'GT', 'countryName': 'Guatemala', 'dialCode': '502'},
  {'phone': '5922261234', 'isoCode': 'GY', 'countryName': 'Guyana', 'dialCode': '592'},
  {'phone': '50922345678', 'isoCode': 'HT', 'countryName': 'Haiti', 'dialCode': '509'},
  {'phone': '50412345678', 'isoCode': 'HN', 'countryName': 'Honduras', 'dialCode': '504'},
  {'phone': '85212345678', 'isoCode': 'HK', 'countryName': 'Hong Kong', 'dialCode': '852'},
  {'phone': '96412345678', 'isoCode': 'IQ', 'countryName': 'Iraq', 'dialCode': '964'},
  {'phone': '97212345678', 'isoCode': 'IL', 'countryName': 'Israel', 'dialCode': '972'},
  {'phone': '18761234567', 'isoCode': 'JM', 'countryName': 'Jamaica', 'dialCode': '1'},
  {'phone': '6861234567', 'isoCode': 'KI', 'countryName': 'Kiribati', 'dialCode': '686'},
  {'phone': '4232364567', 'isoCode': 'LI', 'countryName': 'Liechtenstein', 'dialCode': '423'},
  {'phone': '6926251234', 'isoCode': 'MH', 'countryName': 'Marshall Islands', 'dialCode': '692'},
  {'phone': '6913204567', 'isoCode': 'FM', 'countryName': 'Micronesia', 'dialCode': '691'},
  {'phone': '38267123456', 'isoCode': 'ME', 'countryName': 'Montenegro', 'dialCode': '382'},
  {'phone': '6745551234', 'isoCode': 'NR', 'countryName': 'Nauru', 'dialCode': '674'},
  {'phone': '6491234567', 'isoCode': 'NZ', 'countryName': 'New Zealand', 'dialCode': '64'},
  {'phone': '50581234567', 'isoCode': 'NI', 'countryName': 'Nicaragua', 'dialCode': '505'},
  {'phone': '6808804567', 'isoCode': 'PW', 'countryName': 'Palau', 'dialCode': '680'},
  {'phone': '50761234567', 'isoCode': 'PA', 'countryName': 'Panama', 'dialCode': '507'},
  {'phone': '67512345678', 'isoCode': 'PG', 'countryName': 'Papua New Guinea', 'dialCode': '675'},
  {'phone': '595961123456', 'isoCode': 'PY', 'countryName': 'Paraguay', 'dialCode': '595'},
  {'phone': '18691234567', 'isoCode': 'KN', 'countryName': 'Saint Kitts and Nevis', 'dialCode': '1'},
  {'phone': '17581234567', 'isoCode': 'LC', 'countryName': 'Saint Lucia', 'dialCode': '1'},
  {'phone': '17841234567', 'isoCode': 'VC', 'countryName': 'Saint Vincent and the Grenadines', 'dialCode': '1'},
  {'phone': '6857212345', 'isoCode': 'WS', 'countryName': 'Samoa', 'dialCode': '685'},
  {'phone': '6777412345', 'isoCode': 'SB', 'countryName': 'Solomon Islands', 'dialCode': '677'},
  {'phone': '5972134567', 'isoCode': 'SR', 'countryName': 'Suriname', 'dialCode': '597'},
  {'phone': '6762012345', 'isoCode': 'TO', 'countryName': 'Tonga', 'dialCode': '676'},
  {'phone': '18681234567', 'isoCode': 'TT', 'countryName': 'Trinidad and Tobago', 'dialCode': '1'},
  {'phone': '688201234', 'isoCode': 'TV', 'countryName': 'Tuvalu', 'dialCode': '688'},
  {'phone': '6787712345', 'isoCode': 'VU', 'countryName': 'Vanuatu', 'dialCode': '678'},
];

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
    expect(countries.length, 199);
  });
  for (final testNumber in testNumbers) {
    test("detect phone ${testNumber["countryName"]}", () async {
      final PhoneValidator phoneValidator = PhoneValidator(lang: "en");
      String phoneNumber = testNumber['phone'];
      Country? country = phoneValidator.getCountryByPhone(countries, phoneNumber);
      String phone = phoneNumber.replaceFirst(country!.dialCode, '');
      Map<String, dynamic> data = phoneValidator.checkPhonePattern2(phone, country!);
      print(data);
      bool isValid = phoneValidator.checkPhonePattern(phone, country!);

      expect(country!.isoCode, testNumber['isoCode']);
      expect(country.countryName, testNumber['countryName']);
      expect(country.dialCode, testNumber['dialCode']);
      expect(isValid, true);
    });
  }
}
