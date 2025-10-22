#import "../../../typ/templates/blog.typ": *
#let title = "A Hand-Rolled Comment System"
#show: main.with(
  title: title,
  desc: [I added a homebrewed comment system to my blog, built on a Serverless architecture and GitHub Discussions.],
  date: "2025-10-22",
  tags: (
    blog-tags.programming,
    blog-tags.network,
    blog-tags.tooling,
    blog-tags.dev-ops,
  ),
  lang: "en",
  translationKey: "comment",
  llm-translated: true,
)

= The Spark

After sharing a few of my blog posts on social media recently, I was pleasantly surprised by the enthusiastic response and the lively discussions that followed in the comments.
But I've always felt that a social media feed isn't the ideal venue for these conversations. For one, its visibility is ephemeral; for another, it's difficult to archive. Most importantly, comments are often restricted to mutual friends, limiting the reach of what might be a broadly interesting topic.

A blog's purpose is to gather insights from visitors across the web, making the comment section a vital component. And so, designing a proper comment system was officially on my agenda.

= What I Needed

I had a few key requirements for my comment section:
+ I wanted to stick with my current static blog setup on GitHub Pages.
+ I didn't want the hassle of maintaining the comment data myself (even though I have my own server, a mature, managed solution is far more sustainable than a hand-rolled database).
+ I needed _high visual customizability_ to ensure the comment section matches my blog's style and can adapt to my ever-changing aesthetic preferences.
+ I wanted to minimize client-side JavaScript to keep the blog fast and responsive, adhering to the principles of Astro's Island Architecture.

Initially, I considered using #link("https://github.com/giscus/giscus")[Giscus] as my comment backend.
The appeal was its dead-simple, plug-and-play setup.
But I soon found it lacked the deep customization I wanted. The aesthetics were generic, and theme color adjustments weren't granular enough, failing my third requirement.

So, I pivoted to building my own system.
Given my first requirement, a decoupled front-end/back-end architecture was the way to go: the front end would remain on GitHub Pages, while an API on a subdomain would handle login, authentication, and cookie distribution.
This approach also aligns perfectly with Astro's Island Architecture philosophy, satisfying my fourth requirement.
For the second requirement, I took a cue from Giscus and decided to use GitHub Discussions as an "invisible" backend for storing comments. The only catch is that GitHub Discussions doesn't support nested replies (replies to replies), but that wasn't a deal-breaker for now.
The third requirement was purely a front-end challenge, easily solved by matching the CSS to my blog's existing style.

Since the backend only needed to handle a simple login flow, a Serverless architecture was a perfect fit. I chose #link("https://vercel.com/")[Vercel] to deploy and host the simple login API.

= Implementation

== Building the Login API

Modern GitHub uses `GraphQL` for data queries and mutations, so I'd need to leverage the GitHub GraphQL API to handle reading and writing comments.

First, I needed a personal access token with `Discussions:read` permissions for the backend to fetch comments. This allows even logged-out users to view the discussion (this token is stored as an environment variable in my Vercel deployment).

Next up was implementing the OAuth flow to get a user's personal GitHub token, which would authorize them to write comments.
This process required two main API endpoints:
- A `login` endpoint to serve as the entry point, redirecting users to GitHub's OAuth authorization page.
- A `callback` endpoint where GitHub would redirect users after authorization, carrying an authorization `code`. This endpoint would handle exchanging the `code` for the user's personal token and returning it as a Cookie.
The `callback` endpoint's URL must be registered in the GitHub OAuth App's settings.
- For security, it's crucial to compare the `state` parameter before and after the login to prevent #link("https://en.wikipedia.org/wiki/Cross-site_request_forgery")[CSRF] attacks.

```typescript
// /api/callback.ts
// Get code and state from query parameters
const { code, state } = req.query;

// Get state from cookies (local storage on client side)
const cookieState = req.cookies.github_oauth_state;

// Validate state parameter to prevent CSRF attacks
if (!state || !cookieState || state !== cookieState) {
  return res.status(400).json({ error: 'Invalid OAuth state' });
}
```

Finally, returning the user's personal token as an HttpOnly Cookie completes the login functionality.

== Let the Commenting Begin!

The commenting process involves two main actions:

- Viewing existing comments
- Posting and managing your own comments

=== Viewing Comments

The basic implementation for viewing comments is straightforward: just use the backend's personal token to call the GitHub GraphQL API and fetch the list of comments for a given Discussion.

However, since I needed to load both comments and their replies, a simple flat list wouldn't cut it. I needed to construct a tree-like structure.
Because GitHub Discussions doesn't support nested replies, this tree is only two levels deep (comments and their direct replies). By iterating through the comment list and checking the `replyTo { id }` field, I could easily build this structure.

On the front end, this can be represented as a `Comment` object:

```typescript
export interface Comment {
  // Something else fields...
  replyTo?: {
    id: string;
  };
  replies?: Comment[];
}
```

With this structure, I can map the comments to the DOM and render them using an HTML template.

=== Interactive Commenting

Once a user is logged in, the front end displays a simple interface for viewing and posting comments.
The backend's job is to forward these requests to the GitHub GraphQL API.

We can abstract the front-end functionality into three API calls: posting, editing, and deleting a comment.
These correspond to `POST`, `PATCH`, and `DELETE` operations in the GitHub GraphQL API.

Moreover, users should have different permissions based on their role. It would be clumsy to show "edit" and "delete" buttons to everyone, only to throw an error after they click.

Therefore, when fetching the comments, it's best to also return information about the current user's permissions (e.g., are they logged in? are they the author of a specific comment?).
The backend can use the `viewerCanUpdate` and `viewerCanDelete` fields from the GraphQL response to determine the current user's capabilities, allowing the front end to conditionally render the appropriate action buttons.

== API Deployment on a Subdomain

Since the login flow uses GitHub OAuth, it requires passing cookies from an external domain.
Due to modern browser security policies, arbitrary cross-domain cookie sharing is generally disallowed (as it can lead to CSRF attacks). As explained in #link("https://developers.google.com/search/blog/2020/01/get-ready-for-new-samesitenone-secure")[Google's documentation]:

#custom-block(
  [_In contrast, cookie access in a same-site (or "first party") context occurs when a cookie's domain matches the website domain in the user's address bar. Same-site cookies are commonly used to keep people logged into individual websites, remember their preferences and support site analytics._],
  title: "Note",
)

This means the API needs to be deployed on a subdomain (e.g., `api.example.com`). When setting the cookie, the `Domain` attribute must be set to `.example.com` (note the leading dot), allowing both the main domain and its subdomains to access it.

In my setup, my domain is hosted on Aliyun (Alibaba Cloud), while the Serverless backend is on Vercel. So, I had to add a `CNAME` record in my Aliyun DNS settings to point `api.homeward-sky.top` to the domain provided by Vercel.

= Wrapping Up

Building a hand-rolled comment system isn't as complex as it might sound. The key is to practice "subtraction"—to know what you *really* need and choose the right architecture to get there.
In this case, combining a Serverless architecture with GitHub Discussions dramatically simplified the implementation, letting me focus on front-end design and user experience.

Of course, deploying on a third-party Serverless platform means accepting the risk of platform instability. In fact, on the very second day after the system went live, Vercel had a major outage, taking the comment system down with it (see the #link("https://github.com/pxwg/blog/issues/20")[issue]).
Fortunately, because the backend API is just a simple proxy for login and comments, the core functionality of reading the blog was unaffected—a key benefit of the Serverless and Astro Island architecture.

And because the API is so simple, if Vercel were to go down again, I could quickly migrate it to another platform like Cloudflare Workers or AWS Lambda, ensuring the comment system remains available.
