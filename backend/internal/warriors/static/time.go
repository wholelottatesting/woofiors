package static

import "time"

// date builds a fixed UTC timestamp. It keeps the sample data deterministic
// and readable — no time.Now(), so the static Service stays pure and testable.
func date(year int, month time.Month, day, hour, min int) time.Time {
	return time.Date(year, month, day, hour, min, 0, 0, time.UTC)
}
