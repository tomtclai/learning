func nextGreaterElement(_ findNums: [Int], _ nums: [Int]) -> [Int] {
    var dictOfNextGreaterElement = [Int: Int]()

    dictOfNextGreaterElement[nums.last!] = -1

    for i in 0..<nums.count-1 {
        if nums[i] < nums[i+1] {
            dictOfNextGreaterElement[nums[i]] = nums[i+1]
        } else {
            dictOfNextGreaterElement[nums[i]] = -1
        }
    }

    return findNums.map {dictOfNextGreaterElement[$0]!}
}

//https://leetcode.com/problems/next-greater-element-i/description
