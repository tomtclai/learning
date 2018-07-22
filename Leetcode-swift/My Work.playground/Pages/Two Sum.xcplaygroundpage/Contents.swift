func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var mapDiffBetweenTargetAndNumToIndex = [Int:Int]()
    for (index, num) in nums.enumerated() {
        if let indexOfOtherInteger = mapDiffBetweenTargetAndNumToIndex[num] {
            return [indexOfOtherInteger, index]
        }
        mapDiffBetweenTargetAndNumToIndex[target - num] = index // if I can't find it
    }

    return [0]
}
