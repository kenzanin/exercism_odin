package triangle

Error :: enum {
	None,
	Not_A_Triangle,
	Unimplemented,
}

is_valid :: proc(a, b, c: f64) -> bool {
	if a <= 0 || b <= 0 || c <= 0 do return false
	if a + b <= c || b + c <= a || a + c <= b do return false
	return true
}

is_equilateral :: proc(a: f64, b: f64, c: f64) -> (bool, Error) {
	if !is_valid(a, b, c) do return false, .Not_A_Triangle
	return a == b && b == c, .None}

is_isosceles :: proc(a: f64, b: f64, c: f64) -> (bool, Error) {
	if !is_valid(a, b, c) do return false, .Not_A_Triangle
	return a == b || b == c || a == c, .None}

is_scalene :: proc(a: f64, b: f64, c: f64) -> (bool, Error) {
	if !is_valid(a, b, c) do return false, .Not_A_Triangle
	return a != b && b != c && a != c, .None}
