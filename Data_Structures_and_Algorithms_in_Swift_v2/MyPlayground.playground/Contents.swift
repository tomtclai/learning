import UIKit

func sumFromOne(upTo n: Int) -> Int {
//    // Naive implementation
//
//    var result = 0
//    for i in 1...n {
//        result += i
//    }
//    return result
    
//    // This is faster bc compiled code, Big o is the same but the constants are smaller!
//    return (1...n).reduce(0, +)
    
//    This uses a math trick, this is linear time
    return (n+1) * n/2
}

sumFromOne(upTo: 10000)


func printSorted(_ array: [Int]) {
    let sorted = array.sorted()
    for element in sorted {
        print(element)
    }
}

