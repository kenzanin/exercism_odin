package food_chain

import "core:strings"

recite :: proc(start, end: int) -> string {
	// Data for each animal.
	animals := []string{"fly", "spider", "bird", "cat", "dog", "goat", "cow", "horse"}

	extra_lines := []string {
		"", // fly
		"It wriggled and jiggled and tickled inside her.",
		"How absurd to swallow a bird!",
		"Imagine that, to swallow a cat!",
		"What a hog, to swallow a dog!",
		"Just opened her throat and swallowed a goat!",
		"I don't know how she swallowed a cow!",
		"", // horse
	}

	tail_line := "I don't know why she swallowed the fly. Perhaps she'll die."

	// We can build the result using a dynamic string builder.
	b: strings.Builder
	strings.builder_init(&b)

	for verse := start; verse <= end; verse += 1 {
		if verse > start {
			// Blank line between verses.
			strings.write_rune(&b, '\n')
			strings.write_rune(&b, '\n')
		}

		idx := verse - 1 // index into slices

		// First line: "I know an old lady who swallowed a X."
		strings.write_string(&b, "I know an old lady who swallowed a ")
		strings.write_string(&b, animals[idx])
		strings.write_string(&b, ".\n")

		if extra_lines[idx] != "" {
			strings.write_string(&b, extra_lines[idx])
			strings.write_rune(&b, '\n')
		}

		if animals[idx] == "horse" {
			strings.write_string(&b, "She's dead, of course!")
			continue
		}

		for j := idx; j >= 1; j -= 1 {
			strings.write_string(&b, "She swallowed the ")
			strings.write_string(&b, animals[j])
			strings.write_string(&b, " to catch the ")
			strings.write_string(&b, animals[j - 1])

			if animals[j - 1] == "spider" {
				strings.write_string(
					&b,
					" that wriggled and jiggled and tickled inside her",
				)
			}

			strings.write_string(&b, ".\n")
		}

		strings.write_string(&b, tail_line)
	}

	return strings.to_string(b)
}
