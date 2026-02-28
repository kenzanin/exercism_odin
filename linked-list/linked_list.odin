package linked_list

// Define the content of List.
// (a double-link list must keep track of its head and its tail).
List :: struct {
	head: ^Node,
	tail: ^Node,
	len:  int,
}

// Define the content of Node.
// (for a double-link list, a Node must keep track of its previous and next element).
Node :: struct {
	value: int,
	prev:  ^Node,
	next:  ^Node,
}

Error :: enum {
	None,
	Empty_List,
	Unimplemented,
}

// Create a new list containing 'elements'.
new_list :: proc(elements: ..int) -> List {
	list := List{}
	for v in elements {
		push(&list, v)
	}
	return list
}

// Deallocate the list
destroy_list :: proc(l: ^List) {
	node := l.head
	for node != nil {
		next := node.next
		free(node)
		node = next
	}
	l.head = nil
	l.tail = nil
	l.len = 0
}

// Insert a value at the head of the list.
unshift :: proc(l: ^List, value: int) {
	node := new(Node)
	node.value = value

	if l.head == nil {
		l.head = node
		l.tail = node
	} else {
		node.next = l.head
		l.head.prev = node
		l.head = node
	}
	l.len += 1
}

// Add a value to the tail of the list
push :: proc(l: ^List, value: int) {
	node := new(Node)
	node.value = value

	if l.tail == nil {
		l.head = node
		l.tail = node
	} else {
		node.prev = l.tail
		l.tail.next = node
		l.tail = node
	}
	l.len += 1
}

// Remove and return the value at the head of the list.
shift :: proc(l: ^List) -> (int, Error) {
	if l.head == nil {
		return 0, .Empty_List
	}

	node := l.head
	value := node.value

	l.head = node.next
	if l.head != nil {
		l.head.prev = nil
	} else {
		l.tail = nil
	}
	l.len -= 1

	free(node)
	return value, .None
}

// Remove and return the value at the tail of the list.
pop :: proc(l: ^List) -> (int, Error) {
	if l.tail == nil {
		return 0, .Empty_List
	}

	node := l.tail
	value := node.value

	l.tail = node.prev
	if l.tail != nil {
		l.tail.next = nil
	} else {
		l.head = nil
	}
	l.len -= 1

	free(node)
	return value, .None
}

// Reverse the elements in the list (in-place).
reverse :: proc(l: ^List) {
	if l.head == nil || l.head == l.tail {
		return
	}

	l.tail = l.head

	current := l.head
	for current != nil {
		temp := current.prev
		current.prev = current.next
		current.next = temp
		current = current.prev
	}

	if temp := l.head; temp != nil {
		l.head = temp
	}
}

// Returns the number of elements in the list
count :: proc(l: List) -> int {
	return l.len
}

// Delete (only) the first element from the list with the given value.
// If the value is not in the list, do nothing.
delete :: proc(l: ^List, value: int) {
	node := l.head
	for node != nil {
		if node.value == value {
			prev := node.prev
			next := node.next

			if prev != nil {
				prev.next = next
			} else {
				l.head = next
			}

			if next != nil {
				next.prev = prev
			} else {
				l.tail = prev
			}

			l.len -= 1
			free(node)
			return
		}
		node = node.next
	}
}
