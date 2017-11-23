/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
So how can we write a generic version of this that doesn't mandate integer
indices? Just like with binary search, we still need random access, but we also
have a new requirement that the collection be mutable, since we want to be able
to provide an in-place version. The use of `count - 1` will definitely need to
change in a way similar to the binary search.

Before we get to the generic implementation, there's an extra complication. We
want to use `arc4random_uniform` to generate random numbers, but we don't know
exactly what type of integer `IndexDistance` will be. We know it's an integer,
but not necessarily that it's an `Int`. To handle this, we need to write a
generic version of `arc4random_uniform` that works on any integer type
conforming to the `BinaryInteger` protocol (Swift 4 implemented a new hierarchy
of [protocol-oriented
integers](https://github.com/apple/swift-evolution/blob/master/proposals/0104-improved-integers.md),
which makes this task easier than before):

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
extension BinaryInteger {
    static func arc4random_uniform(_ upper_bound: Self) -> Self {
        precondition(
            upper_bound > 0 && UInt32(upper_bound) < UInt32.max,
            "arc4random_uniform only callable up to \(UInt32.max)")
        return Self(Darwin.arc4random_uniform(UInt32(upper_bound)))
    }
}

/*:
> You could write a version of `arc4random` that operates on ranges spanning
> negative numbers, or above the max of `UInt32`, if you wanted to. But to do so
> would require a lot more code. If you're interested, the definition of
> `arc4random_uniform` is actually [open
> source](https://www.opensource.apple.com/source/Libc/Libc-594.9.4/gen/FreeBSD/arc4random.c)
> and quite well commented, and it gives several clues as to how you might do
> this.

We then use the ability to generate a random number for every `IndexDistance`
type in our generic shuffle implementation:

*/

extension MutableCollection where Self: RandomAccessCollection {
    mutating func shuffle() {
        var i = startIndex
        let beforeEndIndex = index(before: endIndex)
        while i < beforeEndIndex {
            let dist = distance(from: i, to: endIndex)
            let randomDistance = IndexDistance.arc4random_uniform(dist)
            let j = index(i, offsetBy: randomDistance)
            self.swapAt(i, j)
            formIndex(after: &i)
        }
    }
}

extension Sequence {
    func shuffled() -> [Element] {
        var clone = Array(self)
        clone.shuffle()
        return clone
    }
}

var numbers = Array(1...10)
numbers.shuffle()
numbers


/*:
The generic `shuffle` method is significantly more complex and less readable
than the non-generic version. This is partly because we had to replace simple
integer math like `count - 1` with index calculations like `index(before:
endIndex)`. The other reason is that we switched from a `for` to a `while` loop.
The alternative, iterating over the indices with `for i in indices.dropLast()`,
has a potential performance problem that we already talked about in the
collection protocols chapter: if the `indices` property holds a reference to the
collection, mutating the collection while traversing the `indices` will defeat
the copy-on-write optimizations and cause the collection to make an unnecessary
copy.

Admittedly, the chances of this happening in our case are small, because most
random-access collections likely use plain integer indices where the `Indices`
type doesn't need to reference its base collection. For instance,
`Array.Indices` is `CountableRange<Int>` instead of the default
`DefaultRandomAccessIndices`.

Inside the loop, we measure the distance from the running index to the end and
then use our new `BinaryInteger.arc4random_uniform` method to compute a random
index to swap with. The actual swap operation remains the same as it is in the
non-generic version.

You might wonder why we didn't extend `MutableCollection` when implementing the
non-modifying shuffle. Again, this is a pattern you see often in the standard
library — for example, when you sort a `ContiguousArray`, you get back an
`Array` and not a `ContiguousArray`.

In this case, the reason is that our immutable version relies on the ability to
clone the collection and then shuffle it in place. This, in turn, relies on the
collection having value semantics. But not all collections are guaranteed to
have value semantics. If `NSMutableArray` conformed to `MutableCollection`
(which it doesn't — probably because it's bad form for Swift collections to not
have value semantics — but could), then `shuffled` and `shuffle` would have the
same effect, since `NSMutableArray` has reference semantics. `var clone = self`
just makes a copy of the reference, so a subsequent `clone.shuffle` would
shuffle `self` — probably not what the user would expect. Instead, we take a
full copy of the elements into an array and shuffle and return that.

There's a compromise approach. You could write a version of `shuffle` to return
the same type of collection as the one being shuffled, so long as that type is
also a `RangeReplaceableCollection`:

*/

extension MutableCollection
    where Self: RandomAccessCollection, Self: RangeReplaceableCollection
{
    func shuffled() -> Self {
        var clone = Self()
        clone.append(contentsOf: self)
        clone.shuffle()
        return clone
    }
}

/*:
This relies on the two abilities of `RangeReplaceableCollection`: to create a
fresh empty version of the collection, and to then append any sequence (in this
case, `self`) to that empty collection, thus guaranteeing a full clone takes
place. The standard library doesn't take this approach — probably because the
consistency of always creating an array for any kind of non-in-place operation
is preferred — but it's an option if you want it. However, remember to create
the sequence version as well, so that you offer shuffling for non-mutable
collections and sequences.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
