// https://leetcode.com/problems/fizz-buzz/description/
func fizzBuzz(_ n: Int) -> [String] {
    // later optimization, save this outside of the function
    var resultString = [String]()
    for i in 1...n {
        if i % 15 == 0 {
            resultString.append("FizzBuzz")
        } else if i % 3 == 0 {
            resultString.append("Fizz")
        } else if i % 5 == 0 {
            resultString.append("Buzz")
        } else {
            resultString.append("\(i)")
        }
    }
    return resultString
}
