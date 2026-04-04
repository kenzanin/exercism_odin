package book_store

// total calculates the minimum cost for a basket of books with optimal grouping
total :: proc(books: []u32) -> u32 {
	// Base price per book in cents
	BASE_PRICE :: 800

	// Discount multipliers for different group sizes (index = group size)
	// 1 book: 100% (no discount), 2 books: 95% (5% discount), etc.
	DISCOUNT_MULTIPLIERS := [6]u32{100, 100, 95, 90, 80, 75}

	// Count how many of each book we have (books are numbered 1-5)
	counts := [5]u32{0, 0, 0, 0, 0}
	for book in books {
		if book >= 1 && book <= 5 {
			counts[book - 1] += 1
		}
	}

	// Sort counts in descending order for better grouping
	sort_counts_desc(&counts)

	// Calculate minimum price using recursive search
	return calculate_min_price(counts, DISCOUNT_MULTIPLIERS, BASE_PRICE)
}

// sort_counts_desc sorts book counts in descending order
sort_counts_desc :: proc(counts: ^[5]u32) {
	// Simple bubble sort for small array
	for i in 0 ..< 4 {
		for j in 0 ..< 4 - i {
			if counts[j] < counts[j + 1] {
				counts[j], counts[j + 1] = counts[j + 1], counts[j]
			}
		}
	}
}

// calculate_min_price recursively finds the minimum price for given book counts
calculate_min_price :: proc(counts: [5]u32, discounts: [6]u32, base_price: u32) -> u32 {
	// Base case: if all counts are zero, price is zero
	all_zero := true
	for count in counts {
		if count > 0 {
			all_zero = false
			break
		}
	}
	if all_zero {
		return 0
	}

	// Try forming groups of different sizes (5, 4, 3, 2, 1)
	min_price: u32 = ~u32(0)

	// We need to try forming groups from largest to smallest
	// Start from group size 5 down to 1
	group_size: int = 5
	for group_size >= 1 {
		// Check if we can form a group of this size
		// A group of size N requires at least N different books with count > 0
		available_books := 0
		for count in counts {
			if count > 0 {
				available_books += 1
			}
		}

		if available_books >= group_size {
			// Create a new counts array with this group removed
			new_counts := counts

			// Remove one copy from the first 'group_size' books that have count > 0
			removed := 0
			for i in 0 ..< 5 {
				if new_counts[i] > 0 && removed < group_size {
					new_counts[i] -= 1
					removed += 1
				}
			}

			// Sort the new counts to maintain descending order
			sort_counts_desc(&new_counts)

			// Calculate price for this group plus recursive call for remaining books
			group_price := (u32(group_size) * discounts[group_size] * base_price) / 100
			remaining_price := calculate_min_price(new_counts, discounts, base_price)
			total_price := group_price + remaining_price

			if total_price < min_price {
				min_price = total_price
			}
		}
		group_size -= 1
	}

	return min_price
}
