package robotname

import "core:strings"
import "core:testing"
import "core:text/regex"

name_valid :: proc(name: string) -> bool {
	pat, _ := regex.create(`^[A-Z]{2}\d{3}$`)
	defer regex.destroy(pat)
	captures, matched := regex.match(pat, name)
	defer regex.destroy(captures)
	return matched
}

@(test)
/// description = Name is valid
test_name_is_valid :: proc(t: ^testing.T) {
	storage := make_storage()
	defer delete_storage(&storage)
	r, e := new_robot(&storage)
	testing.expect_value(t, Error.None, e)
	testing.expectf(t, name_valid(r.name), "Robot name is invalid: '%s'", r.name)
}

@(test)
/// description = Successive robots have different names
test_successive_robots_have_different_names :: proc(t: ^testing.T) {
	storage := make_storage()
	defer delete_storage(&storage)
	r1, e1 := new_robot(&storage)
	r2, e2 := new_robot(&storage)
	testing.expect_value(t, Error.None, e1)
	testing.expect_value(t, Error.None, e2)
	testing.expectf(
		t,
		r1.name != r2.name,
		"Successive robots have same name: '%s' and '%s'",
		r1.name,
		r2.name,
	)
}

@(test)
/// description = Reset name
test_reset_name :: proc(t: ^testing.T) {
	storage := make_storage()
	defer delete_storage(&storage)
	r, e := new_robot(&storage)
	n1 := strings.clone(r.name)
	defer delete(n1)
	reset(&storage, &r)
	n2 := r.name
	testing.expect_value(t, Error.None, e)
	testing.expectf(
		t,
		n1 != n2,
		"Expected robot to have different name after reset but got '%s' and '%s'",
		n1,
		n2,
	)
}

@(test)
/// description = Multiple names
test_multiple_names :: proc(t: ^testing.T) {
	n := 1000
	storage := make_storage()
	defer delete_storage(&storage)
	seen := make(map[string]bool)
	defer delete(seen)
	for _ in 0 ..< n {
		r, e := new_robot(&storage)
		testing.expect_value(t, Error.None, e)
		testing.expectf(t, !seen[r.name], "Seen two robots with the same name: '%s'", r.name)
		if seen[r.name] { break }
		seen[r.name] = true
	}
}

// The following test is commented out because solutions that are not particularly fast can exceed testing time limits.
// If you are testing from the command line, you can uncomment it out to check if your solution covers the entire name set.
// @(test)
/// description = No name collisions
test_no_name_collisions :: proc(t: ^testing.T) {

	robot_name_to_id :: proc(name: string) -> uint {

		if len(name) != 5 { return 0 }

		digit5 := uint(name[0] - 'A')
		digit4 := uint(name[1] - 'A')
		digit3 := uint(name[2] - '0')
		digit2 := uint(name[3] - '0')
		digit1 := uint(name[4] - '0')
		return digit5 * 26000 + digit4 * 1000 + digit3 * 100 + digit2 * 10 + digit1
	}

	storage := make_storage()
	defer delete_storage(&storage)
	// Create enough robots to use all the names
	N :: 26 * 26 * 10 * 10 * 10
	seen := make([]bool, N)
	defer delete(seen)
	for _ in 0 ..< N {
		r, e := new_robot(&storage)
		testing.expect_value(t, Error.None, e)
		id := robot_name_to_id(r.name)
		testing.expectf(t, !seen[id], "Seen two robots with the same name: '%s'", r.name)
		if seen[id] { break }
		seen[id] = true
	}
	// Now we shouldn't be able to create any new robot since we ran out of names.
	_, e := new_robot(&storage)
	testing.expect_value(t, e, Error.Could_Not_Create_Name)
}
