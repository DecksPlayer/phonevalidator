const fs = require('fs');

const phones = JSON.parse(fs.readFileSync('phones.json', 'utf8'));

let simpleDigitCount = 0;
let complexCount = 0;

for (const p of phones) {
  const pattern = p.pattern; // e.g. "^\+93\d{9}$"
  const dialCode = p.dialCode;
  
  // We want to see if it matches: ^\+<dialCode>\d{<lengths>}$
  // Escaped dial code:
  const escapedDialCode = dialCode.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
  // We expect: start line (^), backslash-plus (\\+), dialCode, backslash-d (\\d), optionally braces ({lengths}), end line ($)
  // Let's test with a simpler match:
  const parts = pattern.match(/^\^\\\+(.*?)\\d(?:\{([\d,]+)\})?\$$/);
  
  if (parts) {
    simpleDigitCount++;
  } else {
    complexCount++;
    if (complexCount <= 5) {
      console.log(`Non-matching pattern for ${p.countryName}: "${p.pattern}" (dialCode: ${p.dialCode})`);
    }
  }
}

console.log(`Simple digit-length patterns: ${simpleDigitCount}`);
console.log(`Complex/other patterns: ${complexCount}`);
