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
