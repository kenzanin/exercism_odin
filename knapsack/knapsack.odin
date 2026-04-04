package knapsack

Item :: struct {
	weight: u32,
	value:  u32,
}

maximum_value :: proc(maximum_weight: u32, items: []Item) -> u32 {
	if maximum_weight == 0 || len(items) == 0 {
		return 0
	}

	dp := make([]u32, maximum_weight + 1)
	defer delete(dp)

	for item in items {
		if item.weight <= maximum_weight {
			w := maximum_weight
			for {
				if w < item.weight {
					break
				}
				val := dp[w - item.weight] + item.value
				if val > dp[w] {
					dp[w] = val
				}
				if w == 0 {
					break
				}
				w -= 1
			}
		}
	}

	return dp[maximum_weight]
}
