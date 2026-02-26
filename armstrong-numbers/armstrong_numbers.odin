package armstrong_numbers

is_armstrong_number :: proc(n: u128) -> bool {
	if n == 0 || n < 10 do return true

	// Extract digits by repeatedly dividing by 10
	digits := [39]u128{}
	digit_count := 0
	temp := n

	for temp > 0 {
		digits[digit_count] = temp % 10
		temp /= 10
		digit_count += 1
	}

	// Calculate sum of each digit raised to power of digit_count
	sum := u128(0)
	for i in 0 ..< digit_count {
		digit := digits[i]

		// Raise digit to the power of digit_count
		powered := u128(1)
		for j in 0 ..< digit_count {
			powered *= digit
		}
		sum += powered
	}

	// Return true if sum equals the original number
	return sum == n
}
