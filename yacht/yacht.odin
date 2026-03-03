package yacht

import "core:slice/heap"
Category :: enum {
	Ones,
	Twos,
	Threes,
	Fours,
	Fives,
	Sixes,
	Full_House,
	Four_Of_A_Kind,
	Little_Straight,
	Big_Straight,
	Yacht,
	Choice,
}

Roll :: [5]int

count :: proc(src: Roll, target: int) -> int {
	count := 0
	for i in src {
		if i == target {
			count += 1
		}
	}
	return count
}

score :: proc(dice: Roll, category: Category) -> int {
	result := 0
	to_map := proc(dice: Roll) -> map[int]int {
		result := make(map[int]int)
		for i in dice {
			result[i] += 1
		}
		return result
	}

	switch category {
	case .Ones:
		result = count(dice, 1)
	case .Twos:
		result = 2 * count(dice, 2)
	case .Threes:
		result = 3 * count(dice, 3)
	case .Fours:
		result = 4 * count(dice, 4)
	case .Fives:
		result = 5 * count(dice, 5)
	case .Sixes:
		result = 6 * count(dice, 6)
	case .Full_House:
		tmp01 := to_map(dice)
		defer delete(tmp01)
		tmp02 := 0
		tmp03 := 0
		for k, v in tmp01 {
			if v == 3 {
				tmp02 = k
			}
			if v == 2 {
				tmp03 = k
			}
		}
		if tmp02 > 0 && tmp03 > 0 {
			result = (tmp02 * 3) + (tmp03 * 2)
		}
	case .Four_Of_A_Kind:
		tmp01 := to_map(dice)
		defer delete(tmp01)
		for k, v in tmp01 {
			if v >= 4 {
				result = 4 * k
				break
			}
		}
	case .Little_Straight:
		tmp01 := to_map(dice)
		defer delete(tmp01)
		if tmp01[1] & tmp01[2] & tmp01[3] & tmp01[4] & tmp01[5] == 1 {
			return 30
		}
	case .Big_Straight:
		tmp01 := to_map(dice)
		defer delete(tmp01)
		if tmp01[2] & tmp01[3] & tmp01[4] & tmp01[5] & tmp01[6] == 1 {
			return 30
		}
	case .Choice:
		return dice[0] + dice[1] + dice[2] + dice[3] + dice[4]
	case .Yacht:
		tmp01 := to_map(dice)
		defer delete(tmp01)
		if tmp01[dice[0]] == 5 {
			return 50
		}
	}
	return result
}
