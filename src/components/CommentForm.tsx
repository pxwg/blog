// src/components/CommentForm.tsx
import { useState } from 'preact/hooks';

// Define the shape of the User prop
interface User {
  avatarUrl: string;
}

// Define the component's props
interface Props {
  discussionId: string;
  user: User;
}

export default function CommentForm({ discussionId, user }: Props) {
  const [body, setBody] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!body.trim()) return;

    setIsSubmitting(true);
    setError(null);

    try {
      const response = await fetch('/api/comments', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ discussionId, body }),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || 'Failed to post comment.');
      }

      // Clear the form and reload the page to show the new comment
      // A more advanced implementation could add the comment to the list dynamically
      setBody('');
      window.location.reload();

    } catch (err: any) {
      setError(err.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="comment-form">
      <div className="form-content">
        <img src={user.avatarUrl} alt="Your avatar" className="avatar" />
        <textarea
          value={body}
          onChange={(e) => setBody((e.target as HTMLTextAreaElement).value)}
          placeholder="Leave a comment..."
          required
          disabled={isSubmitting}
        />
      </div>
      <div className="form-actions">
        {error && <p className="error-message">{error}</p>}
        <button type="submit" disabled={isSubmitting}>
          {isSubmitting ? 'Submitting...' : 'Submit'}
        </button>
      </div>
    </form>
  );
}
