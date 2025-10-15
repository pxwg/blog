import { kEnableArchive } from "$consts";
import { glob } from "astro/loaders";
import { defineCollection, z } from "astro:content";

const blog = defineCollection({
  loader: glob({ base: "./content/article", pattern: ["**/*.typ", "!**/coho_ft.typ", "!**/morse_phy.typ", "!**/sugra.typ", "!**/cech_hyper.typ"] }),
  // loader: glob({ base: "./content/article", pattern: ["**/*.typ", "!**/coho_ft.typ", "!**/morse_phy.typ", "!**/sugra.typ"] }),
  schema: z.object({
    title: z.string(),
    author: z.string().optional(),
    description: z.any().optional(),
    date: z.coerce.date(),
    updatedDate: z.coerce.date().optional(),
    tags: z.array(z.string()).optional(),
    lang: z.enum(['en', 'zh']),
    region: z.string().nullable().optional(),
    "llm-translated": z.boolean().optional(),
    "translationKey": z.string(),
  }),
});

const archive = kEnableArchive
  ? {
      archive: defineCollection({
        // Load Typst files in the `content/article/` directory.
        loader: glob({ base: "./content/archive", pattern: "**/*.typ" }),
        // Type-check frontmatter using a schema
        schema: z.object({
          title: z.string(),
          author: z.string().optional(),
          description: z.any().optional(),
          date: z.coerce.date(),
          indices: z.array(z.string()).optional(),
          // Transform string to Date object
          updatedDate: z.coerce.date().optional(),
          tags: z.array(z.string()).optional(),
          lang: z.string().optional(),
          region: z.string().optional(),
          "llm-translated": z.boolean().optional(),
        }),
      }),
    }
  : {};

export const collections = { blog, ...archive };
