const fs = require('fs');
const path = require('path');

try {
  const mainPath = require.resolve('libphonenumber-js');
  console.log("Main path of libphonenumber-js:", mainPath);
  
  // Find directory of the package
  let current = mainPath;
  while (!current.endsWith('libphonenumber-js') && current !== path.dirname(current)) {
    current = path.dirname(current);
  }
  console.log("Package directory:", current);
  
  // Now list files in package directory
  function searchDir(dir) {
    const files = fs.readdirSync(dir);
    for (const file of files) {
      const fullPath = path.join(dir, file);
      const stat = fs.statSync(fullPath);
      if (stat.isDirectory()) {
        if (file !== 'node_modules') {
          searchDir(fullPath);
        }
      } else if (file.endsWith('.json')) {
        console.log(fullPath);
      }
    }
  }
  searchDir(current);
} catch (e) {
  console.error("Error finding package:", e.message);
}
