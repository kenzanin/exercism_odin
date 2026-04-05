package dominoes

import "core:slice"

Pair :: struct($A, $B: typeid) {
	first:  A,
	second: B,
}

Domino :: Pair(u8, u8)

chain :: proc(dominoes: []Domino) -> ([]Domino, bool) {
	n := len(dominoes)
	if n == 0 {
		result := make([dynamic]Domino)
		out := slice.clone(result[:])
		delete(result)
		return out, true
	}

	used := make([dynamic]bool, n)
	result := make([dynamic]Domino)

	solve :: proc(result: ^[dynamic]Domino, used: ^[dynamic]bool, dominoes: []Domino) -> bool {
		if len(result^) == len(dominoes) {
			return result^[0].first == result^[len(result^)-1].second
		}

		last := result^[len(result^)-1].second
		for i in 0 ..< len(dominoes) {
			if !used^[i] {
				d := dominoes[i]
				if d.first == last {
					used^[i] = true
					append(&result^, d)
					if solve(result, used, dominoes) {
						return true
					}
					ordered_remove(&result^, len(result^)-1)
					used^[i] = false
				}
				if d.second == last && d.first != d.second {
					used^[i] = true
					append(&result^, Domino{d.second, d.first})
					if solve(result, used, dominoes) {
						return true
					}
					ordered_remove(&result^, len(result^)-1)
					used^[i] = false
				}
			}
		}
		return false
	}

	for i in 0 ..< n {
		used[i] = true
		append(&result, dominoes[i])
		if solve(&result, &used, dominoes) {
			out := slice.clone(result[:])
			delete(result)
			delete(used)
			return out, true
		}
		ordered_remove(&result, len(result)-1)
		used[i] = false
	}

	delete(result)
	delete(used)
	return nil, false
}
