/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Custom Collection Indices 

As an example of a collection with non-integer indices, we'll build a way to
iterate over the words in a string. When you want to split a string into its
words, the easiest way is to use
`split(separator:maxSplits:omittingEmptySubsequences:)`. This method is defined
on `Collection`, and it turns a collection into an array of `SubSequence`s,
split at the provided separator:

*/

var str = "Still I see monsters"
str.split(separator: " ")

/*:
This code returns an array of words. Each word is of type `Substring`, which is
`String`'s associated `SubSequence` type. Whenever you need to split a
collection, the `split` method is almost always the right tool to use. It does
have one disadvantage though: it eagerly computes the entire array. If you have
a large string and only need the first few words, this isn't very efficient. To
be more efficient, we build a `Words` collection that doesn't compute all the
words up front but instead allows us to iterate lazily.

Let's start by finding the range of the first word in a `Substring`. We'll use
spaces as word boundaries, although it's an interesting exercise to make this
configurable. A substring might start with an arbitrary number of spaces, which
we skip over. `start` is the substring with the leading spaces removed. We'll
then try to find the next space; if there's any space, we use that as the end of
the word boundary. If we can't find any more spaces, we use `endIndex`:

*/

extension Substring {
    var nextWordRange: Range<Index> {
        let start = drop(while: { $0 == " "})
        let end = start.index(where: { $0 == " "}) ?? endIndex
        return start.startIndex..<end
    }
}

/*:
Note that `Range` is half-open: the upper bound `end` isn't included in the word
range.

A logical first choice for the index type of a `Words` collection would be
`Int`: the index `i` would mean the `i`th word in the collection. However,
accessing an element through the index-based subscript needs to be `O(1)`, and
in order to find the `i`^th^ word, we'd have to process the entire string (which
is an `O(n)` operation).

Another choice for the index type would be to use `String.Index`. The
collection's `startIndex` would be `string.startIndex`, the index after that
would be the index of the beginning of the next word, and so on. Unfortunately,
the subscript implementation will have a similar problem: finding the end of the
word is also `O(n)`.

Instead, we make our index a wrapper around `Range<Substring.Index>`. A
collection's index needs to be `Comparable` (and because `Comparable` inherits
from `Equatable`, we need to implement `==` as well). To compare two indices, we
only compare the range's lower bounds. This doesn't work for comparing `Range`s
in general, but for our purpose it suffices. By marking the `range` property and
the initializer as `fileprivate`, we make `WordsIndex` an opaque type; users of
our collection don't know the internal structure, and the only way to create an
index is through the collection's interface:

*/

struct WordsIndex: Comparable {
    fileprivate let range: Range<Substring.Index>
    fileprivate init(_ value: Range<Substring.Index>) {
        self.range = value
    }
    
    static func <(lhs: Words.Index, rhs: Words.Index) -> Bool {
        return lhs.range.lowerBound < rhs.range.lowerBound
    }
    
    static func ==(lhs: Words.Index, rhs: Words.Index) -> Bool {
        return lhs.range == rhs.range
    }
}

/*:
We're now ready to build our `Words` collection. It stores the underlying
`String` as a `Substring` (we'll see why in the section on slicing) and provides
a start index and an end index. The `Collection` protocol requires `startIndex`
to have a complexity of `O(1)`. Unfortunately, computing it takes `O(n)`, where
`n` is the number of spaces at the start of the string. Therefore, we compute it
in the initializer and store it, instead of defining it as a computed property.
For the end index, we use an empty range that's outside the bounds of the
underlying string:

*/

struct Words: Collection {
    let string: Substring
    let startIndex: WordsIndex
    
    init(_ s: String) {
        self.init(s[...])
    }

    private init(_ s: Substring) {
        self.string = s
        self.startIndex = WordsIndex(string.nextWordRange)
    }
    
    var endIndex: WordsIndex {
        let e = string.endIndex
        return WordsIndex(e..<e)
    }
}

/*:
Collection also requires us to provide a `subscript` that accesses elements.
Here we can directly use the index's underlying range. Note that using the range
of the word as the index makes the implementation `O(1)`:

*/

extension Words {
    subscript(index: WordsIndex) -> Substring {
        return string[index.range]
    }
}

/*:
As the final `Collection` requirement, we need a way to compute the index
following a given index. The upper bound of the index's range is *not* included,
so unless that's already the string's `endIndex`, we can take the substring from
the upper bound onward, and then look for the next word range:

*/

extension Words {
    func index(after i: WordsIndex) -> WordsIndex {
        guard i.range.upperBound < string.endIndex 
            else { return endIndex }
        let remainder = string[i.range.upperBound...]
        return WordsIndex(remainder.nextWordRange)
    }
}

Array(Words(" hello world  test  ").prefix(2))

/*:
With some effort, the `Words` collection could be changed to solve more general
problems. First of all, we can make the word boundary configurable: instead of
using a space, we can pass in a function, `isWordBoundary: (Character) -> Bool`.
Second, the code isn't really specific to strings: we could replace `String`
with any kind of collection. For example, we could reuse the same algorithm to
lazily split `Data` into processable chunks.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
