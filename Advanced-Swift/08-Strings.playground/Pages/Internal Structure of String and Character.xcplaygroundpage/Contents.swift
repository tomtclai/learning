/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Internal Structure of `String` and `Character`

Like the other collection types in the standard library, strings are
copy-on-write collections with value semantics. A `String` instance stores a
reference to a buffer, which holds the actual character data. When you make a
copy of a string (through assignment or by passing it to a function) or create
substrings, all these instances share the same buffer. The character data is
only copied when an instance gets mutated while it's sharing its character
buffer with one or more other instances. For more on copy-on-write, see the
chapter on structs and classes.

In Swift 4.0, `String` uses either 8-bit ASCII (if the string contains nothing
but ASCII characters) or UTF-16 (if one or more non-ASCII characters are
present) as its in-memory representation. You may be able to use this knowledge
to your advantage if you require the best possible performance — traversing the
UTF-16 view may be a bit faster than the UTF-8 or Unicode scalar views for
non-ASCII data — but keep in mind that the in-memory format is an implementation
detail that may change without notice. It's possible that `String` will become
more flexible in the future, e.g. by storing UTF-8-encoded text directly in
UTF-8, thereby saving the effort of transcoding it to UTF-16.

Strings received from Objective-C are backed by an `NSString`. In this case, the
`NSString` acts directly as the Swift string's buffer to make the bridging
efficient. An `NSString`-backed `String` will be converted to a native Swift
string when it gets mutated.

### The `Character` Type

The internal structure of the `Character` type is interesting. As we've seen,
`Character` represents a sequence of scalars that might be arbitrarily long. At
the same time, grapheme clusters of arbitrary length are an edge case — the vast
majority of characters are only a few bytes long. It's a good idea to optimize
for the common case by storing the bytes that make up the character in line as
long as they don't exceed a certain length, and only allocating a separate
buffer for uncommonly large grapheme clusters. If you look at the [source
code](https://github.com/apple/swift/blob/swift-4.0-branch/stdlib/public/core/Character.swift),
you'll find that `Character` is essentially defined like this:

``` swift-example
public struct Character {
    internal enum Representation {
      case smallUTF16(Builtin.Int63)
      case large(Buffer)
    }

    internal var _representation: Representation
}
```

`Character` is a wrapper around an enum with two cases, `.smallUTF16` and
`.large`. The small case is used for grapheme clusters where the UTF-16
representation is 63 bits or less. (`Builtin.Int63` is an internal LLVM type
that's only available to the standard library.) The unusual size of 63 bits was
carefully chosen to fit a `Character` instance into a single machine word. The
remaining bit is needed to discriminate between the two enum cases. The compiler
is smart enough to use so-called [*extra
inhabitants*](https://github.com/apple/swift/blob/master/docs/ABI/TypeLayout.rst#fragile-enum-layout)
— bit patterns that aren't valid values for a particular type — in an enum's
associated values to store the enum case tag. This works here because the
associated value for the large case (which is effectively a pointer) also has
some spare bits. Pointer alignment rules mean that some bits of a valid object
pointer will always be zero.

*/

MemoryLayout<Character>.size

/*:
This technique — holding a small number of elements internally and switching to
a heap-based buffer — is sometimes called the "small string optimization." It
works particularly well here since the optimized case is so much more common
than the unoptimized one.

`String` could profit from a similar optimization because many strings used in
code are small enough to fit into an 8-byte word. Apple introduced such an
optimization for `NSString` a few years ago, where short strings of up to 7
ASCII-only characters are [stored directly in a tagged
pointer](https://www.mikeash.com/pyblog/friday-qa-2015-07-31-tagged-pointer-strings.html),
saving any extra heap allocations. (There's even an extra mode with custom five-
or six-bit encodings for strings of up to 11 characters out of a very
constrained alphabet — it's very clever.) Swift strings could get something like
this in the future. Check out the Swift core team's [String
Manifesto](https://github.com/apple/swift/blob/master/docs/StringManifesto.md#high-performance-string-processing)
to learn more about the plans to provide additional performance enhancements for
strings.

*/


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
