const fs = require('fs');
const path = require('path');

const metadataPath = path.join(__dirname, 'node_modules', 'libphonenumber-js', 'metadata.min.json');
if (!fs.existsSync(metadataPath)) {
  console.error("Metadata file not found at:", metadataPath);
  process.exit(1);
}

const metadata = JSON.parse(fs.readFileSync(metadataPath, 'utf8'));
console.log("Metadata keys:", Object.keys(metadata));
// Typically metadata has 'countries' and/or 'country_calling_codes'
// Let's print the first country
const firstCountryKey = Object.keys(metadata.countries)[0];
console.log(`First country key: ${firstCountryKey}`);
console.log(`First country data:`, JSON.stringify(metadata.countries[firstCountryKey]));
