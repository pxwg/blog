#!/usr/bin/env node

const { NodeCompiler } = require('@myriaddreamin/typst-ts-node-compiler');

console.log('Testing available fonts...');

function initCompiler() {
    return NodeCompiler.create({
        workspace: "./",
    });
}

// Test with different font names
const fonts = [
  "STIX Two Math",
  "Latin Modern Math", 
  "Computer Modern",
  "default",
  "",
  "Times New Roman",
  "serif"
];

for (const font of fonts) {
  const testContent = `
#let math-font = "${font}"
#show math.equation: set text(font: math-font)
Test font "${font}": $alpha + beta = gamma$
`;

  try {
    const compiler = initCompiler();
    const docRes = compiler.compileHtml({
      mainFilePath: 'test.typ',
      inputs: { 'test.typ': testContent }
    });
    
    if (docRes.result) {
      console.log(`✅ Font "${font}" works`);
    } else {
      console.log(`❌ Font "${font}" failed`);
    }
    
  } catch (error) {
    console.log(`❌ Font "${font}" error:`, error.message);
  }
}