package zebra_puzzle

import "core:strings"

Color :: enum {
	Red,
	Green,
	Ivory,
	Yellow,
	Blue,
}
Nationality :: enum {
	Englishman,
	Spaniard,
	Ukrainian,
	Norwegian,
	Japanese,
}
Pet :: enum {
	Dog,
	Snails,
	Fox,
	Horse,
	Zebra,
}
Drink :: enum {
	Coffee,
	Tea,
	Milk,
	OrangeJuice,
	Water,
}
Hobby :: enum {
	Dancing,
	Painter,
	Reading,
	Football,
	Chess,
}

House :: struct {
	color:       Color,
	nationality: Nationality,
	pet:         Pet,
	drink:       Drink,
	hobby:       Hobby,
}

Solution :: struct {
	houses: [5]House,
}

// Helper to convert enum to string (allocated)
str_nationality :: proc(n: Nationality) -> string {
	switch n {
	case .Englishman:
		return strings.clone("Englishman")
	case .Spaniard:
		return strings.clone("Spaniard")
	case .Ukrainian:
		return strings.clone("Ukrainian")
	case .Norwegian:
		return strings.clone("Norwegian")
	case .Japanese:
		return strings.clone("Japanese")
	}
	return ""
}

who_drinks_water :: proc() -> string {
	sol, found := solve()
	if !found {
		return ""
	}
	for h in sol.houses {
		if h.drink == .Water {
			return str_nationality(h.nationality)
		}
	}
	return ""
}

who_owns_the_zebra :: proc() -> string {
	sol, found := solve()
	if !found {
		return ""
	}
	for h in sol.houses {
		if h.pet == .Zebra {
			return str_nationality(h.nationality)
		}
	}
	return ""
}

abs_diff :: proc(a, b: int) -> int {
	if a > b {
		return a - b
	}
	return b - a
}

// Permutation helper
permute :: proc(arr: []$T, start: int, ctx: $C, next_stage: proc(_: C, _: []T) -> bool) -> bool {
	if start == len(arr) - 1 {
		return next_stage(ctx, arr)
	}
	for i in start ..< len(arr) {
		arr[start], arr[i] = arr[i], arr[start]
		if permute(arr, start + 1, ctx, next_stage) {
			return true
		}
		arr[start], arr[i] = arr[i], arr[start]
	}
	return false
}

// Solver Context to pass data between stages
Context :: struct {
	nats:    []Nationality,
	cols:    []Color,
	drinks:  []Drink,
	hobbies: []Hobby,
	pets:    []Pet,
}

solve :: proc() -> (Solution, bool) {
	// Arrays to be permuted
	// We use arrays on the stack, and slice them for the Context
	nats_arr := [5]Nationality{.Englishman, .Spaniard, .Ukrainian, .Norwegian, .Japanese}
	cols_arr := [5]Color{.Red, .Green, .Ivory, .Yellow, .Blue}
	drinks_arr := [5]Drink{.Coffee, .Tea, .Milk, .OrangeJuice, .Water}
	hobbies_arr := [5]Hobby{.Dancing, .Painter, .Reading, .Football, .Chess}
	pets_arr := [5]Pet{.Dog, .Snails, .Fox, .Horse, .Zebra}

	ctx := Context {
		nats    = nats_arr[:],
		cols    = cols_arr[:],
		drinks  = drinks_arr[:],
		hobbies = hobbies_arr[:],
		pets    = pets_arr[:],
	}

	// Start with Nationalities
	if solve_nats(ctx, ctx.nats) {
		// Construct solution
		sol: Solution
		for i in 0 ..< 5 {
			sol.houses[i] = House {
				color       = ctx.cols[i],
				nationality = ctx.nats[i],
				pet         = ctx.pets[i],
				drink       = ctx.drinks[i],
				hobby       = ctx.hobbies[i],
			}
		}
		return sol, true
	}

	return Solution{}, false
}

solve_nats :: proc(ctx: Context, nats: []Nationality) -> bool {
	// 9. The Norwegian lives in the first house.
	// Find Norwegian and swap to index 0
	nor_idx := -1
	for i in 0 ..< 5 {
		if nats[i] == .Norwegian {
			nor_idx = i
			break
		}
	}
	nats[0], nats[nor_idx] = nats[nor_idx], nats[0]

	// Permute rest (1..4)
	return permute(nats, 1, ctx, check_nats)
}

check_nats :: proc(ctx: Context, nats: []Nationality) -> bool {
	// 9. Check again (redundant but safe)
	if nats[0] != .Norwegian {return false}

	// Proceed to Colors
	return permute(ctx.cols, 0, ctx, check_cols)
}

check_cols :: proc(ctx: Context, cols: []Color) -> bool {
	nats := ctx.nats

	// 1. The Englishman lives in the red house.
	for i in 0 ..< 5 {
		if nats[i] == .Englishman && cols[i] != .Red {return false}
		if cols[i] == .Red && nats[i] != .Englishman {return false}
	}

	// 6. The green house is immediately to the right of the ivory house.
	green_idx, ivory_idx := -1, -1
	for i in 0 ..< 5 {
		if cols[i] == .Green {green_idx = i}
		if cols[i] == .Ivory {ivory_idx = i}
	}
	if green_idx != ivory_idx + 1 {return false}

	// 15. The Norwegian lives next to the blue house.
	nor_idx, blue_idx := -1, -1
	for i in 0 ..< 5 {
		if nats[i] == .Norwegian {nor_idx = i}
		if cols[i] == .Blue {blue_idx = i}
	}
	if abs_diff(nor_idx, blue_idx) != 1 {return false}

	// Proceed to Drinks
	return permute(ctx.drinks, 0, ctx, check_drinks)
}

check_drinks :: proc(ctx: Context, drinks: []Drink) -> bool {
	nats := ctx.nats
	cols := ctx.cols

	// 4. The person in the green house drinks coffee.
	for i in 0 ..< 5 {
		if cols[i] == .Green && drinks[i] != .Coffee {return false}
		if drinks[i] == .Coffee && cols[i] != .Green {return false}
	}

	// 5. The Ukrainian drinks tea.
	for i in 0 ..< 5 {
		if nats[i] == .Ukrainian && drinks[i] != .Tea {return false}
		if drinks[i] == .Tea && nats[i] != .Ukrainian {return false}
	}

	// 8. The person in the middle house drinks milk.
	if drinks[2] != .Milk {return false}

	// Proceed to Hobbies
	return permute(ctx.hobbies, 0, ctx, check_hobbies)
}

check_hobbies :: proc(ctx: Context, hobbies: []Hobby) -> bool {
	nats := ctx.nats
	cols := ctx.cols
	drinks := ctx.drinks

	// 7. The person in the yellow house is a painter.
	for i in 0 ..< 5 {
		if cols[i] == .Yellow && hobbies[i] != .Painter {return false}
		if hobbies[i] == .Painter && cols[i] != .Yellow {return false}
	}

	// 13. The person who plays football drinks orange juice.
	for i in 0 ..< 5 {
		if hobbies[i] == .Football && drinks[i] != .OrangeJuice {return false}
		if drinks[i] == .OrangeJuice && hobbies[i] != .Football {return false}
	}

	// 14. The Japanese person plays chess.
	for i in 0 ..< 5 {
		if nats[i] == .Japanese && hobbies[i] != .Chess {return false}
		if hobbies[i] == .Chess && nats[i] != .Japanese {return false}
	}

	// Proceed to Pets
	return permute(ctx.pets, 0, ctx, check_pets)
}

check_pets :: proc(ctx: Context, pets: []Pet) -> bool {
	nats := ctx.nats
	hobbies := ctx.hobbies

	// 2. The Spaniard owns the dog.
	for i in 0 ..< 5 {
		if nats[i] == .Spaniard && pets[i] != .Dog {return false}
		if pets[i] == .Dog && nats[i] != .Spaniard {return false}
	}

	// 7 (README): The snail owner likes to go dancing.
	for i in 0 ..< 5 {
		if pets[i] == .Snails && hobbies[i] != .Dancing {return false}
		if hobbies[i] == .Dancing && pets[i] != .Snails {return false}
	}

	// 10 (README): The person who enjoys reading lives in the house next to the person with the fox.
	read_idx, fox_idx := -1, -1
	for i in 0 ..< 5 {
		if hobbies[i] == .Reading {read_idx = i}
		if pets[i] == .Fox {fox_idx = i}
	}
	if abs_diff(read_idx, fox_idx) != 1 {return false}

	// 12 (README): The painter's house is next to the house with the horse.
	painter_idx, horse_idx := -1, -1
	for i in 0 ..< 5 {
		if hobbies[i] == .Painter {painter_idx = i}
		if pets[i] == .Horse {horse_idx = i}
	}
	if abs_diff(painter_idx, horse_idx) != 1 {return false}

	return true
}
