import type { Discussion, AuthState, Comment, CommentsConfig } from './types';

function populateTemplate(template: HTMLElement, data: any): HTMLElement {
  const clone = template.cloneNode(true) as HTMLElement;

  const getValue = (key: string | undefined): any => {
    if (!key) return undefined;
    return key.split('.').reduce((o, i) => o?.[i], data);
  };

  const elementsToFill = clone.querySelectorAll<HTMLElement>('[data-fill-text], [data-fill-html], [data-fill-src], [data-fill-href], [data-fill-alt]');

  elementsToFill.forEach(el => {
    const textKey = el.dataset.fillText;
    const htmlKey = el.dataset.fillHtml;
    const srcKey = el.dataset.fillSrc;
    const hrefKey = el.dataset.fillHref;
    const altKey = el.dataset.fillAlt;

    if (textKey) {
      let value = getValue(textKey);
      // Special handling for date formatting
      if (textKey === 'createdAt' && value) {
        value = new Date(value).toLocaleString();
      }
      if (value !== undefined) el.textContent = value;
    }
    if (htmlKey) {
      const value = getValue(htmlKey);
      if (value !== undefined) el.innerHTML = value;
    }
    if (srcKey) {
      const value = getValue(srcKey);
      if (value !== undefined) (el as HTMLImageElement | HTMLSourceElement).src = value;
    }
    if (hrefKey) {
      const value = getValue(hrefKey);
      if (value !== undefined) {
        // BUG FIX: Construct the full URL properly here
        (el as HTMLAnchorElement).href = `https://github.com/${value}`;
      }
    }
    if (altKey) {
      const value = getValue(altKey);
      if (value !== undefined) (el as HTMLImageElement).alt = `${value}'s avatar`;
    }
  });

  return clone;
}


export function renderInitialLayout(container: HTMLElement, discussion: Discussion, authState: AuthState): void {
  const commentTemplate = document.querySelector<HTMLTemplateElement>('#comment-item-template')?.content.firstElementChild as HTMLElement | null;
  if (!commentTemplate) {
    console.error('CRITICAL: Comment item template not found!');
    return;
  }

  container.innerHTML = `
    <h3>Comments</h3>
    <div id="comment-list"></div>
    <div id="comment-form-container"></div>
    <p class="view-on-github"><a href="${discussion.url}" target="_blank" rel="noopener noreferrer">View on GitHub →</a></p>
  `;

  const commentList = container.querySelector<HTMLElement>('#comment-list')!;
  const formContainer = container.querySelector<HTMLElement>('#comment-form-container')!;
  const commentNodes = discussion.comments?.nodes || [];

  if (commentNodes.length > 0) {
    commentNodes.forEach(comment => {
      const commentEl = populateTemplate(commentTemplate, comment);
      commentList.appendChild(commentEl);
    });
  } else {
    commentList.innerHTML = '<p id="no-comments-yet">Be the first to comment.</p>';
  }

  const formTemplateId = authState.isLoggedIn ? '#comment-form-template' : '#login-prompt-template';
  const formTemplate = document.querySelector<HTMLTemplateElement>(formTemplateId)?.content.cloneNode(true);

  if (formTemplate) {
    if (authState.isLoggedIn && authState.user) {
      const userAvatar = (formTemplate as HTMLElement).querySelector<HTMLImageElement>('.user-avatar');
      const userName = (formTemplate as HTMLElement).querySelector<HTMLElement>('.user-name');
      if (userAvatar) {
        userAvatar.src = authState.user.avatarUrl;
        userAvatar.alt = `${authState.user.login}'s avatar`;
      }
      if (userName) userName.textContent = authState.user.login;
    }
    formContainer.appendChild(formTemplate);
  }
}

export function addCommentToDOM(comment: Comment): void {
  const commentList = document.getElementById('comment-list');
  const commentTemplate = document.querySelector<HTMLTemplateElement>('#comment-item-template')?.content.firstElementChild as HTMLElement | null;
  if (!commentList || !commentTemplate) return;

  const newCommentEl = populateTemplate(commentTemplate, comment);
  commentList.appendChild(newCommentEl);
  document.getElementById('no-comments-yet')?.remove();
}

// Unchanged functions
export function renderError(container: HTMLElement, error: Error): void {
  container.innerHTML = `<div class="error-box"><p>Sorry, we couldn't load the comments.</p><p class="error-message">Details: ${error.message}</p></div>`;
}
export function renderNoDiscussion(container: HTMLElement, config: CommentsConfig): void {
  const { owner, repo, title } = config;
  container.innerHTML = `<p>No discussion found. <a href="https://github.com/${owner}/${repo}/discussions/new?title=${encodeURIComponent(title)}" target="_blank" rel="noopener noreferrer">Create one</a>!</p>`;
}
