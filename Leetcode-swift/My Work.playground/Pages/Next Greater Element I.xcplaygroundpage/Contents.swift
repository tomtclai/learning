    func nextGreaterElement(_ findNums: [Int], _ nums: [Int]) -> [Int] {
        var dictOfNextGreaterElement = [Int: Int]()
        var stack = [Int]()
        guard !findNums.isEmpty else {return findNums}
        for num in nums {
            while !stack.isEmpty && stack.last! < num {
                dictOfNextGreaterElement[stack.removeLast()] = num
            }
            stack.append(num)
        }

        return findNums.map {
            if let nextGreater = dictOfNextGreaterElement[$0] {
                return nextGreater
            }
            return -1
        }
    }
//https://leetcode.com/problems/next-greater-element-i/description
