// src/utils/ui.ts

import type { Discussion, AuthState, Comment, CommentsConfig } from './types';
import { marked } from 'marked';
import katex from 'katex';

// ==================== 修复后的数学公式渲染功能 ====================
/**
 * 查找并渲染指定元素内的所有数学公式
 * @param element - The HTML element to search within.
 */
function renderMathInElement(element: HTMLElement) {
  // 正则表达式查找 $$...$$ (块级) 和 $...$ (行内) 公式
  const mathRegex = /(\$\$[\s\S]*?\$\$|\$[^$]*?\$)/g;

  // 递归遍历DOM节点
  const walkAndRender = (node: Node) => {
    if (node.nodeType === 3) {
      // 文本节点
      const text = node.textContent || '';
      const parts = text.split(mathRegex);

      if (parts.length > 1) {
        const fragment = document.createDocumentFragment();
        parts.forEach((part, i) => {
          // 匹配到的部分 (即公式) 总是在奇数索引
          if (i % 2 === 1) {
            const isBlock = part.startsWith('$$');
            const math = part.slice(isBlock ? 2 : 1, isBlock ? -2 : -1);

            // 确保我们传递给KaTeX的是一个有效的字符串
            if (typeof math === 'string') {
              try {
                const html = katex.renderToString(math, {
                  displayMode: isBlock,
                  throwOnError: false,
                });
                const span = document.createElement('span');
                span.innerHTML = html;
                fragment.appendChild(span);
              } catch (e) {
                const errorSpan = document.createElement('span');
                errorSpan.style.color = 'red';
                errorSpan.textContent = part; // 渲染失败时显示原始文本
                fragment.appendChild(errorSpan);
              }
            }
          } else if (part) {
            fragment.appendChild(document.createTextNode(part));
          }
        });
        node.parentNode?.replaceChild(fragment, node);
      }
    } else if (node.nodeType === 1) {
      // 元素节点
      const el = node as HTMLElement;
      const tagName = el.tagName.toLowerCase();
      if (
        tagName !== 'pre' &&
        tagName !== 'code' &&
        tagName !== 'a' &&
        tagName !== 'script'
      ) {
        Array.from(el.childNodes).forEach(walkAndRender);
      }
    }
  };

  walkAndRender(element);
}
// ====================================================================

// 你已有的 autosizeTextarea 函数，保持不变
function autosizeTextarea(textarea: HTMLTextAreaElement) {
  const initialHeight = '4.5em';
  textarea.style.height = initialHeight;
  textarea.style.resize = 'none';
  textarea.style.overflowY = 'hidden';

  const adjustHeight = () => {
    textarea.style.height = 'auto';
    textarea.style.height = `${textarea.scrollHeight}px`;
  };

  textarea.addEventListener('input', adjustHeight);
  adjustHeight();
}

function fixLoginUrl(container: HTMLElement) {
  const loginLink = container.querySelector('#login-link');
  if (loginLink) {
    let href = loginLink.getAttribute('href') || '';
    href = href.replace(
      '{currentPage}',
      encodeURIComponent(window.location.href)
    );
    href = href.replace(
      '{callbackUrl}',
      encodeURIComponent(
        `${window.location.protocol}//${window.location.host}/api/callback`
      )
    );
    loginLink.setAttribute('href', href);
  }
}

function populateTemplate(template: HTMLElement, data: Comment): HTMLElement {
  const clone = template.cloneNode(true) as HTMLElement;
  const getValue = (key: string) =>
    key.split('.').reduce((o: any, i) => o?.[i], data);

  const commentNode = clone.querySelector<HTMLElement>('.comment')!;
  commentNode.dataset.commentId = data.id;

  clone.querySelectorAll<HTMLElement>('[data-fill-text]').forEach((el) => {
    let value = getValue(el.dataset.fillText!);
    if (el.dataset.fillText === 'createdAt' && value) {
      value = new Date(value).toLocaleString();
    }
    if (value !== undefined) el.textContent = value;
  });

  clone.querySelectorAll<HTMLElement>('[data-fill-html]').forEach((el) => {
    const value = getValue(el.dataset.fillHtml!);
    if (value !== undefined) {
      el.innerHTML = value;
      renderMathInElement(el);
    }
  });

  clone.querySelectorAll<HTMLImageElement>('[data-fill-src]').forEach((el) => {
    const value = getValue(el.dataset.fillSrc!);
    if (value !== undefined) el.src = value;
  });

  clone
    .querySelectorAll<HTMLAnchorElement>('[data-fill-href]')
    .forEach((el) => {
      const value = getValue(el.dataset.fillHref!);
      if (value !== undefined) el.href = `https://github.com/${value}`;
    });

  clone.querySelectorAll<HTMLImageElement>('[data-fill-alt]').forEach((el) => {
    const value = getValue(el.dataset.fillAlt!);
    if (value !== undefined) el.alt = `${value}'s avatar`;
  });

  if (data.viewerCanUpdate) {
    const btn = clone.querySelector<HTMLElement>('.edit-btn');
    if (btn) btn.style.display = 'inline-block';
  }
  if (data.viewerCanDelete) {
    const btn = clone.querySelector<HTMLElement>('.delete-btn');
    if (btn) btn.style.display = 'inline-block';
  }

  if (data.replyTo) {
    const replyBtn = clone.querySelector<HTMLButtonElement>('.reply-btn');
    if (replyBtn) replyBtn.style.display = 'none';
  }

  return clone;
}

// ... (剩下的所有函数都保持不变) ...
export function renderCommentTree(
  nodes: Comment[],
  container: HTMLElement,
  template: HTMLElement
) {
  nodes.forEach((comment) => {
    const commentWrapperEl = populateTemplate(template, comment);
    container.appendChild(commentWrapperEl);

    if (comment.replies && comment.replies.length > 0) {
      const repliesContainer =
        commentWrapperEl.querySelector<HTMLElement>('.replies-container')!;
      renderCommentTree(comment.replies, repliesContainer, template);
    }
  });
}

export function renderInitialLayout(
  container: HTMLElement,
  discussion: Discussion,
  authState: AuthState,
  commentTree: Comment[]
): void {
  const commentTemplate = document.querySelector<HTMLTemplateElement>(
    '#comment-item-template'
  )?.content.firstElementChild as HTMLElement | null;
  if (!commentTemplate)
    return console.error('Comment item template not found!');

  container.innerHTML = `<h3>Comments</h3>
<div id="comment-list"></div>
<div id="comment-form-container"></div>
<p class="view-on-github"><a href="${discussion.url}" target="_blank" rel="noopener noreferrer">View on GitHub →</a></p>`;
  const commentList = container.querySelector<HTMLElement>('#comment-list')!;

  if (commentTree.length > 0) {
    renderCommentTree(commentTree, commentList, commentTemplate);
  } else {
    commentList.innerHTML =
      '<p id="no-comments-yet">Be the first to comment.</p>';
  }

  const formContainer = container.querySelector<HTMLElement>(
    '#comment-form-container'
  )!;
  const formTemplateId = authState.isLoggedIn
    ? '#comment-form-template'
    : '#login-prompt-template';
  const formTemplate = document
    .querySelector<HTMLTemplateElement>(formTemplateId)
    ?.content.cloneNode(true);
  if (formTemplate) {
    if (authState.isLoggedIn && authState.user) {
      const userAvatar = (
        formTemplate as HTMLElement
      ).querySelector<HTMLImageElement>('.user-avatar');
      const userName = (formTemplate as HTMLElement).querySelector<HTMLElement>(
        '.user-name'
      );
      if (userAvatar) {
        userAvatar.src = authState.user.avatarUrl;
        userAvatar.alt = `${authState.user.login}'s avatar`;
      }
      if (userName) userName.textContent = authState.user.login;

      const mainTextarea = (formTemplate as HTMLElement).querySelector(
        'textarea'
      );
      if (mainTextarea) autosizeTextarea(mainTextarea);
    }
    formContainer.appendChild(formTemplate);
    if (!authState.isLoggedIn) {
      fixLoginUrl(formContainer);
    }
  }
}

export function showReplyForm(
  commentEl: HTMLElement,
  formWrapper: HTMLElement
) {
  const replyContainer = commentEl.querySelector<HTMLElement>(
    '.reply-form-container'
  )!;
  replyContainer.appendChild(formWrapper);
  formWrapper.dataset.replyToId = commentEl.dataset.commentId;

  const replyTextarea = formWrapper.querySelector('textarea');
  if (replyTextarea) autosizeTextarea(replyTextarea);

  if (!formWrapper.querySelector('.cancel-reply-btn')) {
    const cancelButton = document.createElement('button');
    cancelButton.type = 'button';
    cancelButton.textContent = 'Cancel';
    cancelButton.className = 'action-button cancel-reply-btn';
    formWrapper.querySelector('.form-actions')?.prepend(cancelButton);
  }
}

export function hideReplyForm(
  formWrapper: HTMLElement,
  originalParent: HTMLElement
) {
  originalParent.appendChild(formWrapper);
  delete formWrapper.dataset.replyToId;
  formWrapper.querySelector('.cancel-reply-btn')?.remove();
  const textarea = formWrapper.querySelector('textarea') as HTMLTextAreaElement;
  if (textarea) {
    textarea.value = '';
    textarea.style.height = '4.5em';
  }
}

export function showEditForm(commentEl: HTMLElement) {
  const body = commentEl.querySelector<HTMLElement>('.comment-body');
  const actions = commentEl.querySelector<HTMLElement>('.comment-actions');
  const editFormTemplate = document.querySelector<HTMLTemplateElement>(
    '#edit-form-template'
  );
  if (!body || !actions || !editFormTemplate) return;

  const tempDiv = document.createElement('div');
  tempDiv.innerHTML = body.innerHTML;
  const currentText = tempDiv.textContent || '';

  const editForm = editFormTemplate.content.cloneNode(true) as HTMLElement;
  const textarea = editForm.querySelector('textarea');
  if (textarea) {
    textarea.value = currentText;
    autosizeTextarea(textarea);
  }

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
  const commentEl = document.querySelector<HTMLElement>(
    `.comment[data-comment-id="${commentId}"]`
  );
  if (!commentEl) return;
  const body = commentEl.querySelector<HTMLElement>('.comment-body');
  if (body) {
    body.innerHTML = newBodyHTML;
    renderMathInElement(body);
  }
  hideEditForm(commentEl);
}

export function removeCommentFromDOM(commentId: string) {
  document
    .querySelector(`.comment[data-comment-id="${commentId}"]`)
    ?.closest('.comment-wrapper')
    ?.remove();
}

export function renderError(container: HTMLElement, error: Error): void {
  container.innerHTML = `<div class="error-box">
  <p>Sorry, we couldn't load the comments.</p>
  <p class="error-message">Details: ${error.message}</p>
</div>`;
}
export function renderNoDiscussion(
  container: HTMLElement,
  config: CommentsConfig
): void {
  const { owner, repo, title } = config;
  container.innerHTML = `<p>No discussion found. <a href="https://github.com/${owner}/${repo}/discussions/new?title=${encodeURIComponent(
    title
  )}" target="_blank" rel="noopener noreferrer">Create one</a>!</p>`;
}
