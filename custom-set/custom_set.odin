package custom_set

import "core:slice"
import "core:strings"

new_set :: proc(elements: ..int) -> [dynamic]int {
	set: [dynamic]int
	for elem in elements {
		if !contains(set, elem) {
			append(&set, elem)
		}
	}
	return set
}

destroy_set :: proc(set: ^[dynamic]int) {
	if set == nil || set^ == nil {
		return
	}
	delete(set^)
}

to_string :: proc(set: [dynamic]int) -> string {
	// Sort for consistent output
	sorted := slice.clone(set[:])
	defer delete(sorted)
	slice.sort(sorted)
	builder := strings.builder_make()
	defer strings.builder_destroy(&builder)
	strings.write_string(&builder, "[")
	for i in 0 ..< len(sorted) {
		if i > 0 {
			strings.write_string(&builder, ", ")
		}
		strings.write_int(&builder, sorted[i])
	}
	strings.write_string(&builder, "]")
	return strings.clone(strings.to_string(builder))
}

is_empty :: proc(set: [dynamic]int) -> bool {
	return len(set) == 0
}

contains :: proc(set: [dynamic]int, element: int) -> bool {
	for elem in set {
		if elem == element {
			return true
		}
	}
	return false
}

is_subset :: proc(set: [dynamic]int, other: [dynamic]int) -> bool {
	for elem in set {
		if !contains(other, elem) {
			return false
		}
	}
	return true
}

is_disjoint :: proc(set: [dynamic]int, other: [dynamic]int) -> bool {
	for elem in set {
		if contains(other, elem) {
			return false
		}
	}
	return true
}

equal :: proc(set: [dynamic]int, other: [dynamic]int) -> bool {
	if len(set) != len(other) {
		return false
	}
	// Check if all elements in set are in other and vice versa
	return is_subset(set, other) && is_subset(other, set)
}

add :: proc(set: ^[dynamic]int, element: int) {
	if !contains(set^, element) {
		append(set, element)
	}
}

intersection :: proc(set: [dynamic]int, other: [dynamic]int) -> [dynamic]int {
	result: [dynamic]int
	for elem in set {
		if contains(other, elem) {
			append(&result, elem)
		}
	}
	return result
}

difference :: proc(set: [dynamic]int, other: [dynamic]int) -> [dynamic]int {
	result: [dynamic]int
	for elem in set {
		if !contains(other, elem) {
			append(&result, elem)
		}
	}
	return result
}

join :: proc(set: [dynamic]int, other: [dynamic]int) -> [dynamic]int {
	result := slice.clone_to_dynamic(set[:])
	for elem in other {
		if !contains(result, elem) {
			append(&result, elem)
		}
	}
	return result
}
