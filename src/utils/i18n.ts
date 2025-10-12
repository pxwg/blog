/**
 * i18n utilities for language configuration and routing
 */

import { kUrlBase } from "$consts";

export type Language = 'zh' | 'en';

export interface LanguageConfig {
  htmlLang: string;
  title: string;
  description?: string;
  tagListLang?: string;
  modifiedDate?: Date;
}

export interface PageLanguageConfig {
  [key: string]: {
    zh: LanguageConfig;
    en: LanguageConfig;
  };
}

export interface TranslationStrings {
  switchToChinese: string;
  switchToEnglish: string;
  translationNotice: {
    zh: string;
    en: string;
  };
}

/**
 * Centralized language configuration for all pages
 */
export const pageLanguageConfig: PageLanguageConfig = {
  about: {
    zh: {
      htmlLang: "zh",
      title: "关于我",
      description: "关于pxwg",
      tagListLang: "zh"
    },
    en: {
      htmlLang: "en",
      title: "About me",
      description: "Things about pxwg",
      tagListLang: undefined
    }
  },
  friend: {
    zh: {
      htmlLang: "zh",
      title: "友链",
      tagListLang: "zh"
    },
    en: {
      htmlLang: "en",
      title: "Friend Links",
      tagListLang: undefined
    }
  },
  articleIndex: {
    zh: {
      htmlLang: "zh",
      title: "全部文章",
      tagListLang: "zh"
    },
    en: {
      htmlLang: "en",
      title: "All Posts",
      tagListLang: undefined
    }
  },
  index: {
    zh: {
      htmlLang: "zh",
      title: "最近文章",
      tagListLang: "zh"
    },
    en: {
      htmlLang: "en",
      title: "Recent Posts",
      tagListLang: undefined
    }
  }
};

/**
 * Centralized translation strings
 */
export const translations: TranslationStrings = {
  switchToChinese: "切换到中文",
  switchToEnglish: "Switch to English",
  translationNotice: {
    zh: "📝 翻译声明：本文由 LLM 从原文翻译而来，可能存在翻译不准确之处。建议阅读 <a href=\"{targetPath}\">原文</a> 以获得最准确的内容。",
    en: "📝 Translation Notice: This article was translated from the original by LLM and may contain inaccuracies. Please refer to the <a href=\"{targetPath}\">original article</a> for the most accurate content."
  }
};

/**
 * Get current language from URL path
 */
export function getCurrentLanguage(urlPath: string): Language {
  if (urlPath.startsWith('/zh/')) return 'zh';
  if (urlPath.startsWith('/en/')) return 'en';
  return 'en'; // default
}

/**
 * Get target language (opposite of current)
 */
export function getTargetLanguage(currentLang: Language): Language {
  return currentLang === 'zh' ? 'en' : 'zh';
}

/**
 * Get language configuration for a page
 */
export function getLanguageConfig(
  pageKey: keyof PageLanguageConfig,
  lang: Language
): LanguageConfig {
  const config = pageLanguageConfig[pageKey]?.[lang];
  if (!config) {
    throw new Error(`Language configuration not found for page '${pageKey}' and language '${lang}'`);
  }
  return config;
}

/**
 * Generate language toggle links for any page
 */
export function generateLanguageLinks(
  currentPath: string,
  currentLang: Language
): { zh: string; en: string; current: Language } {
  const targetLang = getTargetLanguage(currentLang);

  // Handle article pages
  const articleMatch = currentPath.match(/\/(en|zh)\/article\/([^/]+)/);
  if (articleMatch) {
    const articleSlug = articleMatch[2];
    return {
      zh: `${kUrlBase}/zh/article/${articleSlug}/`,
      en: `${kUrlBase}/en/article/${articleSlug}/`,
      current: currentLang
    };
  }

  // Handle other pages
  const pageMatch = currentPath.match(/\/(en|zh)\/([^/]*)/);
  if (pageMatch) {
    const pagePath = pageMatch[2] || '';
    return {
      zh: `${kUrlBase}/zh/${pagePath}`,
      en: `${kUrlBase}/en/${pagePath}`,
      current: currentLang
    };
  }

  // Handle about page
  if (currentPath.includes('/about')) {
    return {
      zh: `${kUrlBase}/zh/about/`,
      en: `${kUrlBase}/en/about/`,
      current: currentLang
    };
  }

  // Default case (home page)
  return {
    zh: `${kUrlBase}/zh/`,
    en: `${kUrlBase}/en/`,
    current: 'en'
  };
}

/**
 * Generate target path for language switching
 */
export function generateTargetPath(
  currentPath: string,
  targetLang: Language
): string {
  const currentLang = getCurrentLanguage(currentPath);

  // If already on the target language, return current path
  if (currentLang === targetLang) {
    return currentPath;
  }

  // Replace language prefix
  return currentPath.replace(`/${currentLang}/`, `/${targetLang}/`);
}

/**
 * Get translation disclaimer text
 */
export function getTranslationDisclaimer(
  locale: Language,
  targetPath: string
): string {
  const template = translations.translationNotice[locale];
  return template.replace('{targetPath}', targetPath);
}

/**
 * Safe language configuration getter with fallback
 */
export function getSafeLanguageConfig(
  pageKey: keyof PageLanguageConfig,
  lang: Language,
  fallbackConfig?: Partial<LanguageConfig>
): LanguageConfig {
  try {
    return getLanguageConfig(pageKey, lang);
  } catch (error) {
    console.warn(`Failed to get language config for ${pageKey}.${lang}:`, error);

    // Return safe fallback
    return {
      htmlLang: lang,
      title: fallbackConfig?.title || `Page - ${lang}`,
      description: fallbackConfig?.description,
      tagListLang: fallbackConfig?.tagListLang,
      modifiedDate: fallbackConfig?.modifiedDate
    };
  }
}