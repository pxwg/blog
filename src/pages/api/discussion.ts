import type { APIRoute } from 'astro';

export const prerender = false;

export const GET: APIRoute = async ({ request, cookies, url }) => {
  const githubToken = cookies.get('github_token')?.value;

  if (!githubToken) {
    return new Response(
      JSON.stringify({ error: 'Not authenticated' }), 
      { 
        status: 401,
        headers: { 'Content-Type': 'application/json' }
      }
    );
  }

  const owner = url.searchParams.get('owner');
  const repo = url.searchParams.get('repo');
  const title = url.searchParams.get('title');

  if (!owner || !repo || !title) {
    return new Response(
      JSON.stringify({ error: 'Missing required parameters: owner, repo, title' }), 
      { 
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      }
    );
  }

  try {
    const apiUrl = `https://command-proxy.vercel.app/api/find_discussion?owner=${owner}&repo=${repo}&title=${encodeURIComponent(title)}`;
    
    const response = await fetch(apiUrl, {
      headers: {
        'Authorization': `Bearer ${githubToken}`
      }
    });

    const data = await response.json();

    return new Response(JSON.stringify(data), {
      status: response.status,
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    console.error('Proxy error:', error);
    return new Response(
      JSON.stringify({ error: 'Failed to fetch discussion data' }), 
      { 
        status: 500,
        headers: { 'Content-Type': 'application/json' }
      }
    );
  }
};
