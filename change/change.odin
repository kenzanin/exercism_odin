package change

import "core:fmt"
import "core:path/filepath"
import "core:slice"

Error :: enum {
	None,
	No_Solution_With_Given_Coins,
	Target_Cant_Be_Negative,
	Unimplemented,
}

find_fewest_coins :: proc(coins: []int, target: int) -> ([]int, Error) {
	if target < 0 {
		return nil, .Target_Cant_Be_Negative
	}
	if target == 0 {
		return make([]int, 0), .None
	}

	MAX :: 999999999
	dp := make([]int, target + 1)
	coin_used := make([]int, target + 1)
	defer delete(dp)
	defer delete(coin_used)

	for i in 1..=target {
		dp[i] = MAX
		coin_used[i] = -1
	}

	dp[0] = 0

	for i in 1..=target {
		for c in coins {
			if i >= c && dp[i - c] != MAX {
				if dp[i - c] + 1 < dp[i] {
					dp[i] = dp[i - c] + 1
					coin_used[i] = c
				}
			}
		}
	}

	if dp[target] == MAX {
		return nil, .No_Solution_With_Given_Coins
	}

	res := make([]int, dp[target])
	curr := target
	idx := 0
	for curr > 0 {
		c := coin_used[curr]
		res[idx] = c
		idx += 1
		curr -= c
	}
	slice.sort(res)

	return res, .None
}
