#!/bin/bash

echo "=== HTML Export and Font Import Dependency Diagnosis ==="
echo

echo "1. Checking template import dependencies:"
echo "   Templates that content files are trying to import:"
grep -r "#import" content/ | head -5
echo

echo "2. Checking if templates directory exists:"
if [ -d "typ/templates" ]; then
    echo "   ✓ typ/templates directory exists"
    ls -la typ/templates/
else
    echo "   ✗ typ/templates directory missing"
    echo "   Current typ directory contents:"
    ls -la typ/
fi
echo

echo "3. Checking font files and paths:"
echo "   Current font files in project root:"
ls -la *.otf *.ttf 2>/dev/null || echo "   No font files in root"
echo
echo "   Font directories:"
for dir in assets/fonts public/fonts; do
    if [ -d "$dir" ]; then
        echo "   ✓ $dir exists:"
        ls -la "$dir" | head -3
    else
        echo "   ✗ $dir missing"
    fi
done
echo

echo "4. Testing minimal HTML compilation (without templates):"
cat > test_minimal_standalone.typ << 'EOF'
#set page(paper: "a4")
#set text(font: "Linux Libertine", size: 12pt)

= HTML Export Test

Basic text content.

== Simple Math Test
Basic math: $x + y = z$

More complex:
$ f(x) = sum_(i=1)^n i = (n(n+1))/2 $
EOF

echo "   Created minimal test file without template dependencies"
echo "   Trying direct typst compilation..."
if command -v typst &> /dev/null; then
    typst compile test_minimal_standalone.typ test_output.html --format html 2>&1 | head -10
else
    echo "   ✗ typst command not available"
fi
echo

echo "5. Environment variables check:"
echo "   TYPST_FONT_PATHS: ${TYPST_FONT_PATHS:-not set}"
echo "   TYPST_FONT_PATH: ${TYPST_FONT_PATH:-not set}"
echo

echo "=== Diagnosis Complete ==="