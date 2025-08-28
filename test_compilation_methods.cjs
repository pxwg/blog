#!/usr/bin/env node

const { NodeCompiler } = require('@myriaddreamin/typst-ts-node-compiler');

console.log('Testing different compilation methods...');

function initCompiler() {
    return NodeCompiler.create({
        workspace: "./",
    });
}

const testContent = `Basic text without any font specification.`;

try {
  const compiler = initCompiler();
  console.log('Compiler created');
  
  console.log('\n1. Testing compile() method (like my earlier successful test):');
  try {
    const result1 = compiler.compile({
      mainFilePath: 'test.typ',
      format: 'html'
    }, {
      'test.typ': testContent
    });
    console.log('✅ compile() method works');
    console.log('Result type:', typeof result1);
  } catch (e) {
    console.log('❌ compile() method failed:', e.message);
  }
  
  console.log('\n2. Testing compileHtml() method (like astro-typst uses):');
  try {
    const docRes = compiler.compileHtml({
      mainFilePath: 'test.typ',
      inputs: { 'test.typ': testContent }
    });
    
    if (docRes.result) {
      console.log('✅ compileHtml() works');
    } else {
      console.log('❌ compileHtml() failed');
      console.log('Diagnostics:', docRes.takeDiagnostics());
    }
  } catch (e) {
    console.log('❌ compileHtml() method failed:', e.message);
  }
  
} catch (error) {
  console.log('❌ Overall error:', error.message);
}