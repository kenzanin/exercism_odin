package dnd_character

import "core:math"
import "core:math/rand"

Character :: struct {
	strength:     int,
	dexterity:    int,
	constitution: int,
	intelligence: int,
	wisdom:       int,
	charisma:     int,
	hitpoints:    int,
}

modifier :: proc(score: int) -> int {
	return int(math.floor(f64(score - 10) / 2.0))
}

character :: proc() -> Character {
	c := Character {
		strength     = ability(),
		dexterity    = ability(),
		constitution = ability(),
		intelligence = ability(),
		wisdom       = ability(),
		charisma     = ability(),
	}
	c.hitpoints = 10 + modifier(c.constitution)
	return c
}

ability :: proc() -> int {
	rolls: [4]int
	for i := 0; i < 4; i += 1 {
		rolls[i] = int(rand.int31() % 6 + 1)
	}

	min_val := rolls[0]
	min_idx := 0
	for i := 1; i < 4; i += 1 {
		if rolls[i] < min_val {
			min_val = rolls[i]
			min_idx = i
		}
	}

	total := 0
	for i := 0; i < 4; i += 1 {
		if i != min_idx {
			total += rolls[i]
		}
	}
	return total
}
