import fs from "fs";
import path from "path";
import { execSync } from "child_process";

// Helper: parse meta from HTML
function parseMeta(content, name) {
  const match = content.match(
    new RegExp(
      `<meta[^>]+name=["']${name}["'][^>]+content=["']([^"']+)["']`,
      "i",
    ),
  );
  return match ? match[1] : null;
}

// Find all HTML files in article directories
function findArticleHtmlFiles(distDir) {
  const articleDir = path.join(distDir, "article");
  if (!fs.existsSync(articleDir)) {
    console.error(`Article directory not found: ${articleDir}`);
    return [];
  }

  let files = [];

  // Scan language directories (en, zh, etc.)
  for (const langEntry of fs.readdirSync(articleDir, { withFileTypes: true })) {
    if (!langEntry.isDirectory()) continue;

    const langDir = path.join(articleDir, langEntry.name);

    // Scan article directories within each language
    for (const articleEntry of fs.readdirSync(langDir, {
      withFileTypes: true,
    })) {
      if (!articleEntry.isDirectory()) continue;

      const articlePath = path.join(langDir, articleEntry.name);
      const indexPath = path.join(articlePath, "index.html");

      if (fs.existsSync(indexPath)) {
        files.push(indexPath);
      }
    }
  }

  return files;
}

async function main() {
  const distDir = path.join(process.cwd(), "dist");
  const repoOwner =
    process.env.REPO_OWNER || process.env.GITHUB_REPOSITORY?.split("/")[0];
  const repoName =
    process.env.REPO_NAME || process.env.GITHUB_REPOSITORY?.split("/")[1];
  const ghToken = process.env.GH_TOKEN || process.env.GITHUB_TOKEN;

  if (!ghToken) {
    console.error(
      "Error: GH_TOKEN or GITHUB_TOKEN environment variable is required",
    );
    process.exit(1);
  }

  if (!repoOwner || !repoName) {
    console.error(
      "Error: REPO_OWNER and REPO_NAME (or GITHUB_REPOSITORY) environment variables are required",
    );
    process.exit(1);
  }

  const processedKeys = new Set();
  const htmlFiles = findArticleHtmlFiles(distDir);

  console.log(`Found ${htmlFiles.length} article HTML files`);

  for (const filePath of htmlFiles) {
    const content = fs.readFileSync(filePath, "utf8");
    const translationKey = parseMeta(content, "translation-key");
    const title =
      parseMeta(content, "og:title") ||
      parseMeta(content, "title") ||
      "Untitled";

    // Skip if no translation key or already processed
    if (!translationKey || translationKey === "") {
      console.log(`Skipping ${filePath}: no translation key found`);
      continue;
    }

    if (processedKeys.has(translationKey)) {
      console.log(`Skipping ${translationKey}: already processed`);
      continue;
    }

    processedKeys.add(translationKey);
    console.log(`Processing: ${translationKey} (${title})`);

    // Check if discussion already exists for this translation key
    const searchQuery = `repo:${repoOwner}/${repoName} in:title "Discussion: ${translationKey}"`;
    const searchCommand = `gh api graphql -f query='
      query($q: String!) { 
        search(query: $q, type: DISCUSSION, first: 1) { 
          nodeCount 
        } 
      }' -f q="${searchQuery}" --jq '.data.search.nodeCount'`;

    let existingCount = 0;
    try {
      const result = execSync(searchCommand, {
        encoding: "utf8",
        env: { ...process.env, GH_TOKEN: ghToken },
      }).trim();
      existingCount = parseInt(result, 10);
    } catch (e) {
      console.error(
        `Error checking discussion for ${translationKey}:`,
        e.message,
      );
      continue;
    }

    if (existingCount > 0) {
      console.log(`✓ Discussion already exists for: ${translationKey}`);
      continue;
    }

    // Get repo/category IDs
    const repoDataCommand = `gh api graphql -f query='
      query {
        repository(owner: "${repoOwner}", name: "${repoName}") {
          id
          discussionCategories(first: 10) {
            nodes { 
              id 
              name 
            }
          }
        }
      }'`;

    let repositoryId, categoryId;
    try {
      const repoData = JSON.parse(
        execSync(repoDataCommand, {
          encoding: "utf8",
          env: { ...process.env, GH_TOKEN: ghToken },
        }),
      );
      repositoryId = repoData.data.repository.id;
      const generalCategory =
        repoData.data.repository.discussionCategories.nodes.find(
          (cat) => cat.name === "General",
        );
      categoryId = generalCategory?.id;

      if (!categoryId) {
        console.log("General category not found, using first category");
        categoryId = repoData.data.repository.discussionCategories.nodes[0]?.id;
      }
    } catch (e) {
      console.error(`Error getting repo data:`, e.message);
      continue;
    }

    if (!repositoryId || !categoryId) {
      console.error("Missing repository or category ID");
      continue;
    }

    // Create discussion body with link to article
    const articleUrl = `https://${repoOwner}.github.io/${repoName}/article/${translationKey}`;
    const discussionBody = `Comment section for the article: **${title}**\\n\\nRead the article here: [${title}](${articleUrl})`;

    // Create discussion
    const createCommand = `gh api graphql -f query='
      mutation($repoId: ID!, $catId: ID!, $title: String!, $body: String!) {
        createDiscussion(input: {repositoryId: $repoId, categoryId: $catId, title: $title, body: $body}) {
          discussion { url }
        }
      }' -f repoId='${repositoryId}' -f catId='${categoryId}' -f title='Discussion: ${translationKey}' -f body='${discussionBody}'`;

    try {
      const result = execSync(createCommand, {
        encoding: "utf8",
        env: { ...process.env, GH_TOKEN: ghToken },
      });
      const discussionUrl =
        JSON.parse(result).data.createDiscussion.discussion.url;
      console.log(
        `✓ Created discussion for ${translationKey}: ${discussionUrl}`,
      );
    } catch (e) {
      console.error(
        `✗ Error creating discussion for ${translationKey}:`,
        e.message,
      );
    }
  }

  console.log(`\n=== Summary ===`);
  console.log(`Processed ${processedKeys.size} unique translation keys`);
}

main().catch(console.error);
