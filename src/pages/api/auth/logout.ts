// src/pages/api/auth/logout.ts
import type { APIRoute } from 'astro';

export const GET: APIRoute = ({ cookies, redirect, url }) => {
  // Delete the cookie
  cookies.delete('github_token', { path: '/' });

  const redirectTo = url.searchParams.get('redirect_to') || '/';
  return redirect(redirectTo, 302);
};
