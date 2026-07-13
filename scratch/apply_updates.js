const fs = require('fs');
const path = require('path');
const { getExampleNumber } = require('libphonenumber-js');
const examples = require('libphonenumber-js/examples.mobile.json');

const packageDir = 'C:\\Users\\gonoj\\node_modules\\libphonenumber-js';
const metadataPath = path.join(packageDir, 'metadata.max.json');
const metadata = JSON.parse(fs.readFileSync(metadataPath, 'utf8'));

const phones = JSON.parse(fs.readFileSync('phones.json', 'utf8'));

const countries = metadata.countries;
const countryCallingCodes = metadata.country_calling_codes;

function getBestMask(isoCode) {
  const example = getExampleNumber(isoCode, examples);
  if (!example) return '';
  
  const info = countries[isoCode];
  const nationalPrefix = info[5] || '';
  const possibleLengths = info[3] || [];
  const dialCode = info[0];
  
  const national = example.formatNational();
  const international = example.formatInternational();
  
  let cleanNational = national;
  if (nationalPrefix && national.startsWith(nationalPrefix)) {
    cleanNational = national.substring(nationalPrefix.length).trim();
    if (cleanNational.startsWith('-') || cleanNational.startsWith(' ')) {
      cleanNational = cleanNational.substring(1).trim();
    }
  }
  
  const intPrefix = `+${dialCode}`;
  let cleanInt = international;
  if (international.startsWith(intPrefix)) {
    cleanInt = international.substring(intPrefix.length).trim();
  }
  
  const maskNat = cleanNational.replace(/\d/g, '#');
  const maskInt = cleanInt.replace(/\d/g, '#');
  
  const natDigitsCount = (maskNat.match(/#/g) || []).length;
  const intDigitsCount = (maskInt.match(/#/g) || []).length;
  
  const natMatches = possibleLengths.includes(natDigitsCount);
  const intMatches = possibleLengths.includes(intDigitsCount);
  
  if (natMatches && (!intMatches || (maskNat.includes('(') || maskNat.includes('-')))) {
    return maskNat;
  }
  if (intMatches) {
    return maskInt;
  }
  
  return maskNat || maskInt;
}

function generatePattern(dialCode, possibleLengths, isoCode) {
  let prefix = dialCode;
  if (dialCode === '1' && isoCode !== 'US' && isoCode !== 'CA') {
    const info = countries[isoCode];
    const areaCode = info[10];
    if (areaCode) {
      prefix = '1' + areaCode;
    } else {
      const existing = phones.find(p => p.isoCode.toUpperCase() === isoCode.toUpperCase());
      if (existing) {
        const match = existing.pattern.match(/^\^\\\\\+(1\d{3})/);
        if (match) {
          prefix = match[1];
        }
      }
    }
  }
  
  if (possibleLengths.length === 0) {
    return `^\\+${prefix}\\d+$`;
  }
  
  const min = Math.min(...possibleLengths);
  const max = Math.max(...possibleLengths);
  
  let remMin = min;
  let remMax = max;
  if (prefix.length > dialCode.length) {
    const prefixDiff = prefix.length - dialCode.length;
    remMin = min - prefixDiff;
    remMax = max - prefixDiff;
  }
  
  if (remMin === remMax) {
    return `^\\+${prefix}\\d{${remMin}}$`;
  } else {
    return `^\\+${prefix}\\d{${remMin},${remMax}}$`;
  }
}

// Generate the new content for phones.dart
const buffer = [];
buffer.push('List<Map<String, dynamic>> mapSupportedCountries = [');

for (const p of phones) {
  const iso = p.isoCode.toUpperCase();
  const info = countries[iso];
  
  let dialCode = p.dialCode;
  let pattern = p.pattern;
  let mask = p.mask;
  
  if (info) {
    dialCode = info[0];
    const possibleLengths = info[3] || [];
    mask = getBestMask(iso) || p.mask;
    pattern = generatePattern(dialCode, possibleLengths, iso);
  }
  
  // Format areaCodes array
  const areaCodesStr = JSON.stringify(p.areaCodes);
  
  // Escape backslashes in pattern for Dart output (single backslash in pattern -> double backslash in Dart string)
  // Also escape $ for Dart string interpolation compatibility
  const escapedPattern = pattern.replace(/\\/g, '\\\\').replace(/\$/g, '\\$');
  
  buffer.push('  {');
  buffer.push(`    "countryName": "${p.countryName}",`);
  buffer.push(`    "isoCode": "${p.isoCode}",`);
  buffer.push(`    "dialCode": "${dialCode}",`);
  buffer.push(`    "visualText": "+${dialCode}",`);
  buffer.push(`    "pattern": "${escapedPattern}",`);
  buffer.push(`    "mask": "${mask}",`);
  buffer.push(`    "emoji": "${p.emoji}",`);
  buffer.push(`    "areaCodes": ${areaCodesStr}`);
  buffer.push('  },');
}

// Remove the last comma and close the list
const lastIdx = buffer.length - 1;
if (buffer[lastIdx] === '  },') {
  buffer[lastIdx] = '  }';
}
buffer.push('];');

const outputPath = path.resolve(__dirname, '..', 'scripts', 'supported_countries', 'phones.dart');
fs.writeFileSync(outputPath, buffer.join('\n') + '\n');
console.log(`Successfully generated updated phones.dart at: ${outputPath}`);
