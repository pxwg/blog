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
    let html = `<h2>${discussionData.title}</h2>`;
    html += `<div class="discussion-body">${discussionData.bodyHTML || ''}</div><hr><h3>Comments</h3>`;
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
      <div class="comment">
        <div class="comment-header">
          <img src="${comment.author.avatarUrl}" alt="${comment.author.login}" width="40" height="40">
          <strong>${comment.author.login}</strong>
          <span class="comment-date">on ${new Date(comment.createdAt).toLocaleString()}</span>
        </div>
        <div class="comment-body">${comment.bodyHTML || ''}</div>
      </div>
    `;
  }

  private createFormHTML(authState: AuthState): string {
    if (authState.isLoggedIn && authState.user) {
      return `
        <div class="comment-form-wrapper">
          <div class="user-info">
            <img src="${authState.user.avatarUrl}" alt="${authState.user.login}" width="40" height="40" class="user-avatar">
            <span class="user-name">${authState.user.login}</span>
            <button id="logout-btn" class="logout-btn">Logout</button>
          </div>
          <form id="comment-form">
            <textarea name="body" placeholder="Add your comment..." required></textarea>
            <div class="form-actions">
              <button type="submit">Comment</button>
            </div>
          </form>
        </div>
      `;
    } else {
      const currentPage = encodeURIComponent(window.location.href);
      const callbackUrl = encodeURIComponent(`${window.location.protocol}//${window.location.host}/api/callback`);
      const loginUrl = `/api/login?redirect=${currentPage}&callback_url=${callbackUrl}`;
      return `<p class="login-prompt">Please <a id="login-link" class="login-link" href="${loginUrl}">login with GitHub</a> to post a comment.</p>`;
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
