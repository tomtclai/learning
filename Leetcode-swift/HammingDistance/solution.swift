class Solution {
    func hammingDistance(_ x: Int, _ y: Int) -> Int {
        // go thru each bit
        // xor on the bit
        // if it doesn't match i increment a counter 
        var bit = 1
        var hammingCount = 0
        for i in 0...31 {
            let bitInX = bit & x
            let bitInY = bit & y
            let result = bitInX ^ bitInY
            if result != 0 {
                hammingCount += 1
            }
            bit = bit << 1
        }
        
        return hammingCount
    }
}