// https://leetcode.com/problems/binary-number-with-alternating-bits/description/
func hasAlternatingBits(_ n: Int) -> Bool {
    let oppositeOfN = n >> 1          // 
    let allOnes = oppositeOfN + n
    let mostlyZeros = oppositeOfN + n + 1
    return allOnes & mostlyZeros == 0
}
