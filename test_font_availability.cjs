#!/usr/bin/env node

const { NodeCompiler } = require('@myriaddreamin/typst-ts-node-compiler');
const fs = require('fs');
const path = require('path');

console.log('Testing font availability...');

// Set font paths
process.env.TYPST_FONT_PATHS = '.:assets/fonts:public/fonts';
process.env.TYPST_FONT_PATH = '.';

// Create a test that specifically uses the problematic font
const testContent = `
#let math-font = "STIX Two Math"

#show math.equation: set text(font: math-font)

Math equation: $alpha + beta = gamma$

Available fonts test:
#text(font: "STIX Two Math")[STIX Two Math font test]
#text(font: "stix two math")[stix two math font test] 
#text(font: "STIXTwoMath-Regular")[STIXTwoMath-Regular font test]
`;

try {
  console.log('Creating compiler...');
  const compiler = NodeCompiler.create({
    fontPaths: ['.' ,'assets/fonts', 'public/fonts'],
    inputs: {
      'fonts': './assets/fonts'
    }
  });
  
  console.log('Compiler created successfully');
  console.log('Compiling font test...');
  
  const result = compiler.compile({
    mainFilePath: 'font_test.typ',
    format: 'html'
  }, {
    'font_test.typ': testContent
  });
  
  console.log('Compilation successful!');
  console.log('Result type:', typeof result);
  console.log('Result keys:', Object.keys(result));
  
  // Try to extract warnings or output
  if (result) {
    // Check if it's a buffer or has specific properties
    if (result.warnings) {
      console.log('Warnings:', result.warnings);
    }
    if (result.output) {
      fs.writeFileSync('font_test_output.html', result.output);
      console.log('Output written to font_test_output.html');
    }
    if (Buffer.isBuffer(result)) {
      fs.writeFileSync('font_test_output.html', result);
      console.log('Buffer output written to font_test_output.html');
    }
    if (typeof result === 'string') {
      fs.writeFileSync('font_test_output.html', result);
      console.log('String output written to font_test_output.html');
    }
  }
  
} catch (error) {
  console.error('Compilation failed:');
  console.error('Error name:', error.name);
  console.error('Error message:', error.message);
  if (error.message.includes('unknown font')) {
    console.error('This confirms the font is not being found during compilation');
  }
}