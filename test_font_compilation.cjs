#!/usr/bin/env node

const { NodeCompiler } = require('@myriaddreamin/typst-ts-node-compiler');
const fs = require('fs');
const path = require('path');

console.log('Testing font compilation...');

// Set font paths
process.env.TYPST_FONT_PATHS = '.:assets/fonts:public/fonts';
process.env.TYPST_FONT_PATH = '.';

const testContent = `
#import "typ/templates/shared.typ": *

// Test if the math font is available during build  
$x = 1 + 2$

This should compile with math font: $alpha + beta = gamma$
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
  console.log('Compiling test content...');
  
  const result = compiler.compile({
    mainFilePath: 'test.typ',
    format: 'html'
  }, {
    'test.typ': testContent
  });
  
  console.log('Compilation successful!');
  console.log('Result type:', typeof result);
  console.log('Result length:', result?.length || 'N/A');
  
} catch (error) {
  console.error('Compilation failed:');
  console.error('Error name:', error.name);
  console.error('Error message:', error.message);
  console.error('Error stack:', error.stack);
}