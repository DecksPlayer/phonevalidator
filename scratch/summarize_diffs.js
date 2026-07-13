const fs = require('fs');

const report = JSON.parse(fs.readFileSync('comparison_report.json', 'utf8'));

const modified = report.filter(r => r.differs);
console.log(`Total modified: ${modified.length}`);

const dialCodeDiff = modified.filter(m => m.dialCode.differs);
console.log(`Dial Code differences: ${dialCodeDiff.length}`);
for (const d of dialCodeDiff) {
  console.log(`  ${d.name} (${d.iso}): Existing: "${d.dialCode.existing}", New: "${d.dialCode.new}"`);
}

const maskDiff = modified.filter(m => m.mask.differs);
console.log(`\nMask differences: ${maskDiff.length}`);
console.log("Sample mask differences (first 10):");
maskDiff.slice(0, 10).forEach(d => {
  console.log(`  ${d.name} (${d.iso}): Existing: "${d.mask.existing}", New: "${d.mask.new}"`);
});

const patternDiff = modified.filter(m => m.pattern.differs);
console.log(`\nPattern differences: ${patternDiff.length}`);
console.log("Sample pattern differences (first 10):");
patternDiff.slice(0, 10).forEach(d => {
  console.log(`  ${d.name} (${d.iso}): Existing: "${d.pattern.existing}", New: "${d.pattern.new}"`);
});
