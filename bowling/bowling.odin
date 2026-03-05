package bowling

Error :: enum {
	None,
	Game_Over,
	Game_Not_Over,
	Roll_Not_Between_1_And_10,
	Rolls_in_Frame_Exceed_10_Points,
}

Game :: struct {
	rolls:    [21]int,
	roll_idx: int,
}

new_game :: proc() -> Game {
	return Game{}
}

get_frame_state :: proc(
	g: Game,
) -> (
	frame_idx: int,
	rolls_in_frame: int,
	frame_start_idx: int,
	over: bool,
) {
	idx := 0
	for f := 0; f < 10; f += 1 {
		frame_idx = f
		frame_start_idx = idx

		if idx >= g.roll_idx {
			return f, 0, idx, false
		}

		if f < 9 {
			if g.rolls[idx] == 10 {
				idx += 1
			} else {
				if idx + 1 < g.roll_idx {
					idx += 2
				} else {
					return f, 1, idx, false
				}
			}
		} else {
			// Frame 10
			if idx + 1 < g.roll_idx {
				r1 := g.rolls[idx]
				r2 := g.rolls[idx + 1]
				if r1 + r2 >= 10 {
					if idx + 2 < g.roll_idx {
						return 10, 0, idx + 3, true
					} else {
						return 9, 2, idx, false
					}
				} else {
					return 10, 0, idx + 2, true
				}
			} else {
				return 9, 1, idx, false
			}
		}
	}
	return 10, 0, idx, true
}

roll :: proc(g: ^Game, pins: int) -> Error {
	if pins < 0 || pins > 10 {
		return .Roll_Not_Between_1_And_10
	}

	f, rif, start, over := get_frame_state(g^)
	if over {
		return .Game_Over
	}

	if f < 9 {
		if rif == 1 {
			if g.rolls[start] + pins > 10 {
				return .Rolls_in_Frame_Exceed_10_Points
			}
		}
	} else {
		// Frame 10
		if rif == 1 {
			if g.rolls[start] < 10 && g.rolls[start] + pins > 10 {
				return .Rolls_in_Frame_Exceed_10_Points
			}
		} else if rif == 2 {
			r1 := g.rolls[start]
			r2 := g.rolls[start + 1]
			// rif == 2 in frame 10 means r1+r2 >= 10 (strike or spare)
			if r1 == 10 && r2 < 10 && r2 + pins > 10 {
				return .Rolls_in_Frame_Exceed_10_Points
			}
		}
	}

	if g.roll_idx >= 21 {
		return .Game_Over
	}

	g.rolls[g.roll_idx] = pins
	g.roll_idx += 1
	return .None
}

score :: proc(g: Game) -> (int, Error) {
	_, _, _, over := get_frame_state(g)
	if !over {
		return 0, .Game_Not_Over
	}

	total := 0
	idx := 0
	for f := 0; f < 10; f += 1 {
		if f < 9 {
			if g.rolls[idx] == 10 {
				total += 10 + g.rolls[idx + 1] + g.rolls[idx + 2]
				idx += 1
			} else if g.rolls[idx] + g.rolls[idx + 1] == 10 {
				total += 10 + g.rolls[idx + 2]
				idx += 2
			} else {
				total += g.rolls[idx] + g.rolls[idx + 1]
				idx += 2
			}
		} else {
			total += g.rolls[idx] + g.rolls[idx + 1]
			if g.rolls[idx] + g.rolls[idx + 1] >= 10 {
				total += g.rolls[idx + 2]
			}
		}
	}

	return total, .None
}
