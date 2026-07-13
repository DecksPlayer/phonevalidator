const fs = require('fs');
const { getExampleNumber } = require('libphonenumber-js');
const examples = require('libphonenumber-js/examples.mobile.json');

const phones = JSON.parse(fs.readFileSync('phones.json', 'utf8'));

console.log("Country | Existing Mask | National Mask | International Mask (no dial code)");
console.log("---|---|---|---");

const samples = ['AF', 'AR', 'US', 'ES', 'CO', 'BO', 'MX', 'VA', 'BR', 'CA', 'GB', 'FR', 'IT'];

for (const iso of samples) {
  const existing = phones.find(p => p.isoCode.toUpperCase() === iso);
  const example = getExampleNumber(iso, examples);
  
  if (!example) {
    console.log(`${iso} | ${existing ? existing.mask : 'none'} | No Example | No Example`);
    continue;
  }
  
  const national = example.formatNational();
  const nationalMask = national.replace(/\d/g, '#');
  
  const dialCode = existing ? existing.dialCode : example.countryCallingCode;
  const international = example.formatInternational();
  // Strip +dialCode from start of international
  const prefix = `+${dialCode}`;
  let localInt = international;
  if (international.startsWith(prefix)) {
    localInt = international.substring(prefix.length).trim();
  }
  const internationalMask = localInt.replace(/\d/g, '#');
  
  console.log(`${iso} | ${existing ? existing.mask : 'none'} | ${nationalMask} | ${internationalMask}`);
}
