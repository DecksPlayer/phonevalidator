const fs = require('fs');
const path = require('path');

const packageDir = 'C:\\Users\\gonoj\\node_modules\\libphonenumber-js';
const metadataPath = path.join(packageDir, 'metadata.max.json');
const metadata = JSON.parse(fs.readFileSync(metadataPath, 'utf8'));

const phones = JSON.parse(fs.readFileSync('phones.json', 'utf8'));
const phonesMap = new Map(phones.map(p => [p.isoCode.toUpperCase(), p]));

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

// Convert a regex and format template to a mask, e.g. (\d{3})(\d{3})(\d{4}) and ($1) $2-$3 -> (###) ###-####
function parseRegexToGroupLengths(regexStr) {
  // We want to find the lengths of each group in the regex
  // The regex has groups like (\d{3}), (\d{4}), (\d{1,2}), (\d), etc.
  const groupLengths = [];
  
  // Find all parenthesized groups. We must handle escaped parens inside, but phone regexes are simple
  // Let's iterate and extract groups
  let i = 0;
  while (i < regexStr.length) {
    if (regexStr[i] === '(' && (i === 0 || regexStr[i-1] !== '\\')) {
      // Start of group
      let j = i + 1;
      let depth = 1;
      while (j < regexStr.length && depth > 0) {
        if (regexStr[j] === '(' && regexStr[j-1] !== '\\') depth++;
        if (regexStr[j] === ')' && regexStr[j-1] !== '\\') depth--;
        if (depth > 0) j++;
      }
      const groupContent = regexStr.substring(i + 1, j);
      
      // Now parse groupContent for length
      // Patterns: \d{n}, \d{min,max}, \d, [0-9]{n}, etc.
      let len = 1;
      const matchExact = groupContent.match(/\\d\{(\d+)\}/);
      const matchRange = groupContent.match(/\\d\{(\d+),(\d+)\}/);
      if (matchExact) {
        len = parseInt(matchExact[1], 10);
      } else if (matchRange) {
        // Use max length for mask
        len = parseInt(matchRange[2], 10);
      } else if (groupContent.includes('\\d')) {
        // Count number of \d
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
  
  // Now replace $1, $2, etc. in formatTemplate with # repeated groupLengths[index] times
  let mask = formatTemplate;
  for (let idx = 0; idx < groupLengths.length; idx++) {
    const placeholder = `$${idx + 1}`;
    const hashes = '#'.repeat(groupLengths[idx]);
    mask = mask.replace(placeholder, hashes);
  }
  return mask;
}

// Compare masks
const diffs = [];

for (const iso of Object.keys(countries)) {
  const info = countries[iso];
  const callingCode = info[0];
  const generalPattern = info[2];
  const possibleLengths = info[3] || [];
  
  const existing = phonesMap.get(iso);
  if (!existing) {
    console.log(`Missing country in existing phones: ${iso}`);
    continue;
  }
  
  const formats = getFormatsForCountry(iso);
  
  // Find the best format
  // We want to skip formats that are for special services (like leading digits starting with 800, 900)
  // And prefer standard mobile/fixed-line format
  let chosenMask = '';
  let bestFormat = null;
  
  if (formats.length > 0) {
    // Filter formats
    const standardFormats = formats.filter(f => {
      const leadingDigits = f[2];
      if (leadingDigits && leadingDigits.length > 0) {
        const leading = leadingDigits[0];
        // If it starts with 800 or 900, it's likely a toll-free number format, skip if we have other choices
        if (/^[89]00/.test(leading)) return false;
      }
      return true;
    });
    
    // Choose the first standard format or the first format
    const formatToUse = standardFormats.length > 0 ? standardFormats[standardFormats.length - 1] : formats[0];
    bestFormat = formatToUse;
    chosenMask = getMaskFromFormat(formatToUse);
  }
  
  // Compare with existing mask
  if (existing.mask !== chosenMask) {
    diffs.push({
      iso,
      country: existing.countryName,
      existingMask: existing.mask,
      newMask: chosenMask,
      allFormats: formats.map(f => getMaskFromFormat(f))
    });
  }
}

console.log(`\nFound ${diffs.length} differences in formatting masks:`);
for (let i = 0; i < Math.min(diffs.length, 20); i++) {
  const d = diffs[i];
  console.log(`${d.country} (${d.iso}):`);
  console.log(`  Existing Mask: "${d.existingMask}"`);
  console.log(`  New Mask:      "${d.newMask}"`);
  console.log(`  All Formats:   `, d.allFormats);
}
