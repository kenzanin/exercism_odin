package clock

import "core:fmt"
import "core:strings"

// Clock stores time as total minutes since midnight (0-1439)
Clock :: struct {
	total_minutes: int,
}

// Helper function to normalize total minutes to 0-1439 range
normalize_minutes :: proc(total_minutes: int) -> int {
	minutes := total_minutes % 1440
	if minutes < 0 {
		minutes += 1440
	}
	return minutes
}

// Create a new clock with given hour and minute
create_clock :: proc(hour, minute: int) -> Clock {
	// Convert hours and minutes to total minutes
	total_minutes := hour * 60 + minute
	// Normalize to 0-1439 range
	normalized_minutes := normalize_minutes(total_minutes)
	return Clock{total_minutes = normalized_minutes}
}

// Convert clock to string in "HH:MM" format
to_string :: proc(clock: Clock) -> string {
	// Calculate hours and minutes from total minutes
	hours := clock.total_minutes / 60
	minutes := clock.total_minutes % 60

	// Format with leading zeros
	builder := strings.builder_make()
	fmt.sbprintf(&builder, "%02d:%02d", hours, minutes)
	return strings.to_string(builder)
}

// Add minutes to a clock
add :: proc(clock: ^Clock, minutes: int) {
	clock.total_minutes = normalize_minutes(clock.total_minutes + minutes)
}

// Subtract minutes from a clock
subtract :: proc(clock: ^Clock, minutes: int) {
	clock.total_minutes = normalize_minutes(clock.total_minutes - minutes)
}

// Check if two clocks represent the same time
equals :: proc(clock1, clock2: Clock) -> bool {
	return clock1.total_minutes == clock2.total_minutes
}
