package main

//  Binary Tree Traveral in Go - https://www.youtube.com/watch?v=TyA1M0L0EM4&ab_channel=JustinZollars

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

// Input: root = [1,null,2,3]

// https://leetcode.com/problems/binary-tree-inorder-traversal/
// https://leetcode.com/submissions/detail/812203254/
//  Left - Value(Root Node) - Right
func inorderTraversal(root *TreeNode) []int {

	ans := []int{}

	var inorder func(*TreeNode)

	inorder = func(root *TreeNode) {
		if root == nil {
			return
		}

		inorder(root.Left)
		ans = append(ans, root.Val)
		inorder(root.Right)

	}
	inorder(root)

	return ans
}

// https://leetcode.com/problems/binary-tree-postorder-traversal/
// https://leetcode.com/submissions/detail/812204576/
// Left - Right - Value(Root Node)
func postorderTraversal(root *TreeNode) []int {

	ans := []int{}

	var inorder func(*TreeNode)

	inorder = func(root *TreeNode) {
		if root == nil {
			return
		}

		inorder(root.Left)
		inorder(root.Right)
		ans = append(ans, root.Val)

	}
	inorder(root)

	return ans
}

//  https://leetcode.com/problems/binary-tree-preorder-traversal/
// https://leetcode.com/submissions/detail/812205801/
// Value(Root Node) - Left - Right
func preorderTraversal(root *TreeNode) []int {

	ans := []int{}

	var inorder func(*TreeNode)

	inorder = func(root *TreeNode) {
		if root == nil {
			return
		}

		ans = append(ans, root.Val)
		inorder(root.Left)
		inorder(root.Right)

	}
	inorder(root)

	return ans
}
