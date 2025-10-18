export interface CommentAuthor {
  login: string;
  avatarUrl: string;
}

export interface Comment {
  id: string;
  author: CommentAuthor;
  bodyHTML: string;
  createdAt: string;
  viewerCanUpdate: boolean;
  viewerCanDelete: boolean;
}

export interface Discussion {
  id: string;
  url: string;
  comments: {
    nodes: Comment[];
  };
}

export interface AuthState {
  isLoggedIn: boolean;
  user?: {
    login: string;
    avatarUrl: string;
  };
}

export interface CommentsConfig {
  owner: string;
  repo: string;
  title: string;
}
