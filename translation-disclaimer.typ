// Translation disclaimer template for blog localization
// Generates disclaimer notices for LLM-translated content

#let translation-disclaimer(original-path: "", lang: "en") = {
  // Convert .typ file path to proper article URL by extracting filename and removing .typ extension
  let filename = original-path.split("/").last()
  let article-name = filename.replace(regex("\.typ$"), "")  // Remove .typ extension using regex
  let article-url = "/article/" + article-name
  
  let disclaimer-text = if lang == "zh" [
    #text(fill: rgb("#888"), size: 0.9em)[
      📝 *翻译声明：* 本文由 LLM 从原文翻译而来，可能存在翻译不准确之处。建议阅读 #link(article-url)[原文] 以获得最准确的内容。
    ]
  ] else [
    #text(fill: rgb("#888"), size: 0.9em)[
      📝 *Translation Notice:* This article was translated from the original by LLM and may contain inaccuracies. Please refer to the #link(article-url)[original article] for the most accurate content.
    ]
  ]
  
  // Add some spacing and styling
  v(0.5em)
  block(
    width: 100%,
    inset: 12pt,
    radius: 6pt,
    fill: rgb("#f8f9fa"),
    stroke: (left: 3pt + rgb("#007acc")),
    disclaimer-text
  )
  v(1em)
}