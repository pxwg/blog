import * as api from './api';
import * as ui from './ui';
import type { CommentsConfig, AuthState, Discussion, Comment } from './types';

function buildCommentTree(comments: Comment[]): Comment[] {
  const commentMap = new Map<string, Comment>();
  const topLevelComments: Comment[] = [];

  comments.forEach((comment) => {
    comment.replies = [];
    commentMap.set(comment.id, comment);
  });

  comments.forEach((comment) => {
    if (comment.replyTo && commentMap.has(comment.replyTo.id)) {
      commentMap.get(comment.replyTo.id)!.replies!.push(comment);
    } else {
      topLevelComments.push(comment);
    }
  });

  return topLevelComments;
}

class CommentsController {
  private container: HTMLElement;
  private config: CommentsConfig;
  private authState: AuthState = { isLoggedIn: false };
  private discussion: Discussion | null = null;
  private originalFormParent: HTMLElement | null = null;

  private clickHandler: (e: Event) => void;
  private submitHandler: (e: Event) => void;

  constructor(container: HTMLElement, config: CommentsConfig) {
    this.container = container;
    this.config = config;

    this.clickHandler = this.handleClick.bind(this);
    this.submitHandler = this.handleSubmit.bind(this);
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
        return ui.renderNoDiscussion(this.container, this.config);
      }

      const commentTree = buildCommentTree(this.discussion.comments.nodes);

      ui.renderInitialLayout(
        this.container,
        this.discussion,
        this.authState,
        commentTree
      );

      this.originalFormParent = this.container.querySelector(
        '#comment-form-container'
      );
      this.attachEventListeners();
    } catch (error) {
      console.error('Failed to load comments app:', error);
      ui.renderError(this.container, error as Error);
    }
  }

  private attachEventListeners(): void {
    this.container.removeEventListener('click', this.clickHandler);
    this.container.removeEventListener('submit', this.submitHandler);

    this.container.addEventListener('click', this.clickHandler);
    this.container.addEventListener('submit', this.submitHandler);
  }

  private handleClick(e: Event) {
    const target = e.target as HTMLElement;
    const commentEl = target.closest<HTMLElement>('.comment');

    if (!commentEl && !target.matches('#logout-btn')) return;

    if (target.matches('.reply-btn')) this.handleReplyClick(commentEl!);
    else if (target.matches('.edit-btn')) this.handleEditClick(commentEl!);
    else if (target.matches('.delete-btn')) this.handleDeleteClick(commentEl!);
    else if (target.matches('.cancel-edit-btn')) ui.hideEditForm(commentEl!);
    else if (target.matches('.cancel-reply-btn')) this.handleCancelReply();
    else if (target.matches('#logout-btn')) this.handleLogout();
    else if (target.matches('#login-link'))
      sessionStorage.setItem('just_logged_in', 'true');
  }

  private handleSubmit(e: Event) {
    e.preventDefault();
    const form = e.target as HTMLFormElement;
    if (form.matches('#comment-form')) this.handleMainFormSubmit(form);
    if (form.matches('.edit-form')) this.handleEditFormSubmit(form);
  }

  private handleReplyClick(commentEl: HTMLElement) {
    const formWrapper = this.container.querySelector<HTMLElement>(
      '.comment-form-wrapper'
    );
    if (formWrapper) {
      ui.showReplyForm(commentEl, formWrapper);
    }
  }

  private handleCancelReply() {
    const formWrapper = this.container.querySelector<HTMLElement>(
      '.comment-form-wrapper'
    );
    if (formWrapper && this.originalFormParent) {
      ui.hideReplyForm(formWrapper, this.originalFormParent);
    }
  }

  private async handleEditClick(commentEl: HTMLElement) {
    const commentId = commentEl.dataset.commentId;
    if (!commentId) return;

    const editButton = commentEl.querySelector<HTMLButtonElement>('.edit-btn');
    if (editButton) {
      editButton.disabled = true;
      editButton.textContent = 'Loading...';
    }

    try {
      await this.init();

      const newCommentEl = this.container.querySelector<HTMLElement>(
        `.comment[data-comment-id="${commentId}"]`
      );

      if (newCommentEl) {
        ui.showEditForm(newCommentEl);
      }
    } catch (error) {
      alert(`Error loading latest comment: ${(error as Error).message}`);
      if (editButton) {
        editButton.disabled = false;
        editButton.textContent = 'Edit';
      }
    }
  }

  private async handleDeleteClick(commentEl: HTMLElement) {
    if (!window.confirm('Are you sure you want to delete this comment?'))
      return;
    const commentId = commentEl.dataset.commentId!;
    try {
      await api.deleteComment(commentId);
      this.discussion!.comments.nodes = this.discussion!.comments.nodes.filter(
        (c) => c.id !== commentId
      );
      this.rerenderCommentList();
    } catch (error) {
      alert(`Error: ${(error as Error).message}`);
    }
  }

  private rerenderCommentList() {
    const commentTree = buildCommentTree(this.discussion!.comments.nodes);
    const listContainer =
      this.container.querySelector<HTMLElement>('#comment-list');
    const commentTemplate = document.querySelector<HTMLTemplateElement>(
      '#comment-item-template'
    )?.content.firstElementChild as HTMLElement | null;

    if (!listContainer || !commentTemplate) {
      console.error('Could not find elements needed for re-rendering.');
      return;
    }

    listContainer.innerHTML = '';
    const noCommentsEl = document.getElementById('no-comments-yet');
    if (noCommentsEl) noCommentsEl.remove();

    if (commentTree.length > 0) {
      ui.renderCommentTree(
        commentTree,
        listContainer,
        commentTemplate,
        this.authState
      );
      listContainer.innerHTML =
        '<p id="no-comments-yet">Be the first to comment.</p>';
    }
  }

  private async handleMainFormSubmit(form: HTMLFormElement) {
    if (!this.discussion?.id) return;
    const textarea = form.querySelector('textarea')!;
    const button = form.querySelector('button[type="submit"]')!;
    const body = textarea.value.trim();
    if (!body) return;

    const formWrapper = form.closest<HTMLElement>('.comment-form-wrapper');
    const replyToId = formWrapper?.dataset.replyToId;

    const originalButtonText = button.textContent;
    button.disabled = true;
    button.textContent = 'Posting...';

    try {
      const newComment = await api.postComment(
        this.discussion.id,
        body,
        replyToId
      );

      if (replyToId && !newComment.replyTo) {
        newComment.replyTo = { id: replyToId };
      }

      this.discussion.comments.nodes.push(newComment);
      this.rerenderCommentList();

      textarea.value = '';
      if (replyToId) {
        this.handleCancelReply();
      }
    } catch (error) {
      alert(`Error: ${(error as Error).message}`);
    } finally {
      button.disabled = false;
      button.textContent = originalButtonText;
    }
  }

  private async handleEditFormSubmit(form: HTMLFormElement) {
    const commentEl = form.closest<HTMLElement>('.comment')!;
    const commentId = commentEl.dataset.commentId!;
    const textarea = form.querySelector('textarea')!;
    const button = form.querySelector('button[type="submit"]')!;
    const body = textarea.value.trim();
    if (!body) return;

    const originalButtonText = button.textContent;
    button.disabled = true;
    button.textContent = 'Saving...';

    try {
      await api.updateComment(commentId, body);
      await this.init();
    } catch (error) {
      alert(`Error: ${(error as Error).message}`);
      button.disabled = false;
      button.textContent = originalButtonText;
    }
  }

  private async handleLogout() {
    try {
      await api.logout();
      window.location.reload();
    } catch (error) {
      alert('Failed to logout.');
    }
  }
}

export function initializeComments(containerId: string): void {
  const container = document.getElementById(containerId);
  if (!container) return;
  const { owner, repo, title } = container.dataset;
  if (!owner || !repo || !title) return;
  new CommentsController(container, { owner, repo, title }).init();
}
