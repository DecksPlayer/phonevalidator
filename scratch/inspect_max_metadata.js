const fs = require('fs');
const path = require('path');

const packageDir = 'C:\\Users\\gonoj\\node_modules\\libphonenumber-js';
const metadataPath = path.join(packageDir, 'metadata.max.json');

const metadata = JSON.parse(fs.readFileSync(metadataPath, 'utf8'));

// The metadata object typically has "countries"
console.log("Root keys:", Object.keys(metadata));

const countries = metadata.countries;
console.log("Number of countries in metadata.max:", Object.keys(countries).length);

const sample = ['AF', 'AR', 'ES', 'US'];
for (const country of sample) {
  const info = countries[country];
  console.log(`\n--- ${country} ---`);
  // Print keys or structure
  console.log(JSON.stringify(info, null, 2).substring(0, 1500));
}
