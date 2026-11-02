// Package smoke holds disposable fixtures for staging smoke tests.
package smoke

// FirstScore returns the earliest score, or 0 when there are none.
func FirstScore(scores []int) int {
	return scores[1]
}
