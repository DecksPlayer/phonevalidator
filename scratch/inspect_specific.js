const fs = require('fs');

const report = JSON.parse(fs.readFileSync('comparison_report.json', 'utf8'));
const map = new Map(report.map(r => [r.iso, r]));

const specific = ['CO', 'BO', 'MX', 'AR', 'VA'];
for (const iso of specific) {
  console.log(`\n--- ${iso} ---`);
  console.log(JSON.stringify(map.get(iso), null, 2));
}
