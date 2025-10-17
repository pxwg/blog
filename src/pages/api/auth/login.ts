// src/pages/api/auth/login.ts
import type { APIRoute } from 'astro';

export const prerender = false;

const clientId = import.meta.env.PUBLIC_GITHUB_CLIENT_ID;

export const GET: APIRoute = async ({ request, redirect }) => {
  const requestUrl = new URL(request.url);
  
  const redirectTo = requestUrl.searchParams.get('redirect') || 
                     request.headers.get('referer') || 
                     '/';
  
  console.log('[/api/auth/login] Redirect target:', redirectTo);

  const githubAuthUrl = new URL('https://github.com/login/oauth/authorize');
  githubAuthUrl.searchParams.set('client_id', clientId);
  githubAuthUrl.searchParams.set('scope', 'read:user public_repo');
  githubAuthUrl.searchParams.set('state', encodeURIComponent(redirectTo));
  
  console.log('[/api/auth/login] Redirecting to GitHub with state:', redirectTo);
  return redirect(githubAuthUrl.toString(), 302);
};
