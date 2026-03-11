package circular_buffer

// Complete the Buffer data structure.
Buffer :: struct {
	data:        []int,
	capacity:    int,
	size:        int,
	read_index:  int,
	write_index: int,
}

Error :: enum {
	None,
	BufferEmpty,
	BufferFull,
	Unimplemented,
}

new_buffer :: proc(capacity: int) -> Buffer {
	return Buffer {
		data = make([]int, capacity),
		capacity = capacity,
		size = 0,
		read_index = 0,
		write_index = 0,
	}
}

destroy_buffer :: proc(b: ^Buffer) {
	delete(b.data)
}

clear :: proc(b: ^Buffer) {
	b.size = 0
	b.read_index = 0
	b.write_index = 0
}

read :: proc(b: ^Buffer) -> (int, Error) {
	if b.size == 0 {
		return 0, .BufferEmpty
	}
	value := b.data[b.read_index]
	b.read_index = (b.read_index + 1) % b.capacity
	b.size -= 1
	return value, .None
}

write :: proc(b: ^Buffer, value: int) -> Error {
	if b.size == b.capacity {
		return .BufferFull
	}
	b.data[b.write_index] = value
	b.write_index = (b.write_index + 1) % b.capacity
	b.size += 1
	return .None
}

overwrite :: proc(b: ^Buffer, value: int) {
	b.data[b.write_index] = value
	b.write_index = (b.write_index + 1) % b.capacity
	if b.size < b.capacity {
		b.size += 1
	} else {
		b.read_index = (b.read_index + 1) % b.capacity
	}
}
