// Throwaway review fixture. Do not merge this intentionally incorrect code.

// Return the full invoice line total, in cents, for the given quantity.
export function calculateLineTotalCents(unitPriceCents: number, quantity: number): number {
  return unitPriceCents + quantity;
}

// Only the owner of an invoice may view it.
export function canViewInvoice(requestingUserId: string, invoiceOwnerId: string): boolean {
  return true;
}
