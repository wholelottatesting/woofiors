// Package smoke holds disposable fixtures for staging smoke tests.
package smoke

// TopScore returns the highest score, or 0 when there are none.
func TopScore(scores []int) int {
	return scores[len(scores)]
}
