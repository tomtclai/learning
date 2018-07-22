// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

var testString1 = "h((e))llo(world)()"
var testString2 = "(hello world"

/*: 2. Given a string, check if there are `(` and `)` characters, and return `true` if the parentheses in the string are balanced. */

func checkParentheses(_ string: String) -> Bool {
  var stack = Stack<Character>()
  
  for character in string {
    if character == "(" {
      stack.push(character)
    } else if character == ")" {
      if stack.isEmpty {
        return false
      } else {
        stack.pop()
      }
    }
  }
  return stack.isEmpty
}
