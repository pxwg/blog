export type Language = 'zh' | 'en';

/**
 * Global Language State Manager
 * Handles persistent language preferences across the entire application
 */
export class GlobalLanguageState {
  private static readonly STORAGE_KEY = 'blog-language-preference';
  private static _instance: GlobalLanguageState | null = null;
  private _updatingLanguage: boolean = false;
  
  private constructor() {}
  
  static getInstance(): GlobalLanguageState {
    if (!GlobalLanguageState._instance) {
      GlobalLanguageState._instance = new GlobalLanguageState();
    }
    return GlobalLanguageState._instance;
  }
  
  /**
   * Get the stored language preference from localStorage
   */
  getStoredLanguage(): Language | null {
    if (typeof window === 'undefined') return null;
    
    try {
      const stored = localStorage.getItem(GlobalLanguageState.STORAGE_KEY);
      if (stored === 'en' || stored === 'zh') {
        return stored;
      }
    } catch (e) {
      console.warn('Failed to read language preference from localStorage:', e);
    }
    
    return null;
  }
  
  /**
   * Save language preference to localStorage
   */
  setStoredLanguage(language: Language): void {
    if (typeof window === 'undefined') return;
    
    try {
      localStorage.setItem(GlobalLanguageState.STORAGE_KEY, language);
      
      // Dispatch global event for components to listen
      window.dispatchEvent(new CustomEvent('globalLanguageChanged', { 
        detail: { language } 
      }));
    } catch (e) {
      console.warn('Failed to save language preference to localStorage:', e);
    }
  }
  
  /**
   * Save language preference to localStorage without dispatching events (prevents infinite loops)
   */
  private setStoredLanguageQuiet(language: Language): void {
    if (typeof window === 'undefined') return;
    
    try {
      localStorage.setItem(GlobalLanguageState.STORAGE_KEY, language);
    } catch (e) {
      console.warn('Failed to save language preference to localStorage:', e);
    }
  }
  
  /**
   * Clear stored language preference
   */
  clearStoredLanguage(): void {
    if (typeof window === 'undefined') return;
    
    try {
      localStorage.removeItem(GlobalLanguageState.STORAGE_KEY);
    } catch (e) {
      console.warn('Failed to clear language preference from localStorage:', e);
    }
  }
  
  /**
   * Get current language based on priority:
   * 1. Stored preference
   * 2. URL parameters  
   * 3. Path patterns
   * 4. Default to Chinese
   */
  getCurrentLanguage(): Language {
    // Priority 1: Check stored preference
    const stored = this.getStoredLanguage();
    if (stored) return stored;
    
    // Priority 2: Check URL parameters (client-side only)
    if (typeof window !== 'undefined') {
      const urlParams = new URLSearchParams(window.location.search);
      const langParam = urlParams.get('lang');
      if (langParam === 'en') return 'en';
      
      // Priority 3: Check path patterns
      const path = window.location.pathname;
      if (path.match(/\/blog\/article\/en\/[^\/]+\/?$/)) return 'en';
      if (path.match(/\/blog\/article\/zh\/[^\/]+\/?$/)) return 'zh';
    }
    
    // Priority 4: Default to Chinese
    return 'zh';
  }
  
  /**
   * Switch to a specific language and redirect if necessary
   */
  switchToLanguage(targetLanguage: Language): void {
    if (typeof window === 'undefined') return;
    
    // Save preference
    this.setStoredLanguage(targetLanguage);
    
    // Get current URL info
    const currentPath = window.location.pathname;
    const currentSearch = window.location.search;
    const currentUrl = new URL(window.location.href);
    
    let redirectUrl: string | null = null;
    
    // Handle article pages
    const articleMatch = currentPath.match(/^\/blog\/article\/(.+?)\/?$/);
    if (articleMatch) {
      let articlePath = articleMatch[1];
      let baseArticle = articlePath;
      
      // Extract base article name
      if (articlePath.startsWith('en/')) {
        baseArticle = articlePath.replace(/^en\//, '');
      } else if (articlePath.startsWith('zh/')) {
        baseArticle = articlePath.replace(/^zh\//, '');
      }
      
      // Generate target URL based on language
      if (targetLanguage === 'en') {
        redirectUrl = `/blog/article/en/${baseArticle}/?lang=en`;
      } else {
        redirectUrl = `/blog/article/zh/${baseArticle}/`;
      }
    } else {
      // Handle listing pages (Home, Posts, etc.)
      const newUrl = new URL(currentUrl);
      
      if (targetLanguage === 'en') {
        newUrl.searchParams.set('lang', 'en');
      } else {
        newUrl.searchParams.delete('lang');
      }
      
      redirectUrl = newUrl.pathname + (newUrl.search || '');
    }
    
    // Redirect if URL needs to change
    if (redirectUrl && redirectUrl !== (currentPath + currentSearch)) {
      window.location.href = redirectUrl;
    } else {
      // Just refresh the current page to apply language changes
      window.location.reload();
    }
  }
  
  /**
   * Initialize global language state on page load
   * Updates stored preference based on current URL (for translation disclaimer navigation)
   * Only redirects for listing pages to maintain language consistency
   */
  initialize(): void {
    if (typeof window === 'undefined') return;
    
    const storedLang = this.getStoredLanguage();
    const currentUrlLang = this.getLanguageFromCurrentUrl();
    const currentPath = window.location.pathname;
    const articleMatch = currentPath.match(/^\/blog\/article\/(.+?)\/?$/);
    
    if (articleMatch) {
      // For article pages: Update stored preference to match current article language
      // This handles translation disclaimer navigation correctly
      if (currentUrlLang !== storedLang) {
        this.setStoredLanguageQuiet(currentUrlLang);
      }
    } else {
      // For listing pages: Only redirect if URL parameters don't match preference
      if (storedLang && this.needsRedirectForListingPage(storedLang)) {
        this.switchToLanguage(storedLang);
      }
    }
  }
  
  /**
   * Check if a redirect is needed for listing pages only
   */
  private needsRedirectForListingPage(storedLang: Language): boolean {
    if (typeof window === 'undefined') return false;
    
    // Only apply to listing pages (not article pages)
    const currentPath = window.location.pathname;
    const articleMatch = currentPath.match(/^\/blog\/article\/(.+?)\/?$/);
    
    if (articleMatch) {
      return false; // Never redirect for article pages
    }
    
    // For listing pages (Home, Posts), only redirect if URL parameters don't match preference
    const hasEnParam = window.location.search.includes('lang=en');
    
    if (storedLang === 'en' && !hasEnParam) {
      return true; // Need to add ?lang=en
    }
    
    if (storedLang === 'zh' && hasEnParam) {
      return true; // Need to remove ?lang=en
    }
    
    return false;
  }
  
  /**
   * Get language from current URL (without checking localStorage)
   */
  private getLanguageFromCurrentUrl(): Language {
    if (typeof window === 'undefined') return 'zh';
    
    const urlParams = new URLSearchParams(window.location.search);
    const langParam = urlParams.get('lang');
    if (langParam === 'en') return 'en';
    
    const path = window.location.pathname;
    if (path.match(/\/blog\/article\/en\/[^\/]+\/?$/)) return 'en';
    if (path.match(/\/blog\/article\/zh\/[^\/]+\/?$/)) return 'zh';
    
    return 'zh';
  }
}

// Export singleton instance
export const globalLanguageState = GlobalLanguageState.getInstance();

// Immediate language detection (synchronous, for early use)
export const getImmediateLanguage = (): Language => {
  if (typeof window === 'undefined') return 'zh';
  
  try {
    // Check localStorage first (normal priority)
    const stored = localStorage.getItem('blog-language-preference');
    if (stored === 'en' || stored === 'zh') {
      return stored;
    }
  } catch (e) {
    // localStorage access failed, continue with other methods
  }
  
  // Check URL parameters
  const urlParams = new URLSearchParams(window.location.search);
  const langParam = urlParams.get('lang');
  if (langParam === 'en') return 'en';
  
  // Check path patterns  
  const path = window.location.pathname;
  if (path.match(/\/blog\/article\/en\/[^\/]+\/?$/)) return 'en';
  if (path.match(/\/blog\/article\/zh\/[^\/]+\/?$/)) return 'zh';
  
  // Default to Chinese
  return 'zh';
};

// Client-side initialization script (to be used in pages)
export const initializeGlobalLanguageState = () => {
  if (typeof window !== 'undefined') {
    // Initialize on DOM ready
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', () => {
        globalLanguageState.initialize();
      });
    } else {
      globalLanguageState.initialize();
    }
  }
};

// Early language detection script (runs immediately, before DOM ready)
export const earlyLanguageDetectionScript = `
(function() {
  // Immediate language detection to prevent flickering
  function getStoredLanguage() {
    try {
      const stored = localStorage.getItem('blog-language-preference');
      return (stored === 'en' || stored === 'zh') ? stored : null;
    } catch (e) {
      return null;
    }
  }
  
  function getCurrentUrlLanguage() {
    const urlParams = new URLSearchParams(window.location.search);
    
    const langParam = urlParams.get('lang');
    if (langParam === 'en') return 'en';
    
    const path = window.location.pathname;
    if (path.match(/\\/blog\\/article\\/en\\/[^\\/]+\\/?$/)) return 'en';
    if (path.match(/\\/blog\\/article\\/zh\\/[^\\/]+\\/?$/)) return 'zh';
    
    return 'zh';
  }
  
  function needsRedirect(storedLang, currentUrlLang) {
    if (!storedLang) return false;
    
    const currentPath = window.location.pathname;
    const articleMatch = currentPath.match(/^\\/blog\\/article\\/(.+?)\\/?$/);
    
    if (articleMatch) {
      return false; // Never redirect for article pages - update preference instead
    } else {
      const hasEnParam = window.location.search.includes('lang=en');
      
      if (storedLang === 'en' && !hasEnParam) {
        return true;
      }
      
      if (storedLang === 'zh' && hasEnParam) {
        return true;
      }
      
      return false;
    }
  }
  
  // Check if we need to redirect immediately
  const storedLang = getStoredLanguage();
  const currentUrlLang = getCurrentUrlLanguage();
  
  if (storedLang && needsRedirect(storedLang, currentUrlLang)) {
    // Set a flag to indicate we're about to redirect (prevents content flash)
    document.documentElement.style.visibility = 'hidden';
    
    // Show content after a short delay if redirect doesn't happen
    setTimeout(function() {
      document.documentElement.style.visibility = 'visible';
    }, 100);
  }
  
  // Make immediate language available globally
  window.immediateLanguage = storedLang || currentUrlLang;
})();
`;
