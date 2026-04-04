package intergalactic_transmission

has_even_parity :: proc(value: u8) -> bool {
	ones_bits := 0
	for shift in 0..<8 {
		if ((value >> uint(shift)) & 1) != 0 {
			ones_bits += 1
		}
	}
	return ones_bits % 2 == 0
}

transmit_sequence :: proc(msg: []u8) -> (seq: []u8) {
	if len(msg) == 0 {
		return []u8{}
	}
	bits := [dynamic]u8{}
	for i in 0..<len(msg) {
		byte := msg[i]
		for bit_index in 0..<8 {
			bit := u8((byte >> uint(7-bit_index)) & 1)
			append_elem(&bits, bit)
		}
	}

	result := [dynamic]u8{}
	for i := 0; i < len(bits); i += 7 {
		chunk := u8(0)
		limit := 7
		if i+limit > len(bits) {
			limit = len(bits) - i
		}
		for j in 0..<limit {
			chunk = (chunk << 1) | bits[i+j]
		}
		if limit < 7 {
			chunk <<= uint(7 - limit)
		}

		parity := u8(0)
		if !has_even_parity(chunk) {
			parity = 1
		}

		append_elem(&result, (chunk << 1) | parity)
	}

	return result[:]
}

decode_message :: proc(seq: []u8) -> (msg: []u8, okay: bool) {
	if len(seq) == 0 {
		return []u8{}, true
	}

	bits := [dynamic]u8{}
	for i in 0..<len(seq) {
		byte := seq[i]
		if !has_even_parity(byte) {
			return nil, false
		}

		data := byte >> 1
		for bit_index in 0..<7 {
			bit := u8((data >> uint(6-bit_index)) & 1)
			append_elem(&bits, bit)
		}
	}

	result := [dynamic]u8{}
	for i := 0; i+7 < len(bits); i += 8 {
		byte := u8(0)
		for j in 0..<8 {
			byte = (byte << 1) | bits[i+j]
		}
		append_elem(&result, byte)
	}

	return result[:], true
}
