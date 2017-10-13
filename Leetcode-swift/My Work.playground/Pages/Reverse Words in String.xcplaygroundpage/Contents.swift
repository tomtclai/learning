//https://leetcode.com/problems/reverse-words-in-a-string-iii/description/
import Foundation
func reverseWordsWithSplit(_ s: String) -> String {
    var listOfStrings = s.components(separatedBy: " ")
    var listOfReversedStrings =  listOfStrings.map { return String($0.characters.reversed())}
    return listOfReversedStrings.joined(separator: " ")
}


func reverseWords(_ s: String) -> String {
    var arrayOfChars = Array(s.characters)
    var wordBeginning = 0
    var i = 0
    while i<arrayOfChars.count {
        if i == arrayOfChars.count - 1 {
            reverseChars(array: &arrayOfChars, beginIndex: wordBeginning, endIndexExclusive: i+1)
            i = i + 1
        } else if arrayOfChars[i] == " " {
            reverseChars(array: &arrayOfChars, beginIndex: wordBeginning, endIndexExclusive: i)
            while arrayOfChars[i] == " " {
                i = i + 1
            }
            wordBeginning = i
        } else {
            i = i + 1
        }
    }
    return String(arrayOfChars)
}
func reverseChars(array: inout [Character], beginIndex: Int, endIndexExclusive: Int) {

    var i = beginIndex
    var j = endIndexExclusive - 1
    while i < j {
        array.swapAt(i,j)
        i = i + 1
        j = j - 1
    }
}
