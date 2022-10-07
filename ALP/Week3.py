from doctest import TestResults
from typing import List, Optional

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
    def __str__(self) -> str:
        printy = ""
        if self.val:
            printy += ' ' + str(self.val)
            if self.left:
                printy += ' ' + str(self.left)
            else: 
                printy += " None"
            if self.right:
                printy += ' ' + str(self.right) 
            else:
                printy += " None"
        else: 
            printy += " None"
        return printy

class Solution:
    def generateTrees(self, n: int) -> List[Optional[TreeNode]]:
        def helper(start: int, end: int) -> List[Optional[TreeNode]]:
            # Base Case: Eventually start will become x + 1 which is also equal to end
            if start > end:
                return [None]
            allTrees = []
            # Each tree's starting place
            for x in range(start, end + 1):
                # Numbers smaller than x
                lTrees = helper(start, x - 1)
                # Numbers larger than x
                rTrees = helper(x + 1, end)
                currTrees = []
                # Make the trees for current x and the smaller branches
                for y in lTrees:
                    currTree = TreeNode(x, y, None)
                    currTrees.append(currTree)
                currTreesWR = []
                # For each tree with a left branch, rTree many more trees 
                # and append it to our final list of trees for this x and then add that list to the total list of completed trees
                for w in currTrees:
                    for z in rTrees:
                        curr = TreeNode(w.val, w.left, z)
                        currTreesWR.append(curr)
                allTrees.extend(currTreesWR)
            return allTrees
        return helper(1, n)
    def generateTreesNonUnique(self, n: int) -> List[Optional[TreeNode]]:
        # 1: ([1], [2, 3]) -> ([1, 2], [3]), ([1, 3], [2]) -> [1, 2, 3], [1, 3, 2]
        # 2: ([2], [1, 3]) -> ([2, 1], [3]), ([2, 3], [1]) -> [2, 1, 3], [2, 3, 1]
        # 3: ([3], [1, 2]) -> ([3, 1], [2]), ([3, 2], [1]) -> [3, 1, 2], [3, 2, 1]
        def recurOptions(li: List[int]) -> List[List[int]]:
            optionsList = []
            if len(li) == 1:
                return [li]
            for x in li:
                cop = li.copy()
                cop.remove(x)
                options = recurOptions(cop)
                [y.append(x) for y in options]
                optionsList.extend(options)
            return optionsList
        treesList = []
        trees = recurOptions([*range(1, n+1)])
        for x in trees:
            nodeX = TreeNode(x[0], None, None)
            for y in x[1:]:
                currNode = nodeX
                while currNode != None:
                    if y > currNode.val:
                        if currNode.right == None:  
                            currNode.right = TreeNode(y, None, None)
                            break
                        else:
                            currNode = currNode.right
                    else:
                        if currNode.left == None:  
                            currNode.left = TreeNode(y, None, None)
                            break
                        else:
                            currNode = currNode.left
            if not nodeX in treesList:
                treesList.append(nodeX)
        return treesList
    def inorderTraversalRecur(self, root: Optional[TreeNode]) -> List[int]:
        if root == None:
            return []
        else:
            a = []
            a.extend(self.inorderTraversal(root.left))
            a.append(root.val)
            a.extend(self.inorderTraversal(root.right))
            return a
    # Morris Traversal of a BST
    # https://www.educative.io/answers/what-is-morris-traversal
    # Sorts the trees by manipulating the order of the nodes, so that by the time you have found the leftmost node of the original tree
    # you have a sorted tree that you can traverse linerally to the right
    def inorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        a = []
        parent = root
        while parent != None:
            if parent.left == None:
                # Found the leftmost
                a.append(parent.val)
                # Find next leftmost 
                parent = parent.right
            else:
                # Parent is not leftmost 
                # Assume that the current leftmost has no right children
                pre = parent.left
                # Find the furthest right (if exists)
                while pre.right != None:
                    pre = pre.right
                # Drop parent to the furthest right of the left subtree and make the left subtree the parent
                pre.right = parent
                tmp = parent
                parent = parent.left
                # Remove the left node so that the old parent does not loop through previously traversed nodes
                tmp.left = None
        return a

a = Solution()
# for x in a.generateTrees(3):
#     print(x)
for x in a.generateTreesNonUnique(3):
    print(x)