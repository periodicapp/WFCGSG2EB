package main

import "fmt"

type Node struct {
	Val   int
	Left  *Node
	Right *Node
}

type BST struct {
	Root *Node
}

func (t *BST) Insert(val int) {
	if t.Root == nil {
		t.Root = &Node{Val: val, Left: nil, Right: nil}
		return
	}
	t.Root.Insert(val)
}

func (n *Node) Insert(val int) {
	if val < n.Val {
		if n.Left == nil {
			n.Left = &Node{Val: val, Left: nil, Right: nil}
			return
		}
		n.Left.Insert(val)
	} else {
		if n.Right == nil {
			n.Right = &Node{Val: val, Left: nil, Right: nil}
			return
		}
		n.Right.Insert(val)
	}
}

func InorderTraversal(node *Node) {
	if node == nil {
		return
	}
	InorderTraversal(node.Left)
	fmt.Println(node.Val)
	InorderTraversal(node.Right)
}

func main() {
	tree := &BST{}
	tree.Insert(5)
	tree.Insert(3)
	tree.Insert(7)
	tree.Insert(2)
	fmt.Println("Inorder traversal")
	InorderTraversal(tree.Root)

}

