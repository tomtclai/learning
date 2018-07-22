//https://leetcode.com/problems/two-sum-iv-input-is-a-bst/description/
var mapForComplements = [Int: Int]()
func findTarget(_ root: TreeNode?, _ k: Int) -> Bool {
    guard let root = root else {
        return false
    }
    if mapForComplements.keys.contains(root.val) {
        return true
    }
    mapForComplements[k - root.val] = root.val
    return findTarget(root.left, k) || findTarget(root.right, k)
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
