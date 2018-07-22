/*
 https://leetcode.com/problems/maximum-binary-tree/description/
 Input: [3,2,1,6,0,5]
 Output: return the tree root node representing the following tree:

       6
      / \
     /   \
    /     \
   3       5
    \     /
     2   0
      \
       1
 */

func constructMaximumBinaryTree(_ nums: [Int]) -> TreeNode? {
    var pathToRoot = [TreeNode]()
    for num in nums {
        var current = TreeNode(num)
        while !pathToRoot.isEmpty && pathToRoot.last!.val < num {
            // I should be the root because I'm bigger
            current.left = pathToRoot.removeLast()
        }
        // I'm smaller, I will be the children
        pathToRoot.last?.right = current
        pathToRoot.append(current)
    }
    return pathToRoot.first!
}

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}
