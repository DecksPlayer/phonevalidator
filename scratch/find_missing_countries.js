const fs = require('fs');
const { getCountries } = require('libphonenumber-js');

const phones = JSON.parse(fs.readFileSync('phones.json', 'utf8'));
const existingIsos = new Set(phones.map(p => p.isoCode.toUpperCase()));

const googleCountries = getCountries();

const missing = [];
for (const iso of googleCountries) {
  if (!existingIsos.has(iso.toUpperCase())) {
    missing.push(iso);
  }
}

console.log("Missing countries in phones.json:", missing);
