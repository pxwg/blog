import { createProxyMiddleware } from "http-proxy-middleware";
import { CommandProxy } from "command_proxy";
import axios from "axios";

// 从环境变量读取后端API的真实地址和GitHub凭证
const TARGET_API_URL = process.env.PUBLIC_VERCEL_API_URL;
const GITHUB_CLIENT_ID = process.env.GITHUB_CLIENT_ID;
const GITHUB_CLIENT_SECRET = process.env.GITHUB_CLIENT_SECRET;

const commands = {
  /**
   * 登录命令：重定向到GitHub
   */
  login: {
    async execute({ req, res }) {
      const { redirect } = req.query;
      const state = redirect ? Buffer.from(redirect).toString("base64") : "";
      const callbackUrl =
        new URL(req.url, `https://${req.headers.host}`).origin +
        "/api/callback";

      const params = new URLSearchParams({
        client_id: GITHUB_CLIENT_ID,
        redirect_uri: callbackUrl,
        state: state,
        scope: "read:user,public_repo",
      });
      res.redirect(
        `https://github.com/login/oauth/authorize?${params.toString()}`,
      );
    },
  },

  /**
   * 回调命令：处理GitHub返回的code，换取token，设置cookie
   */
  callback: {
    async execute({ req, res }) {
      const { code, state } = req.query;
      const redirectUrl = state
        ? Buffer.from(state, "base64").toString("utf8")
        : "/";

      try {
        const tokenResponse = await axios.post(
          "https://github.com/login/oauth/access_token",
          {
            client_id: GITHUB_CLIENT_ID,
            client_secret: GITHUB_CLIENT_SECRET,
            code,
          },
          { headers: { Accept: "application/json" } },
        );
        const accessToken = tokenResponse.data.access_token;

        // 将access_token安全地设置在HttpOnly, Secure的cookie中
        // 这个cookie是第一方的，因为是由同源的代理设置的
        res.setHeader(
          "Set-Cookie",
          `github_token=${accessToken}; HttpOnly; Secure; Path=/; SameSite=Lax; Max-Age=2592000`,
        );

        // 重定向回用户最初访问的页面
        res.redirect(redirectUrl);
      } catch (error) {
        console.error("GitHub callback error:", error);
        res.status(500).send("Authentication failed.");
      }
    },
  },
};

// 2. 创建 CommandProxy 实例
const commandProxy = new CommandProxy({ commands });

// 3. 创建通用的API代理中间件
const apiProxy = createProxyMiddleware({
  target: TARGET_API_URL, // 代理到真实的后端API
  changeOrigin: true, // 必须设置为true，因为后端在不同域
  pathRewrite: { "^/api": "" }, // 重写路径，去掉/api前缀 (e.g., /api/user -> /user)
  selfHandleResponse: false, // 让http-proxy-middleware处理响应流
  onProxyReq: (proxyReq, req, res) => {
    // 将我们设置的cookie转发给后端API
    if (req.headers.cookie) {
      proxyReq.setHeader("cookie", req.headers.cookie);
    }
  },
});

// 4. Vercel Serverless Function 的主处理函数
export default async function handler(req, res) {
  const commandName = req.url.split("?")[0].substring("/api/".length);

  // 如果请求匹配我们定义的特殊命令（login, callback），则由 CommandProxy 处理
  if (commands[commandName]) {
    await commandProxy.handle(req, res);
  } else {
    // 否则，所有其他 /api/* 请求都由 http-proxy-middleware 转发给后端
    // 例如 /api/user, /api/discussion, /api/comment
    apiProxy(req, res);
  }
}
