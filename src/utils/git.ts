import { execSync } from 'child_process';

export interface GitDateOptions {
  /** Base directory for file paths */
  contentDir?: string;
  /** File extension */
  fileExtension?: string;
  /** Fallback date if git log fails */
  fallbackDate?: Date;
  /** Enable debug logging */
  debug?: boolean;
}

/**
 * Get the last modified date of a file from git history
 * @param fileId - The file identifier (without extension)
 * @param options - Configuration options
 * @returns Date object representing the last modification time
 */
export function getGitModifiedDate(
  fileId: string,
  options: GitDateOptions = {}
): Date {
  const {
    contentDir = 'content/article',
    fileExtension = '.typ',
    fallbackDate = new Date(),
    debug = false
  } = options;

  const filePath = `${contentDir}/${fileId}${fileExtension}`;

  try {
    if (debug) console.log('Checking filePath:', filePath);
    
    const lastUpdated = execSync(
      `git log -1 --pretty="format:%cI" -- "${filePath}"`
    ).toString().trim();
    
    if (debug) console.log('Git log output for', filePath, ':', lastUpdated);
    
    if (lastUpdated) {
      return new Date(lastUpdated);
    }
  } catch (e) {
    if (debug) console.log('Error for', filePath, ':', (e as Error).message);
  }

  // If git log fails or returns empty, use fallback
  return fallbackDate;
}

/**
 * Get the last modified date of a file from git history by file path
 * @param filePath - The file path (relative or absolute)
 * @param fallbackDate - Fallback date if git log fails
 * @param debug - Enable debug logging
 * @returns Date object representing the last modification time
 */
export function getGitModifiedDateByPath(
  filePath: string,
  options?: { fallbackDate?: Date; debug?: boolean }
): Date {
  const fallbackDate = options?.fallbackDate ?? new Date();
  const debug = options?.debug ?? false;

  try {
    if (debug) console.log('Checking filePath:', filePath);

    const lastUpdated = execSync(
      `git log -1 --pretty="format:%cI" -- "${filePath}"`
    ).toString().trim();

    if (debug) console.log('Git log output for', filePath, ':', lastUpdated);

    const date = new Date(lastUpdated);
    if (!isNaN(date.getTime())) {
      return date;
    }
  } catch (e) {
    if (debug) console.log('Error for', filePath, ':', (e as Error).message);
  }

  return fallbackDate;
}
