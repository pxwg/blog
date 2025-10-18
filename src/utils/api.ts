import type { AuthState, Discussion, Comment, CommentsConfig } from './types';

const COMMON_FETCH_OPTIONS: RequestInit = {
  credentials: 'include',
  headers: { 'Cache-Control': 'no-cache', 'Content-Type': 'application/json' },
};

async function handleResponse<T>(res: Response): Promise<T> {
  if (res.status === 204) return null as T;
  const data = await res.json();
  if (!res.ok) {
    throw new Error(data.error || `Request failed with status ${res.status}`);
  }
  return data;
}

export async function fetchAuthState(): Promise<AuthState> {
  try {
    const res = await fetch(`/api/user`, {
      ...COMMON_FETCH_OPTIONS,
      method: 'GET',
    });
    if (res.ok) return await res.json();
    return { isLoggedIn: false };
  } catch (error) {
    console.error('Auth fetch error:', error);
    return { isLoggedIn: false };
  }
}

export async function fetchDiscussion(
  config: CommentsConfig
): Promise<Discussion | null> {
  const url = `/api/discussion?owner=${config.owner}&repo=${config.repo}&title=${encodeURIComponent(config.title)}`;
  const res = await fetch(url, { ...COMMON_FETCH_OPTIONS, method: 'GET' });
  if (res.status === 404) return null;
  return handleResponse<Discussion>(res);
}

export async function postComment(
  discussionId: string,
  body: string,
  replyToId?: string
): Promise<Comment> {
  const res = await fetch(`/api/comment`, {
    ...COMMON_FETCH_OPTIONS,
    method: 'POST',
    body: JSON.stringify({ discussionId, body, replyToId }),
  });
  return handleResponse<Comment>(res);
}

export async function updateComment(
  commentId: string,
  body: string
): Promise<{ id: string; bodyHTML: string }> {
  const res = await fetch(`/api/comment`, {
    ...COMMON_FETCH_OPTIONS,
    method: 'PATCH',
    body: JSON.stringify({ commentId, body }),
  });
  return handleResponse<{ id: string; bodyHTML: string }>(res);
}

export async function deleteComment(commentId: string): Promise<void> {
  const res = await fetch(`/api/comment`, {
    ...COMMON_FETCH_OPTIONS,
    method: 'DELETE',
    body: JSON.stringify({ commentId }),
  });
  await handleResponse<void>(res);
}

export async function logout(): Promise<void> {
  const res = await fetch('/api/logout', {
    ...COMMON_FETCH_OPTIONS,
    method: 'GET',
  });
  await handleResponse<void>(res);
}
