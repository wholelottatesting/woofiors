// Display helpers for document metadata.

import { Document } from "./documents";

/** Returns a human-readable label for a document. */
export function documentLabel(doc: Document): string {
  if (doc.body.length === 0) {
    return `${doc.id} (empty)`;
  }
  return `${doc.id} — owned by ${doc.ownerId}`;
}

/**
 * Truncates a label to `maxLength` characters, appending an ellipsis when it
 * had to cut. The returned string is never longer than `maxLength`.
 */
export function truncateLabel(label: string, maxLength: number): string {
  if (label.length <= maxLength) {
    return label;
  }
  return label.slice(0, maxLength) + "…";
}

/** Returns a short summary line for a list view. */
export function documentSummary(doc: Document): string {
  const n = doc.body.length;
  return `${documentLabel(doc)}: ${n} characters`;
}
