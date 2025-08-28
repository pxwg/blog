#!/bin/bash

echo "=== Minimal HTML Export Tests ==="
echo

# Test 1: Simplest possible typst document
echo "1. Testing absolute minimal HTML export:"
cat > test_absolute_minimal.typ << 'EOF'
= Hello World
This is text.
EOF

echo "   Created minimal document without any font specifications"

# Test 2: Document with default fonts only  
echo "2. Testing with system default fonts:"
cat > test_default_fonts.typ << 'EOF'
#set page(paper: "a4")
= Default Fonts Test
Regular text content.
Math: $x + y = z$
EOF

echo "   Created document using system defaults"

# Test 3: Document with explicit font that should exist
echo "3. Testing with available font:"
cat > test_available_font.typ << 'EOF'
#set page(paper: "a4") 
#set text(font: "DejaVu Sans", size: 12pt)
= Available Font Test
This uses DejaVu Sans which should be available.
Math: $a^2 + b^2 = c^2$
EOF

echo "   Created document with commonly available font"

# Test 4: STIX font test with full path
echo "4. Testing STIX font with different approaches:"
cat > test_stix_variations.typ << 'EOF'
#set page(paper: "a4")

= STIX Font Tests

== Test 1: Default math
Default math font: $sum_(i=1)^n i$

== Test 2: Explicit STIX (original name)
#show math.equation: set text(font: "STIX Two Math")
STIX explicit: $integral_0^1 x d x$

== Test 3: Lowercase STIX
#show math.equation: set text(font: "stix two math")  
STIX lowercase: $lim_(x -> infinity) f(x)$

== Test 4: File-based font reference
#show math.equation: set text(font: ("STIXTwoMath-Regular.otf",))
STIX file reference: $sum_(k=0)^infinity x^k$
EOF

echo "   Created STIX font variation tests"

echo
echo "5. Checking if we can identify HTML export issues by examining astro-typst source:"

# Check astro-typst configuration in node_modules
if [ -f "node_modules/.pnpm/astro-typst@0.9.0-rc1*/node_modules/astro-typst/package.json" ]; then
    echo "   ✓ Found astro-typst package"
    echo "   Version info:"
    grep -A2 -B2 "version\|typst" node_modules/.pnpm/astro-typst@*/node_modules/astro-typst/package.json 2>/dev/null | head -5
else
    echo "   ✗ astro-typst package not found in expected location"
fi

echo
echo "6. Testing environment with different font paths:"
echo "   Current TYPST_FONT_PATHS: ${TYPST_FONT_PATHS:-not set}"

# Test with font path including current directory
export TYPST_FONT_PATHS=".:$PWD:assets/fonts:public/fonts"
echo "   Set TYPST_FONT_PATHS to: $TYPST_FONT_PATHS"

echo
echo "=== Test files created for manual inspection ==="
ls -la test_*.typ
echo
echo "=== Minimal HTML Export Tests Complete ==="