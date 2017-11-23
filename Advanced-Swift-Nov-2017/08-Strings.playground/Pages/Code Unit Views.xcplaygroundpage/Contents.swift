/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Code Unit Views

Sometimes it's necessary to drop down to a lower level of abstraction and
operate directly on Unicode scalars or code units instead of grapheme clusters.
`String` provides three views for this: `unicodeScalars`, `utf16`, and `utf8`.
Like `String`, these are bidirectional collections that support all the familiar
operations. And like substrings, the views share the string's storage; they
simply represent the underlying bytes in a different way.

There are a few common reasons why you'd need to work on one of the views.
Firstly, maybe you actually need the code units, perhaps for rendering into a
UTF-8-encoded webpage, or for interoperating with a non-Swift API that expects a
particular encoding. Or maybe you need information about the string in a
specific format.

For example, suppose you're writing a Twitter client. While the Twitter API
expects strings to be UTF-8-encoded, [Twitter's character counting
algorithm](https://developer.twitter.com/en/docs/basics/counting-characters) is
based on [NFC-normalized](https://unicode.org/reports/tr15/#Norm_Forms) code
points (i.e. scalars). So if you want to show your users how many characters
they have left, this is how you could do it:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
let tweet = "Having ☕️ in a cafe\u{301} in 🇫🇷 and enjoying the ☀️."
let characterCount = tweet
    .precomposedStringWithCanonicalMapping
    .unicodeScalars.count

/*:
(NFC normalization converts base letters along with combining marks, such as the
e plus accent in `"cafe\u{301}"`, into their precomposed form. The
`precomposedStringWithCanonicalMapping` property is defined in Foundation.)

UTF-8 is the de facto standard for storing text or sending it over the network.
Since the `utf8` view is a collection, you can use it to pass the raw UTF-8
bytes to any other API that accepts a sequence of bytes, such as the
initializers for `Data` or `Array`:

*/

let utf8Bytes = Data(tweet.utf8)
utf8Bytes.count

/*:
Note that the `utf8` collection doesn't include a trailing null byte. If you
need a null-terminated representation, use the `withCString` method or the
`utf8CString` property on `String`. The latter returns an array of bytes:

*/

let nullTerminatedUTF8 = tweet.utf8CString
nullTerminatedUTF8.count

/*:
The `utf16` view has a special significance because Foundation APIs
traditionally treat strings as collections of UTF-16 code units. While the
`NSString` interface is transparently bridged to `Swift.String`, thereby
handling the transformations implicitly for you, other Foundation APIs such as
`NSRegularExpression` or `NSAttributedString` often expect input in terms of
UTF-16 data. We'll see an example of this in the next section.

A second reason for using the code unit views is that operating on code units
rather than fully composed characters can be faster. This is because the Unicode
grapheme breaking algorithm is fairly complex and requires additional lookahead
to identify the start of the next grapheme cluster. Traversing the `String` as a
`Character` collection got much faster between Swift 3.0 and 4.0, however, so be
sure to measure if the (relatively small) speedup is worth your losing Unicode
correctness. As soon as you drop down to one of the code unit views, you must be
certain that your specific algorithm works correctly on that basis. For example,
using the UTF-16 view to parse JSON should be alright because all special
characters the parser is interested in (such as commas, quotes, or braces) are
representable in a single code unit; it doesn't matter that some strings in the
JSON data may contain complex emoji sequences. On the other hand, finding all
occurrences of a word in a string wouldn't work correctly on a code unit view if
you want the search algorithm to find different normalization forms of the
search string. To see just how big the speed difference can be, take a look at
the performance section at the end of this chapter.

### No Random Access

One desirable feature *none* of the views provides is random access. This is a
change from Swift 3, where `String.UTF16View` view did conform to
`RandomAccessCollection` (although only when you imported Foundation). This was
possible for just this view type because `String` uses UTF-16 or ASCII
internally for its in-memory representation. This means the *n*^th^ UTF-16 code
unit would always be at the *n*^th^ position in the buffer (even if the string
was in "ASCII buffer mode" – it's just a question of the width of the entries to
advance over). And although this is still true in Swift 4.0, the internal format
of `String` is supposed to be an implementation detail. The Swift team wants to
keep the door open for adding different backing store types in the future.

The consequence is that `String` and its views are a bad match for algorithms
that require random access. The vast majority of string-processing tasks should
work fine with sequential traversal, especially since an algorithm can always
store substrings for fragments it wants to be able to revisit in constant time.
If you absolutely need random access, you can always convert the UTF-8 or UTF-16
view into an array and work on that, as in `Array(str.utf16)` (again, at the
price of sacrificing Unicode correctness).

### Index Sharing

Strings and their views share the same index type, `String.Index`. This means
you can use an index derived from the string to subscript one of the views. In
the following example, we search the string for `"é"` (which consists of two
scalars, the letter e and the combining accent). The resulting index refers to
the first scalar in the Unicode scalar view:

*/

let pokemon = "Poke\u{301}mon"
if let index = pokemon.index(of: "é") {
    let scalar = pokemon.unicodeScalars[index]
    String(scalar)
}

/*:
This works great as long as you go down the abstraction ladder, from characters
to scalars to UTF-16 or UTF-8 code units. Going the other way can fail because
not every valid index in one of the code unit views is on a `Character`
boundary. In the following example, accessing the string with an index on a
UTF-16 code unit boundary would trap:

*/

let family = "👨‍👩‍👧‍👦"
// This initializer creates an index at a UTF-16 offset
let someUTF16Index = String.Index(encodedOffset: 2)
//family[someUTF16Index] // trap, invalid index

/*:
`String.Index` has a set of methods (`samePosition(in:)`) and failable
initializers (`String.Index.init?(_:within:)`) for converting indices between
views. These return `nil` if the given index has no exact corresponding position
in the specified view. For example, trying to convert the position of the
combining accent in the scalars view to a valid index in the string fails
because the combining character doesn't have its own position in the string:

*/

if let accentIndex = pokemon.unicodeScalars.index(of: "\u{301}") {
    accentIndex.samePosition(in: pokemon)
}

/*:
Note that [there's a bug](https://bugs.swift.org/browse/SR-5992) in Swift 4.0
that sometimes causes these conversions to wrongly succeed when working with
complex emoji sequences, such as the family emoji we use above.
`noCharacterBoundary` isn't a valid position in the string, yet the return value
is non-`nil`:

*/

let noCharacterBoundary = family.utf16.index(family.utf16.startIndex, 
    offsetBy: 3)
// Not a valid index for the character view
noCharacterBoundary.encodedOffset

// Wrong! if let should fail because source index was not on character boundary
if let idx = String.Index(noCharacterBoundary, within: family) {
    // Subscripting returns incomplete Character, this shouldn't happen
    family[idx]
}

/*:
Until this is fixed, a reliable way to find the start of `Character` boundary is
to use the Foundation method `rangeOfComposedCharacterSequence`:

*/

extension String.Index {
    func samePositionOnCharacterBoundary(in str: String) -> String.Index {
        let range = str.rangeOfComposedCharacterSequence(at: self)
        return range.lowerBound
    }
}

let validIndex = 
    noCharacterBoundary.samePositionOnCharacterBoundary(in: family)
// Works
family[validIndex]


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
