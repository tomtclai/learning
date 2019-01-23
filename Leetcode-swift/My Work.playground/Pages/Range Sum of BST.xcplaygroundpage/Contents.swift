//: [Previous](@previous)
/*
 Given the root node of a binary search tree, return the sum of values of all nodes with value between L and R (inclusive).

 The binary search tree is guaranteed to have unique values.



 Example 1:

 Input: root = [10,5,15,3,7,null,18], L = 7, R = 15
 Output: 32
 Example 2:

 Input: root = [10,5,15,3,7,13,18,1,null,6], L = 6, R = 10
 Output: 23


 Note:

 The number of nodes in the tree is at most 10000.
 The final answer is guaranteed to be less than 2^31.

 */
import Foundation

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int, _ left: TreeNode? = nil, _ right: TreeNode? = nil) {
        self.val = val
        self.left = left
        self.right = right
    }
}


func rangeSumBST(_ root: TreeNode?, _ L: Int, _ R: Int) -> Int {
    guard let root = root else { return 0 }
    /*
     Definition of BST
     left child always smaller than parent
     right child always bigger than parent
     */
    var sum = 0
    if L <= root.val && root.val <= R {
        sum += root.val
    }

    if root.val > L {
        sum += rangeSumBST(root.left, L, R)
    }

    if R > root.val {
        sum += rangeSumBST(root.right, L, R)
    }
    return sum
}

let root = TreeNode(10,
                    TreeNode(5,
                             TreeNode(3), TreeNode(7)),
                    TreeNode(15,
                             nil, TreeNode(18)))


rangeSumBST(root, 7, 15)
//: [Next](@next)
