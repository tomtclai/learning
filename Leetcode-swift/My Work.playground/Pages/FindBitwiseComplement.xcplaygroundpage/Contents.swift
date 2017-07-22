//: [Previous](@previous)

import Foundation
func findComplement(_ num: Int32) -> Int {
    var currentBitmask: Int32 = 0xFFFFFFFF
    var numberOfBitsInNum = 0
    var bitwiseResult = currentBitmask & num
    while bitwiseResult != 0 {
        currentBitmask <<= 1
        numberOfBitsInNum += 1
        bitwiseResult = currentBitmask & num
    }
    
    var result: Int32 = 0xFFFFFFFF ^ num
    result <<= (32 - numberOfBitsInNum)
    result >>= (32 - numberOfBitsInNum)
    return result
}

findComplement(5)
//: [Next](@next)
