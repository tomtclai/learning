/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### `CharacterSet` 

Let's look at one last interesting Foundation type, and that's `CharacterSet`.
We already mentioned in the built-in collections chapter that this struct should
really be called `UnicodeScalarSet` because that's what it is: an efficient data
structure for representing sets of Unicode scalars. It is not at all compatible
with the `Character` type.

We can illustrate this by creating a set from a couple of complex emoji. It
seems as though the set only contains the two emoji we put in, but testing for
membership with a third emoji is successful because the firefighter emoji is
really a sequence of *woman* + ZWJ + *fire engine*:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
let favoriteEmoji = CharacterSet("👩‍🚒👨‍🎤".unicodeScalars)
// Wrong! Or is it?
favoriteEmoji.contains("🚒")

/*:
`CharacterSet` provides a number of factory initializers like `.alphanumerics`
or `.whitespacesAndNewlines`. Most of these correspond to official [Unicode
character categories](https://unicode.org/reports/tr44/#General_Category_Values)
(each code point is assigned a category, such as "Letter" or "Nonspacing Mark").
The categories cover all scripts, and not just ASCII or Latin-1, so the number
of members in these predefined sets is often huge. The type conforms to
`SetAlgebra`, which defines the interface for set operations such as membership
testing and constructing unions or intersections. `CharacterSet` does *not*
conform to `Sequence` or `Collection`, so we can't easily count or iterate over
all members in a set.

The following example implements an alternative way of splitting a string into
words using a `CharacterSet` via the `UnicodeScalarView`:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
extension String {
    func words(with charset: CharacterSet = .alphanumerics) -> [Substring] {
        return self.unicodeScalars.split {
            !charset.contains($0)
        }.map(Substring.init)
    }
}

let code = "struct Array<Element>: Collection { }"
code.words()

/*:
This will break the string apart at every non-alphanumeric character, giving us
an array of `UnicodeScalarView` slices. We then turn them back into substrings
via `map`, passing the substring initializer. The good news is, even after going
through this fairly extensive pipeline, the string slices in `words` will still
just be views onto the original string, so this should be more efficient than
the `components(separatedBy:)` method (which returns an array of strings, and
thus copies).

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
