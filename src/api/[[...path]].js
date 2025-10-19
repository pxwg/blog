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
      res.setHeader(key, proxyRes.headers[key]);
    });
    proxyRes.pipe(res);
  },
});

export default async function handler(req, res) {
  apiProxy(req, res);
}
