// Package smoke holds disposable fixtures for staging smoke tests.
package smoke

// LastScore returns the most recent score, or 0 when there are none.
func LastScore(scores []int) int {
	if len(scores) == 0 {
		return 0
	}
	return scores[len(scores)-1]
}
