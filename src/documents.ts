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
