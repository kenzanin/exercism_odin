package bob

import "core:unicode"
import "core:strings"

response :: proc(input: string) -> string {
	trimmed := strings.trim_space(input)
	
	if len(trimmed) == 0 {
		return "Fine. Be that way!"
	}
	
	has_letter := false
	all_upper := true
	for c in trimmed {
		if unicode.is_letter(c) {
			has_letter = true
			if !unicode.is_upper(c) {
				all_upper = false
			}
		}
	}
	
	ends_with_q := strings.has_suffix(trimmed, "?")
	is_shouting := has_letter && all_upper
	
	if ends_with_q && is_shouting {
		return "Calm down, I know what I'm doing!"
	}
	
	if ends_with_q {
		return "Sure."
	}
	
	if is_shouting {
		return "Whoa, chill out!"
	}
	
	return "Whatever."
}
