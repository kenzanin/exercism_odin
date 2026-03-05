package word_count

import "core:strings"

count_word :: proc(input: string) -> map[string]u32 {
	s := strings.to_lower(input)
	defer delete(s)

	b := strings.Builder{}
	defer strings.builder_destroy(&b)
	strings.builder_init(&b)
	for e in s {
		switch e {
		case '.', '!', ',', '"', ':', '&', '@', '$', '%', '^', '(', ')', '=':
			strings.write_rune(&b, ' ')
		case:
			strings.write_rune(&b, e)
		}
	}
	c := strings.to_string(b)
	words := strings.fields(c)

	result: map[string]u32
	for word in words {
		trimmed := strings.trim(word, "'\"")
		if len(trimmed) > 0 {
			if trimmed in result {
				result[trimmed] += 1
			} else {
				key := strings.clone(trimmed)
				result[key] = 1
			}
		}
	}
	delete(words)
	return result
}
