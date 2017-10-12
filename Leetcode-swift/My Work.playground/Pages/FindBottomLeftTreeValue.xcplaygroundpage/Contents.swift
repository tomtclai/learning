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
        fatalError("root does not exist")
    }
    func findBottomLeftValue(root: TreeNode, currentLevel: Int, maxLevel: inout Int, blVal: inout Int) {
        // right, middle, left
        if let right = root.right {
            findBottomLeftValue(root: right, currentLevel: currentLevel+1, maxLevel: &maxLevel, blVal: &blVal)
        }
        // base case: I'm at the lowest level value
        if currentLevel >= maxLevel {
            blVal = root.val
            maxLevel = currentLevel
        }
        if let left = root.left {
            findBottomLeftValue(root: left, currentLevel: currentLevel+1, maxLevel: &maxLevel, blVal: &blVal)
        }

    }
    var bottomLeftValue = 0
    var level = 0
    findBottomLeftValue(root: root, currentLevel: 0, maxLevel: &level, blVal: &bottomLeftValue)
    return bottomLeftValue
}
