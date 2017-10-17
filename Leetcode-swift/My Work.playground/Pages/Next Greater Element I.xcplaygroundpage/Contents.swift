    func nextGreaterElement(_ findNums: [Int], _ nums: [Int]) -> [Int] {
        var dictOfNextGreaterElement = [Int: Int]()
        var unmatchedNums = [Int]()
        guard !findNums.isEmpty else {return findNums}
        for num in nums {
            while !unmatchedNums.isEmpty && unmatchedNums.last! < num {
                dictOfNextGreaterElement[unmatchedNums.removeLast()] = num
            }
            unmatchedNums.append(num)
        }

        return findNums.map {
            if let nextGreater = dictOfNextGreaterElement[$0] {
                return nextGreater
            }
            return -1
        }
    }
//https://leetcode.com/problems/next-greater-element-i/description
