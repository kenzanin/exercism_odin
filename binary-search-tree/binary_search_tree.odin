package binary_search_tree

Tree :: ^Node

Node :: struct {
	value: int,
	left:  Tree,
	right: Tree,
}

// Helper function to create a new node
create_node :: proc(value: int) -> Tree {
	node := new(Node)
	node.value = value
	node.left = nil
	node.right = nil
	return node
}

// Recursively destroy a tree and free all nodes
destroy_tree :: proc(t: Tree) {
	if t == nil {
		return
	}

	// Recursively destroy left and right subtrees
	destroy_tree(t.left)
	destroy_tree(t.right)

	// Free the current node
	free(t)
}

// Insert a value into the binary search tree
insert :: proc(t: ^Tree, value: int) {
	if t^ == nil {
		// Tree is empty, create root node
		t^ = create_node(value)
		return
	}

	current := t^

	for {
		if value <= current.value {
			// Go left
			if current.left == nil {
				current.left = create_node(value)
				return
			}
			current = current.left
		} else {
			// Go right
			if current.right == nil {
				current.right = create_node(value)
				return
			}
			current = current.right
		}
	}
}

// Helper function for in-order traversal to collect values
in_order_traversal :: proc(node: Tree, values: ^[dynamic]int) {
	if node == nil {
		return
	}

	// Traverse left subtree
	in_order_traversal(node.left, values)

	// Visit current node
	append(values, node.value)

	// Traverse right subtree
	in_order_traversal(node.right, values)
}

// Return all values in the tree in sorted order (in-order traversal)
sorted_data :: proc(t: Tree) -> []int {
	if t == nil {
		return nil
	}

	values := make([dynamic]int)
	defer delete(values)

	in_order_traversal(t, &values)

	// Return a copy of the values
	result := make([]int, len(values))
	copy(result, values[:])
	return result
}
