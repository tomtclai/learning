//https://leetcode.com/problems/trim-a-binary-search-tree/description/
  func trimBST(_ root: TreeNode?, _ L: Int, _ R: Int) -> TreeNode? {
    guard var root = root else {
        return nil
    }
    // I'm root and I'm out of range:
    // return a node that is in range (might be nil)
    if root.val < L {
        // trim the left subtree
        return trimBST(root.right, L, R)
    } else if root.val > R {
        // trim the right subtree
        return trimBST(root.left, L, R)
    } else {
        // I'm root and I'm in the range:
        // recursive calls on each children
        root.left = trimBST(root.left, L, R)
        root.right = trimBST(root.right, L, R)
        return root
    }

  }

  //  Definition for a binary tree node.
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
