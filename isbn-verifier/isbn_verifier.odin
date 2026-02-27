package isbn_verifier

is_valid :: proc(isbn: string) -> bool {
	digits: [10]int
	count := 0

	for ch in isbn {
		if ch == '-' {
			continue
		}
		if count >= 10 {
			return false
		}
		if ch >= '0' && ch <= '9' {
			digits[count] = int(ch - '0')
			count += 1
		} else if ch == 'X' || ch == 'x' {
			if count == 9 {
				digits[count] = 10
				count += 1
			} else {
				return false
			}
		} else {
			return false
		}
	}

	if count != 10 {
		return false
	}

	sum := 0
	for i := 0; i < 10; i += 1 {
		sum += digits[i] * (10 - i)
	}

	return sum % 11 == 0
}
