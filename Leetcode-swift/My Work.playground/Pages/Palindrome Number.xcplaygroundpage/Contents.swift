
//https://leetcode.com/problems/palindrome-number/
/*
 Determine whether an integer is a palindrome. An integer is a palindrome when it reads the same backward as forward.

 Example 1:

 Input: 121
 Output: true

 Example 2:
 Input: -121
 Output: false
 Explanation: From left to right, it reads -121. From right to left, it becomes 121-. Therefore it is not a palindrome.

 Example 3:
 Input: 10
 Output: false
 Explanation: Reads 01 from right to left. Therefore it is not a palindrome.
 Follow up:

 Coud you solve it without converting the integer to a string?
 */
import Foundation

func isPalindrome(_ x: Int) -> Bool {
    var xString = String(x)
    while xString.count > 1 {
        if xString.removeFirst() != xString.removeLast() { return false }
    }
    return true
}


func isPalindrome_56ms(_ x: Int) -> Bool {
    guard x > 0 else { return false }
    var temp = x
    var xInReverse = 0

    while temp != 0 {
        xInReverse = xInReverse * 10 + temp % 10
        temp = temp / 10
    }

    return xInReverse == x
}



isPalindrome(-121)
isPalindrome(10)
isPalindrome(121)


isPalindrome_56ms(-121)
isPalindrome_56ms(10)
isPalindrome_56ms(121)
