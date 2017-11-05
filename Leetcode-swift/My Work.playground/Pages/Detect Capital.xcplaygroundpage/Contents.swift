// https://leetcode.com/problems/detect-capital/description/
func detectCapitalUse(_ word: String) -> Bool {
    func isUpper(_ char: UnicodeScalar) -> Bool {
        return CharacterSet.uppercaseLetters.contains(char)
    }
    let charArray = Array(word.unicodeScalars)
    guard charArray.count > 1 else {
        return true
    }
    var lastCharIsUpperCase = isUpper(charArray.first!)
    var allCharShouldBeUpperCase = isUpper(charArray.first!) && isUpper(charArray[1])
    for i in 1..<charArray.count {
        let thisCharIsUpperCase = isUpper(charArray[i])
        if !lastCharIsUpperCase && thisCharIsUpperCase {
            return false
        }
        if allCharShouldBeUpperCase && !thisCharIsUpperCase {
            return false
        }
        lastCharIsUpperCase = thisCharIsUpperCase
    }
    return true
}
