# Translation Disclaimer Link Generation Guide

This document outlines how translation disclaimer links should be generated in the new simplified blog architecture where all Chinese articles are in `/zh/` subdirectory and English articles are in `/en/` subdirectory.

## Architecture Overview

### Folder Structure
```
content/article/
├── zh/
│   ├── article1.typ  # Chinese articles
│   ├── article2.typ
│   └── ...
├── en/
│   ├── article1.typ  # English articles
│   ├── article2.typ
│   └── ...
└── assets/
    └── ...
```

### URL Structure
- Chinese articles: `/blog/article/zh/article-name/`
- English articles: `/blog/article/en/article-name/?lang=en`

## Translation Disclaimer Link Generation

### Template Usage

In your Typst articles, use the `translation-disclaimer` function with just the article name:

```typst
#import "../../../typ/templates/translation-disclaimer.typ": (
  translation-disclaimer,
)

// For Chinese articles pointing to English version:
#translation-disclaimer(
  original-path: "article-name",  // Just the article name
  lang: "zh",
)

// For English articles pointing to Chinese version:
#translation-disclaimer(
  original-path: "article-name",  // Just the article name  
  lang: "en",
)
```

### Link Generation Logic

The `translation-disclaimer` template automatically generates appropriate URLs:

1. **From Chinese to English**:
   - Input: `original-path: "article-name"`, `lang: "zh"`
   - Generated URL: `/blog/article/en/article-name/?lang=en`

2. **From English to Chinese**:
   - Input: `original-path: "article-name"`, `lang: "en"`
   - Generated URL: `/blog/article/zh/article-name/`

### URL Consistency Rules

1. **English URLs**: Always include `?lang=en` parameter for consistency with global language state
2. **Chinese URLs**: Never include language parameters (default behavior)
3. **Absolute URLs**: All generated links use absolute paths starting with `/blog/article/`

### Examples

#### Chinese Article (zh/typst_md_tex.typ)
```typst
#translation-disclaimer(
  original-path: "typst_md_tex",  // Clean article name
  lang: "zh",
)
```
Generates link to: `/blog/article/en/typst_md_tex/?lang=en`

#### English Article (en/typst_md_tex.typ)
```typst
#translation-disclaimer(
  original-path: "typst_md_tex",  // Clean article name
  lang: "en",
)
```
Generates link to: `/blog/article/zh/typst_md_tex/`

## Integration with Global Language State

Translation disclaimer links now work seamlessly with the global language toggle system:

1. **Standard URL Generation**: Disclaimer links use the same URL patterns as language toggle buttons
2. **Preference Updates**: Clicking disclaimer links automatically updates the stored language preference  
3. **No Redirect Conflicts**: Articles respect user's explicit navigation choices from disclaimer links
4. **Smooth Transitions**: Language preference persists across all page navigation after using disclaimer links

### How It Works

1. **Translation Disclaimer Navigation**: When users click disclaimer links, they navigate directly to the target language article
2. **Preference Update**: The global language state detects the navigation and updates the stored preference to match
3. **Consistent Experience**: All subsequent navigation (Home, Posts, other articles) respects the updated language preference
4. **No Redirect Loops**: Article pages never force redirects back to stored preferences - they update preferences instead

## Migration Notes

### From Previous Implementation

If you have existing articles with old-style disclaimer paths, they should be updated to use clean article names:

```typst
// Old (problematic):
#translation-disclaimer(
  original-path: "../../en/article-name/?explicit_lang=en",
  lang: "zh",
)

// New (recommended):
#translation-disclaimer(
  original-path: "article-name",  // Just the article name
  lang: "zh",
)
```

### Benefits of New Implementation

1. **Consistency**: All language switching uses the same URL patterns
2. **Reliability**: No conflicts between disclaimer links and language toggles  
3. **Simplicity**: Clean, predictable URL generation with just article names
4. **User Experience**: Translation disclaimer links update language preferences automatically
5. **Maintainability**: Easier to understand and debug language switching behavior