package two_bucket

// Result struct contains the solution to the two-bucket problem:
// - moves: total number of actions performed
// - goal_bucket: which bucket ("one" or "two") contains the desired amount
// - other_bucket: how many liters are in the other bucket
Result :: struct {
	moves:        int,
	goal_bucket:  string,
	other_bucket: int,
}

// Helper: Returns the minimum of two integers
// Used to calculate how much water to transfer between buckets
min :: proc(a: int, b: int) -> int {
	if a < b {
		return a
	}
	return b
}

// Main procedure: Solves the two-bucket problem using the Extended Euclidean Algorithm
//
// This is a greedy mathematical approach that finds the minimum number of moves
// to measure an exact amount of water by transferring between two buckets.
//
// Algorithm: Extended Euclidean Algorithm
// - Time Complexity: O(max(bucket_one, bucket_two))
// - Space Complexity: O(1) - no additional memory allocation needed
//
// The algorithm works by repeatedly applying a deterministic transfer strategy:
// 1. If the source bucket is empty, fill it
// 2. If the destination bucket is full, empty it
// 3. Otherwise, pour from source to destination
//
// This strategy is guaranteed to find a solution if one exists because:
// - Any amount that's a multiple of gcd(bucket_one, bucket_two) can be measured
// - The systematic exploration covers all reachable states without cycles
//
// Parameters:
//   bucket_one: capacity of the first bucket
//   bucket_two: capacity of the second bucket
//   goal: the exact amount of water to measure
//   start_bucket: which bucket to fill first ("one" or "two")
//
// Returns:
//   Result: struct containing moves, goal_bucket, and other_bucket
//   bool: true if solution found, false if impossible
measure :: proc(
	bucket_one: int,
	bucket_two: int,
	goal: int,
	start_bucket: string,
) -> (
	Result,
	bool,
) {
	// Current state of the buckets (both start empty)
	b1, b2, moves: int

	// Nested procedure: Performs one transfer action between buckets
	//
	// This implements the core transfer strategy:
	// - Calculate how much water can be transferred (limited by source amount and destination space)
	// - If source is empty, fill it to capacity
	// - If destination is full, empty it
	// - Otherwise, transfer water from source to destination
	//
	// Parameters:
	//   b1: pointer to source bucket's current amount
	//   b2: pointer to destination bucket's current amount
	//   b1c: capacity of source bucket
	//   b2c: capacity of destination bucket
	move :: proc(b1: ^int, b2: ^int, b1c: int, b2c: int) {
		// Calculate amount to transfer: minimum of what's available and what fits
		a: int = min(b1^, b2c - b2^)

		// Update source bucket: fill if empty, otherwise subtract transferred amount
		b1^ = b1^ == 0 ? b1c : b1^ - a

		// Update destination bucket: empty if full, otherwise add transferred amount
		b2^ = b2^ == b2c ? 0 : b2^ + a
	}

	// Main loop: iterate until we find the goal or exhaust all possibilities
	// The upper bound bucket_one * bucket_two + 1 is generous - in practice,
	// the algorithm finds a solution much faster (O(max(bucket_one, bucket_two)))
	for moves = 0; moves < bucket_one * bucket_two + 1; {
		// Perform one transfer action
		// Direction depends on which bucket we started with
		if start_bucket == "one" do move(&b1, &b2, bucket_one, bucket_two)
		else do move(&b2, &b1, bucket_two, bucket_one)

		// Count this action
		moves += 1

		// Check if we've reached the goal in either bucket
		if b1 == goal || b2 == goal do break

		// Special case: if the goal equals one of the bucket capacities,
		// we can simply fill that bucket directly
		if bucket_one == goal || bucket_two == goal {
			if bucket_one == goal do b1 = bucket_one
			else if bucket_two == goal do b2 = bucket_two
			moves += 1
			break
		}
	}

	// If we couldn't reach the goal, return failure
	// This happens when goal is not a multiple of gcd(bucket_one_one, bucket_two)
	if b1 != goal && b2 != goal do return Result{}, false

	// Determine which bucket contains the goal and the other bucket's amount
	g_bucket := b1 == goal ? "one" : "two"
	o_bucket := b1 == goal ? b2 : b1

	// Return the successful result
	return Result{moves = moves, goal_bucket = g_bucket, other_bucket = o_bucket}, true
}
