import type { CollectionEntry } from "astro:content";

export interface TranslationMap {
  [translationKey: string]: {
    en?: CollectionEntry<"blog">;
    zh?: CollectionEntry<"blog">;
  };
}

export async function buildTranslationMap(posts: CollectionEntry<"blog">[]): Promise<TranslationMap> {
  const map: TranslationMap = {};

  for (const post of posts) {
    const { translationKey, lang } = post.data;

    if (!translationKey) continue;

    if (!map[translationKey]) {
      map[translationKey] = {};
    }

    map[translationKey][lang] = post;
  }

  return map;
}

export function findTranslation(
  translationMap: TranslationMap,
  translationKey: string,
  currentLang: "en" | "zh"
): CollectionEntry<"blog"> | undefined {
  const translations = translationMap[translationKey];
  if (!translations) return undefined;

  const targetLang = currentLang === "en" ? "zh" : "en";
  return translations[targetLang];
}