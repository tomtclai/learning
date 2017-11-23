/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Unicode, Or: No More Fixed Width

Things used to be so simple. ASCII strings were a sequence of integers between 0
and 127. If you stored them in an 8-bit byte, you even had a bit to spare\!
Since every character was of a fixed size, ASCII strings could be random access.

But ASCII wasn't enough if you were writing in anything other than English or
for a non-U.S. audience; other countries and languages needed other characters
(even English-speaking Britain needed a £ sign). Most of them needed more
characters than would fit into seven bits. ISO 8859 takes the extra bit and
defines 16 different encodings above the ASCII range, such as Part 1
(ISO 8859-1, aka Latin-1), covering several Western European languages; and
Part 5, covering languages that use the Cyrillic alphabet.

This is still limiting, though. If you want to use ISO 8859 to write in Turkish
about Ancient Greek, you're out of luck, since you'd need to pick either Part 7
(Latin/Greek) or Part 9 (Turkish). And eight bits is still not enough to encode
many languages. For example, Part 6 (Latin/Arabic) doesn't include the
characters needed to write Arabic-script languages such as Urdu or Persian.
Meanwhile, Vietnamese — which is based on the Latin alphabet but with a large
number of diacritic combinations — only fits into eight bits by replacing a
handful of ASCII characters from the lower half. And this isn't even an option
for other East Asian languages.

When you run out of room with a fixed-width encoding, you have a choice: either
increase the size, or switch to variable-width encoding. Initially, Unicode was
defined as a 2-byte fixed-width format, now called UCS-2. This was before
reality set in, and it was accepted that even two bytes would not be sufficient,
while four would be horribly inefficient for most purposes.

So today, Unicode is a variable-width format, and it's variable in two different
senses: in the combining of code units into Unicode scalars, and in the
combining of scalars into characters.

Unicode data can be encoded with many different widths of *code unit,* most
commonly 8 (UTF-8) or 16 (UTF-16) bits. UTF-8 has the added benefit of being
backwardly compatible with 8-bit ASCII — something that's helped it overtake
ASCII as the most popular encoding on the web. Swift represents UTF-16 and UTF-8
code units as `UInt16` and `UInt8` values, respectively (aliased as
`Unicode.UTF16.CodeUnit` and `Unicode.UTF8.CodeUnit`).

A *code point* in Unicode is a single value in the Unicode code space with a
possible value from `0` to `0x10FFFF` (in decimal: 1,114,111). Only
about 137,000 of the 1.1 million available code points are currently in use, so
there's a lot of room for more emoji. A given code point might take a single
code unit if you're using UTF-32, or it might take between one and four if
you're using UTF-8. The first 256 Unicode code points match the characters found
in Latin-1.

Unicode *scalars* are almost, but not quite, the same as code points. They're
all the code points *except* the 2,048 *surrogate code points* in the range
`0xD800–0xDFFF`, i.e. the code points used for the leading and trailing codes
that indicate pairs in UTF-16 encoding. Scalars are represented in Swift string
literals as `"\u{xxxx}"`, where xxxx represents hex digits. So the euro sign can
be written in Swift as either `"€"` or `"\u{20AC}"`. The corresponding Swift
type is `Unicode.Scalar`, which is a wrapper around a `UInt32` value.

To represent each Unicode scalar by a single code unit, you'd need a 21-bit
encoding scheme (which usually gets rounded up to 32-bit, i.e. UTF-32), but even
that wouldn't get you a fixed-width encoding: Unicode is still a variable-width
format when it comes to "characters." What a user might consider "a single
character" — as displayed on the screen — might require multiple scalars
composed together. The Unicode term for such a user-perceived character is
*(extended) grapheme cluster.*

The rules for how scalars form grapheme clusters determine how text is
segmented. For example, if you hit the backspace key on your keyboard, you
expect your text editor to delete exactly one grapheme cluster, even if that
"character" is composed of multiple Unicode scalars, each of which may use a
varying number of code units in the text's representation in memory. Grapheme
clusters are represented in Swift by the `Character` type, which can encode an
arbitrary number of scalars, as long as they form a single user-perceived
character. We'll see some examples of this in the next section.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
