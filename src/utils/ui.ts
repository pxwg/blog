import type { Discussion, AuthState, Comment, CommentsConfig } from './types';

function createDOMFromHTML(htmlString: string): HTMLElement {
  const div = document.createElement('div');
  div.innerHTML = htmlString.trim();
  return div.firstChild as HTMLElement;
}

function createCommentHTML(comment: Comment): string {
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

function createFormHTML(authState: AuthState): string {
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

export function renderInitialLayout(container: HTMLElement, discussion: Discussion, authState: AuthState): void {
  const commentNodes = discussion.comments?.nodes || [];
  
  const commentsHTML = commentNodes.length
    ? commentNodes.map(createCommentHTML).join('')
    : '<p id="no-comments-yet">Be the first to comment.</p>';

  const formHTML = createFormHTML(authState);
  
  const finalHTML = `
    <h3>Comments</h3>
    <div id="comment-list">${commentsHTML}</div>
    <div id="comment-form-container">${formHTML}</div>
    <p class="view-on-github">
      <a href="${discussion.url}" target="_blank" rel="noopener noreferrer" class="github-link">View on GitHub →</a>
    </p>
  `;
  container.innerHTML = finalHTML;
}

export function renderError(container: HTMLElement, error: Error): void {
  container.innerHTML = `
    <div class="error-box">
      <p>Sorry, we couldn't load the comments.</p>
      <p class="error-message">Details: ${error.message}</p>
    </div>`;
}

export function renderNoDiscussion(container: HTMLElement, config: CommentsConfig): void {
  const { owner, repo, title } = config;
  container.innerHTML = `
    <p>No discussion found for this article. Be the first to 
      <a class="create-link" href="https://github.com/${owner}/${repo}/discussions/new?title=${encodeURIComponent(title)}" target="_blank" rel="noopener noreferrer">create one</a>!
    </p>`;
}

export function addCommentToDOM(comment: Comment): void {
    const commentList = document.getElementById('comment-list');
    if (!commentList) return;

    const newCommentEl = createDOMFromHTML(createCommentHTML(comment));
    commentList.appendChild(newCommentEl);
    
    document.getElementById('no-comments-yet')?.remove();
}
