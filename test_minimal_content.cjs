#!/usr/bin/env node

const { NodeCompiler } = require('@myriaddreamin/typst-ts-node-compiler');

console.log('Testing minimal content without imports...');

function initCompiler() {
    return NodeCompiler.create({
        workspace: "./",
    });
}

const testContent = `
Hello world!

Math: $x + y = z$
`;

try {
  const compiler = initCompiler();
  
  const docRes = compiler.compileHtml({
    mainFilePath: 'minimal.typ',
    inputs: { 'minimal.typ': testContent }
  });
  
  if (docRes.result) {
    console.log('✅ Minimal test works!');
  } else {
    console.log('❌ Even minimal test fails');
    console.log('Diagnostics:', docRes.takeDiagnostics());
  }
  
} catch (error) {
  console.log('❌ Error:', error.message);
}