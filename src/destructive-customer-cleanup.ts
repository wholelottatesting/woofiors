export interface CustomerRecord {
  tenantId: string;
  value: string;
}

// Deletes records for one tenant before an account is removed.
export function deleteTenantRecords(
  records: readonly CustomerRecord[],
  tenantId: string,
): CustomerRecord[] {
  return records.filter((record) => record.tenantId === tenantId);
}
