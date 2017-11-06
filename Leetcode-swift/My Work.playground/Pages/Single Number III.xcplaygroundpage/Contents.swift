// https://leetcode.com/problems/single-number-iii/description/
 func singleNumberWithSet(_ nums: [Int]) -> [Int] {
    var setOfNums = Set<Int>()
    nums.forEach { num in
        if setOfNums.contains(num) {
            setOfNums.remove(num)
        } else {
            setOfNums.insert(num)
        }
    }
    return Array(setOfNums)
 }

func singleNumber(_ nums: [Int]) -> [Int] {
    let x = nums.reduce(0, {$0 ^ $1}) // XOR everything together
    // negative x in twos compliment (remember college?)
    // AND gets you the last set bit (that differentiates the two nums we want)
    let lastSetBit = x & -x
    var result1 = 0, result2 = 0
    nums.forEach{ num in
        if num & lastSetBit == 0 {
            result1 ^= num
        } else {
            result2 ^= num
        }
    }
    return [result1, result2]
}
