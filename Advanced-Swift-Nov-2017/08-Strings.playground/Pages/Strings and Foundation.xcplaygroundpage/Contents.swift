/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Strings and Foundation

Swift's `String` type has a very close relationship with its Foundation
counterpart, `NSString`. Any `String` instance can be bridged to `NSString`
using the `as` operator, and Objective-C APIs that take or return an `NSString`
are automatically translated to use `String`. But that's not all. As of
Swift 4.0, `String` still lacks a lot of functionality that `NSString`
possesses. Since strings are such fundamental types and constantly having to
cast to `NSString` would be annoying, `String` receives special treatment from
the compiler: when you import Foundation, `NSString` members become directly
accessible on `String` instances, making Swift strings significantly more
capable than they'd otherwise be.

Having the additional features is undoubtedly a good thing, but it can make
working with strings somewhat confusing. For one thing, if you forget to import
Foundation, you may wonder why some methods aren't available. Foundation's
history as an Objective-C framework also tends to make the `NSString` APIs feel
a little bit out of place next to the standard library, if only because of
different naming conventions. Last but not least, overlap between the feature
sets of the two libraries sometimes means there are two APIs with completely
different names that perform nearly identical tasks. If you're a long-time Cocoa
developer and learned the `NSString` API before Swift came along, this is
probably not a big deal, but it will be puzzling for newcomers.

We've already seen one example — the standard library's `split` method vs.
`components(separatedBy:)` in Foundation — and there are numerous other
mismatches: Foundation uses `ComparisonResult` enums for comparison predicates,
while the standard library is designed around boolean predicates; methods like
`trimmingCharacters(in:)` and `components(separatedBy:)` take a `CharacterSet`
as an argument, which is an unfortuate misnomer in Swift (more on that later);
the extremely powerful `enumerateSubstrings(in:options:_:)` method, which can
iterate over a string in chunks of grapheme clusters, words, sentences, or
paragraphs, deals with strings and ranges where a corresponding standard library
API would use substrings. (The standard library could also expose the same
functionality as a lazy sequence, which would be very cool.)

The following example enumerates the words in a string. The callback closure is
called once for every word found:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
let sentence = """
    The quick brown fox jumped \
    over the lazy dog.
    """
var words: [String] = []
sentence.enumerateSubstrings(in: sentence.startIndex..., options: .byWords)
{ (word, range, _, _) in
    guard let word = word else { return }
    words.append(word)
}
words

/*:
To get an overview of all `NSString` members imported into `String`, check out
the file
[`NSStringAPI.swift`](https://github.com/apple/swift/blob/swift-4.0-branch/stdlib/public/SDK/Foundation/NSStringAPI.swift)
in the Swift source code repository.

### Other String-Related Foundation APIs

Having said all that, native `NSString` APIs are mostly pleasant to use with
Swift strings because most of the bridging work is done for you. Many other
Foundation APIs that deal with strings are a lot trickier to use because Apple
hasn't (yet?) written special Swift overlays for them. Consider
`NSAttributedString`, the Foundation class for representing rich text with
formatting. To use attributed strings successfully from Swift, you have to be
aware of the following:

  - There are two classes, `NSAttributedString` for immutable strings, and
    `NSMutableAttributedString` for mutable ones. They have reference semantics,
    as opposed to the Swift standard for collections to have value semantics.

  - Although all `NSAttributedString` APIs that originally take an `NSString`
    now take a `Swift.String`, the entire API is still based on `NSString`'s
    concept of a collection of UTF-16 code units.

For example, the `attributes(at: Int, effectiveRange: NSRangePointer?)` method
for querying the formatting attributes at a specific location expects an integer
index (measured in UTF-16 units) rather than a `String.Index`, and the
`effectiveRange` returned via pointer is an `NSRange`, not a
`Range<String.Index>`. The same is true for ranges you pass to
`NSMutableAttributedString.addAttribute(_:value:range:)`.

`NSRange` is a structure that contains two integer fields, `location` and
`length`:

``` swift-example
public struct NSRange {
    public var location: Int
    public var length: Int
}
```

In the context of strings, the fields specify a string segment in terms of
UTF-16 code units. Swift 4 makes working with `NSRange` somewhat easier than in
earlier versions because there are now initializers for converting between
`Range<String.Index>` and `NSRange`; this doesn't make the extra code required
to translate back and forth any shorter, however. Here's an example of how you'd
create and modify an attributed string:

*/

// --- (Hidden code block) ---
import Foundation
#if os(macOS)
    import AppKit
#else
    import UIKit
#endif
// ---------------------------
let text = "👉 Click here for more info."
let linkTarget = 
    URL(string: "https://www.youtube.com/watch?v=DLzxrzFCyOs")!

// Object is mutable despite `let` (reference semantics)
let formatted = NSMutableAttributedString(string: text)

// Modify attributes of a part of the text
if let linkRange = formatted.string.range(of: "Click here") {
    // Convert Swift range to NSRange
    // Note that the start of the range is 3 because the preceding emoji
    // character doesn't fit in a single UTF-16 code unit
    let nsRange = NSRange(linkRange, in: formatted.string)
    // Add the attribute
    formatted.addAttribute(.link, value: linkTarget, range: nsRange)
}

/*:
This code adds a link to the `"Click here"` segment of the string.

Querying the attributed string for the formatting attributes at a specific
character position works like this (including the cumbersome process of
allocating a pointer to receive the effective range of the returned attributes
as an out-parameter because Objective-C has no tuple return types):

*/

// Query attributes at start of the word "here"
if let queryRange = formatted.string.range(of: "here"),
    // Get the character index in the UTF-16 view
    let utf16Index = String.Index(queryRange.lowerBound, 
        within: formatted.string.utf16)
{
    // Convert index to UTF-16 integer offset
    let utf16Offset = utf16Index.encodedOffset
    // Prepare NSRangePointer to receive effective attributes range
    var attributesRange = UnsafeMutablePointer<NSRange>.allocate(capacity: 1)
    defer {
        attributesRange.deinitialize(count: 1)
        attributesRange.deallocate(capacity: 1)
    }

    // Execute query
    let attributes = formatted.attributes(at: utf16Offset, 
        effectiveRange: attributesRange)
    attributesRange.pointee

    // Convert NSRange back to Range<String.Index>
    if let effectiveRange = Range(attributesRange.pointee, in: formatted.string) {
        // The substring spanned by the attribute
        formatted.string[effectiveRange]
    }
}

/*:
We think you'll agree that there's still a long way to go before this code
starts to feels like idiomatic Swift.

Aside from `NSAttributedString`, other Foundation classes with very similar
impedance mismatches include `NSRegularExpression` and the wonderful
`NSLinguisticTagger`.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
