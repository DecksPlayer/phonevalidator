const fs = require('fs');
const path = require('path');

const packageDir = 'C:\\Users\\gonoj\\node_modules\\libphonenumber-js';
const metadataPath = path.join(packageDir, 'metadata.max.json');
const metadata = JSON.parse(fs.readFileSync(metadataPath, 'utf8'));

const phones = JSON.parse(fs.readFileSync('phones.json', 'utf8'));
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

// Generates the pattern using dialing codes and possible lengths
function generatePattern(dialCode, possibleLengths, isoCode) {
  // For NANP countries with specific sub-area codes in the existing pattern, let's see how they are structured
  // E.g., Anguilla (AI) dialCode is 1, pattern starts with 1264
  // We can check if the existing pattern starts with visualText + areaCode
  // Let's retrieve if the existing pattern has specific digits after dialCode
  const existing = phones.find(p => p.isoCode.toUpperCase() === isoCode.toUpperCase());
  
  // If it's a NANP country (calling code 1) and not US/CA, it has a 3-digit area code.
  // The area code can be determined from the existing pattern, or from the metadata
  let prefix = dialCode;
  if (dialCode === '1' && isoCode !== 'US' && isoCode !== 'CA') {
    // Look at metadata or existing pattern for the 3-digit area code
    const info = countries[isoCode];
    const areaCode = info[10]; // index 10 is usually the leading digits/area code for single-area-code NANP countries
    if (areaCode) {
      prefix = '1' + areaCode;
    } else if (existing) {
      // Extract prefix from existing pattern: e.g. ^\+1264\d{7}$ -> 1264
      const match = existing.pattern.match(/^\^\\\\\+(1\d{3})/);
      if (match) {
        prefix = match[1];
      }
    }
  }
  
  // For other countries, check if possibleLengths contains multiple sizes
  // E.g., [10, 11] -> \d{10,11}
  // [9] -> \d{9}
  // [8, 9, 10] -> \d{8,10} (ranges)
  if (possibleLengths.length === 0) {
    return `^\\+\\+${prefix}\\d+$`; // fallback
  }
  
  // Find min and max of possibleLengths
  const min = Math.min(...possibleLengths);
  const max = Math.max(...possibleLengths);
  
  // In NANP, the 10 possible digits include the 3-digit area code.
  // If prefix is 4 digits (e.g. 1264), the remaining digits typed is (length - 3).
  // Standard NANP phone number typed after +1 is 10 digits (including area code 264 + 7 digits = 10 digits).
  // So the pattern matches `^\+1264\d{7}$`.
  // Let's compute remaining digits:
  let remMin = min;
  let remMax = max;
  if (prefix.length > dialCode.length) {
    const prefixDiff = prefix.length - dialCode.length;
    remMin = min - prefixDiff;
    remMax = max - prefixDiff;
  }
  
  if (remMin === remMax) {
    return `^\\+\\+${prefix}\\d{${remMin}}$`;
  } else {
    // Check if it's contiguous
    let isContiguous = true;
    for (let l = remMin; l <= remMax; l++) {
      // if possibleLengths does not contain l + prefixDiff, we might still include it or define it as range
    }
    return `^\\+\\+${prefix}\\d{${remMin},${remMax}}$`;
  }
}

const comparisonReport = [];

for (const p of phones) {
  const iso = p.isoCode.toUpperCase();
  const info = countries[iso];
  
  if (!info) {
    comparisonReport.push({
      iso,
      name: p.countryName,
      status: 'MISSING_IN_GOOGLE',
    });
    continue;
  }
  
  const dialCode = info[0];
  const possibleLengths = info[3] || [];
  const formats = getFormatsForCountry(iso);
  
  // Determine new mask
  let newMask = '';
  if (formats.length > 0) {
    const standardFormats = formats.filter(f => {
      const leadingDigits = f[2];
      if (leadingDigits && leadingDigits.length > 0) {
        const leading = leadingDigits[0];
        if (/^[89]00/.test(leading)) return false;
      }
      return true;
    });
    const formatToUse = standardFormats.length > 0 ? standardFormats[standardFormats.length - 1] : formats[0];
    newMask = getMaskFromFormat(formatToUse);
  }
  
  // Fallback for empty newMask
  if (!newMask) {
    // If no format, generate simple mask of '#' based on possible lengths
    if (possibleLengths.length > 0) {
      const maxLen = Math.max(...possibleLengths);
      newMask = '#'.repeat(maxLen);
    }
  }
  
  // Generate proposed pattern
  const rawPattern = generatePattern(dialCode, possibleLengths, iso);
  // Unescape backslash for display
  const newPattern = rawPattern.replace('^\\+\\+', '^\\+');
  
  const maskDiffers = p.mask !== newMask;
  const patternDiffers = p.pattern !== newPattern;
  const dialCodeDiffers = p.dialCode !== dialCode;
  
  comparisonReport.push({
    iso,
    name: p.countryName,
    dialCode: { existing: p.dialCode, new: dialCode, differs: dialCodeDiffers },
    mask: { existing: p.mask, new: newMask, differs: maskDiffers },
    pattern: { existing: p.pattern, new: newPattern, differs: patternDiffers },
    differs: maskDiffers || patternDiffers || dialCodeDiffers
  });
}

fs.writeFileSync('comparison_report.json', JSON.stringify(comparisonReport, null, 2));
console.log(`Generated comparison_report.json for ${comparisonReport.length} countries.`);
const modified = comparisonReport.filter(r => r.differs);
console.log(`Total countries with differences: ${modified.length}`);
