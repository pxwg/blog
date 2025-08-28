# Font Deployment Solution

## Problem
The Typst HTML compilation fails in deployment environments with:
```
warning: unknown font family: stix two math
```

This occurs because astro-typst creates NodeCompiler without passing fontPaths configuration from astro.config.mjs, causing fonts to be inaccessible during deployment builds.

## Root Cause Analysis
1. **astro-typst limitation**: The integration creates `NodeCompiler.create({ workspace: "./" })` without fontPaths
2. **Font discovery**: NodeCompiler only checks system font directories and current workspace
3. **Deployment gap**: CI/CD environments don't have STIX fonts installed system-wide

## Solution Implementation

### 1. System Font Installation
Use `scripts/setup-fonts.sh` to install fonts system-wide:
```bash
# For deployment environments
npm run build:deploy
```

### 2. Multiple Font Locations
Fonts are now available in:
- System: `/usr/share/fonts/truetype/stix/`
- Project: `assets/fonts/`
- Public: `public/fonts/` 
- Root: `.`

### 3. Build Scripts
- `npm run build`: Standard build with font paths
- `npm run build:deploy`: Sets up system fonts then builds

## Usage

### Local Development
```bash
npm run build  # Uses local font paths
```

### CI/CD Deployment
```bash
npm run build:deploy  # Sets up system fonts + builds
```

### Manual Setup
```bash
bash scripts/setup-fonts.sh
npm run build
```

## Font Configuration
The astro.config.mjs includes fontPaths configuration:
```javascript
typst({
  options: {
    fontPaths: [".", "assets/fonts", "public/fonts"],
  }
})
```

However, due to astro-typst limitations, system font installation is required for deployment environments.

## Verification
Check font availability:
```bash
fc-list | grep -i stix
```

## Future Improvements
When astro-typst is updated to properly pass fontPaths to NodeCompiler, the system font installation step can be removed.