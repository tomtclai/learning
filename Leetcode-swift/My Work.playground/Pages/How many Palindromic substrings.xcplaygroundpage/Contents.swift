//https://leetcode.com/problems/palindromic-substrings/description/
func countSubstrings(_ s: String) -> Int {
    let charArray = Array(s.characters)
    var isPalindromeFromTo = makeBoolTable(ofSize: s.characters.count)
    var howManyPalindromes = 0
    for i in (0..<s.characters.count).reversed() {
        for j in i..<s.characters.count {
            if charArray[i] == charArray[j] &&
                (j-i < 3 || isPalindromeFromTo[i+1][j-1]) {
                isPalindromeFromTo[i][j] = true
                howManyPalindromes = howManyPalindromes + 1
            }
        }
    }
    return howManyPalindromes
}

func makeBoolTable(ofSize size: Int) -> [[Bool]] {
    var tableRow = [Bool]()
    var table = [[Bool]]()
    for _ in 0..<size {
        tableRow.append(Bool())
    }
    for _ in 0..<size {
        table.append(tableRow)
    }
    return table
}
