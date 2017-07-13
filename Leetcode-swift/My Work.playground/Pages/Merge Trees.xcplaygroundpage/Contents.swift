/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     public var val: Int
 *     public var left: TreeNode?
 *     public var right: TreeNode?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.left = nil
 *         self.right = nil
 *     }
 * }
 */
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
func mergeTrees(_ t1: TreeNode?, _ t2: TreeNode?) -> TreeNode? {
    
    // if both is nil, return nil
    if t1 == nil && t2 == nil {
        return nil
    }
    // if one of them is nil, return the non nil one
    guard let t1 = t1 else {
        return t2
    }
    guard let t2 = t2 else {
        return t1
    }
    // add the root together
    var newNode = TreeNode(t1.val + t2.val)
    // recursive call on left
    newNode.left = mergeTrees(t1.left, t2.left)
    // recursive call on right
    newNode.right = mergeTrees(t1.right, t2.right)
    
    return newNode
}

