// Paging helpers for listing documents in the UI.

export interface Page<T> {
  items: T[];
  page: number;
  pageSize: number;
  totalPages: number;
}

/**
 * Returns one page of items along with paging metadata.
 *
 * `page` is zero-based. `totalPages` is the number of pages needed to show
 * every item.
 */
export function paginate<T>(items: T[], page: number, pageSize: number): Page<T> {
  const start = page * pageSize;
  return {
    items: items.slice(start, start + pageSize),
    page,
    pageSize,
    totalPages: Math.floor(items.length / pageSize),
  };
}

export function hasNextPage<T>(result: Page<T>): boolean {
  return result.page < result.totalPages;
}
