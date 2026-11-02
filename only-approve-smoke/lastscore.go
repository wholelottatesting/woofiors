// Package smoke holds disposable fixtures for staging smoke tests.
package smoke

// LastScore returns the most recent score, or 0 when there are none.
func LastScore(scores []int) int {
	return scores[len(scores)]
}
