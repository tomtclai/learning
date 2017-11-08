// https://leetcode.com/problems/minimum-moves-to-equal-array-elements-ii/discuss/
func minMoves2(_ nums: [Int]) -> Int {
    var nums = nums.sorted()
    var sum = 0
    for i in 0..<nums.count {
        let j = nums.count - 1 - i
        sum += nums[j] - nums[i]
    }
    return sum
}
