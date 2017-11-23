/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## String Indices

Most programming languages use integers for subscripting strings, e.g. `str[5]`
would return the sixth "character" of `str` (for whatever that language's idea
of a "character" is). Swift doesn't allow this. Why? The answer should sound
familiar to you by now: subscripting is supposed to take constant time
(intuitively as well as per the requirements of the `Collection` protocol), and
looking up the *n*^th^ `Character` is impossible without looking at all bytes
that come before it.

`String.Index`, the index type used by `String` and its views, is an opaque
value that essentially stores a byte offset from the beginning of the string.
It's still an `O(n)` operation if you want to compute the index for the *n*^th^
character and have to start at the beginning of the string, but once you have a
valid index, subscripting the string with it now only takes `O(1)` time. And
crucially, finding the next index after an existing index is also fast because
you can start at the existing index's byte offset — you don't need to go back to
the beginning again. This is why iterating over the characters in a string in
order (forward or backward) is efficient.

String index manipulation is based on the same `Collection` APIs you'd use with
any other collection. It's easy to miss this equivalence since the collections
we use by far the most — arrays — use integer indices, and we usually use simple
arithmetic to manipulate those. The `index(after:)` method returns the index of
the next character:

*/

let s = "abcdef"
let second = s.index(after: s.startIndex)
s[second]

/*:
You can automate iterating over multiple characters in one go via the
`index(_:offsetBy:)` method:

*/

// Advance 4 more characters
let sixth = s.index(second, offsetBy: 4)
s[sixth]

/*:
If there's a risk of advancing past the end of the string, you can add a
`limitedBy:` parameter. The method returns `nil` if it hits the limit before
reaching the target index:

*/

let safeIdx = s.index(s.startIndex, offsetBy: 400, limitedBy: s.endIndex)
safeIdx

/*:
This is undoubtedly more code than simple integer indices would require, but
again, that's the point. If Swift allowed integer subscripting of strings, the
temptation to accidentally write horribly inefficient code (e.g. by using
integer subscripting inside a loop) would be too big.

Nevertheless, to someone used to dealing with fixed-width characters, working
with strings in Swift seems challenging at first — how will you navigate without
integer indices? And indeed, some seemingly simple tasks like extracting the
first four characters of a string can turn into monstrosities like this one:

*/

s[..<s.index(s.startIndex, offsetBy: 4)]

/*:
But thankfully, being able to access the string via the `Collection` interface
also means you have several helpful techniques at your disposal. Many of the
methods that operate on `Array` also work on `String`. Using the `prefix`
method, the same thing looks much clearer:

*/

s.prefix(4)

/*:
(Note that either expression returns a `Substring`; you can convert it back into
a `String` by wrapping it in a `String.init`. We'll talk more about substrings
in the next section.)

Iterating over characters in a string is easy without integer indices; just use
a `for` loop. If you want to number each character in turn, use `enumerated()`:

*/

for (i, c) in s.enumerated() {
    print("\(i): \(c)")
}

/*:
Or say you want to find a specific character. In that case, you can use
`index(of:)`:

*/

var hello = "Hello!"
if let idx = hello.index(of: "!") {
    hello.insert(contentsOf: ", world", at: idx)
}
hello

/*:
The `insert(contentsOf:)` method inserts another collection of the same element
type (e.g. `Character` for strings) before a given index. This doesn't have to
be another `String`; you could insert an array of characters into a string just
as easily.

*/


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
