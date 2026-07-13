const fs = require('fs');
const path = require('path');

const packageDir = 'C:\\Users\\gonoj\\node_modules\\libphonenumber-js';
const metadataPath = path.join(packageDir, 'metadata.max.json');
const metadata = JSON.parse(fs.readFileSync(metadataPath, 'utf8'));

const countries = metadata.countries;
const countryCallingCodes = metadata.country_calling_codes;

function getFormatsForCountry(countryCode) {
  let info = countries[countryCode];
  if (!info) return [];
  let formats = info[4];
  if (formats === 0 || !formats) {
    const callingCode = info[0];
    const mainCountry = countryCallingCodes[callingCode][0];
    if (mainCountry && mainCountry !== countryCode) {
      return getFormatsForCountry(mainCountry);
    }
  }
  return formats || [];
}

function parseRegexToGroupLengths(regexStr) {
  const groupLengths = [];
  let i = 0;
  while (i < regexStr.length) {
    if (regexStr[i] === '(' && (i === 0 || regexStr[i-1] !== '\\')) {
      let j = i + 1;
      let depth = 1;
      while (j < regexStr.length && depth > 0) {
        if (regexStr[j] === '(' && regexStr[j-1] !== '\\') depth++;
        if (regexStr[j] === ')' && regexStr[j-1] !== '\\') depth--;
        if (depth > 0) j++;
      }
      const groupContent = regexStr.substring(i + 1, j);
      let len = 1;
      const matchExact = groupContent.match(/\\d\{(\d+)\}/);
      const matchRange = groupContent.match(/\\d\{(\d+),(\d+)\}/);
      if (matchExact) {
        len = parseInt(matchExact[1], 10);
      } else if (matchRange) {
        len = parseInt(matchRange[2], 10);
      } else if (groupContent.includes('\\d')) {
        const count = (groupContent.match(/\\d/g) || []).length;
        len = count > 0 ? count : 1;
      }
      groupLengths.push(len);
      i = j;
    }
    i++;
  }
  return groupLengths;
}

function getMaskFromFormat(formatArr) {
  const [pattern, formatTemplate] = formatArr;
  const groupLengths = parseRegexToGroupLengths(pattern);
  let mask = formatTemplate;
  for (let idx = 0; idx < groupLengths.length; idx++) {
    const placeholder = `$${idx + 1}`;
    const hashes = '#'.repeat(groupLengths[idx]);
    mask = mask.replace(placeholder, hashes);
  }
  return mask;
}

const list = ['CO', 'BO', 'MX', 'AR', 'VA'];
for (const iso of list) {
  console.log(`\n--- ${iso} ---`);
  const info = countries[iso];
  console.log("Calling Code:", info[0]);
  console.log("Possible Lengths:", info[3]);
  const formats = getFormatsForCountry(iso);
  console.log("Formats:");
  formats.forEach((f, idx) => {
    console.log(`  Format ${idx}: [${f[0]}, ${f[1]}, ${f[2] || 'no-lead-digits'}] -> Mask: "${getMaskFromFormat(f)}"`);
  });
}
