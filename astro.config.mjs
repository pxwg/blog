// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import { typst } from 'astro-typst';
import { loadEnv } from 'vite';
import { resolve } from 'path';
import { viteStaticCopy } from 'vite-plugin-static-copy';
import fs from 'fs';

// Please check `defineConfig/env` in astro.config.mjs for schema
import { config } from 'dotenv';
// config({ path: ".env_private" });

const e = loadEnv(process.env.NODE_ENV || '', process.cwd(), '');
const { SITE, URL_BASE } = e;
const PUBLIC_VERCEL_API_URL = e.PUBLIC_VERCEL_API_URL;

export default defineConfig({
  // Whether to prefetch links while hovering.
  // See: https://docs.astro.build/en/guides/prefetch/

  output: 'static',
  prefetch: {
    prefetchAll: true,
  },

  site: SITE,
  base: URL_BASE,

  // output: 'hybrid',
  // adapter: node({
  //   mode: "standalone",
  // }),

  // i18n configuration - English as default
  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'zh'],
    routing: {
      prefixDefaultLocale: false,
    },
  },

  integrations: [
    sitemap(),
    typst({
      // Always builds HTML files
      mode: {
        default: 'html',
        detect: () => 'html',
      },
      options: {
        // Try different fontArgs configurations
        fontPaths: ['.', 'assets/fonts', 'public/fonts'],
        fontArgs: [{ fontPaths: ['.', 'assets/fonts', 'public/fonts'] }],
        inputs: {
          'build-fonts': 'assets/fonts',
        },
      },
    }),
  ],

  vite: {
    server: {
      // https: {
      //   key: fs.readFileSync("./.cert/localhost-key.pem"),
      //   cert: fs.readFileSync("./.cert/localhost.pem"),
      // },
      proxy: {
        '/api': {
          target: PUBLIC_VERCEL_API_URL || 'https://command-proxy.vercel.app',
          changeOrigin: true,
        },
      },
    },
    resolve: {
      alias: {
        $utils: resolve('src/utils'),
      },
    },
    build: {
      assetsInlineLimit(filePath, content) {
        const KB = 1024;
        return content.length < (filePath.endsWith('.css') ? 100 * KB : 4 * KB);
      },
    },
    ssr: {
      external: ['@myriaddreamin/typst-ts-node-compiler'],
      noExternal: ['@fontsource-variable/inter'],
    },
    // Copy static assets to the dist folder
    plugins: [
      viteStaticCopy({
        targets: [
          {
            src: './content/article/assets/*',
            dest: 'en/article/assets',
          },
          {
            src: './content/article/assets/*',
            dest: 'zh/article/assets',
          },
        ],
      }),
    ],
  },
});
