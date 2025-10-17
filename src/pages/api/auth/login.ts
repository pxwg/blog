// src/pages/api/auth/login.ts
import type { APIRoute } from 'astro';

const clientId = import.meta.env.PUBLIC_GITHUB_CLIENT_ID;
const scope = 'public_repo'; // Permissions we're requesting

export const GET: APIRoute = ({ redirect, url }) => {
  const redirectTo = url.searchParams.get('redirect_to') || '/';

  const authUrl = `https://github.com/login/oauth/authorize?client_id=${clientId}&scope=${scope}&state=${encodeURIComponent(redirectTo)}`;

  return redirect(authUrl, 302);
};
