//https://leetcode.com/problems/add-digits/
func addDigits(_ num: Int) -> Int {
    if num == 0 {
        return 0
    }
    let lastDigit = num % 10
    let restOfNum = addDigits(num / 10)
    if restOfNum == 0 {
        return lastDigit
    }
    return addDigits(lastDigit + restOfNum)
}
