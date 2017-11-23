/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Strings and Collections

As we've seen, `String` is a collection of `Character` values. In Swift's first
three years of existence, `String` went back and forth between conforming and
not conforming to the `Collection` protocol. The argument for *not* adding the
conformance was that programmers would expect all generic collection-processing
algorithms to be completely safe and Unicode-correct, which wouldn't necessarily
be true for all edge cases.

As a simple example, you might assume that if you concatenate two collections,
the resulting collection's length would be the sum of the lengths of the two
source collections. But this doesn't hold for strings if a suffix of the first
string forms a grapheme cluster with a prefix of the second string:

*/

let flagLetterJ = "🇯"
let flagLetterP = "🇵"
let flag = flagLetterJ + flagLetterP
flag.count
flag.count == flagLetterJ.count + flagLetterP.count

/*:
To this end, `String` itself was not made a `Collection` in Swift 2 and 3; a
collection-of-characters view was moved to a property, `characters`, which put
it on a footing similar to the other collection views: `unicodeScalars`, `utf8`,
and `utf16`. Picking a specific view prompted you to acknowledge you were moving
into a "collection-processing" mode and that you should consider the
consequences of the algorithm you were about to run.

In practice, the loss in usability and learnability caused by this change turned
out to vastly outweigh the gain in correctness for a few edge cases that are
rarely relevant in real code (unless you're writing a text editor). So `String`
was made a `Collection` again in Swift 4. The `characters` view still exists,
but only for backward compatibility.

### Bidirectional, Not Random Access

However, for reasons that should be clear from the examples in the previous
section, `String` is *not* a random-access collection. How could it be, when
knowing where the *n*^th^ character of a particular string is involves
evaluating just how many Unicode scalars precede that character? For this
reason, `String` conforms only to `BidirectionalCollection`. You can start at
either end of the string, moving forward or backward, and the code will look at
the composition of the adjacent characters and skip over the correct number of
bytes. However, you need to iterate up and down one character at a time.

Keep the performance implications of this in mind when writing string-processing
code. Algorithms that depend on random access to maintain their performance
guarantees aren't a good match for Unicode strings. Consider this `String`
extension for generating a list of a string's prefixes, which works by
generating an integer range from zero to the string's length and then mapping
over the range to create the prefix for each length:

*/

extension String {
    var allPrefixes1: [Substring] {
        return (0...self.count).map(self.prefix)
    }
}

let hello = "Hello"
hello.allPrefixes1

/*:
As simple as this code looks, it's very inefficient. It first walks over the
string once to calculate the length, which is fine. But then each of the n + 1
calls to `prefix` is another `O(n)` operation because `prefix` always starts at
the beginning and has to work its way through the string to count the desired
number of characters. Running a linear process inside another linear loop means
this algorithm is accidentally `O(n^2)` — as the length of the string increases,
the time this algorithm takes increases quadratically.

If possible, an efficient string algorithm should walk over a string only once
and then operate on string indices to denote the substrings it's interested in.
Here's another version of the same algorithm:

*/

extension String {
    var allPrefixes2: [Substring] {
        return [""] + self.indices.map { index in self[...index] }
    }
}

hello.allPrefixes2

/*:
This code also has to iterate over the string once to generate the `indices`
collection. But once that's done, the subscripting operation inside `map` is
`O(1)`. This makes the whole algorithm `O(n)`.

> The `PrefixIterator` we implemented in the collection protocols chapter solves
> the same problem in a generic way for all sequences.

### Range-Replaceable, Not Mutable

`String` also conforms to `RangeReplaceableCollection`. Here's an example of how
you'd replace part of a string by first identifying the appropriate range in
terms of string indices and then calling `replaceSubrange`. The replacement
string can have a different length or could even be empty (which would be
equivalent to calling `removeSubrange`):

*/

var greeting = "Hello, world!"
if let comma = greeting.index(of: ",") {
    greeting[..<comma]
    greeting.replaceSubrange(comma..., with: " again.")
}
greeting

/*:
As always, keep in mind that results may be surprising if parts of the
replacement string form new grapheme clusters with adjacent characters in the
original string.

One collection-like feature strings do *not* provide is that of
`MutableCollection`. This protocol adds one feature to a collection — that of
the single-element subscript `set` — in addition to `get`. This isn't to say
strings aren't mutable — as we've just seen, they have several mutation methods.
But what you can't do is replace a single character using the subscript
operator. The reason comes back to variable-length characters. Most people can
probably intuit that a single-element subscript update would happen in constant
time, as it does for `Array`. But since a character in a string may be of
variable width, updating a single character could take linear time in proportion
to the length of the string: changing the width of a single element would
require shuffling all the later elements up or down in memory. Moreover, indices
that come after the replaced index would become invalid through the shuffling,
which is equally unintuitive. For these reasons, you have to use
`replaceSubrange`, even if the range you pass in is only a single element.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
