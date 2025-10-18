export interface CommentAuthor {
  login: string;
  avatarUrl: string;
}

export interface Comment {
  id: string;
  author: CommentAuthor;
  bodyHTML: string;
  createdAt: string;
}

export interface Discussion {
  id: string;
  title: string;
  bodyHTML: string;
  url: string;
  comments: {
    nodes: Comment[];
  };
}

export interface AuthState {
  isLoggedIn: boolean;
  user?: {
    login: string;
    avatarUrl: string;
  };
}

export interface CommentsConfig {
  owner: string;
  repo: string;
  title: string;
}

export class CommentsManager {
  private config: CommentsConfig;
  private container: HTMLElement;

  constructor(container: HTMLElement, config: CommentsConfig) {
    this.container = container;
    this.config = config;
  }

  async init(): Promise<void> {
    try {
      const justLoggedIn = sessionStorage.getItem('just_logged_in');
      if (justLoggedIn) {
        sessionStorage.removeItem('just_logged_in');
      }

      const [authState, discussionData] = await Promise.all([
        this.fetchAuthState(),
        this.fetchDiscussion()
      ]);

      if (!discussionData) {
        this.renderNoDiscussion();
        return;
      }

      this.render(discussionData, authState);
      this.attachEventListeners(authState, discussionData.id);

    } catch (error) {
      console.error("Failed to load comments app:", error);
      this.renderError(error as Error);
    }
  }

  private async fetchAuthState(): Promise<AuthState> {
    const userApiUrl = `/api/user`;
    const fetchOptions = {
      credentials: 'include' as RequestCredentials,
      headers: {
        'Cache-Control': 'no-cache',
        'Pragma': 'no-cache',
      },
    };

    try {
      const userRes = await fetch(userApiUrl, fetchOptions);
      
      if (userRes.ok) {
        return await userRes.json();
      } else if (userRes.status === 401) {
        return { isLoggedIn: false };
      } else {
        console.error(`User API request failed with status: ${userRes.status}`);
        return { isLoggedIn: false };
      }
    } catch (error) {
      console.error('Failed to fetch auth state:', error);
      return { isLoggedIn: false };
    }
  }

  private async fetchDiscussion(): Promise<Discussion | null> {
    const { owner, repo, title } = this.config;
    const discussionApiUrl = `/api/discussion?owner=${owner}&repo=${repo}&title=${encodeURIComponent(title)}`;
    
    const fetchOptions = {
      credentials: 'include' as RequestCredentials,
      headers: {
        'Cache-Control': 'no-cache',
        'Pragma': 'no-cache',
      },
    };

    const discussionRes = await fetch(discussionApiUrl, fetchOptions);
    
    if (!discussionRes.ok) {
      if (discussionRes.status === 404) {
        return null;
      } else {
        throw new Error(`API request failed with status: ${discussionRes.status}`);
      }
    }

    return await discussionRes.json();
  }

  private renderNoDiscussion(): void {
    const { owner, repo, title } = this.config;
    this.container.innerHTML = `
      <p>No discussion found for this article. Be the first to 
        <a class="create-link" href="https://github.com/${owner}/${repo}/discussions/new?title=${encodeURIComponent(title)}" target="_blank" rel="noopener noreferrer">create one</a>!
      </p>
    `;
  }

  private renderError(error: Error): void {
    this.container.innerHTML = `
      <div class="error-box">
        <p>Sorry, we couldn't load the comments.</p>
        <p class="error-message">Details: ${error.message}</p>
      </div>
    `;
  }

  private render(discussionData: Discussion, authState: AuthState): void {
    let html = `<h3>Comments</h3>`;
    html += `<div id="comment-list">`;

    if (!discussionData.comments?.nodes?.length) {
      html += '<p id="no-comments-yet">Be the first to comment.</p>';
    } else {
      discussionData.comments.nodes.forEach(comment => {
        html += this.createCommentHTML(comment);
      });
    }

    html += `</div>`; // Close #comment-list
    html += `<div id="comment-form-container">${this.createFormHTML(authState)}</div>`;
    html += `<p class="view-on-github"><a href="${discussionData.url}" target="_blank" rel="noopener noreferrer" class="github-link">View on GitHub →</a></p>`;

    this.container.innerHTML = html;
  }

  private createCommentHTML(comment: Comment): string {
    return `
      <style>
        :root {
          --comment-border-color: #3498db;
          --comment-bg-color: #e8f4f8;
          --comment-text-color: #2c3e50;
          --comment-link-color: #3498db;
          --comment-link-hover-color: #2980b9;
          --comment-date-color: #7f8c8d;
        }
        :root.dark {
          --comment-border-color: #5dade2;
          --comment-bg-color: #1a2332;
          --comment-text-color: #e8e8e8;
          --comment-link-color: #5dade2;
          --comment-link-hover-color: #85c1e9;
          --comment-date-color: #95a5a6;
        }
      </style>
      <div class="comment" style="margin:0;padding:0;border-left:3px solid var(--comment-border-color);background:var(--comment-bg-color);border-radius:4px;box-shadow:0 1px 4px rgba(0,0,0,0.06);">
        <div class="comment-header" style="display:flex;align-items:center;gap:0.5em;padding:0.3em 0.5em;margin:0;font-weight:600;font-size:0.9em;color:var(--comment-link-color);border-bottom:1px solid rgba(128,128,128,0.1);">
          <img src="${comment.author.avatarUrl}" alt="${comment.author.login}" width="28" height="28" style="border-radius:50%;flex-shrink:0;">
          <a href="https://github.com/${comment.author.login}" target="_blank" rel="noopener noreferrer" style="font-weight:600;color:var(--comment-link-color);text-decoration:none;transition:color 0.2s ease;" onmouseover="this.style.color='var(--comment-link-hover-color)'" onmouseout="this.style.color='var(--comment-link-color)'">${comment.author.login}</a>
          <span class="comment-date" style="margin-left:auto;font-size:0.85em;font-weight:normal;color:var(--comment-date-color);opacity:0.8;">${new Date(comment.createdAt).toLocaleString()}</span>
        </div>
        <div class="comment-body" style="padding:0.3em 0.5em;margin:0.5em;line-height:1.4;font-size:0.9em;color:var(--comment-text-color);">${comment.bodyHTML || ''}</div>
      </div>
    `;
  }

  private createFormHTML(authState: AuthState): string {
    if (authState.isLoggedIn && authState.user) {
      return `
        <style>
          :root {
            --form-border-color: #95a5a6;
            --form-bg-color: #f9f9f9;
            --form-text-color: #34495e;
            --form-button-color: #7f8c8d;
          }
          :root.dark {
            --form-border-color: #7f8c8d;
            --form-bg-color: #1c1e20;
            --form-text-color: #d0d0d0;
            --form-button-color: #95a5a6;
          }
          #comment-form textarea:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 1.5px var(--accent-dark);
          }
        </style>
        <div class="comment-form-wrapper" style="margin:0;padding:0;border-left:3px solid var(--form-border-color);background:var(--form-bg-color);border-radius:4px;box-shadow:0 1px 4px rgba(0,0,0,0.06);">
          <div class="user-info" style="display:flex;align-items:center;gap:0.5em;padding:0.3em 0.5em;margin:0;font-weight:600;font-size:0.9em;color:var(--form-text-color);border-bottom:1px solid rgba(128,128,128,0.1);">
            <img src="${authState.user.avatarUrl}" alt="${authState.user.login}" width="28" height="28" class="user-avatar" style="border-radius:50%;flex-shrink:0;">
            <span class="user-name" style="font-weight:600;">${authState.user.login}</span>
            <button id="logout-btn" class="logout-btn" style="margin-left:auto;background:transparent;border:1px solid var(--form-button-color);color:var(--form-button-color);padding:0.2em 0.6em;border-radius:3px;cursor:pointer;font-size:0.85em;transition:all 0.2s ease;">Logout</button>
          </div>
          <form id="comment-form" style="padding:0.3em 0.5em;margin:0;">
            <textarea name="body" placeholder="Add your comment..." required style="width:100%;min-height:80px;padding:0.4em;border:1px solid var(--form-border-color);background:var(--form-bg-color);color:var(--form-text-color);border-radius:3px;font-family:inherit;font-size:0.9em;resize:vertical;box-sizing:border-box;transition:border-color 0.2s ease,box-shadow 0.2s ease;"></textarea>
            <div class="form-actions" style="margin-top:0.5em;display:flex;justify-content:flex-end;">
              <button type="submit" style="background:var(--form-button-color);color:#fff;border:none;padding:0.4em 1em;border-radius:3px;cursor:pointer;font-size:0.9em;transition:opacity 0.2s ease;" onmouseover="this.style.opacity='0.8'" onmouseout="this.style.opacity='1'">Comment</button>
            </div>
          </form>
        </div>
      `;
    } else {
      const currentPage = encodeURIComponent(window.location.href);
      const callbackUrl = encodeURIComponent(`${window.location.protocol}//${window.location.host}/api/callback`);
      const loginUrl = `/api/login?redirect=${currentPage}&callback_url=${callbackUrl}`;
      return `<p class="login-prompt" style="color:var(--form-text-color);">Please <a id="login-link" class="login-link" href="${loginUrl}" style="color:var(--form-button-color);text-decoration:none;transition:opacity 0.2s ease;" onmouseover="this.style.opacity='0.7'" onmouseout="this.style.opacity='1'">login with GitHub</a> to post a comment.</p>`;
    }
  }

  private attachEventListeners(authState: AuthState, discussionId?: string): void {
    if (authState.isLoggedIn && discussionId) {
      this.addFormSubmitListener(discussionId);
      this.addLogoutListener();
    } else {
      this.addLoginListener();
    }
  }

  private addLoginListener(): void {
    const loginLink = document.getElementById('login-link');
    if (loginLink) {
      loginLink.addEventListener('click', () => {
        sessionStorage.setItem('just_logged_in', 'true');
      });
    }
  }

  private addLogoutListener(): void {
    const logoutBtn = document.getElementById('logout-btn');
    if (logoutBtn) {
      logoutBtn.addEventListener('click', async () => {
        try {
          await fetch('/api/logout', {
            method: 'GET',
            credentials: 'include'
          });
          window.location.reload();
        } catch (error) {
          console.error('Logout failed:', error);
          alert('Failed to logout. Please try again.');
        }
      });
    }
  }

  private addFormSubmitListener(discussionId: string): void {
    const form = document.getElementById('comment-form') as HTMLFormElement;
    if (!form) return;

    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      const textarea = form.querySelector('textarea') as HTMLTextAreaElement;
      const button = form.querySelector('button') as HTMLButtonElement;
      const body = textarea.value.trim();

      if (!body) return;

      button.disabled = true;
      button.textContent = 'Posting...';

      try {
        const res = await fetch(`/api/comment`, {
          method: 'POST',
          credentials: 'include',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ discussionId, body }),
        });

        if (!res.ok) {
          const errorData = await res.json();
          throw new Error(errorData.error || 'Failed to post comment.');
        }

        const newComment: Comment = await res.json();
        const commentList = document.getElementById('comment-list');
        
        if (commentList) {
          const newCommentEl = document.createElement('div');
          newCommentEl.innerHTML = this.createCommentHTML(newComment);
          commentList.appendChild(newCommentEl.firstElementChild!);

          const noCommentsMsg = document.getElementById('no-comments-yet');
          if (noCommentsMsg) noCommentsMsg.remove();
        }
        
        textarea.value = '';
      } catch (error) {
        alert(`Error: ${(error as Error).message}`);
      } finally {
        button.disabled = false;
        button.textContent = 'Comment';
      }
    });
  }
}

// Factory function to initialize comments
export function initializeComments(containerId: string, config: CommentsConfig): void {
  const container = document.getElementById(containerId);
  if (!container) {
    console.error(`Container with id '${containerId}' not found`);
    return;
  }

  const commentsManager = new CommentsManager(container, config);
  commentsManager.init();
}
