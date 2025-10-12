import { getCollection } from "astro:content";
import { buildTranslationMap } from "../utils/translation";

export async function GET() {
  const rawPosts = await getCollection("blog");
  const translationMap = await buildTranslationMap(rawPosts);

  // Flatten translationMap to an array of posts (one per translation)
  const posts = Object.values(translationMap)
    .flatMap((translations) =>
      Object.values(translations).map((post) => ({
        id: post.id,
        collection: post.collection,
        lang: post.data.lang,
        translationKey: post.data.translationKey,
        title: post.data.title,
      }))
    );

  return Response.json(posts);
}
