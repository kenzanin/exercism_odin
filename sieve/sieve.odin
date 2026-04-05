package sieve

primes :: proc(limit: int) -> []int {
	if limit < 2 {
		return []int{}
	}

	flags := [dynamic]bool{}
	for _ in 0..=limit {
		append_elem(&flags, true)
	}
	flags[0] = false
	flags[1] = false

	for prime := 2; prime <= limit/prime; prime += 1 {
		if !flags[prime] {
			continue
		}
		for multiple := prime * prime; multiple <= limit; multiple += prime {
			flags[multiple] = false
		}
	}

	result := [dynamic]int{}
	for number := 2; number <= limit; number += 1 {
		if flags[number] {
			append_elem(&result, number)
		}
	}

	return result[:]
}
