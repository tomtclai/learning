// https://leetcode.com/problems/keyboard-row/description/

let firstRow = CharacterSet(charactersIn: "qwertyuiop")
let secondRow = CharacterSet(charactersIn: "asdfghjkl")
let thirdRow = CharacterSet(charactersIn: "zxcvbnm")
func canBeTypedWithOneRow(_ word: String) -> Bool {
    let charArray = Array(word.lowercased().unicodeScalars)
    guard let firstChar = charArray.first else {
        return true
    }
    var characterSet: CharacterSet!
    if firstRow.contains(firstChar) {
        characterSet = firstRow
    } else if secondRow.contains(firstChar) {
        characterSet = secondRow
    } else if thirdRow.contains(firstChar) {
        characterSet = thirdRow
    } else {
        print("first char is not english!")
    }

    for c in charArray {
        if !characterSet.contains(c) {
            return false
        }
    }
    return true
}
func findWords(_ words: [String]) -> [String] {
    return words.filter {canBeTypedWithOneRow($0)}
}
