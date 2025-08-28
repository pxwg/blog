#!/usr/bin/env node

const { NodeCompiler } = require('@myriaddreamin/typst-ts-node-compiler');

console.log('Testing basic compilation...');

function initCompiler() {
    return NodeCompiler.create({
        workspace: "./",
    });
}

// Very simple test without any font specification
const testContent = `
Basic text without any font specification.

Math equation: $x + y = z$

This should work with default fonts.
`;

try {
  const compiler = initCompiler();
  console.log('Compiler created');
  
  const docRes = compiler.compileHtml({
    mainFilePath: 'test.typ',
    inputs: { 'test.typ': testContent }
  });
  
  if (docRes.result) {
    console.log('✅ Basic compilation works');
    const doc = docRes.result;
    const html = compiler.tryHtml(doc);
    if (html.result) {
      console.log('✅ HTML generation works');
    } else {
      console.log('❌ HTML generation failed');
      html.printDiagnostics();
    }
  } else {
    console.log('❌ Basic compilation failed');
    console.log('Diagnostics:', docRes.takeDiagnostics());
    docRes.printDiagnostics();
  }
  
} catch (error) {
  console.log('❌ Error:', error.message);
  console.log('Stack:', error.stack);
}