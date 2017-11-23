/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Ranges of Characters

Speaking of ranges, you may have tried to iterate over a range of characters and
found that it doesn't work:

*/

let lowercaseLetters = ("a" as Character)..."z"

/*:
``` swift-example
for c in lowercaseLetters { // Error
    ...
}
```

(The cast to `Character` is important because the default type of a string
literal is `String`; we need to tell the type checker we want a `Character`
range.)

We talked about the reason why this fails in the chapter about built-in
collections: `Character` doesn't conform to the `Strideable` protocol, which is
a requirement for ranges to become *countable* and thus collections. All you can
do with a range of characters is compare other characters against it, i.e. check
whether a character is inside the range or not:

*/

lowercaseLetters.contains("A")
lowercaseLetters.contains("é")

/*:
It's interesting that Swift's default string ordering orders é between e and f,
i.e. accented letters are inside the range. Combine that with the fact that a
single `Character` can contain an infinite number of combining marks, and it
makes sense that the range can't be countable: it contains an infinite (i.e.
uncountable) number of possible characters.

One type for which the notion of countable ranges does make sense is
`Unicode.Scalar`, at least if you stick to ASCII or other well-ordered subsets
of the Unicode catalog. Scalars have a well-defined order through their code
point values, and there's always a finite number of scalars between any two
bounds. `Unicode.Scalar` isn't `Strideable` by default, but we can add the
conformance retroactively:

*/

extension Unicode.Scalar: Strideable {
    public typealias Stride = Int

    public func distance(to other: Unicode.Scalar) -> Int {
        return Int(other.value) - Int(self.value)
    }

    public func advanced(by n: Int) -> Unicode.Scalar {
        return Unicode.Scalar(UInt32(Int(value) + n))!
    }
}

/*:
(We're ignoring the fact that the surrogate code points `0xD800` to `0xDFFF`
aren't valid Unicode scalar values. Constructing a range that overlaps this
region is a programmer error.)

This allows us to create a countable range of Unicode scalars and use it as a
very convenient way to generate an array of characters:

*/

let lowercase = ("a" as Unicode.Scalar)..."z"
Array(lowercase.map(Character.init))

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
