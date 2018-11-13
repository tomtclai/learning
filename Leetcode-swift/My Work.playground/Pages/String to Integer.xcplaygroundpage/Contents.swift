import Foundation
class Solution {
  func myAtoi(_ str: String) -> Int {
    // trim white space
    let trimmedString = str.trimmingCharacters(in: .whitespacesAndNewlines)
    // first char:
    //     test for +/-
    let firstChar = trimmedString.first
    var negative = false
    if firstChar == "-" {
      negative = true
    } else if firstChar == "+" {
      negative = false
    } else {
      guard let firstChar = firstChar, let _ = Int(String(firstChar)) else {
        return 0
      }
    }

    let numberAsStrings = matchesForRegexInText(regex: "\\d+", text: trimmedString)  // [String]

    guard let firstNumber = numberAsStrings else { return 0 }
    if let number32 = Int32(firstNumber) {
      let number = Int(number32)
      return negative ? -number : number
    } else {
      return negative ? Int(Int32.min) : Int(Int32.max)
    }

  }

  func matchesForRegexInText(regex: String!, text: String!) -> String? {
    let range = text.range(of: regex, options: .regularExpression)
    if let range = range {
      return text.substring(with: range)
    } else {
      return nil
    }
  }
}

let solution = Solution()
solution.myAtoi("words and 987")
