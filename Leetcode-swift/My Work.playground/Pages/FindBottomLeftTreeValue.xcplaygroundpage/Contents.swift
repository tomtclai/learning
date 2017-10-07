//https://leetcode.com/problems/find-bottom-left-tree-value/description/

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

func findBottomLeftValue(_ root: TreeNode?) -> Int {
    guard let root = root else {
        return 9999
    }
    var maxLevel = -1
    var bottomLeftValue = -1
    findBottomLeftValue(root, level: 0, maxLevel: &maxLevel, bottomLeftValue: &bottomLeftValue)
    return bottomLeftValue
}

func findBottomLeftValue(_ root: TreeNode, level: Int, maxLevel: inout Int, bottomLeftValue: inout Int){
    // you wanna do left, middle, right
    if let left = root.left {
        findBottomLeftValue(left, level: level + 1, maxLevel: &maxLevel, bottomLeftValue: &bottomLeftValue)
    }
    if level > maxLevel {
        maxLevel = level
        bottomLeftValue = root.val
    }
    if let right = root.right {
        findBottomLeftValue(right, level: level + 1, maxLevel: &maxLevel, bottomLeftValue: &bottomLeftValue)
    }
}
