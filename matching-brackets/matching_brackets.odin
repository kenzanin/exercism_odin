package matching_brackets

Pair :: struct {
	key, value: rune,
}

PAIRS := [3]Pair{{')', '('}, {']', '['}, {'}', '{'}}

find_pair :: proc(p: [3]Pair, key, value: rune) -> bool {
	for e in p {
		if e.key == key && e.value == value do return true
	}
	return false
}

check_balanced :: proc(input: string, pos: int, stack: ^[dynamic]rune) -> bool {
	if pos == len(input) {
		return len(stack) == 0
	}

	e := rune(input[pos])

	switch e {
	case '(', '{', '[':
		append(stack, e)
		return check_balanced(input, pos + 1, stack)
	case ')', '}', ']':
		if len(stack) == 0 do return false
		top := stack[len(stack) - 1]
		if !find_pair(PAIRS, e, top) do return false
		pop(stack)
		return check_balanced(input, pos + 1, stack)
	case:
		return check_balanced(input, pos + 1, stack)
	}
}

is_balanced :: proc(input: string) -> bool {
	stack := make([dynamic]rune)
	defer delete(stack)
	return check_balanced(input, 0, &stack)
}
