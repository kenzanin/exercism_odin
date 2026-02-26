package zipper

// A Binary Tree representation
Tree :: ^Node

// A single Node within the Binary Tree
Node :: struct {
	value: int,
	left:  Tree,
	right: Tree,
}

// The Zipper data structure that keeps track of the focus and the previous operations.
Zipper :: struct {
	tree:  Tree,
	trail: Trail,
}

// The set of previous operations applied to the tree.
Trail :: ^Step

// A single operation applied to the tree.
Step :: struct {
	action: Action,
	value:  int,
	tree:   Tree,
	next:   Trail,
}

// The possible operations applied to the tree.
Action :: enum {
	Right,
	Left,
}

// Get a zipper out of a tree, the focus is on the root node.
zip_from_tree :: proc(t: Tree) -> Zipper {
	return Zipper{tree = t, trail = nil}
}

// Get the tree out of the zipper.
zip_to_tree :: proc(z: Zipper) -> Tree {
	current_z := z

	// Walk up the trail, reconstructing the tree as we go
	for current_z.trail != nil {
		step := current_z.trail

		if step.action == .Left {
			// We came from the left, so reconstruct with our current tree as left child
			parent := new(Node)
			parent.value = step.value
			parent.left = current_z.tree
			parent.right = step.tree
			current_z.tree = parent
		} else {
			// We came from the right, so reconstruct with our current tree as right child
			parent := new(Node)
			parent.value = step.value
			parent.left = step.tree
			parent.right = current_z.tree
			current_z.tree = parent
		}

		current_z.trail = step.next
	}

	return current_z.tree
}

// Get the value of the focus node.
zip_value :: proc(z: Zipper) -> int {
	if z.tree == nil {
		return 0
	}
	return z.tree.value
}

// Move the focus to the left child of the focus node, returns a new zipper.
// If there is no left child, return a zero value Zipper.
zip_left :: proc(z: Zipper) -> Zipper {
	if z.tree == nil || z.tree.left == nil {
		return Zipper{}
	}

	step := new(Step)
	step.action = .Left
	step.value = z.tree.value
	step.tree = z.tree.right
	step.next = z.trail

	return Zipper{tree = z.tree.left, trail = step}
}

// Move the focus to the right child of the focus node, returns a new zipper.
// If there is no right child, return a zero value Zipper.
zip_right :: proc(z: Zipper) -> Zipper {
	if z.tree == nil || z.tree.right == nil {
		return Zipper{}
	}

	step := new(Step)
	step.action = .Right
	step.value = z.tree.value
	step.tree = z.tree.left
	step.next = z.trail

	return Zipper{tree = z.tree.right, trail = step}
}

// Move the focus to the parent of the focus node, returns a new zipper.
// If there is no parent, return a zero value Zipper.
zip_up :: proc(z: Zipper) -> Zipper {
	if z.trail == nil {
		return Zipper{}
	}

	step := z.trail

	parent := new(Node)
	parent.value = step.value

	if step.action == .Left {
		parent.left = z.tree
		parent.right = step.tree
	} else {
		parent.left = step.tree
		parent.right = z.tree
	}

	return Zipper{tree = parent, trail = step.next}
}

// Set the value of the focus node, returns a new zipper.
zip_set_value :: proc(z: Zipper, value: int) -> Zipper {
	if z.tree == nil {
		return Zipper{}
	}

	new_node := new(Node)
	new_node.value = value
	new_node.left = z.tree.left
	new_node.right = z.tree.right

	return Zipper{tree = new_node, trail = z.trail}
}

// Set the left subtree of the focus node, returns a new zipper.
zip_set_left :: proc(z: Zipper, subtree: Tree) -> Zipper {
	if z.tree == nil {
		return Zipper{}
	}

	new_node := new(Node)
	new_node.value = z.tree.value
	new_node.left = subtree
	new_node.right = z.tree.right

	return Zipper{tree = new_node, trail = z.trail}
}

// Set the right subtree of the focus node, returns a new zipper.
zip_set_right :: proc(z: Zipper, subtree: Tree) -> Zipper {
	if z.tree == nil {
		return Zipper{}
	}

	new_node := new(Node)
	new_node.value = z.tree.value
	new_node.left = z.tree.left
	new_node.right = subtree

	return Zipper{tree = new_node, trail = z.trail}
}
