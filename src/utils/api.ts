import type { AuthState, Discussion, Comment, CommentsConfig } from './types';

const COMMON_FETCH_OPTIONS: RequestInit = {
  credentials: 'include',
  headers: {
    'Cache-Control': 'no-cache',
    Pragma: 'no-cache',
  },
};

export async function fetchAuthState(): Promise<AuthState> {
  try {
    const res = await fetch(`/api/user`, COMMON_FETCH_OPTIONS);
    if (res.ok) {
      return await res.json();
    }
    return { isLoggedIn: false };
  } catch (error) {
    console.error('Failed to fetch auth state:', error);
    return { isLoggedIn: false };
  }
}

export async function fetchDiscussion(config: CommentsConfig): Promise<Discussion | null> {
  const { owner, repo, title } = config;
  const url = `/api/discussion?owner=${owner}&repo=${repo}&title=${encodeURIComponent(title)}`;
  
  const res = await fetch(url, COMMON_FETCH_OPTIONS);
  
  if (res.ok) {
    return await res.json();
  }
  if (res.status === 404) {
    return null;
  }
  throw new Error(`API request failed with status: ${res.status}`);
}

export async function postComment(discussionId: string, body: string): Promise<Comment> {
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
    return res.json();
}

export async function logout(): Promise<Response> {
    return fetch('/api/logout', {
        method: 'GET',
        credentials: 'include'
    });
}
