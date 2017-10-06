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

func longestPalindrome(_ s: String) -> String {
    // use brute force...
    // function for testing for palindrome .. O(n)
    // loop that varies the start index O(n)
    // loop that varies the end index O(n)

    var arrayBools = [Bool]()
    var isPalindomeFromTo = [[Bool]]()
    // better solution... remember those smaller solutions
    // make a table of (string size)^2
    s.characters.forEach { _ in
        arrayBools.append(false)
    }

    s.characters.forEach { _ in
        isPalindomeFromTo.append(arrayBools)
    }

    // input: babad
    //        01234
    //
    // from    0 1 2 3 4
    //       0 T
    //       1 F T
    // to    2 T F T
    //       3 F T F T
    //       4 F F F F T

    var maxPalindromeLength = 1
    var maxPalindromeStart = 0
    for i in 0..<s.count {
        // any strings from i to i is 1 character long, 1 character strings are palindromes
        isPalindomeFromTo[i][i] = true
    }

    // for max length 2
    for i in 0..<s.count {
        if String(s[s.index(s.startIndex, offsetBy: s)]) == String(s[s.index(s.startIndex, offsetBy: s+1)]) {
            isPalindomeFromTo[i][i+1] = true
            maxPalindromeStart = i
            maxPalindromeLength = 2
        }
    }

    //for length 3 and above
    for length in 3...s.count {
        for start in 0..<s.count-length {
            let end = start + length - 1

            if isPalindomeFromTo[start+1][end-1] && String(
                s[s.index(
                    s.startIndex, offsetBy: start)
                ]) == String(
                    s[s.index(
                        s.startIndex, offsetBy: end)
                    ])
            {
                isPalindomeFromTo[start][end] = true
                if length > maxPalindromeLength {
                    maxPalindromeStart = start
                    maxPalindromeLength = length
                }
            }
        }
    }
    let rangeStart = s.index(s.startIndex, offsetBy: maxPalindromeStart)
    let rangeEnd = s.index(s.startIndex, offsetBy: maxPalindromeStart+maxPalindromeLength)
    return String(s[rangeStart..<rangeEnd])
}

