import type { Discussion, AuthState, Comment, CommentsConfig } from './types';

function populateTemplate(template: HTMLElement, data: Comment): HTMLElement {
  const clone = template.cloneNode(true) as HTMLElement;
  const getValue = (key: string) => key.split('.').reduce((o, i) => o?.[i], data);

  clone.dataset.commentId = data.id;

  clone.querySelectorAll<HTMLElement>('[data-fill-text]').forEach(el => {
    let value = getValue(el.dataset.fillText!);
    if (el.dataset.fillText === 'createdAt' && value) {
      value = new Date(value).toLocaleString();
    }
    if (value !== undefined) el.textContent = value;
  });

  clone.querySelectorAll<HTMLElement>('[data-fill-html]').forEach(el => {
    const value = getValue(el.dataset.fillHtml!);
    if (value !== undefined) el.innerHTML = value;
  });

  clone.querySelectorAll<HTMLImageElement>('[data-fill-src]').forEach(el => {
    const value = getValue(el.dataset.fillSrc!);
    if (value !== undefined) el.src = value;
  });

  clone.querySelectorAll<HTMLAnchorElement>('[data-fill-href]').forEach(el => {
    const value = getValue(el.dataset.fillHref!);
    if (value !== undefined) el.href = `https://github.com/${value}`;
  });

  clone.querySelectorAll<HTMLImageElement>('[data-fill-alt]').forEach(el => {
    const value = getValue(el.dataset.fillAlt!);
    if (value !== undefined) el.alt = `${value}'s avatar`;
  });

  if (data.viewerCanUpdate) {
    const btn = clone.querySelector<HTMLElement>('.edit-btn');
    if (btn) {
      btn.style.display = 'inline-block';
    }
  }
  if (data.viewerCanDelete) {
    const btn = clone.querySelector<HTMLElement>('.delete-btn');
    if (btn) {
      btn.style.display = 'inline-block';
    }
  }
  return clone;
}

export function renderInitialLayout(container: HTMLElement, discussion: Discussion, authState: AuthState): void {
  const commentTemplate = document.querySelector<HTMLTemplateElement>('#comment-item-template')?.content.firstElementChild as HTMLElement | null;
  if (!commentTemplate) return console.error('Comment item template not found!');

  container.innerHTML = `<h3>Comments</h3><div id="comment-list"></div><div id="comment-form-container"></div><p class="view-on-github"><a href="${discussion.url}" target="_blank" rel="noopener noreferrer">View on GitHub →</a></p>`;
  const commentList = container.querySelector<HTMLElement>('#comment-list')!;
  const formContainer = container.querySelector<HTMLElement>('#comment-form-container')!;
  const commentNodes = discussion.comments?.nodes || [];

  if (commentNodes.length > 0) {
    commentNodes.forEach(comment => commentList.appendChild(populateTemplate(commentTemplate, comment)));
  } else {
    commentList.innerHTML = '<p id="no-comments-yet">Be the first to comment.</p>';
  }

  const formTemplateId = authState.isLoggedIn ? '#comment-form-template' : '#login-prompt-template';
  const formTemplate = document.querySelector<HTMLTemplateElement>(formTemplateId)?.content.cloneNode(true);
  if (formTemplate) {
    if (authState.isLoggedIn && authState.user) {
      const userAvatar = (formTemplate as HTMLElement).querySelector<HTMLImageElement>('.user-avatar');
      const userName = (formTemplate as HTMLElement).querySelector<HTMLElement>('.user-name');
      if (userAvatar) { userAvatar.src = authState.user.avatarUrl; userAvatar.alt = `${authState.user.login}'s avatar`; }
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

export function showReplyForm(commentEl: HTMLElement, formWrapper: HTMLElement) {
  const replyContainer = commentEl.querySelector<HTMLElement>('.reply-form-container')!;
  
  // 关键改动：移动表单本身，并在其上设置data-reply-to-id
  replyContainer.appendChild(formWrapper);
  formWrapper.dataset.replyToId = commentEl.dataset.commentId;

  // 添加“Cancel”按钮
  if (!formWrapper.querySelector('.cancel-reply-btn')) {
    const cancelButton = document.createElement('button');
    cancelButton.type = 'button';
    cancelButton.textContent = 'Cancel';
    // 在你的 .astro 文件中，此类名为 .action-button，这里保持一致
    cancelButton.className = 'action-button cancel-reply-btn'; 
    formWrapper.querySelector('.form-actions')?.prepend(cancelButton);
  }
}

export function hideReplyForm(formWrapper: HTMLElement, originalParent: HTMLElement) {
  // 关键改动：将表单移回其原始的父容器
  originalParent.appendChild(formWrapper);
  
  // 清理状态
  delete formWrapper.dataset.replyToId;
  formWrapper.querySelector('.cancel-reply-btn')?.remove();
  (formWrapper.querySelector('textarea') as HTMLTextAreaElement)!.value = '';
}

export function showEditForm(commentEl: HTMLElement) {
  const body = commentEl.querySelector<HTMLElement>('.comment-body');
  const actions = commentEl.querySelector<HTMLElement>('.comment-actions');
  const editFormTemplate = document.querySelector<HTMLTemplateElement>('#edit-form-template');
  if (!body || !actions || !editFormTemplate) return;
  
  const tempDiv = document.createElement('div');
  tempDiv.innerHTML = body.innerHTML;
  const currentText = tempDiv.textContent || '';
  
  const editForm = editFormTemplate.content.cloneNode(true) as HTMLElement;
  const textarea = editForm.querySelector('textarea');
  if (textarea) textarea.value = currentText;

  body.style.display = 'none';
  actions.style.display = 'none';
  commentEl.insertBefore(editForm, actions);
}

export function hideEditForm(commentEl: HTMLElement) {
  const body = commentEl.querySelector<HTMLElement>('.comment-body');
  const actions = commentEl.querySelector<HTMLElement>('.comment-actions');
  const editForm = commentEl.querySelector<HTMLElement>('.edit-form-wrapper');
  if (body) body.style.display = 'block';
  if (actions) actions.style.display = 'flex';
  editForm?.remove();
}

export function updateCommentInDOM(commentId: string, newBodyHTML: string) {
  const commentEl = document.querySelector<HTMLElement>(`[data-comment-id="${commentId}"]`);
  if (!commentEl) return;
  const body = commentEl.querySelector<HTMLElement>('.comment-body');
  if (body) body.innerHTML = newBodyHTML;
  hideEditForm(commentEl);
}

export function removeCommentFromDOM(commentId: string) {
  document.querySelector<HTMLElement>(`[data-comment-id="${commentId}"]`)?.remove();
}

export function renderError(container: HTMLElement, error: Error): void { container.innerHTML = `<div class="error-box"><p>Sorry, we couldn't load the comments.</p><p class="error-message">Details: ${error.message}</p></div>`; }
export function renderNoDiscussion(container: HTMLElement, config: CommentsConfig): void { const { owner, repo, title } = config; container.innerHTML = `<p>No discussion found. <a href="https://github.com/${owner}/${repo}/discussions/new?title=${encodeURIComponent(title)}" target="_blank" rel="noopener noreferrer">Create one</a>!</p>`; }
