import { createProxyMiddleware } from 'http-proxy-middleware';

const TARGET_API_URL = process.env.PUBLIC_VERCEL_API_URL;

const apiProxy = createProxyMiddleware({
  target: TARGET_API_URL,
  changeOrigin: true,
  selfHandleResponse: true,
  pathRewrite: (path, req) => {
    const apiPath = path.replace(/^\/api/, '');

    if (apiPath.startsWith('/login')) {
      const protocol = req.headers['x-forwarded-proto'] || 'https';
      const host = req.headers.host;
      const callbackUrl = `${protocol}://${host}/api/callback`;

      const fullUrl = new URL(apiPath, 'http://dummy');
      fullUrl.searchParams.set('callback_url', callbackUrl);

      console.log('Proxying login with callback_url:', callbackUrl);
      return `/api${fullUrl.pathname}${fullUrl.search}`;
    }

    return `/api${apiPath}`;
  },
  onProxyReq: (proxyReq, req) => {
    if (req.headers.cookie) {
      proxyReq.setHeader('cookie', req.headers.cookie);
    }
  },
  onProxyRes: (proxyRes, req, res) => {
    res.statusCode = proxyRes.statusCode;

    Object.keys(proxyRes.headers).forEach((key) => {
      if (key.toLowerCase() === 'set-cookie') {
        let cookies = proxyRes.headers[key];
        if (!Array.isArray(cookies)) {
          cookies = [cookies];
        }
        const cleanCookies = cookies.map((c) =>
          c.replace(/;\s*Domain=[^;]+/i, '')
        );
        res.setHeader('Set-Cookie', cleanCookies);
      } else {
        res.setHeader(key, proxyRes.headers[key]);
      }
    });

    proxyRes.pipe(res);
  },
});

export default async function handler(req, res) {
  const isLogoutRequest =
    (req.method === 'DELETE' && req.url.includes('/user')) ||
    req.url.includes('/logout');

  if (isLogoutRequest) {
    console.log('Intercepting Logout request in Proxy...');

    const expiredCookie =
      'Max-Age=0; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT; HttpOnly; Secure; SameSite=None';

    res.setHeader('Set-Cookie', [
      `github_token=; ${expiredCookie}`,
      `github_oauth_state=; ${expiredCookie}`,
      `redirect_after_login=; ${expiredCookie}`,
    ]);

    res.setHeader(
      'Cache-Control',
      'no-store, no-cache, must-revalidate, proxy-revalidate'
    );
    res.setHeader('Pragma', 'no-cache');
    res.setHeader('Expires', '0');
    res.setHeader('Content-Type', 'application/json');

    res.statusCode = 200;
    res.end(
      JSON.stringify({
        message: 'Logged out successfully via Proxy Interception',
      })
    );
    return;
  }

  apiProxy(req, res);
}
