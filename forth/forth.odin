package forth

import "core:strings"
import "core:strconv"

Error :: enum {
	None,
	Cant_Nest_Definitions,
	Cant_Redefine_Compilation_Word,
	Cant_Redefine_Number,
	Divide_By_Zero,
	Incomplete_Definition,
	Stack_Underflow,
	Unknown_Word,
	Unimplemented,
}

evaluate :: proc(input: ..string) -> (output: []int, error: Error) {
	stack := make([dynamic]int)
	
	dict := make(map[string][dynamic]string)
	defer {
		for k, v in dict {
			for s in v do delete(s)
			delete(v)
			delete(k)
		}
		delete(dict)
	}

	for line in input {
		words_in_line := strings.fields(line)
		defer delete(words_in_line)
		
		i := 0
		for i < len(words_in_line) {
			token := strings.to_lower(words_in_line[i])
			defer delete(token)
			
			if token == ":" {
				i += 1
				if i >= len(words_in_line) {
					delete(stack)
					return nil, .Incomplete_Definition
				}
				name := strings.to_lower(words_in_line[i])
				if val, ok := strconv.parse_int(name); ok {
					delete(name)
					delete(stack)
					return nil, .Cant_Redefine_Number
				}
				
				i += 1
				def := make([dynamic]string)
				closed := false
				for i < len(words_in_line) {
					t := strings.to_lower(words_in_line[i])
					if t == ";" {
						closed = true
						delete(t)
						break
					}
					if t == ":" {
						delete(t)
						for s in def do delete(s)
						delete(def)
						delete(name)
						delete(stack)
						return nil, .Cant_Nest_Definitions
					}
					if v, ok := dict[t]; ok {
						for s in v {
							append(&def, strings.clone(s))
						}
					} else {
						append(&def, strings.clone(t))
					}
					delete(t)
					i += 1
				}
				if !closed {
					for s in def do delete(s)
					delete(def)
					delete(name)
					delete(stack)
					return nil, .Incomplete_Definition
				}
				
				if old, ok := dict[name]; ok {
					for s in old do delete(s)
					delete(old)
					delete(name) // name is already key, wait, we must remove old or update
                    // actually if we overwrite we shouldn't delete the key name, just the value, but dict[name] replaces it. wait, in odin map if key exists it doesn't replace the key string allocation. So delete(name) is needed if key exists.
				}
				dict[name] = def
			} else {
				// execute token
				err := execute_token(token, &stack, &dict)
				if err != .None {
					delete(stack)
					return nil, err
				}
			}
			i += 1
		}
	}
	
	output = make([]int, len(stack))
	for v, idx in stack {
		output[idx] = v
	}
	delete(stack)
	return output, .None
}

execute_token :: proc(token: string, stack: ^[dynamic]int, dict: ^map[string][dynamic]string) -> Error {
	if def, ok := dict[token]; ok {
		for t in def {
			err := execute_token(t, stack, dict)
			if err != .None do return err
		}
		return .None
	}
	
	if val, ok := strconv.parse_int(token); ok {
		append(stack, val)
		return .None
	}
	
	if token == "+" {
		if len(stack^) < 2 do return .Stack_Underflow
		a := pop(stack)
		b := pop(stack)
		append(stack, b + a)
		return .None
	}
	if token == "-" {
		if len(stack^) < 2 do return .Stack_Underflow
		a := pop(stack)
		b := pop(stack)
		append(stack, b - a)
		return .None
	}
	if token == "*" {
		if len(stack^) < 2 do return .Stack_Underflow
		a := pop(stack)
		b := pop(stack)
		append(stack, b * a)
		return .None
	}
	if token == "/" {
		if len(stack^) < 2 do return .Stack_Underflow
		a := pop(stack)
		b := pop(stack)
		if a == 0 do return .Divide_By_Zero
		append(stack, b / a)
		return .None
	}
	if token == "dup" {
		if len(stack^) < 1 do return .Stack_Underflow
		v := stack^[len(stack^)-1]
		append(stack, v)
		return .None
	}
	if token == "drop" {
		if len(stack^) < 1 do return .Stack_Underflow
		pop(stack)
		return .None
	}
	if token == "swap" {
		if len(stack^) < 2 do return .Stack_Underflow
		a := pop(stack)
		b := pop(stack)
		append(stack, a)
		append(stack, b)
		return .None
	}
	if token == "over" {
		if len(stack^) < 2 do return .Stack_Underflow
		v := stack^[len(stack^)-2]
		append(stack, v)
		return .None
	}
	
	return .Unknown_Word
}
