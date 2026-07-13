const fs = require('fs');
const path = require('path');

try {
  const { getCountries, getCountryCallingCode, AsYouType } = require('libphonenumber-js');
  console.log("Successfully loaded libphonenumber-js");
  
  const countries = getCountries();
  console.log(`Total countries in libphonenumber-js: ${countries.length}`);
  
  // Print details for a few countries to inspect metadata structure
  const sample = ['AF', 'AR', 'US', 'ES'];
  for (const country of sample) {
    const callingCode = getCountryCallingCode(country);
    console.log(`\nCountry: ${country}, Calling Code: ${callingCode}`);
    
    // Test AsYouType formatter to see how it formats
    const formatter = new AsYouType(country);
    formatter.input('912345678');
    console.log(`AsYouType format for 912345678: ${formatter.formattedOutput || formatter.input}`);
  }
} catch (e) {
  console.error("Error loading libphonenumber-js:", e.message);
}
