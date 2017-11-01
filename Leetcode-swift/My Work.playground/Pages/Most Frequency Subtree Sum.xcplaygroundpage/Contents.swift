// https://leetcode.com/problems/most-frequent-subtree-sum/description/
func findFrequentTreeSum(_ root: TreeNode?) -> [Int] {
    var valToFrequency = [Int: Int]()
    guard root != nil else {
        return [Int]()
    }
    // as im reading in nums, put them on dictionary with the frequency in the value
    let sum = readSumFrequency(root, &valToFrequency)
    guard sum != 0 else {
        return [0]
    }

    // then i move them all to an array so i can sort by the frequency
    guard let max = valToFrequency.map({$0.value}).max() else {
        return [Int]()
    }

    return valToFrequency.filter{ $0.value == max }.map{ $0.key }
}
private func readSumFrequency(_ root: TreeNode?,_ dict: inout [Int:Int]) -> Int {
    guard let root = root else {
        return 0
    }
    let left = readSumFrequency(root.left, &dict)
    let right = readSumFrequency(root.right, &dict)
    let sum = left + right + root.val

    if dict[sum] != nil {
        dict[sum]! += 1
    } else {
        dict[sum] = 1
    }

    return sum
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

