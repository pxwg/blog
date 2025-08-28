#!/usr/bin/env node

const { NodeCompiler } = require('@myriaddreamin/typst-ts-node-compiler');

console.log('Testing with disabled math font...');

function initCompiler() {
    return NodeCompiler.create({
        workspace: "./",
    });
}

const testContent = `
#import "typ/templates/shared.typ": *

Math equation: $alpha + beta = gamma$

This should work now with default fonts.
`;

try {
  const compiler = initCompiler();
  
  const docRes = compiler.compileHtml({
    mainFilePath: 'test.typ',
    inputs: { 'test.typ': testContent }
  });
  
  if (docRes.result) {
    console.log('✅ Compilation with disabled math font works!');
  } else {
    console.log('❌ Still failing');
    console.log('Diagnostics:', docRes.takeDiagnostics());
    docRes.printDiagnostics();
  }
  
} catch (error) {
  console.log('❌ Error:', error.message);
}