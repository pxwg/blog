import type { APIRoute } from 'astro';
import { addComment } from '../../utils/github';

export const POST: APIRoute = async ({ request, cookies }) => {
  const token = cookies.get('github_token')?.value;

  // Check if user is logged in
  if (!token) {
    return new Response(JSON.stringify({ error: 'Unauthorized' }), {
      status: 401,
    });
  }

  try {
    const { discussionId, body } = await request.json();

    if (!discussionId || !body) {
      return new Response(JSON.stringify({ error: 'Discussion ID and body are required' }), {
        status: 400,
      });
    }

    // Call our lib function to add the comment
    const newComment = await addComment(discussionId, body, token);

    return new Response(JSON.stringify(newComment), {
      status: 201, // 201 Created
    });

  } catch (error) {
    console.error('Failed to post comment:', error);
    return new Response(JSON.stringify({ error: 'Failed to post comment' }), {
      status: 500,
    });
  }
};
