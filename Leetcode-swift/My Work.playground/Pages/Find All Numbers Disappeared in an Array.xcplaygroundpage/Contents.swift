// https://leetcode.com/problems/find-all-numbers-disappeared-in-an-array/description/
    func findDisappearedNumbers(_ nums: [Int]) -> [Int] {
        // save the data you need in the positive/negativeness in the array
        var nums = nums
        for num in nums {
            // negative means I'd seen this number before
            if nums[num-1] > 0 {
                nums[num-1] = -nums[num-1]
            }
        }
        var result = [Int]()
        // record all positive indices
        for i in 0..<nums.count {
            if nums[i] > 0 {
                result.append(i+1)
            }
        }
        return result
    }
