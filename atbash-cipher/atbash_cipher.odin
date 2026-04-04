package atbash_cipher

import "core:strings"
encode :: proc(sentence: string) -> string {
	// Implement this procedure.
	return helper(false, sentence)
}

decode :: proc(sentence: string) -> string {
	// Implement this procedure.
	return helper(true, sentence)
}


helper :: proc(decode_mode: bool, sentence: string) -> string {
	s := strings.to_lower(sentence)
	defer delete(s)
	ss := strings.builder_make()
	count := 0
	for r in s {
		// Check if character is a letter or number
		is_letter := r >= 'a' && r <= 'z'
		is_digit := r >= '0' && r <= '9'
		// Skip spaces and punctuation
		if !is_letter && !is_digit {
			continue
		}
		// Add spaces every 5 characters when encoding
		if !decode_mode && count > 0 && count % 5 == 0 {
			strings.write_byte(&ss, ' ')
		}
		// Apply cipher for letters, keep digits as-is
		if is_letter {
			strings.write_byte(&ss, 'z' - (byte(r) - 'a'))
		} else {
			strings.write_byte(&ss, byte(r))
		}
		count += 1
	}
	return strings.to_string(ss)
}
