/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Substrings

Like all collections, `String` has a specific slice or `SubSequence` type named
`Substring`. A substring is much like an `ArraySlice`: it's a view of a base
string with different start and end indices. Substrings share the text storage
of their base strings. This has the huge benefit that slicing a string is a very
cheap operation. Creating the `firstWord` variable in the following example
requires no expensive copies or memory allocations:

*/

let sentence = "The quick brown fox jumped over the lazy dog."
let firstSpace = sentence.index(of: " ") ?? sentence.endIndex
let firstWord = sentence[..<firstSpace]
type(of: firstWord)

/*:
Slicing being cheap is especially important in loops where you iterate over the
entire (potentially long) string to extract its components. Tasks like finding
all occurrences of a word in a text or parsing a CSV file come to mind. A very
useful string processing operation in this context is splitting. The `split`
method is defined on `Collection` and returns an array of subsequences (i.e.
`[Substring]`). Its most common variant is defined like so:

``` swift-example
extension Collection where Element: Equatable {
    public func split(separator: Element, maxSplits: Int = Int.max,
        omittingEmptySubsequences: Bool = true) -> [SubSequence]
}
```

You can use it like this:

*/

let poem = """
    Over the wintry
    forest, winds howl in rage
    with no leaves to blow.
    """
let lines = poem.split(separator: "\n")
type(of: lines)

/*:
This can serve a function similar to the `components(separatedBy:)` method
`String` inherits from `NSString`, with added configurations for whether or not
to drop empty components. Again, no copies of the input string are made. And
since there's another variant of `split` that takes a closure, it can do more
than just compare characters. Here's an example of a primitive word wrap
algorithm, where the closure captures a count of the length of the line thus
far:

*/

extension String {
    func wrapped(after: Int = 70) -> String {
        var i = 0
        let lines = self.split(omittingEmptySubsequences: false) {
            character in
            switch character {
            case "\n", " " where i >= after:
                i = 0
                return true
            default:
                i += 1
                return false
            }
        }
        return lines.joined(separator: "\n")
    }
}

sentence.wrapped(after: 15)

/*:
Or, consider writing a version that takes a sequence of multiple separators:

*/

extension Collection where Element: Equatable {
    func split<S: Sequence>(separators: S) -> [SubSequence]
        where Element == S.Element
    {
        return split { separators.contains($0) }
    }
}

/*:
This way, you can write the following:

*/

"Hello, world!".split(separators: ",! ")

/*:
### `StringProtocol`

`Substring` has almost the same interface as `String`. This is achieved through
a common protocol named `StringProtocol`, which both types conform to. Since
almost the entire string API is defined on `StringProtocol`, you can mostly work
with a `Substring` as you would with a `String`. At some point, though, you'll
have to turn your substrings back into `String` instances; like all slices,
substrings are only intended for short-term storage, in order to avoid expensive
copies during an operation. When the operation is complete and you want to store
the results or pass them on to another subsystem, you should create a new
`String`. You can do this by initializing a `String` with a `Substring`, as we
do in this example:

*/

func lastWord(in input: String) -> String? {
    // Process the input, working on substrings
    let words = input.split(separators: [",", " "])
    guard let lastWord = words.last else { return nil }
    // Convert to String for return
    return String(lastWord)
}

lastWord(in: "one, two, three, four, five")

/*:
The rationale for discouraging long-term storage of substrings is that a
substring always holds on to the entire original string. A substring
representing a single character of a huge string will hold the entire string in
memory, even after the original string's lifetime would normally have ended.
Long-term storage of substrings would therefore effectively cause memory leaks
because the original strings have to be kept in memory even when they're no
longer accessible.

By working with substrings during an operation and only creating new strings at
the end, we defer copies until the last moment and make sure to only incur the
cost of those copies that are actually necessary. In the example above, we split
the entire (potentially long) string into substrings, but only pay the cost for
a single copy of one short substring at the end. (Ignore for a moment that this
algorithm isn't efficient anyway; iterating backward from the end until we find
the first separator would be the better approach.)

Encountering a function that only accepts a `Substring` when you want to pass a
`String` is less common — most functions should either take a `String` or any
`StringProtocol`-conforming type. But if you do need to pass a `String`, the
quickest way is to subscript the string with the range operator `...` without
specifying any bounds:

*/

// Substring with identical start and end index as the base string
let substring = sentence[...]

/*:
We already saw an example of this in the chapter on collection-protocols when we
defined the `Words` collection.

> The `Substring` type is new in Swift 4. In Swift 3, `String.CharacterView`
> used to be its own slice type. This had the advantage that users only had to
> understand a single type, but it meant that a stored substring would keep the
> entire original string buffer alive even after it normally would've been
> released. Swift 4 trades a small loss in convenience for cheap slicing
> operations and predictable memory usage.
> 
> The Swift team does recognize that requiring explicit conversions from
> `Substring` to `String` is a little annoying. If this turns out to be a big
> problem in practical use, the team is considering wiring an [implicit subtype
> relationship](https://github.com/apple/swift/blob/master/docs/StringManifesto.md#substrings)
> between `Substring` and `String` directly into the compiler, in the same way
> that `Int` is a subtype of `Optional<Int>`. This would allow you to pass a
> `Substring` anywhere a `String` is expected, and the compiler would perform
> the conversion for you.

You may be tempted to take full advantage of the existence of `StringProtocol`
and convert all your APIs to take `StringProtocol` instances rather than plain
`String`s. But the advice of the Swift team is [not to do
that](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20170626/037828.html):

> Our general advice is to stick with `String`. Most APIs would be simpler and
> clearer just using `String` rather than being made generic (which itself can
> come at a cost), and user conversion on the way in on the few occasions that's
> needed isn’t much of a burden.

APIs that are extremely likely to be used with substrings, and at the same time
aren't further generalizable to the `Sequence` or `Collection` level, are an
exception to this rule. An example of this in the standard library is the
`joined` method. Swift 4 added an overload for sequences with
`StringProtocol`-conforming elements:

``` swift-example
extension Sequence where Element: StringProtocol {
    /// Returns a new string by concatenating the elements of the sequence,
    /// adding the given separator between each element.
    public func joined(separator: String = "") -> String
}
```

This lets you call `joined` directly on an array of substrings (which you got
from a call to `split`, for example) without having to map over the array and
copy every substring into a new string. This is more convenient and much faster.

The number type initializers that take a string and convert it into a number
also take `StringProtocol` values in Swift 4. Again, this is especially handy if
you want to process an array of substrings:

*/

let commaSeparatedNumbers = "1,2,3,4,5"
let numbers = commaSeparatedNumbers
    .split(separator: ",").flatMap { Int($0) }

/*:
Since substrings are intended to be short-lived, it's generally not advisable to
return one from a function unless we're talking about `Sequence` or `Collection`
APIs that return slices. If you write a similar function that only makes sense
for strings, having it return a substring tells readers that it doesn't make a
copy. Functions that create new strings requiring memory allocations, such as
`uppercased()`, should always return `String` instances.

If you want to extend `String` with new functionality, placing the extension on
`StringProtocol` is a good idea to keep the API surface between `String` and
`Substring` consistent. `StringProtocol` is explicitly designed to be used
whenever you would've previously extended `String`. If you want to move existing
extensions from `String` to `StringProtocol`, the only change you should have to
make is to replace any passing of `self` into an API that takes a concrete
`String` with `String(self)`.

Keep in mind, though, that as of Swift 4, `StringProtocol` is not yet intended
as a conformance target for your own custom string types. The documentation
explicitly warns against it:

> Do not declare new conformances to `StringProtocol`. Only the `String` and
> `Substring` types of the standard library are valid conforming types.

Allowing developers to write their own string types (with special storage or
performance optimizations, for instance) is the eventual goal, but the protocol
design hasn't yet been finalized, so adopting it now may break your code in
Swift 5.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
