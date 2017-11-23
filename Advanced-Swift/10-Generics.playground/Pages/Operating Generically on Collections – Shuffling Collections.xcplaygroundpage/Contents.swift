/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Shuffling Collections

To help cement this concept, here's another example, this time an implementation
of the [Fisher-Yates](https://en.wikipedia.org/wiki/Fisher–Yates_shuffle)
shuffling algorithm:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            self.swapAt(i, j)
        }
    }

    /// Non-mutating variant of `shuffle`
    func shuffled() -> [Element] {
        var clone = self
        clone.shuffle()
        return clone
    }
}

/*:
Again, we've followed a standard library practice: providing an in-place
version, since this can be done more efficiently, and then providing a
non-mutating version that generates a shuffled copy of the array, which can be
implemented in terms of the in-place version.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
