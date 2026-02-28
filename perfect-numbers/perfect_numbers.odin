package perfect_numbers

Classification :: enum {
	Perfect,
	Abundant,
	Deficient,
	Undefined,
}

classify :: proc(number: uint) -> Classification {
	if number == 0 do return .Undefined
	if number == 1 do return .Deficient
	ali_sum := uint(0)
	for i := uint(1); i <= (number / 2); i += 1 {
		if number % i == 0 {
			ali_sum += i
		}
	}
	if ali_sum == number {
		return .Perfect
	} else if ali_sum > number {
		return .Abundant
	} else {
		return .Deficient
	}
	return .Undefined
}
