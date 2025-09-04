export interface BlogPost {
  id: string;
  data: {
    title: string;
    date: Date;
    description?: string;
    tags?: string[];
    [key: string]: any;
  };
}

export type Language = 'zh' | 'en';

/**
 * Get the language preference from URL search parameters
 */
export function getLanguageFromUrl(url: URL): Language {
  const langParam = url.searchParams.get('lang');
  if (langParam === 'en') return 'en';
  return 'zh'; // Default to Chinese
}

/**
 * Classify an article by its ID to determine its language
 */
export function getArticleLanguage(articleId: string): Language {
  // Articles in 'en/' folder are English articles
  if (articleId.startsWith('en/')) return 'en';
  
  // Articles in 'zh/' folder are Chinese articles  
  if (articleId.startsWith('zh/')) return 'zh';
  
  // Base articles (no language prefix) are considered Chinese
  return 'zh';
}

/**
 * Filter blog posts by language preference
 */
export function filterPostsByLanguage(posts: BlogPost[], language: Language): BlogPost[] {
  return posts.filter(post => {
    const articleLang = getArticleLanguage(post.id);
    return articleLang === language;
  });
}

/**
 * Generate language toggle URLs for listing pages
 */
export function getListingLanguageUrls(currentUrl: URL) {
  const baseUrl = currentUrl.pathname;
  
  // Create URLs with language parameters
  const zhUrl = new URL(currentUrl);
  zhUrl.searchParams.delete('lang'); // Chinese is default, no param needed
  
  const enUrl = new URL(currentUrl);
  enUrl.searchParams.set('lang', 'en');
  
  const currentLang = getLanguageFromUrl(currentUrl);
  
  return {
    zh: zhUrl.pathname + (zhUrl.search || ''),
    en: enUrl.pathname + enUrl.search,
    current: currentLang
  };
}