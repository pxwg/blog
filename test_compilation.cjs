const { NodeCompiler } = require('@myriaddreamin/typst-ts-node-compiler');

const compiler = new NodeCompiler();

// Try to compile the test file
try {
  const result = compiler.compile('html', '/tmp/simple_math_test.typ', {
    fontPaths: ['assets/fonts', 'public/fonts'],
  });
  console.log('Compilation successful');
  console.log(result);
} catch (error) {
  console.error('Compilation failed:', error.message);
}