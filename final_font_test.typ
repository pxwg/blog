#set page(paper: "a4")

= Font Import Dependency Test

== Default Math Fonts
Math with defaults: $sum_(i=1)^n i = (n(n+1))/2$

== STIX Two Math Test (if available)
#show math.equation: set text(font: ("STIX Two Math", "STIXTwoMath-Regular"))
STIX math: $integral_0^infinity e^(-x^2) d x = sqrt(pi)/2$

== Font Fallback Test
#set text(font: ("STIX Two Math", "DejaVu Sans", "Arial"))
Text with font fallback chain.
