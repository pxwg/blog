# Blog Localization System

This blog now supports localization with Chinese and English language variants. Here's how the system works:

## Features Implemented

### 1. Language Toggle in Header
- **Location**: Top-right corner of the header, between navigation and theme toggle
- **Languages**: 中文 (Chinese) and EN (English)
- **Visual**: Clean toggle with active state highlighting
- **Responsive**: Adapts to mobile layouts

### 2. Translation Disclaimer System
- **Template**: `typ/templates/translation-disclaimer.typ`
- **Purpose**: Warns users about LLM-translated content accuracy
- **Languages**: Supports both Chinese and English disclaimers
- **Usage**: Automatically includes links to original articles

### 3. Directory Structure
```
content/
├── article/
│   ├── *.typ                    # Original articles (Chinese by default)
│   ├── zh/                      # Chinese translations
│   │   ├── README.md            # Translation disclaimer
│   │   └── *.typ                # Translated articles
│   └── en/                      # English translations
│       ├── README.md            # Translation disclaimer  
│       └── *.typ                # Translated articles
```

## Usage Instructions

### For Content Writers

#### Creating Original Articles
Place original articles in `content/article/*.typ`:

```typst
#import "../../typ/templates/blog.typ": *

#show: main-zh.with(
  // Use main-zh for Chinese, main for English
  title: "Article Title",
  desc: [Article description.],
  date: "2025-09-03",
  tags: (
    blog-tags.programming,
  ),
)

= Content Here
```

#### Creating Translations

1. **For Chinese translations** (`content/article/zh/*.typ`):
```typst
#import "../../../typ/templates/blog.typ": *
#import "../../../typ/templates/translation-disclaimer.typ": (
  translation-disclaimer,
)

#show: main-zh.with(
  title: [Translated Title],
  desc: [Translated description.],
  date: "2025-09-03",
  tags: (
    blog-tags.programming,
  ),
)

#translation-disclaimer(
  original-path: "content/article/original-file.typ",
  lang: "zh",
)
= Translated Content Here
```

2. **For English translations** (`content/article/en/*.typ`):
```typst
#import "../../../typ/templates/blog.typ": *
#import "../../../typ/templates/translation-disclaimer.typ": (
  translation-disclaimer,
)

#show: main.with(
  title: [Translated Title],
  desc: [Translated description.],
  date: "2025-09-03",
  tags: (
    blog-tags.programming,
  ),
)

#translation-disclaimer(
  original-path: "content/article/original-file.typ",
  lang: "en",
)

= Translated Content Here
```

### For Developers

#### Language Toggle Component
The `LanguageToggle.astro` component:
- Automatically detects current language from URL patterns
- Generates appropriate language-specific URLs
- Handles both article and general page navigation
- Passes `articleId` prop for article-specific language switching

#### URL Patterns
- Original: `/blog/article/article-name`
- Chinese: `/blog/article/zh/article-name`  
- English: `/blog/article/en/article-name`

#### Translation Disclaimer Template
Use the `translation-disclaimer.typ` template to add automatic disclaimers:
- Shows colored notice boxes
- Includes links to original articles
- Supports both Chinese and English text
- Customizable original file paths

## File Examples

See the existing localized files for reference:
- `content/article/en/float_and_pin.typ` - English translation with disclaimer
- `content/article/zh/typst_md_tex.typ` - Chinese translation with disclaimer

## Technical Notes

- The language toggle integrates seamlessly with the existing theme system
- Translation disclaimers use Typst's block formatting for visual prominence  
- README files in language directories provide user-friendly explanations
- All localized content is self-contained (no parent file dependencies)

## Future Enhancements

- Automatic content discovery for missing translations
- Language-specific RSS feeds
- SEO meta tags for language variants
