/*:
 Given a positive integer, output its complement number. The complement strategy is to flip the bits of its binary representation.

 Note:
 1. The given integer is guaranteed to fit within the range of a 32-bit signed integer.
 2. You could assume no leading zero bit in the integer’s binary representation.

 ```
 Input: 5
 Output: 2
 ```
 Explanation: The binary representation of 5 is 101 (no leading zero bits), and its complement is 010. So you need to output 2.

 ```
 Input: 1
 Output: 0
 ```
 Explanation: The binary representation of 1 is 1 (no leading zero bits), and its complement is 0. So you need to output 0.
 */
import Foundation
func findComplement(_ num: Int) -> Int {
    var currentBitmask = 0xFFFFFFFF
    var numberOfBitsInNum = 0
    var bitwiseResult = currentBitmask & Int(num)
    while bitwiseResult != 0 {
        currentBitmask <<= 1
        numberOfBitsInNum += 1
        bitwiseResult = currentBitmask & Int(num)
    }

    let result64 = 0x7FFFFFFF ^ Int32(num)
    var result = Int32(result64)
    let numberOfBitsToShift64 = 32 - numberOfBitsInNum
    let numberOfBitsToShift = Int32(numberOfBitsToShift64)
    result <<= numberOfBitsToShift
    result >>= numberOfBitsToShift
    return Int(result)
}

findComplement(5)
findComplement(2147483647)
