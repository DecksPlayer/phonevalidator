const fs = require('fs');
const path = require('path');

const packageDir = 'C:\\Users\\gonoj\\node_modules\\libphonenumber-js';
const metadataPath = path.join(packageDir, 'metadata.max.json');

const metadata = JSON.parse(fs.readFileSync(metadataPath, 'utf8'));

const nanp = ['AI', 'BS', 'US'];
for (const country of nanp) {
  console.log(`\n--- ${country} ---`);
  console.log(JSON.stringify(metadata.countries[country], null, 2));
}
