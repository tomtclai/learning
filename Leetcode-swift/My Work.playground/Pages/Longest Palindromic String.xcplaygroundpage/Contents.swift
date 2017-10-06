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

    var arrayOfInts = [Int]()
    var tableOfInts = [[Int]]()
    // better solution... remember those smaller solutions
    // make a table of (string size)^2
    s.characters.forEach { _ in
        arrayOfInts.append(0)
    }

    s.characters.forEach { _ in
        tableOfInts.append(arrayOfInts)
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
    return ""
}

