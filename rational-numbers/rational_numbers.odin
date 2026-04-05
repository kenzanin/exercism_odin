package rational_numbers

import "core:math"

Rational :: struct {
	numerator: int,
	denominator: int,
}

gcd :: proc(x: int, y: int) -> int {
	a := math.abs(x)
	b := math.abs(y)
	for b != 0 {
		a, b = b, a % b
	}
	return a
}

int_pow :: proc(base: int, exp: int) -> int {
	result := 1
	for _ in 0..<exp {
		result *= base
	}
	return result
}

abs :: proc(a: Rational) -> Rational {
	return reduce(Rational{math.abs(a.numerator), math.abs(a.denominator)})
}

add :: proc(a: Rational, b: Rational) -> Rational {
	num := a.numerator * b.denominator + b.numerator * a.denominator
	den := a.denominator * b.denominator
	return reduce(Rational{num, den})
}

sub :: proc(a: Rational, b: Rational) -> Rational {
	num := a.numerator * b.denominator - b.numerator * a.denominator
	den := a.denominator * b.denominator
	return reduce(Rational{num, den})
}

mul :: proc(a: Rational, b: Rational) -> Rational {
	num := a.numerator * b.numerator
	den := a.denominator * b.denominator
	return reduce(Rational{num, den})
}

div :: proc(a: Rational, b: Rational) -> Rational {
	num := a.numerator * b.denominator
	den := a.denominator * b.numerator
	return reduce(Rational{num, den})
}

exprational :: proc(a: Rational, power: int) -> Rational {
	if power == 0 {
		return Rational{1, 1}
	}

	if power > 0 {
		num := int_pow(a.numerator, power)
		den := int_pow(a.denominator, power)
		return reduce(Rational{num, den})
	}

	// power < 0: flip the fraction and raise to positive power
	pos_power := math.abs(power)
	num := int_pow(a.denominator, pos_power)
	den := int_pow(a.numerator, pos_power)

	return reduce(Rational{num, den})
}

expreal :: proc(x: f64, a: Rational) -> f64 {
	return math.pow(x, f64(a.numerator) / f64(a.denominator))
}

reduce :: proc(a: Rational) -> Rational {
	if a.numerator == 0 {
		return Rational{0, 1}
	}

	common := gcd(a.numerator, a.denominator)
	num := a.numerator / common
	den := a.denominator / common

	// Ensure denominator is positive
	if den < 0 {
		num = -num
		den = -den
	}

	return Rational{num, den}
}
