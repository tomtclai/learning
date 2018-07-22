func reconstructQueue(_ people: [[Int]]) -> [[Int]] {
    var people = people.sorted { a, b in
        if a[0] > b[0] { return true } else if a[0] < b[0] { return false } else { return a[1] < b[1] }
    }

    // find where the first number stops
    guard let firstNumber = people.first?[0] else {
        return people
    }
    guard let index = people.index(where: { return $0[0] != firstNumber}) else {
        return people
    }

    var recontructedQueue = Array(people[0..<index])

    for i in index..<people.count {
        recontructedQueue.insert(people[i], at: people[i][1])
    }

    return recontructedQueue
}
//https://leetcode.com/problems/queue-reconstruction-by-height/description/
