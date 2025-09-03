#import "../../typ/templates/blog.typ": *

#show: main.with(
  title: "Test Localization",
  desc: [A simple test for localization features.],
  date: "2025-09-03",
  tags: (
    blog-tags.misc,
  ),
)

= Test Article

This is a test article to verify the localization system works correctly.

The language toggle should be visible in the header, and this content should be accessible through the blog system.