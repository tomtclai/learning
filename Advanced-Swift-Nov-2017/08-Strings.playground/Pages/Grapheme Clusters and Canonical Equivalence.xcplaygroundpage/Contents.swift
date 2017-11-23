/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Grapheme Clusters and Canonical Equivalence

### Combining Marks

A quick way to see how `String` handles Unicode data is to look at the two
different ways to write é. Unicode defines U+00E9, *Latin small letter e with
acute,* as a single value. But you can also write it as the plain letter e,
followed by U+0301, *combining acute accent.* In both cases, what's displayed is
é, and a user probably has a reasonable expectation that two strings displayed
as "résumé" would not only be equal to each other but also have a "length" of
six characters, no matter which technique was used to produce the é in either
one. They would be what the Unicode specification describes as *canonically
equivalent.*

And in Swift, this is exactly the behavior you get:

*/

let single = "Pok\u{00E9}mon"
let double = "Poke\u{0301}mon"

/*:
They both display identically:

*/

(single, double)

/*:
And both have the same character count:

*/

single.count
double.count

/*:
Consequently, they also compare equal:

*/

single == double

/*:
Only if you drop down to a view of the underlying representation can you see
that they're different:

*/

single.utf16.count
double.utf16.count

/*:
Contrast this with `NSString` in Foundation: the two strings aren't equal, and
the `length` property — which many programmers probably use to count the number
of characters to be displayed on the screen — gives different results:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
let nssingle = single as NSString
nssingle.length
let nsdouble = double as NSString
nsdouble.length
nssingle == nsdouble

/*:
Here, `==` is defined as the version for comparing two `NSObject`s:

``` swift-example
extension NSObject: Equatable {
    static func ==(lhs: NSObject, rhs: NSObject) -> Bool {
        return lhs.isEqual(rhs)
    }
}
```

In the case of `NSString`, this will do a literal comparison on the level of
UTF-16 code units, rather than one accounting for equivalent but differently
composed characters. Most string APIs in other languages work this way too. If
you really want to perform a canonical comparison, you must use
`NSString.compare(_:)`. Didn't know that? Enjoy your future undiagnosable bugs
and grumpy international user base.

Of course, there's one big benefit to just comparing code units: it's faster\!
This is an effect that can still be achieved with Swift strings, via the `utf16`
view:

*/

single.utf16.elementsEqual(double.utf16)

/*:
Why does Unicode support multiple representations of the same character at all?
The existence of precomposed characters is what enables the opening range of
Unicode code points to be compatible with Latin-1, which already had characters
like é and ñ. While they might be a pain to deal with, it makes conversion
between the two encodings quick and simple.

And ditching precomposed forms wouldn't have helped anyway, because composition
doesn't just stop at pairs; you can compose more than one diacritic together.
For example, Yoruba has the character ọ́, which could be written three different
ways: by composing ó with a dot, or by composing ọ with an acute, or by
composing o with both an acute and a dot. And for that last one, the two
diacritics can be in either order\! So these are all equal:

*/

// --- (Hidden code block) ---
extension Sequence {
    func all(matching predicate: (Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            if try !predicate(element) {
                return false
            }
        }
        return true
    }
}
// ---------------------------
let chars: [Character] = [
    "\u{1ECD}\u{300}",      // ọ́
    "\u{F2}\u{323}",        // ọ́
    "\u{6F}\u{323}\u{300}", // ọ́
    "\u{6F}\u{300}\u{323}"  // ọ́
]
let allEqual = chars.dropFirst().all { $0 == chars.first }

/*:
(The `all(matching:)` method checks if the condition is true for all elements in
a sequence and is defined in the chapter on built-in collections.)

In fact, some diacritics can be added ad infinitum. A famous internet meme
illustrates this nicely:

*/

let zalgo = "s̼̐͗͜o̠̦̤ͯͥ̒ͫ́ͅo̺̪͖̗̽ͩ̃͟ͅn̢͔͖͇͇͉̫̰ͪ͑"

zalgo.count
zalgo.utf16.count

/*:
In the above, `zalgo.count` (correctly) returns 4, while `zalgo.utf16.count`
returns 36. And if your code doesn't work correctly with internet memes, then
what good is it, really?

Unicode's grapheme breaking rules even affect you when all strings you deal with
are pure ASCII: CR+LF, the character pair of carriage return and line feed
that's commonly used as a line break on Windows, is a single grapheme:

*/

// CR+LF is a single Character
let crlf = "\r\n"
crlf.count

/*:
### Emoji

Strings containing emoji can also be surprising in many other languages. Many
emoji are assigned Unicode scalars that don't fit in a single UTF-16 code unit.
Languages that represent strings as collections of UTF-16 code units, such as
Java or C\#, would say that the string `"😂"` is two "characters" long. Swift
handles this case correctly:

*/

let oneEmoji = "😂" // U+1F602
oneEmoji.count

/*:
> Notice that the important thing is how the string is exposed to the program,
> *not* how it's stored in memory. Swift also uses UTF-16 as its internal
> encoding for non-ASCII strings, but that's an implementation detail. The
> public API is based on grapheme clusters.

Other emoji are composed of multiple scalars. An emoji flag is a combination of
two [regional indicator
letters](https://en.wikipedia.org/wiki/Regional_Indicator_Symbol) that
correspond to an ISO country code. Swift treats it correctly as one `Character`:

*/

let flags = "🇧🇷🇳🇿"
flags.count

/*:
To inspect the Unicode scalars a string is composed of, use the `unicodeScalars`
view. Here, we format the scalar values as hex numbers in the common format for
code points:

*/

flags.unicodeScalars.map {
    "U+\(String($0.value, radix: 16, uppercase: true))"
}

/*:
Skin tones combine a base character such as 👧 with one of five skin tone
modifiers (e.g. 🏽, or the type-4 skin tone modifier) to yield the final emoji
(e.g. 👧🏽). Again, Swift handles this correctly:

*/

let skinTone = "👧🏽" // 👧 + 🏽
skinTone.count

/*:
This time, let's use a Foundation API to apply an [ICU string
transform](http://userguide.icu-project.org/transforms/general) that converts
Unicode scalars to their official Unicode names:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
extension StringTransform {
    static let toUnicodeName = StringTransform(rawValue: "Any-Name")
}

extension Unicode.Scalar {
    /// The scalar's Unicode name, e.g. "LATIN CAPITAL LETTER A".
    var unicodeName: String {
        // Force-unwrapping is safe because this transform always succeeds
        let name = String(self).applyingTransform(.toUnicodeName, reverse: false)!

        // The string transform returns the name wrapped in "\\N{...}". Remove those.
        let prefixPattern = "\\N{"
        let suffixPattern = "}"
        let prefixLength = name.hasPrefix(prefixPattern) ? prefixPattern.count : 0
        let suffixLength = name.hasSuffix(suffixPattern) ? suffixPattern.count : 0
        return String(name.dropFirst(prefixLength).dropLast(suffixLength))
    }
}

skinTone.unicodeScalars.map { $0.unicodeName }

/*:
The essential part of this code snippet is the
`applyingTransform(.toUnicodeName, …)` call. The remaining lines clean up the
name returned from the transform method by removing the wrapping braces. We code
this defensively: we first check whether the string matches the expected pattern
and compute the number of characters to strip from the start and end. If the
format returned by the transform method changes in the future, it's better to
return the string unchanged than to remove characters we didn't anticipate.
Notice how we use the standard `Collection` methods `dropFirst` and `dropLast`
to perform the stripping operation. This is a good example of how you can
manipulate a string without doing manual index calculations. It's also efficient
because `dropFirst` and `dropLast` return a `Substring`, which is a slice of the
original string. No new memory allocations are needed until the final step when
we create a new `String` from the substring. We'll have more to say about
substrings later in this chapter.

Emoji depicting families and couples, such as 👨‍👩‍👧‍👦 and 👩‍❤️‍👩, present
another challenge to the Unicode standards body. Due to the countless possible
combinations of genders and the number of people in a group, providing a
separate code point for each variation is problematic. Combine this with a
distinct skin tone for each person and it becomes impossible. Unicode solves
this by specifying that these emoji are actually sequences of multiple emoji,
combined with the invisible *zero-width joiner* (ZWJ) character (U+200D). So the
family 👨‍👩‍👧‍👦 is really *man* 👨 + ZWJ + *woman* 👩 + ZWJ + *girl* 👧 + ZWJ +
*boy* 👦. The ZWJ serves as an indicator to the operating system that it should
use a single glyph if available.

You can verify that this is really what's going on:

*/

let family1 = "👨‍👩‍👧‍👦"
let family2 = "👨\u{200D}👩\u{200D}👧\u{200D}👦"
family1 == family2

/*:
And once again, Swift is smart enough to treat such a sequence as a single
`Character`:

*/

family1.count
family2.count

/*:
New emoji for professions introduced in 2016 are ZWJ sequences too. For example,
the *female firefighter* 👩‍🚒 is composed of *woman* 👩 + ZWJ + *fire engine* 🚒,
and the *male health worker* 👨‍⚕️ is a sequence of *man* 👨 + ZWJ + *staff of
aesculapius* ⚕.

Rendering these sequences into a single glyph is the task of the operating
system. On Apple platforms in 2017, the OS includes glyphs for the subset of
sequences the Unicode standard lists as "[recommended for general
interchange](https://unicode.org/emoji/charts/emoji-zwj-sequences.html)" (RGI),
i.e. the ones "most likely to be widely supported across multiple platforms."
When no glyph is available for a syntactically valid sequence, the text
rendering system falls back to rendering each component as a separate glyph.
Notice that this can cause a mismatch "in the other direction" between
user-perceived characters and what Swift sees as a grapheme cluster; all
examples up until now were concerned with programming languages *overcounting*
characters, but here we see the reverse. As an example, family sequences
containing skin tones are currently not part of the RGI subset. But even if the
operating system renders such a sequence as multiple glyphs, Swift still counts
it as a single `Character` because the Unicode text segmentation rules are not
concerned with rendering:

*/

// Family with skin tones is rendered as multiple glyphs
// on most platforms in 2017
let family3 = "👱🏾\u{200D}👩🏽\u{200D}👧🏿\u{200D}👦🏻"
// But Swift still counts it as a single Character
family3.count

/*:
Microsoft can already render this and other variations as a single glyph, by the
way, and the other OS vendors will almost certainly follow soon. But the point
still stands: no matter how carefully a string API is designed, text is so
complicated that it may never catch all edge cases.

> In the past, Swift had trouble keeping up with Unicode changes. Swift 3
> handled skin tones and ZWJ sequences incorrectly because its grapheme breaking
> algorithm was based on an old version of the Unicode standard. As of Swift 4,
> Swift uses the operating system's [ICU](http://site.icu-project.org) library.
> As a result, your programs will automatically adopt new Unicode rules as users
> update their OSes. The other side of the coin is of course that you can't rely
> on users seeing the same behavior you see during development.

In the examples we discussed in this section, we treated the length of a string
as a proxy for all sorts of things that can go wrong when a language doesn't
take the full complexity of Unicode into account. Just think of the gibberish a
simple task such as reversing a string can produce in a programming language
that doesn't process strings by grapheme clusters when the string contains
composed character sequences. This isn't a new problem, but the emoji explosion
has made it much more likely that bugs caused by sloppy text handling will come
to the surface, even if your user base is predominantly English-speaking. And
the magnitude of errors has increased as well: whereas a decade ago a botched
accented character would cause an off-by-one error, messing up a modern emoji
can easily cause results to be off by 10 or more "characters." For example, a
four-person family emoji is 11 (UTF-16) or 25 (UTF-8) code units long:

*/

family1.count
family1.utf16.count
family1.utf8.count

/*:
It's not that other languages don't have Unicode-correct APIs at all — most do.
For instance, `NSString` has the `enumerateSubstrings` method that can be used
to walk through a string by grapheme clusters. But defaults matter; Swift's
priority is to do the correct thing by default. And if you ever need to drop
down to a lower level of abstraction, `String` provides views that let you
operate directly on Unicode scalars or code units. We'll say more about those
below.

*/


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
