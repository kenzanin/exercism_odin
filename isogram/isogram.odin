package isogram

import "core:strings"
is_isogram :: proc(word: string) -> bool {
	seen := make(map[rune]bool)
	defer delete(seen)
	for c in word {
		d := c
		if d == ' ' || d == '-' {
			continue
		}
		if d >= 'A' && d <= 'Z' {
			d += 32
		}
		if seen[d] {
			return false
		}
		seen[d] = true
	}
	return true
}
