#import "../../typ/templates/blog.typ": *
#show: main.with(
  title: "Test Article",
  desc: [A simple test article],
  date: "2025-08-20",
  tags: ("test",),
)

= Test

This is a simple test article.

No complex math, just text to verify the basic setup works.