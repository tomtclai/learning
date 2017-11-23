/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Slices

All collections get a default implementation of the slicing operation and have
an overload for `subscript` that takes a `Range<Index>`. This is the equivalent
of `list.dropFirst()`:

*/

// --- (Hidden code block) ---
extension Substring {
    var nextWordRange: Range<Index> {
        let start = drop(while: { $0 == " "})
        let end = start.index(where: { $0 == " "}) ?? endIndex
        return start.startIndex..<end
    }
}

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

extension Words {
    subscript(index: WordsIndex) -> Substring {
        return string[index.range]
    }
}

extension Words {
    func index(after i: WordsIndex) -> WordsIndex {
        guard i.range.upperBound < string.endIndex 
            else { return endIndex }
        let remainder = string[i.range.upperBound...]
        return WordsIndex(remainder.nextWordRange)
    }
}

Array(Words(" hello world  test  ").prefix(2))
// ---------------------------
let words: Words = Words("one two three")
let onePastStart = words.index(after: words.startIndex)
let firstDropped = words[onePastStart..<words.endIndex]
Array(firstDropped)

/*:
Since operations like `words[somewhere..<words.endIndex]` (slice from a specific
point to the end) and `words[words.startIndex..<somewhere]` (slice from the
start to a specific point) are common, there are variants in the standard
library that do these operations in a more readable way:

*/

let firstDropped2 = words.suffix(from: onePastStart)
// or:
let firstDropped3 = words[onePastStart...]

/*:
By default, the type of `firstDropped` won't be `Words` — it'll be a
`Slice<Words>`. `Slice` is a lightweight wrapper on top of any collection. The
implementation looks something like this:

*/

struct Slice_sample_impl<Base: Collection>: Collection {
    typealias Index = Base.Index
    typealias IndexDistance = Base.IndexDistance
    typealias SubSequence = Slice_sample_impl<Base>
        
    let collection: Base

    var startIndex: Index
    var endIndex: Index

    init(base: Base, bounds: Range<Index>) {
        collection = base
        startIndex = bounds.lowerBound
        endIndex = bounds.upperBound
    }

    func index(after i: Index) -> Index {
        return collection.index(after: i)
    }

    subscript(position: Index) -> Base.Element {
        return collection[position]
    }

    subscript(bounds: Range<Base.Index>) -> Slice_sample_impl<Base> {
        return Slice_sample_impl(base: collection, bounds: bounds)
    }
}

/*:
`Slice` is a perfectly good default subsequence type, but every time you write a
custom collection, it's worth investigating whether or not you can make the
collection its own `SubSequence`. For `Words`, this is easy to do:

*/

extension Words {
    subscript(range: Range<WordsIndex>) -> Words {
        let start = range.lowerBound.range.lowerBound
        let end = range.upperBound.range.upperBound
        return Words(string[start..<end])
    }
}

/*:
The compiler infers the `SubSequence` type from the return type of the
range-based subscript.

Using the same type for a collection and its `SubSequence` makes life easier for
users of the collection because they only have to understand a single type
instead of two. On the flip side, using distinct types for "root" collections
and their slices can help prevent accidental memory "leaks," which is why the
standard library has `ArraySlice` and `Substring`.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
