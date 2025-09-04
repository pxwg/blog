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
   * 1. Explicit language parameter (explicit user choice, highest priority)
   * 2. Stored preference
   * 3. URL parameters  
   * 4. Path patterns
   * 5. Default to Chinese
   */
  getCurrentLanguage(): Language {
    // Priority 1: Check for explicit language parameter (from translation disclaimer clicks)
    if (typeof window !== 'undefined') {
      const urlParams = new URLSearchParams(window.location.search);
      const explicitLang = urlParams.get('explicit_lang');
      if (explicitLang === 'en' || explicitLang === 'zh') {
        // Update stored preference when user explicitly chooses a language
        // Use a flag to prevent recursive calls
        if (!this._updatingLanguage) {
          this._updatingLanguage = true;
          this.setStoredLanguageQuiet(explicitLang);
          this._updatingLanguage = false;
        }
        return explicitLang;
      }
    }
    
    // Priority 2: Check stored preference
    const stored = this.getStoredLanguage();
    if (stored) return stored;
    
    // Priority 3: Check URL parameters (client-side only)
    if (typeof window !== 'undefined') {
      const urlParams = new URLSearchParams(window.location.search);
      const langParam = urlParams.get('lang');
      if (langParam === 'en') return 'en';
      
      // Priority 4: Check path patterns
      const path = window.location.pathname;
      if (path.match(/\/blog\/article\/en\/[^\/]+\/?$/)) return 'en';
      if (path.match(/\/blog\/article\/zh\/[^\/]+\/?$/)) return 'zh';
    }
    
    // Priority 5: Default to Chinese
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
   * Only redirects if absolutely necessary (different article or incompatible URL structure)
   */
  initialize(): void {
    if (typeof window === 'undefined') return;
    
    const storedLang = this.getStoredLanguage();
    const currentUrlLang = this.getLanguageFromCurrentUrl();
    
    // Only redirect if we have a stored preference AND the current URL structure 
    // cannot represent that language (e.g., wrong article language folder)
    if (storedLang && this.needsRedirectForLanguage(storedLang, currentUrlLang)) {
      this.switchToLanguage(storedLang);
    }
  }
  
  /**
   * Check if a redirect is needed to properly display the stored language
   * Do not redirect if user has explicitly chosen a language via translation disclaimer
   */
  private needsRedirectForLanguage(storedLang: Language, currentUrlLang: Language): boolean {
    if (typeof window === 'undefined') return false;
    
    // Don't redirect if user has explicitly chosen a language (e.g., via translation disclaimer)
    const urlParams = new URLSearchParams(window.location.search);
    const explicitLang = urlParams.get('explicit_lang');
    if (explicitLang === 'en' || explicitLang === 'zh') {
      return false; // Respect user's explicit choice
    }
    
    const currentPath = window.location.pathname;
    const articleMatch = currentPath.match(/^\/blog\/article\/(.+?)\/?$/);
    
    if (articleMatch) {
      // For article pages, redirect only if we're on the wrong language version of the article
      const articlePath = articleMatch[1];
      
      if (storedLang === 'en' && !articlePath.startsWith('en/')) {
        // Want English but not on English article - need to check if English version exists
        return true;
      }
      
      if (storedLang === 'zh' && !articlePath.startsWith('zh/')) {
        // Want Chinese but not on Chinese article - need to check if Chinese version exists  
        return true;
      }
      
      // We're already on the correct language version of the article
      return false;
    } else {
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
  }
  
  /**
   * Get language from current URL (without checking localStorage)
   */
  private getLanguageFromCurrentUrl(): Language {
    if (typeof window === 'undefined') return 'zh';
    
    // Check for explicit language parameter first
    const urlParams = new URLSearchParams(window.location.search);
    const explicitLang = urlParams.get('explicit_lang');
    if (explicitLang === 'en' || explicitLang === 'zh') {
      return explicitLang;
    }
    
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
  
  // Check for explicit language parameter first (highest priority)
  const urlParams = new URLSearchParams(window.location.search);
  const explicitLang = urlParams.get('explicit_lang');
  if (explicitLang === 'en' || explicitLang === 'zh') {
    // Update stored preference when user explicitly chooses a language
    // Don't dispatch events to prevent issues during early detection
    try {
      localStorage.setItem('blog-language-preference', explicitLang);
    } catch (e) {
      // localStorage access failed, continue
    }
    return explicitLang;
  }
  
  try {
    // Check localStorage second (normal priority)
    const stored = localStorage.getItem('blog-language-preference');
    if (stored === 'en' || stored === 'zh') {
      return stored;
    }
  } catch (e) {
    // localStorage access failed, continue with other methods
  }
  
  // Check URL parameters
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
    
    // Check for explicit language parameter first
    const explicitLang = urlParams.get('explicit_lang');
    if (explicitLang === 'en' || explicitLang === 'zh') {
      // Update stored preference when user explicitly chooses a language
      // Don't dispatch events to prevent issues during early detection
      try {
        localStorage.setItem('blog-language-preference', explicitLang);
      } catch (e) {
        // localStorage access failed, continue
      }
      return explicitLang;
    }
    
    const langParam = urlParams.get('lang');
    if (langParam === 'en') return 'en';
    
    const path = window.location.pathname;
    if (path.match(/\\/blog\\/article\\/en\\/[^\\/]+\\/?$/)) return 'en';
    if (path.match(/\\/blog\\/article\\/zh\\/[^\\/]+\\/?$/)) return 'zh';
    
    return 'zh';
  }
  
  function needsRedirect(storedLang, currentUrlLang) {
    if (!storedLang) return false;
    
    // Don't redirect if user has explicitly chosen a language
    const urlParams = new URLSearchParams(window.location.search);
    const explicitLang = urlParams.get('explicit_lang');
    if (explicitLang === 'en' || explicitLang === 'zh') {
      return false;
    }
    
    const currentPath = window.location.pathname;
    const articleMatch = currentPath.match(/^\\/blog\\/article\\/(.+?)\\/?$/);
    
    if (articleMatch) {
      const articlePath = articleMatch[1];
      
      if (storedLang === 'en' && !articlePath.startsWith('en/')) {
        return true;
      }
      
      if (storedLang === 'zh' && !articlePath.startsWith('zh/')) {
        return true;
      }
      
      return false;
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