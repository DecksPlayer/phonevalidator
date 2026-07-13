const fs = require('fs');
const path = require('path');
const { getExampleNumber } = require('libphonenumber-js');
const examples = require('libphonenumber-js/examples.mobile.json');

const packageDir = 'C:\\Users\\gonoj\\node_modules\\libphonenumber-js';
const metadataPath = path.join(packageDir, 'metadata.max.json');
const metadata = JSON.parse(fs.readFileSync(metadataPath, 'utf8'));

const phones = JSON.parse(fs.readFileSync('phones.json', 'utf8'));

const countries = metadata.countries;

function getBestMask(isoCode) {
  const example = getExampleNumber(isoCode, examples);
  if (!example) return '';
  
  const info = countries[isoCode];
  const nationalPrefix = info[5] || '';
  const possibleLengths = info[3] || [];
  const dialCode = info[0];
  
  const national = example.formatNational();
  const international = example.formatInternational();
  
  // Method 1: Clean national prefix from national format
  let cleanNational = national;
  if (nationalPrefix && national.startsWith(nationalPrefix)) {
    cleanNational = national.substring(nationalPrefix.length).trim();
    // Also remove leading dash/space if any
    if (cleanNational.startsWith('-') || cleanNational.startsWith(' ')) {
      cleanNational = cleanNational.substring(1).trim();
    }
  }
  
  // Method 2: Strip dial code from international format
  const intPrefix = `+${dialCode}`;
  let cleanInt = international;
  if (international.startsWith(intPrefix)) {
    cleanInt = international.substring(intPrefix.length).trim();
  }
  
  const maskNat = cleanNational.replace(/\d/g, '#');
  const maskInt = cleanInt.replace(/\d/g, '#');
  
  const natDigitsCount = (maskNat.match(/#/g) || []).length;
  const intDigitsCount = (maskInt.match(/#/g) || []).length;
  
  // We want a mask whose digit count matches one of the possible lengths.
  // Prefer maskNat if it matches possibleLengths and has more formatting characters (like parentheses)
  const natMatches = possibleLengths.includes(natDigitsCount);
  const intMatches = possibleLengths.includes(intDigitsCount);
  
  if (natMatches && (!intMatches || (maskNat.includes('(') || maskNat.includes('-')))) {
    return maskNat;
  }
  if (intMatches) {
    return maskInt;
  }
  
  // Fallback
  return maskNat || maskInt;
}

const testCountries = ['AF', 'AR', 'US', 'ES', 'CO', 'BO', 'MX', 'VA', 'BR', 'CA', 'GB', 'FR', 'IT'];
for (const iso of testCountries) {
  const existing = phones.find(p => p.isoCode.toUpperCase() === iso);
  console.log(`${iso}:`);
  console.log(`  Existing Mask: "${existing ? existing.mask : ''}"`);
  console.log(`  Best Mask:     "${getBestMask(iso)}"`);
}
