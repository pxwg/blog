#!/usr/bin/env node

const { NodeCompiler } = require('@myriaddreamin/typst-ts-node-compiler');

console.log('Testing astro-typst NodeCompiler behavior...');

// This mimics how astro-typst creates the compiler 
function initCompiler() {
    return NodeCompiler.create({
        workspace: "./", // default - this is exactly what astro-typst does
    });
}

const testContent = `
#let math-font = "STIX Two Math"
#show math.equation: set text(font: math-font)
Math equation: $alpha + beta = gamma$
`;

try {
  console.log('Creating compiler the same way astro-typst does...');
  const compiler = initCompiler();
  
  console.log('Compiling with exact same setup as astro-typst...');
  
  const docRes = compiler.compileHtml({
    mainFilePath: 'test.typ',
    inputs: { 'test.typ': testContent }
  });
  
  if (!docRes.result) {
    console.log('Compilation failed - this matches the astro-typst error!');
    console.log('Diagnostics:', docRes.takeDiagnostics());
    docRes.printDiagnostics();
  } else {
    console.log('Compilation succeeded');
    const doc = docRes.result;
    const html = compiler.tryHtml(doc);
    if (!html.result) {
      console.log('HTML generation failed');
      html.printDiagnostics();
    } else {
      console.log('HTML generation succeeded');
    }
  }
  
} catch (error) {
  console.error('Error:', error.message);
}