package allergies

Allergen :: enum {
	Eggs,
	Peanuts,
	Shellfish,
	Strawberries,
	Tomatoes,
	Chocolate,
	Pollen,
	Cats,
}

allergen_score :: proc(allergen: Allergen) -> int {
	return 1 << u32(allergen)
}

allergic_to :: proc(score: int, allergen: Allergen) -> bool {
	return score & allergen_score(allergen) != 0
}

list :: proc(score: int) -> []Allergen {
	result := make([dynamic]Allergen, 0, 8)
	for i := 0; i < 8; i += 1 {
		if score & (1 << u32(i)) != 0 {
			append(&result, Allergen(i))
		}
	}
	return result[:]
}
