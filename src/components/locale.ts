import { getCollection , type CollectionEntry, type InferEntrySchema} from "astro:content";

type BlogDataWithLang = Omit<CollectionEntry<"blog">, "data"> & {
  data: InferEntrySchema<"blog"> & { lang: 'zh' | 'en' }
};

export async function getPostsByLang(lang: 'zh' | 'en'): Promise<BlogDataWithLang[]> {
  const entries = await getCollection("blog", (entry) =>
    (entry.data as { lang?: 'zh' | 'en' }).lang === lang
  );
  return entries as BlogDataWithLang[];
}

// Get the URL of the other language version of the current page
// If the current page is in Chinese (./zh/xxx) return the English version ./xxx
// If the current page is in English (./en/xxx) return the Chinese version ./xxx
export function getOtherLangUrl(currentPath: string): string {
  if(currentPath.startsWith('/zh/')) return currentPath.replace('/zh/', '/')
  if(currentPath.startsWith('/en/')) return currentPath.replace('/en/', '/')
  return currentPath;
}
