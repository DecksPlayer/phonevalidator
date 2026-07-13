const fs = require('fs');
const path = require('path');

try {
  const { getExampleNumber } = require('libphonenumber-js');
  const examples = require('libphonenumber-js/examples.mobile.json');
  
  console.log("Successfully loaded examples");
  
  const testCountries = ['AF', 'AR', 'US', 'ES', 'CO', 'BO', 'MX', 'VA'];
  for (const country of testCountries) {
    const example = getExampleNumber(country, examples);
    if (example) {
      // formatNational() returns something like "300 123 4567" or "(912) 345-6789"
      const national = example.formatNational();
      const international = example.formatInternational();
      console.log(`${country}:`);
      console.log(`  National example:      "${national}"`);
      console.log(`  International example: "${international}"`);
    } else {
      console.log(`${country}: No example number found`);
    }
  }
} catch (e) {
  console.error("Error loading examples:", e.message);
}
