package robotname

import "core:math/rand"
import "core:strings"

Robot_Storage :: struct {
	used: map[string]bool,
}

Robot :: struct {
	name: string,
}

Error :: enum {
	None,
	Could_Not_Create_Name,
	Unimplemented,
}

make_storage :: proc() -> Robot_Storage {
	result := Robot_Storage{}
	result.used = make(map[string]bool)
	return result
}

delete_storage :: proc(storage: ^Robot_Storage) {
	for key, _ in storage.used {
		delete(key)
	}
	delete(storage.used)
}

new_robot :: proc(storage: ^Robot_Storage) -> (Robot, Error) {
	for len(storage.used) < 676_000 {
		name := generate_random_name()
		_, exists := storage.used[name]
		if exists {
			delete_string(name)
			continue
		}
		storage.used[name] = true
		return Robot{name = name}, .None
	}
	return Robot{}, .Could_Not_Create_Name
}

reset :: proc(storage: ^Robot_Storage, r: ^Robot) {
	old_name := r.name
	if old_name != "" {
		delete_key(&storage.used, old_name)
	}
	new_r, _ := new_robot(storage)
	r.name = new_r.name
	if old_name != "" {
		delete(old_name)
	}
}

generate_random_name :: proc() -> string {
	buf: [5]u8
	buf[0] = 'A' + u8(rand.uint32() % 26)
	buf[1] = 'A' + u8(rand.uint32() % 26)
	buf[2] = '0' + u8(rand.uint32() % 10)
	buf[3] = '0' + u8(rand.uint32() % 10)
	buf[4] = '0' + u8(rand.uint32() % 10)
	return strings.clone(string(buf[:]))
}
