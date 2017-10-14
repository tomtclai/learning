// https://leetcode.com/problems/baseball-game/description/
func calPoints(_ ops: [String]) -> Int {
    var confirmedSum = 0
    var history = [Int]()

    func addToSum(_ n: Int) {
        confirmedSum += n
        history.append(n)
    }

    for op in ops {
        if let numericRound = Int(op) {
            addToSum(numericRound)
        } else if op == "C" {
            // cancel, skip the last one
            confirmedSum -= history.removeLast()
        } else if op == "D" {
            // double, double the last one
            addToSum(history.last! * 2)
        } else if op == "+" {
            let last = history.removeLast()
            let secondtoLast = history.last!
            history.append(last)
            addToSum(last + secondtoLast)
        }
    }
    return confirmedSum
}
