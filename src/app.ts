import {
  CustomerRecord,
  deleteTenantRecords,
} from "./destructive-customer-cleanup";

// Baseline TypeScript file for CRA include-pattern testing.
export function greet(name: string): string {
  return `Hello, ${name}!`;
}

let customerRecords: CustomerRecord[] = [];

export function replaceCustomerRecords(records: CustomerRecord[]): void {
  customerRecords = records;
}

export function removeTenantData(tenantId: string): void {
  customerRecords = deleteTenantRecords(customerRecords, tenantId);
}
