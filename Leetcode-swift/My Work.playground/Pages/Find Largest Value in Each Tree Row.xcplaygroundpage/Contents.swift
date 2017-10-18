// https://leetcode.com/problems/find-largest-value-in-each-tree-row/description/
func largestValues(_ root: TreeNode?) -> [Int] {
    func largestValue(_ root: TreeNode?, values: inout [Int], level: Int) {
        guard let root = root else {
            return
        }
        if !values.indices.contains(level) {
            values.append(root.val)
        } else if values[level] < root.val {
            values[level] = root.val
        }
        largestValue(root.left, values: &values, level: level+1)
        largestValue(root.right, values: &values, level: level+1)
    }

    var result = [Int]()
    largestValue(root, values: &result, level: 0)
    return result
}

//Definition for a binary tree node.
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

