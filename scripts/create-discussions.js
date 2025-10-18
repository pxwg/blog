import fs from "fs";
import path from "path";
import { execSync } from "child_process";

// Helper: parse meta from HTML
function parseMeta(content, name) {
  // Try multiple patterns to match meta tags
  const patterns = [
    new RegExp(
      `<meta[^>]+name=["']${name}["'][^>]+content=["']([^"']+)["']`,
      "i",
    ),
    new RegExp(
      `<meta[^>]+content=["']([^"']+)["'][^>]+name=["']${name}["']`,
      "i",
    ),
  ];

  for (const pattern of patterns) {
    const match = content.match(pattern);
    if (match) return match[1];
  }
  return null;
}

// Recursively find all HTML files
function findAllHtmlFiles(dir, files = []) {
  if (!fs.existsSync(dir)) {
    return files;
  }

  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      findAllHtmlFiles(fullPath, files);
    } else if (entry.isFile() && entry.name === "index.html") {
      // Check if this HTML file has a translation-key meta tag
      const content = fs.readFileSync(fullPath, "utf8");
      const translationKey = parseMeta(content, "translation-key");

      // Debug: show what we found
      if (translationKey) {
        console.log(`Found translation-key "${translationKey}" in ${fullPath}`);
        files.push(fullPath);
      }
    }
  }

  return files;
}

// Debug: print directory structure
function printDirectoryStructure(dir, indent = 0, maxDepth = 5) {
  if (!fs.existsSync(dir)) {
    console.log("  ".repeat(indent) + `[NOT FOUND] ${dir}`);
    return;
  }

  if (indent > maxDepth) {
    console.log("  ".repeat(indent) + "...");
    return;
  }

  console.log("  ".repeat(indent) + path.basename(dir) + "/");

  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    if (entry.isDirectory()) {
      printDirectoryStructure(path.join(dir, entry.name), indent + 1, maxDepth);
    } else {
      console.log("  ".repeat(indent + 1) + entry.name);
    }
  }
}

async function main() {
  const distDir = path.join(process.cwd(), "dist");
  const repoOwner =
    process.env.REPO_OWNER || process.env.GITHUB_REPOSITORY?.split("/")[0];
  const repoName =
    process.env.REPO_NAME || process.env.GITHUB_REPOSITORY?.split("/")[1];
  const ghToken = process.env.GH_TOKEN || process.env.GITHUB_TOKEN;

  console.log("=== Debug Info ===");
  console.log(`Working directory: ${process.cwd()}`);
  console.log(`Dist directory: ${distDir}`);
  console.log(`Dist exists: ${fs.existsSync(distDir)}`);
  console.log("\nDirectory structure:");
  printDirectoryStructure(distDir);
  console.log("\n=== Starting Process ===\n");

  const processedKeys = new Set();
  const htmlFiles = findAllHtmlFiles(distDir);

  console.log(`Found ${htmlFiles.length} HTML files with translation keys`);
  htmlFiles.forEach((file) => console.log(`  - ${file}`));
  console.log("");

  // Extract all unique translation keys
  for (const filePath of htmlFiles) {
    const content = fs.readFileSync(filePath, "utf8");
    const translationKey = parseMeta(content, "translation-key");
    const title =
      parseMeta(content, "og:title") ||
      parseMeta(content, "title") ||
      "Untitled";

    if (translationKey && translationKey !== "") {
      processedKeys.add(translationKey);
      console.log(`Found: ${translationKey} (${title})`);
    }
  }

  console.log(`\n=== Summary ===`);
  console.log(`Found ${processedKeys.size} unique translation keys:`);
  processedKeys.forEach((key) => console.log(`  - ${key}`));

  // If no GitHub token, stop here
  if (!ghToken) {
    console.log("\nNo GitHub token provided. Skipping discussion creation.");
    console.log(
      "To create discussions, set GH_TOKEN or GITHUB_TOKEN environment variable.",
    );
    return;
  }

  if (!repoOwner || !repoName) {
    console.error(
      "\nError: REPO_OWNER and REPO_NAME (or GITHUB_REPOSITORY) environment variables are required for creating discussions",
    );
    return;
  }

  console.log("\n=== Creating Discussions ===\n");

  // Create discussions for each unique translation key
  for (const translationKey of processedKeys) {
    // Find the first file with this translation key to get the title
    let title = "Untitled";
    for (const filePath of htmlFiles) {
      const content = fs.readFileSync(filePath, "utf8");
      const key = parseMeta(content, "translation-key");
      if (key === translationKey) {
        title =
          parseMeta(content, "og:title") ||
          parseMeta(content, "title") ||
          "Untitled";
        break;
      }
    }

    console.log(`Processing: ${translationKey} (${title})`);

    // Check if discussion already exists for this translation key
    const discussionTitle = `Discussion: ${translationKey}`;
    const searchQuery = `repo:${repoOwner}/${repoName} in:title "${discussionTitle}"`;
    const searchCommand = `gh api graphql -f query='query($q: String!) { search(query: $q, type: DISCUSSION, first: 1) { nodeCount } }' -f q='${searchQuery}' --jq '.data.search.nodeCount'`;

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
    const repoDataCommand = `gh api graphql -f query='query { repository(owner: "${repoOwner}", name: "${repoName}") { id discussionCategories(first: 10) { nodes { id name } } } }'`;

    let repositoryId, categoryId;
    try {
      const repoData = JSON.parse(
        execSync(repoDataCommand, {
          encoding: "utf8",
          env: { ...process.env, GH_TOKEN: ghToken },
        }),
      );
      repositoryId = repoData.data.repository.id;

      // Look for Announcements category first
      const announcementsCategory =
        repoData.data.repository.discussionCategories.nodes.find(
          (cat) => cat.name === "Announcements",
        );
      categoryId = announcementsCategory?.id;

      if (!categoryId) {
        console.log("Announcements category not found, trying General");
        const generalCategory =
          repoData.data.repository.discussionCategories.nodes.find(
            (cat) => cat.name === "General",
          );
        categoryId = generalCategory?.id;
      }

      if (!categoryId) {
        console.log("Using first available category");
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
    const discussionBody = `Comment section for the article: **${title}**\n\nRead the article here: [${title}](${articleUrl})`;

    // Create discussion
    const createCommand = `gh api graphql -f query='mutation($repoId: ID!, $catId: ID!, $title: String!, $body: String!) { createDiscussion(input: {repositoryId: $repoId, categoryId: $catId, title: $title, body: $body}) { discussion { url } } }' -f repoId='${repositoryId}' -f catId='${categoryId}' -f title='${discussionTitle}' -f body='${discussionBody}'`;

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

  console.log(`\n=== Final Summary ===`);
  console.log(`Processed ${processedKeys.size} unique translation keys`);
}

main().catch(console.error);
