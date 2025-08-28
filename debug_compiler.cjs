// Debug typst compiler module
const typstCompiler = require('@myriaddreamin/typst-ts-node-compiler');

console.log('=== Typst Compiler Module Debug ===');
console.log('Type:', typeof typstCompiler);
console.log('Constructor:', typstCompiler.constructor.name);
console.log('Available properties and methods:');

if (typeof typstCompiler === 'object') {
  const props = Object.getOwnPropertyNames(typstCompiler);
  const prototypeMethods = Object.getOwnPropertyNames(Object.getPrototypeOf(typstCompiler));
  
  console.log('Properties:', props);
  console.log('Prototype methods:', prototypeMethods);
  
  // Try to find compilation methods
  for (const prop of props) {
    if (typeof typstCompiler[prop] === 'function') {
      console.log(`Method: ${prop}`);
    }
  }
}

// Check if it's the actual compiler instance
if (typstCompiler && typeof typstCompiler.compile === 'function') {
  console.log('This appears to be a compiler instance, not a constructor');
} else if (typstCompiler && typstCompiler.NodeCompiler) {
  console.log('NodeCompiler is available as property');
  console.log('NodeCompiler type:', typeof typstCompiler.NodeCompiler);
}

console.log('=== Debug Complete ===');