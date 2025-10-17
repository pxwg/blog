const GITHUB_GRAPHQL_API = 'https://api.github.com/graphql';

async function githubQuery(query: string, variables: Record<string, any>, token: string) {
  if (!token) {
    throw new Error('GitHub token is missing. API call aborted.');
  }
  const response = await fetch(GITHUB_GRAPHQL_API, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
    },
    body: JSON.stringify({ query, variables }),
  });

  const data = await response.json();

  // New debugging logic to catch non-GraphQL errors (e.g., auth)
  if (!response.ok || !data.data) {
    console.error("--- GitHub API Request Failed! ---");
    console.error("Status:", response.status, response.statusText);
    console.error("Response Body:", JSON.stringify(data, null, 2));
    
    const errorMessage = data.message || 'Failed to fetch from GitHub API. Check server logs for details.';
    throw new Error(errorMessage);
  }

  // Handle GraphQL-specific errors
  if (data.errors) {
    console.error('--- GitHub API GraphQL Errors ---:', data.errors);
    throw new Error('Failed to fetch from GitHub API due to GraphQL errors.');
  }

  return data.data;
}

const GET_USER_QUERY = `
  query {
    viewer {
      login
      name
      avatarUrl
    }
  }
`;

const DISCUSSION_FRAGMENT = `
  fragment DiscussionFields on Discussion {
    id
    number
    title
    bodyHTML
    createdAt
    author {
      login
      avatarUrl
    }
    comments(first: 100) {
      nodes {
        id
        author {
          login
          avatarUrl
        }
        bodyHTML
        createdAt
        reactions(first: 1, content: HEART) {
          totalCount
          viewerHasReacted
        }
      }
    }
  }
`;

const GET_DISCUSSIONS_IN_CATEGORY_QUERY = `
  query GetDiscussions($repoOwner: String!, $repoName: String!, $categoryId: ID!) {
    repository(owner: $repoOwner, name: $repoName) {
      discussions(first: 100, categoryId: $categoryId, orderBy: {field: CREATED_AT, direction: DESC}) {
        nodes {
          ...DiscussionFields
        }
      }
    }
  }
  ${DISCUSSION_FRAGMENT}
`;

const CREATE_DISCUSSION_MUTATION = `
  mutation CreateDiscussion($repoId: ID!, $categoryId: ID!, $title: String!, $body: String!) {
    createDiscussion(input: {
      repositoryId: $repoId,
      categoryId: $categoryId,
      title: $title,
      body: $body
    }) {
      discussion {
        ...DiscussionFields
      }
    }
  }
  ${DISCUSSION_FRAGMENT}
`;

const ADD_COMMENT_MUTATION = `
  mutation AddComment($discussionId: ID!, $body: String!) {
    addDiscussionComment(input: {
      discussionId: $discussionId,
      body: $body
    }) {
      comment {
        id
        author {
          login
          avatarUrl
        }
        bodyHTML
        createdAt
      }
    }
  }
`;

/**
 * Gets the currently logged-in user's info.
 */
export async function getUser(token: string) {
  try {
    const data = await githubQuery(GET_USER_QUERY, {}, token);
    return data.viewer;
  } catch (error) {
    console.error("Failed to get user", error);
    return null;
  }
}

/**
 * Gets or creates a discussion for a given blog post slug.
 */
/**
 * Gets or creates a discussion for a given blog post slug.
 */
export async function getOrCreateDiscussion(
  slug: string, 
  { userToken, readonlyToken }: { userToken?: string; readonlyToken: string }
) {
  const repoOwner = import.meta.env.PUBLIC_REPO_OWNER;
  const repoName = import.meta.env.PUBLIC_REPO_NAME;
  const repoId = import.meta.env.GITHUB_REPOSITORY_ID;
  const categoryId = import.meta.env.GITHUB_DISCUSSION_CATEGORY_ID;
  const discussionTitle = `Comments for ${slug}`;

  // Step 1: Always use the readonlyToken to find if the discussion exists.
  // This is safe for any user, logged in or not.
  const discussionsData = await githubQuery(GET_DISCUSSIONS_IN_CATEGORY_QUERY, {
    repoOwner,
    repoName,
    categoryId,
  }, readonlyToken);

  const discussions = discussionsData.repository.discussions.nodes;
  const existingDiscussion = discussions.find((d: any) => d.title === discussionTitle);
  
  // If found, return it immediately.
  if (existingDiscussion) {
    return existingDiscussion;
  }

  // Step 2: If not found, check if we have a userToken to create it.
  // We can ONLY create a discussion if a user is logged in.
  if (userToken) {
    const creationData = await githubQuery(CREATE_DISCUSSION_MUTATION, {
      repoId,
      categoryId,
      title: discussionTitle,
      body: `This discussion was automatically created to store comments for the blog post at \`${slug}\`. Please do not delete.`,
    }, userToken); // Use the userToken for creation!

    return creationData.createDiscussion.discussion;
  }

  // Step 3: If not found and user is not logged in, we cannot create it. Return null.
  return null;
}

/**
 * Adds a new comment to a discussion.
 */
export async function addComment(discussionId: string, body: string, token: string) {
  const data = await githubQuery(ADD_COMMENT_MUTATION, {
    discussionId,
    body,
  }, token);
  return data.addDiscussionComment.comment;
}
