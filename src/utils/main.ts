import * as api from './api';
import * as ui from './ui';
import type { CommentsConfig, AuthState, Discussion } from './types';

class CommentsController {
  private container: HTMLElement;
  private config: CommentsConfig;
  private authState: AuthState = { isLoggedIn: false };
  private discussion: Discussion | null = null;

  constructor(container: HTMLElement, config: CommentsConfig) {
    this.container = container;
    this.config = config;
  }

  public async init(): Promise<void> {
    try {
      const [authState, discussionData] = await Promise.all([
        api.fetchAuthState(),
        api.fetchDiscussion(this.config),
      ]);

      this.authState = authState;
      this.discussion = discussionData;

      if (!this.discussion) {
        ui.renderNoDiscussion(this.container, this.config);
        return;
      }

      ui.renderInitialLayout(this.container, this.discussion, this.authState);
      this.attachEventListeners();

    } catch (error) {
      console.error("Failed to load comments app:", error);
      ui.renderError(this.container, error as Error);
    }
  }
  
  private attachEventListeners(): void {
    this.container.addEventListener('click', (e) => {
      const target = e.target as HTMLElement;
      if (target.matches('#logout-btn')) this.handleLogout();
      if (target.matches('#login-link')) this.handleLogin();
    });

    this.container.addEventListener('submit', (e) => {
      const target = e.target as HTMLElement;
      if (target.matches('#comment-form')) {
        e.preventDefault();
        this.handleFormSubmit(target as HTMLFormElement);
      }
    });
  }

  private handleLogin(): void {
    sessionStorage.setItem('just_logged_in', 'true');
  }

  private async handleLogout(): Promise<void> {
    try {
      await api.logout();
      window.location.reload();
    } catch (error) {
      console.error('Logout failed:', error);
      alert('Failed to logout. Please try again.');
    }
  }

  private async handleFormSubmit(form: HTMLFormElement): Promise<void> {
    if (!this.discussion?.id) return;
    
    const textarea = form.querySelector('textarea');
    const button = form.querySelector('button[type="submit"]');
    if (!textarea || !button) return;

    const body = textarea.value.trim();
    if (!body) return;

    const originalButtonText = button.textContent;
    button.disabled = true;
    button.textContent = 'Posting...';

    try {
      const newComment = await api.postComment(this.discussion.id, body);
      ui.addCommentToDOM(newComment);
      textarea.value = '';
    } catch (error) {
      alert(`Error: ${(error as Error).message}`);
    } finally {
      button.disabled = false;
      button.textContent = originalButtonText;
    }
  }
}

// Factory function to initialize the comments controller
export function initializeComments(containerId: string, config: CommentsConfig): void {
  const container = document.getElementById(containerId);
  if (!container) {
    console.error(`Container with id '${containerId}' not found`);
    return;
  }

  const controller = new CommentsController(container, config);
  controller.init();
}
