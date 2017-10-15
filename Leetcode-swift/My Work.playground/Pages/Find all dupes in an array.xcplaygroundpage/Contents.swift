func findDuplicates(_ nums: [Int]) -> [Int] {
    // [4,3,2,7,8,2,3,1] range 1~9
    // [+,+,+,+,+,+,+,+]
    var nums = nums
    var result = [Int]()
    for num in nums {
        if nums[abs(num-1)] > 0 {
            // positive
            nums[abs(num-1)] = -nums[abs(num-1)]
        } else {
            result.append(abs(num))
        }
    }
    return result
}

//https://leetcode.com/submissions/detail/123699458/
