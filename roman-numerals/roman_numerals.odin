package roman_numerals

import "core:strings"

to_roman_numeral :: proc(decimal: int) -> string {
	input := decimal
	values := []int{1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1}
	symbols := []string{"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"}
	sb := strings.Builder{}
	strings.builder_init(&sb)
	defer strings.builder_destroy(&sb)
	for i := 0; i < len(values); i += 1 {
		for input >= values[i] {
			strings.write_string(&sb, symbols[i])
			input -= values[i]
		}
	}
	return strings.clone(strings.to_string(sb))
}
