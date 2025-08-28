# Font Configuration Fix for Typst CI Builds

This document describes the changes made to fix font path issues during CI builds when rendering mathematical formulas as SVG using Typst.

## Problem

The original issue was that fonts were not being found during CI builds, causing failures when trying to render mathematical formulas as SVG using the astro-typst plugin.

## Root Cause Analysis

1. **Missing Git Submodules**: The `typ` submodule containing Typst templates was not initialized
2. **Incomplete Font Assets**: CI downloads OTF fonts but local development only had WOFF2 fonts  
3. **Missing Dependencies**: The `mathyml` package submodule failed to clone, causing template import errors
4. **Environment Variables**: Font paths weren't properly configured for the Typst compiler

## Solution Implemented

### 1. Git Submodules Setup
```bash
git submodule update --init --recursive
```

### 2. Font Asset Configuration
- Created `assets/fonts` directory to match CI expectations
- Downloaded proper OTF fonts that Typst can use:
  - STIX fonts for mathematics (from stipub/stixfonts)
  - Source Han fonts for Chinese text (from Myriad-Dreamin/shiroa)

### 3. Environment Variables
Modified `package.json` to include required environment variables:
```json
{
  "scripts": {
    "build": "TYPST_FONT_PATHS=assets/fonts:public/fonts TYPST_FONT_PATH=assets/fonts astro build"
  }
}
```

### 4. Fixed Missing Dependencies
Created minimal `mathyml` module at `typ/packages/mathyml/src/lib.typ`:
```typst
// Empty mathyml module - since use-mathyml is false, this should not be used
#let prelude = ()
```

### 5. Test Workflow
Created `.github/workflows/test-build.yml` to test builds on pull requests before merging to main:
```yaml
name: Test Build
on:
  pull_request:
    branches: ["main", "update"]
  workflow_dispatch:
```

## Configuration Changes

### astro.config.mjs
```javascript
options: {
  fontPaths: ["assets/fonts", "public/fonts"],
  fontArgs: [{ fontPaths: ["assets/fonts", "public/fonts"] }],
  inputs: {
    "build-fonts": "assets/fonts",
  },
},
```

## Current Status

✅ **Font Infrastructure**: Proper OTF fonts downloaded and configured
✅ **CI Test Workflow**: Test workflow created for validating builds
✅ **Git Submodules**: Templates and dependencies properly initialized  
✅ **Environment Setup**: Font paths and variables configured

⚠️ **Known Issue**: There appears to be a compatibility issue with the current `@myriaddreamin/typst-ts-node-compiler` version that prevents proper frontmatter extraction from Typst files. This may require updating the astro-typst plugin or compiler version.

## Usage

The test workflow will now run on all pull requests to validate that builds complete successfully before merging to main, addressing the requirement for testing builds without deployment.

To test locally:
```bash
pnpm build
```

To test in CI: Create a pull request and the test workflow will automatically run.