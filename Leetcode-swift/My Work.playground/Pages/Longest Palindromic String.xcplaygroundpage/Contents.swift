/*:

 Longest Palindromic Substring

 Given a string s, find the longest palindromic substring in s. You may assume that the maximum length of s is 1000.


```
 Input: "babad"

 Output: "bab"
```
 Note: "aba" is also a valid answer.

```
 Input: "cbbd"

 Output: "bb"
```
*/
/*
 Ref: http://oleb.net/blog/2014/07/swift-strings/
 "Because of the way Swift strings are stored, the String type does not support random access to its Characters via an integer index — there is no direct equivalent to NSStringʼs characterAtIndex: method. Conceptually, a String can be seen as a doubly linked list of characters rather than an array."

 By creating and storing a seperate array of the same sequence of characters,
 we could hopefully achieve amortized O(1) time for random access.
 */

func longestPalindrome(_ s: String) -> String {
    let strArr = Array(s.characters)
    let stringLength = s.count
    var palindromeStart = 0
    var palindromeLength = 0

    var isPalindromFromTo = makeBoolTable(ofSize: stringLength)
    for begin in (0..<stringLength).reversed() {
        for end in begin..<stringLength {
            if strArr[begin] == strArr[end] {
                isPalindromFromTo[begin][end] =
                    // This covers the 1 character, 2 character and 3 character case.
                    end-begin < 3 ||
                    // if there are more than 3 characters, we refer to previous answers
                    isPalindromFromTo[begin+1][end-1]
            }
            if isPalindromFromTo[begin][end] && end-begin+1 > palindromeLength {
                palindromeStart = begin
                palindromeLength = end-begin+1
            }
        }
    }
    let rangeStart = s.index(s.startIndex, offsetBy: palindromeStart)
    let rangeEnd = s.index(s.startIndex, offsetBy: palindromeStart+palindromeLength)
    return String(s[rangeStart..<rangeEnd])
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

longestPalindrome("oooo")
