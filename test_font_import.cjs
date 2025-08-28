// Test font import dependencies
const fs = require('fs');
const path = require('path');

// Import the compiler properly
const { NodeCompiler } = require('@myriaddreamin/typst-ts-node-compiler');

console.log('=== Font Import Dependency Test ===\n');

// Check if font files exist
const fontPaths = [
  './STIXTwoMath-Regular.otf',
  './assets/fonts/STIXTwoMath-Regular.otf', 
  './public/fonts/STIXTwoMath-Regular.otf'
];

console.log('1. Checking font file existence:');
fontPaths.forEach(fontPath => {
  const exists = fs.existsSync(fontPath);
  console.log(`   ${fontPath}: ${exists ? '✓' : '✗'}`);
});

// Check environment variables
console.log('\n2. Checking environment variables:');
console.log(`   TYPST_FONT_PATHS: ${process.env.TYPST_FONT_PATHS || 'not set'}`);
console.log(`   TYPST_FONT_PATH: ${process.env.TYPST_FONT_PATH || 'not set'}`);

// Test basic HTML compilation
console.log('\n3. Testing basic HTML compilation:');
let compiler;
try {
  compiler = new NodeCompiler();
  console.log('   ✓ NodeCompiler created successfully');
} catch (error) {
  console.log('   ✗ Failed to create NodeCompiler:', error.message);
  console.log('\n=== Font Import Dependency Test Complete ===');
  process.exit(1);
}

// Test 1: Simple HTML export without math
try {
  const simpleContent = `
#set page(paper: "a4")
= Simple Test
This is basic text content.
  `;
  
  fs.writeFileSync('./test_simple.typ', simpleContent);
  const result = compiler.compile('html', './test_simple.typ', {
    fontPaths: ['.', 'assets/fonts', 'public/fonts'],
  });
  console.log('   ✓ Simple HTML compilation successful');
} catch (error) {
  console.log(`   ✗ Simple HTML compilation failed: ${error.message}`);
}

// Test 2: HTML export with basic math
try {
  const mathContent = `
#set page(paper: "a4")
= Math Test
Basic math: $x + y = z$
  `;
  
  fs.writeFileSync('./test_math.typ', mathContent);
  const result = compiler.compile('html', './test_math.typ', {
    fontPaths: ['.', 'assets/fonts', 'public/fonts'],
  });
  console.log('   ✓ Basic math HTML compilation successful');
} catch (error) {
  console.log(`   ✗ Basic math HTML compilation failed: ${error.message}`);
}

// Test 3: HTML export with STIX font
try {
  const stixContent = `
#set page(paper: "a4")
#show math.equation: set text(font: "STIX Two Math")
= STIX Font Test
Math with STIX: $sum_(i=1)^n i$
  `;
  
  fs.writeFileSync('./test_stix.typ', stixContent);
  const result = compiler.compile('html', './test_stix.typ', {
    fontPaths: ['.', 'assets/fonts', 'public/fonts'],
  });
  console.log('   ✓ STIX font HTML compilation successful');
} catch (error) {
  console.log(`   ✗ STIX font HTML compilation failed: ${error.message}`);
}

// Cleanup test files
['./test_simple.typ', './test_math.typ', './test_stix.typ'].forEach(file => {
  if (fs.existsSync(file)) {
    fs.unlinkSync(file);
  }
});

console.log('\n=== Font Import Dependency Test Complete ===');