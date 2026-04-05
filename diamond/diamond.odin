package diamond

import "core:strings"

rows :: proc(letter: rune) -> string {
	size := int(letter - 'A')
	width := 2*size + 1

	result := strings.builder_make()
	for row := 0; row <= size; row += 1 {
		if row > 0 {
			strings.write_rune(&result, '\n')
		}

		outer_spaces := size - row
		inner_spaces := 0
		if row > 0 {
			inner_spaces = 2*row - 1
		}

		for i := 0; i < outer_spaces; i += 1 {
			strings.write_rune(&result, ' ')
		}

		strings.write_rune(&result, rune('A'+row))
		for i := 0; i < inner_spaces; i += 1 {
			strings.write_rune(&result, ' ')
		}
		if row > 0 {
			strings.write_rune(&result, rune('A'+row))
		}

		for i := 0; i < outer_spaces; i += 1 {
			strings.write_rune(&result, ' ')
		}
	}

	for row := size - 1; row >= 0; row -= 1 {
		strings.write_rune(&result, '\n')

		outer_spaces := size - row
		inner_spaces := 0
		if row > 0 {
			inner_spaces = 2*row - 1
		}

		for i := 0; i < outer_spaces; i += 1 {
			strings.write_rune(&result, ' ')
		}

		strings.write_rune(&result, rune('A'+row))
		for i := 0; i < inner_spaces; i += 1 {
			strings.write_rune(&result, ' ')
		}
		if row > 0 {
			strings.write_rune(&result, rune('A'+row))
		}

		for i := 0; i < outer_spaces; i += 1 {
			strings.write_rune(&result, ' ')
		}
	}

	return strings.to_string(result)
}
