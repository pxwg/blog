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


export function exists(articleId: string, posts: BlogPost[]): boolean {
  const normalizedId = articleId.replace(/^en\//, '').replace(/^zh\//, '');
  return posts.some((post: BlogPost) =>
    post.id === articleId ||
    post.id === `en/${normalizedId}` ||
    post.id === `zh/${normalizedId}`
  );
}

/**
 * Classify an article by its ID to determine its language
 * rules:
 * - If it starts with 'en/', it's English
 * - If it starts with 'zh/', it's Chinese
 * - If it has no prefix, its language is the opposite of the same-named post with en/xxx or zh/xxx.
 */
export function getArticleLanguage(articleId: string, posts: BlogPost[]): Language {
  if (articleId.startsWith('en/')) return 'en';
  if (articleId.startsWith('zh/')) return 'zh';

  const baseId = articleId.replace(/^en\//, '').replace(/^zh\//, '');

  if (posts.some(post => post.id === `en/${baseId}`)) return 'zh';
  if (posts.some(post => post.id === `zh/${baseId}`)) return 'en';

  return 'zh';
}

/**
 * Filter blog posts by language preference
 */
export function filterPostsByLanguage(posts: BlogPost[], language: Language): BlogPost[] {
  return posts.filter(post => {
    const articleLang = getArticleLanguage(post.id, posts);
    return articleLang === language;
  });
}

/**
 * Generate language toggle URLs for listing pages
 */
export function getListingLanguageUrls(currentUrl: URL) {
  // Create URLs with language parameters for consistent navigation
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
