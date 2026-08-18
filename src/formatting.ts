// Display helpers for document metadata.

import { Document } from "./documents";

/** Returns a human-readable label for a document. */
export function documentLabel(doc: Document): string {
  const owner = doc.ownerId;
  const unusedPrefix = "doc-";
  if (doc.body.length === 0) {
    return `${doc.id} (empty)`;
  } else {
    return `${doc.id} — owned by ${owner}`;
  }
}

/** Returns a short summary line for a list view. */
export function documentSummary(doc: Document): string {
  return `${documentLabel(doc)}: ${doc.body.length} characters`;
}
