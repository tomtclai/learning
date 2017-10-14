// https://leetcode.com/problems/baseball-game/description/
func calPoints(_ ops: [String]) -> Int {
    var confirmedSum = 0
    var history = [Int]()
    // ["5","2","C","D","+"]
    // 5
    // 5,2 "7"
    // 5 "5"
    // 5,10,15 "15"
    // 5,10,15 "30"
    for op in ops {
        if let numericRound = Int(op) {
            confirmedSum += numericRound
            history.append(numericRound)
        } else if op == "C" {
            // cancel, skip the last one
            confirmedSum -= history.removeLast()
        } else if op == "D" {
            // double, double the last one
            history.append( history.last! * 2)
            confirmedSum +=  history.last!
        } else if op == "+" {
            let last = history.removeLast()
            let secondtoLast = history.last!
            history.append(last)
            history.append(last + secondtoLast)
            confirmedSum +=  history.last!
        }
    }
    return confirmedSum
}

