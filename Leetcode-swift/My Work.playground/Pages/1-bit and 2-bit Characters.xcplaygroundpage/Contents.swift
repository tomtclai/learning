// https://leetcode.com/problems/1-bit-and-2-bit-characters/description/
class Solution {
    func isOneBitCharacter(_ bits: [Int]) -> Bool {
        // start a while loop on the characters - 1
        var pointer = 0
        while pointer < bits.count - 1 {
            // if it is 0, advance one
            if bits[pointer] == 0 {
                pointer += 1
            } else {
                // if it is not, advance two
                pointer += 2
            }
        }
        // at the end of loop, if pointer points at the last index, return true, otherwise, false
        return pointer == bits.count - 1
    }
}
