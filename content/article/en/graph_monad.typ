#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *
#let title = "Feynman Rule as a Monad"
#show: main.with(
  title: title,
  desc: [The definition of Feynman rules can be captured using the language of monad, and the "renormalization" procedure corresponds to the bar construction.],
  date: "2025-12-11",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.topology,
    blog-tags.abstract-nonsense,
  ),
  lang: "en",
  translationKey: "graph_monad",
)
