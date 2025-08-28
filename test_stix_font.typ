// Test specifically for STIX font issues
#set page(paper: "a4")

// Test different font name variations for STIX Two Math
#let test-fonts = ("STIX Two Math", "stix two math", "STIXTwoMath-Regular")

= STIX Font Dependency Test

== Default Math Font Test
Default math rendering:
$ sum_(i=1)^n i = (n(n+1))/2 $

== STIX Font Tests
#for font-name in test-fonts [
  Trying font: #font-name
  
  #show math.equation: set text(font: font-name)
  $ integral_0^infinity e^(-x^2) d x = sqrt(pi)/2 $
  
]

== Font Path Test
Checking if STIX font file is accessible at expected locations.