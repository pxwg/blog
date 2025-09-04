export type Language = 'zh' | 'en';

/**
 * Global Language State Manager
 * Handles persistent language preferences across the entire application
 */
export class GlobalLanguageState {
  private static readonly STORAGE_KEY = 'blog-language-preference';
  private static _instance: GlobalLanguageState | null = null;
  
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
   * 1. Stored preference (highest priority)
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
   */
  initialize(): void {
    if (typeof window === 'undefined') return;
    
    const currentLang = this.getCurrentLanguage();
    const storedLang = this.getStoredLanguage();
    
    // If we have a stored preference but current page doesn't match it,
    // redirect to the appropriate language version
    if (storedLang && storedLang !== this.getLanguageFromCurrentUrl()) {
      this.switchToLanguage(storedLang);
    }
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