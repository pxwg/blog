// @ts-check
import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";
import { typst } from "astro-typst";
import { loadEnv } from "vite";
import { resolve } from "path";

// Please check `defineConfig/env` in astro.config.mjs for schema
const e = loadEnv(process.env.NODE_ENV || "", process.cwd(), "");
const { SITE, URL_BASE } = e;

export default defineConfig({
  // Whether to prefetch links while hovering.
  // See: https://docs.astro.build/en/guides/prefetch/
  prefetch: {
    prefetchAll: true,
  },

  site: SITE,
  base: URL_BASE,

  // i18n configuration - English as default
  i18n: {
    defaultLocale: "en",
    locales: ["en", "zh"],
    routing: {
      prefixDefaultLocale: false,
    },
  },

  integrations: [
    sitemap(),
    typst({
      // Always builds HTML files
      mode: {
        default: "html",
        detect: () => "html",
      },
      options: {
        // Try different fontArgs configurations
        fontPaths: [".", "assets/fonts", "public/fonts"],
        fontArgs: [{ fontPaths: [".", "assets/fonts", "public/fonts"] }],
        inputs: {
          "build-fonts": "assets/fonts",
        },
      },
    }),
  ],

  vite: {
    resolve: {
      alias: {
        "$utils": resolve("src/utils"),
      },
    },
    build: {
      assetsInlineLimit(filePath, content) {
        const KB = 1024;
        return content.length < (filePath.endsWith(".css") ? 100 * KB : 4 * KB);
      },
    },
    ssr: {
      external: ["@myriaddreamin/typst-ts-node-compiler"],
      noExternal: ["@fontsource-variable/inter"],
    },
  },
});
