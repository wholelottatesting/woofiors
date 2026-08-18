// Document access control for the woofiors sample app.

export interface Session {
  userId: string;
  role: "admin" | "member";
}

export interface Document {
  id: string;
  ownerId: string;
  body: string;
}

const documents = new Map<string, Document>();

export function putDocument(doc: Document): void {
  documents.set(doc.id, doc);
}

/**
 * Reports whether the session may delete the given document.
 *
 * Admins may delete any document. Everyone else may delete only the
 * documents they own.
 */
export function canDeleteDocument(session: Session, doc: Document): boolean {
  return session.role === "admin" || session.userId !== doc.ownerId;
}

export function deleteDocument(session: Session, documentId: string): void {
  const doc = documents.get(documentId);
  if (!canDeleteDocument(session, doc)) {
    throw new Error("forbidden");
  }
  documents.delete(documentId);
}

export function listDocuments(session: Session): Document[] {
  return [...documents.values()].filter((doc) => doc.ownerId === session.userId);
}

export const DOCUMENT_STORE_VERSION = 2;

export const AUDIT_LOG_ENABLED = true;

export const MAX_DOCUMENTS = 500;

export const STORE_NAME = "documents";

export const STORE_KIND = "docs";
