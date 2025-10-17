// src/pages/api/auth/callback.ts
import type { APIRoute } from 'astro';

export const prerender = false;

const clientId = import.meta.env.PUBLIC_GITHUB_CLIENT_ID;
const clientSecret = import.meta.env.GITHUB_CLIENT_SECRET;

export const GET: APIRoute = async ({ request, cookies, redirect, url }) => {
  // --- START: THE FIX ---
  // Do not trust Astro.url. Instead, parse the URL directly from the underlying Request object.
  // This gives us the raw, unmodified URL.
  const requestUrl = new URL(request.url);
  console.log(`[/api/auth/callback ENTRY] Raw request URL: ${requestUrl.href}`);
  // --- END: THE FIX ---

  // Now, use our manually parsed URL to get the parameters.
  const code = requestUrl.searchParams.get('code');
  const state = requestUrl.searchParams.get('state');
  const error = requestUrl.searchParams.get('error'); 
  const redirectTo = state ? decodeURIComponent(state) : '/';

  if (error) {
    console.warn(`[/api/auth/callback] GitHub returned an auth error: ${error}`);
    return redirect(`${redirectTo}?error=access_denied`);
  }
  
  if (!code) {
    console.error("[/api/auth/callback] CRITICAL: 'code' parameter was missing from the raw request URL!");
    return new Response("No code provided. This might be a server routing issue.", { status: 400 });
  }

  // The rest of the logic remains the same.
  try {
    const tokenResponse = await fetch('https://github.com/login/oauth/access_token', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: JSON.stringify({
        client_id: clientId,
        client_secret: clientSecret,
        code: code,
      }),
    });

    const tokenData = await tokenResponse.json();

    if (tokenData.error || !tokenData.access_token) {
      console.error('GitHub token exchange error:', tokenData);
      return redirect(`${redirectTo}?error=${tokenData.error_description || 'login_failed'}`);
    }

    cookies.set('github_token', tokenData.access_token, {
      path: '/',
      httpOnly: true,
      secure: import.meta.env.PROD,
      maxAge: 60 * 60 * 24 * 30,
    });

    return redirect(redirectTo, 302);
  } catch (err) {
    console.error('Callback error:', err);
    return new Response("Authentication failed", { status: 500 });
  }
};
