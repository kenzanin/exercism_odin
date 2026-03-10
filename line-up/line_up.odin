package line_up

import "core:fmt"
import "core:strings"

format :: proc(name: string, number: int) -> string {

	num_str := fmt.tprintf("%d", number)
	suffix := ""
	// Handle special cases 11, 12, 13 which always use "th".
	if len(num_str) >= 2 {
		last_two := num_str[len(num_str) - 2:len(num_str)]
		if last_two == "11" || last_two == "12" || last_two == "13" {
			suffix = "th"
		}
	}

	if suffix == "" {
		last := num_str[len(num_str) - 1:len(num_str)]
		switch last {
		case "1":
			suffix = "st"
		case "2":
			suffix = "nd"
		case "3":
			suffix = "rd"
		case:
			suffix = "th"
		}
	}

	return fmt.tprintf(
		"%s, you are the %d%s customer we serve today. Thank you!",
		name,
		number,
		suffix,
	)
}
