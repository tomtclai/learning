// https://leetcode.com/problems/beautiful-arrangement/discuss/
func countArrangement(_ N: Int) -> Int {
    func counts(_ n: Int, _ vs: inout [Int]) -> Int{
        if n < 1 {
            return 1
        }
        var answer = 0
        for i in 0..<n {
            if vs[i]%n == 0 || n%vs[i] == 0 {
                vs.swapAt(i, n-1) // moving this eligible number out of sight, so my recursive call don't see this number
                answer += counts(n-1, &vs)
                vs.swapAt(i, n-1) // swapping back for next iteration
            }
        }
        return answer
    }
    var vs = [Int]()
    for i in 1...N {
        vs.append(i)
    }
    return counts(N, &vs)
}

