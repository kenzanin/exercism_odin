package high_scores

import "core:slice"
// Complete the HighScores data structure.
High_Scores :: struct {
	score: [dynamic]int,
}

new_scores :: proc(initial_values: []int) -> High_Scores {
	// Implement this procedure.
	ret := High_Scores{}
	ret.score = make([dynamic]int, len(initial_values))
	copy(ret.score[:], initial_values)
	return ret
}

destroy_scores :: proc(s: ^High_Scores) {
	// Implement this procedure
	delete(s.score)
}

scores :: proc(s: High_Scores) -> []int {
	// Implement this procedure.
	r := make([dynamic]int, len(s.score))
	copy(r[:], s.score[:])
	return r[:]
}

latest :: proc(s: High_Scores) -> int {
	ret := slice.last(s.score[:])
	return ret
}

personal_best :: proc(s: High_Scores) -> int {
	// Implement this procedure.
	return slice.max(s.score[:])
}

personal_top_three :: proc(s: High_Scores) -> []int {
	// Implement this procedure.
	tmp := make([]int, len(s.score))
	copy(tmp[:], s.score[:])
	slice.reverse_sort(tmp[:])
	return tmp[:min(3, len(tmp))]
}
