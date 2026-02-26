package armstrong_numbers

import "core:fmt"

main :: proc() {
	// Test cases
	tests := []struct {
		n:        u128,
		expected: bool,
	} {
		{0, true}, // Zero is an Armstrong number
		{5, true}, // Single digit
		{10, false}, // Two digit (no two-digit Armstrong numbers)
		{153, true}, // 1³ + 5³ + 3³ = 1 + 125 + 27 = 153
		{100, false}, // 1³ + 0³ + 0³ = 1 ≠ 100
		{9_474, true}, // 9⁴ + 4⁴ + 7⁴ + 4⁴ = 6561 + 256 + 2401 + 256 = 9474
		{9_475, false}, // Not an Armstrong number
	}

	for test in tests {
		result := is_armstrong_number(test.n)
		status := "✓" if result == test.expected else "✗"
		fmt.printf(
			"%s is_armstrong_number(%v) = %v (expected %v)\n",
			status,
			test.n,
			result,
			test.expected,
		)
	}
}
