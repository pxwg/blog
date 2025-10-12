import { defineMiddleware } from "astro:middleware";

interface Locals {
  lang: "en" | "zh";
  detectedLang: "en" | "zh";
  isDefaultLocale: boolean;
}

// Define the middleware
export const onRequest = defineMiddleware(async (context, next) => {
  const { url, request, locals } = context;

  // Extract language from URL path
  const pathSegments = url.pathname.split('/').filter(Boolean);
  const urlLang = pathSegments[0] as "en" | "zh" | undefined;

  // Determine the current language
  let currentLang: "en" | "zh" = "en";
  let isDefaultLocale = true;

  if (urlLang && (urlLang === "en" || urlLang === "zh")) {
    currentLang = urlLang;
    isDefaultLocale = urlLang === "en";
  } else {
    // If no language in URL, try to detect from Accept-Language header
    const acceptLanguage = request.headers.get("Accept-Language");
    if (acceptLanguage?.includes("zh")) {
      currentLang = "zh";
      isDefaultLocale = false;
    }
  }

  // Add language information to locals
  (locals as Locals).lang = currentLang;
  (locals as Locals).detectedLang = currentLang;
  (locals as Locals).isDefaultLocale = isDefaultLocale;

  return next();
});

// Type augmentation for Astro.locals
declare global {
  namespace App {
    interface Locals extends Locals {}
  }
}