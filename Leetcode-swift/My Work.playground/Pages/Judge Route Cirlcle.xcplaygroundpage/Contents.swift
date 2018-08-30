// https://leetcode.com/problems/judge-route-circle/description/
func judgeCircle(_ moves: String) -> Bool {
    var x = 0
    var y = 0
    let charArray = Array(moves.characters)
    for char in charArray {
        switch char {
        case "U": y += 1
        case "D": y -= 1
        case "L": x -= 1
        case "R": x += 1
        default:
            print("unexpected characters!!")
        }
    }
    return x==0 && y==0
}
