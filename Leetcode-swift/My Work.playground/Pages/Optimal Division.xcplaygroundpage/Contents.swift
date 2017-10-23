// https://leetcode.com/problems/optimal-division/discuss/
// Ugh, kind of a trick question....
// if you remembered more math you'd know.
//
// The optimal fraction:
//
//  A[0] / (A[1] / A[2] / ... / A[everything else])
//
//     A[0] * A[2] * ... * A[everything else]
// =   --------------------------------------
//                  A[1]
//
//
//
func optimalDivision(_ nums: [Int]) -> String {
    guard !nums.isEmpty else {
        return ""
    }
    // "3"
    guard nums.count != 1 else {
        return "\(nums.first!)"
    }
    // "3 / 2"
    guard nums.count != 2 else {
        return "\(nums.first!)/\(nums.last!)"
    }
    // "3 / ( 2 / 1 / 4 / 5 )
    var mutableNums = nums
    let firstNum = mutableNums.removeFirst()
    return "\(firstNum)/(\(mutableNums.map{String($0)}.joined(separator:"/")))"
}
