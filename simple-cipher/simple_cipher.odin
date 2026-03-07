package simple_cipher

import "core:math/rand"

decode :: proc(ciphertext, key: string) -> string {
	result := make([]u8, len(ciphertext))
	
	for i := 0; i < len(ciphertext); i += 1 {
		c := ciphertext[i]
		k := key[i % len(key)]
		shift := int(k - 'a')
		decoded := int(c - 'a') - shift
		if decoded < 0 {
			decoded += 26
		}
		result[i] = u8(decoded + 'a')
	}
	
	return string(result)
}

encode :: proc(plaintext, key: string) -> string {
	result := make([]u8, len(plaintext))
	
	for i := 0; i < len(plaintext); i += 1 {
		p := plaintext[i]
		k := key[i % len(key)]
		shift := int(k - 'a')
		encoded := int(p - 'a') + shift
		encoded %= 26
		result[i] = u8(encoded + 'a')
	}
	
	return string(result)
}

key :: proc() -> string {
	letters := "abcdefghijklmnopqrstuvwxyz"
	result := make([]u8, 100)
	
	for i := 0; i < 100; i += 1 {
		idx := int(rand.uint32() % 26)
		result[i] = letters[idx]
	}
	
	return string(result)
}
