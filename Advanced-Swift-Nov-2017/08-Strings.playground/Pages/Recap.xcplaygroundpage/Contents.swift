/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Recap

Strings in Swift are very different than their counterparts in almost all other
mainstream programming languages. When you're used to strings effectively being
arrays of code units, it'll take a while to switch your mindset to Swift's
approach of prioritizing Unicode correctness over simplicity.

Ultimately, we think Swift makes the right choice. Unicode text is much more
complicated than what those other languages pretend it is. In the long run, the
time savings from avoided bugs you'd otherwise have written will probably
outweigh the time it takes to unlearn integer indexing.

We're so used to random "character" access that we may not realize how rarely
this feature is really needed in string processing code. We hope the examples in
this chapter convince you that simple in-order traversal is perfectly fine for
most common operations. Forcing you to be explicit about which representation of
a string you want to work on — grapheme clusters, Unicode scalars, UTF-16 or
UTF-8 code units — is another safety measure; readers of your code will be
grateful for it.

When Chris Lattner outlined [the goals for Swift's string
implementation](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20160725/025676.html)
in July 2016, he ended with this:

> Our goal is to be better at string processing than Perl\!

Swift 4 isn't quite there yet — too many desirable features are missing,
including moving more string APIs from Foundation into the standard library,
native language support for regular expressions, string formatting and parsing
APIs, and more powerful string interpolation. The good news it that the Swift
team has expressed interest in [tackling all these topics in the
future](https://github.com/apple/swift/blob/master/docs/StringManifesto.md).

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
