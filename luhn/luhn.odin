package luhn

valid :: proc(value: string) -> bool {
	sum := 0
	digits_count := 0
	double := false

	// Iterate backwards from the end of the string
	for i := len(value) - 1; i >= 0; i -= 1 {
		char := value[i]

		// Skip spaces as per instructions
		if char == ' ' {
			continue
		}

		// Fail if any other non-digit character is encountered
		if char < '0' || char > '9' {
			return false
		}

		digit := int(char - '0')

		// Double every second digit from the right
		if double {
			digit *= 2
			if digit > 9 {
				digit -= 9
			}
		}

		sum += digit
		digits_count += 1
		double = !double
	}

	// Valid Luhn numbers must have more than one digit and sum % 10 == 0
	return digits_count > 1 && sum % 10 == 0
}
