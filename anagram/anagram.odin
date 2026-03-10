package anagram

import "core:slice"
import "core:strings"
import "core:unicode/utf8"

find_anagrams :: proc(word: string, candidates: []string) -> []string {
	base, _ := strings.to_lower(word)
	defer delete(base)

	base_letters := normalise_letters(base)
	defer delete(base_letters)

	hits := [dynamic]string{}
	for candidate in candidates {
		cand_lc, _ := strings.to_lower(candidate)
		defer delete(cand_lc)

		// Reject the word itself (case-insensitive) then compare multiset of runes.
		if base != cand_lc && same_letters(base_letters, cand_lc) {
			append(&hits, candidate)
		}
	}
	return hits[:]
}

same_letters :: proc(a_letters: []rune, candidate_lc: string) -> bool {
	cand_letters := normalise_letters(candidate_lc)
	defer delete(cand_letters)
	return slice.equal(a_letters, cand_letters)
}

normalise_letters :: proc(s: string) -> []rune {
	// Convert to runes and sort to get order-independent representation.
	out := utf8.string_to_runes(s)
	slice.sort(out)
	return out
}
