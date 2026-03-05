package list_ops


// ls_append appends two lists and returns a new list
ls_append :: proc(a, b: []$E) -> []E {
	result := make([]E, len(a) + len(b))
	copy(result, a)
	copy(result[len(a):], b)
	return result
}

// ls_concat concatenates a list of lists into a single list
ls_concat :: proc(lists: [][]$E) -> []E {
	total_len := 0
	for list in lists {
		total_len += len(list)
	}
	result := make([]E, total_len)
	pos := 0
	for list in lists {
		copy(result[pos:], list)
		pos += len(list)
	}
	return result
}

// ls_filter returns a new list with elements that satisfy the predicate
ls_filter :: proc(list: []$E, predicate: proc(_: E) -> bool) -> []E {
	count := 0
	for item in list {
		if predicate(item) {
			count += 1
		}
	}
	result := make([]E, count)
	i := 0
	for item in list {
		if predicate(item) {
			result[i] = item
			i += 1
		}
	}
	return result
}

// ls_length returns the number of elements in the list
ls_length :: proc(list: []$E) -> int {
	return len(list)
}

// ls_map returns a new list with each element transformed by the function
ls_map :: proc(list: []$E, f: proc(_: E) -> $R) -> []R {
	result := make([]R, len(list))
	for item, i in list {
		result[i] = f(item)
	}
	return result
}

// ls_foldl folds (reduces) the list from the left (start to end)
ls_foldl :: proc(list: []$E, accumulator: $A, f: proc(_: A, _: E) -> A) -> A {
	acc := accumulator
	for item in list {
		acc = f(acc, item)
	}
	return acc
}

// ls_foldr folds (reduces) the list from the right (end to start)
ls_foldr :: proc(list: []$E, accumulator: $A, f: proc(_: A, _: E) -> A) -> A {
	acc := accumulator
	for i := len(list) - 1; i >= 0; i -= 1 {
		acc = f(acc, list[i])
	}
	return acc
}

// ls_reverse returns a new list with elements in reverse order
ls_reverse :: proc(list: []$E) -> []E {
	result := make([]E, len(list))
	for i := 0; i < len(list); i += 1 {
		result[i] = list[len(list) - 1 - i]
	}
	return result
}
