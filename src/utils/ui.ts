import type { Discussion, AuthState, Comment, CommentsConfig } from './types';

function populateTemplate(template: HTMLElement, data: any): HTMLElement {
  const clone = template.cloneNode(true) as HTMLElement;

  clone.querySelectorAll<HTMLElement>('[data-fill]').forEach(el => {
    const key = el.dataset.fill;
    if (!key) return;
    const value = key.split('.').reduce((o, i) => o?.[i], data);
    if (value === undefined || value === null) return;

    if (el.dataset.fillTarget === 'html') {
      el.innerHTML = value;
    } else if (el.dataset.fillTarget) {
      el.setAttribute(el.dataset.fillTarget, value);
    } else {
      el.textContent = value;
    }
  });
  
  clone.querySelectorAll<HTMLElement>('[data-attr-template]').forEach(el => {
      const instructions = el.dataset.attrTemplate;
      instructions?.split(',').forEach(inst => {
          const [attr, template] = inst.split(':');
          const key = el.dataset.fill;
          if(!key) return;
          const value = key.split('.').reduce((o, i) => o?.[i], data);
          if (value === undefined || value === null) return;
          
          el.setAttribute(attr, template.replace('{value}', value));
      });
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
      // 日期需要预处理
      const displayData = { ...comment, createdAt: new Date(comment.createdAt).toLocaleString() };
      const commentEl = populateTemplate(commentTemplate, displayData);
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
      if (userAvatar) userAvatar.src = authState.user.avatarUrl;
      if (userName) userName.textContent = authState.user.login;
    }
    formContainer.appendChild(formTemplate);
  }
}

export function addCommentToDOM(comment: Comment): void {
  const commentList = document.getElementById('comment-list');
  const commentTemplate = document.querySelector<HTMLTemplateElement>('#comment-item-template')?.content.firstElementChild as HTMLElement | null;
  if (!commentList || !commentTemplate) return;

  const displayData = { ...comment, createdAt: new Date(comment.createdAt).toLocaleString() };
  const newCommentEl = populateTemplate(commentTemplate, displayData);
  commentList.appendChild(newCommentEl);
  document.getElementById('no-comments-yet')?.remove();
}

export function renderError(container: HTMLElement, error: Error): void {
  container.innerHTML = `<div class="error-box"><p>Sorry, we couldn't load the comments.</p><p class="error-message">Details: ${error.message}</p></div>`;
}

export function renderNoDiscussion(container: HTMLElement, config: CommentsConfig): void {
  const { owner, repo, title } = config;
  container.innerHTML = `<p>No discussion found. <a href="https://github.com/${owner}/${repo}/discussions/new?title=${encodeURIComponent(title)}" target="_blank" rel="noopener noreferrer">Create one</a>!</p>`;
}
