/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## String Performance 

There's no denying that coalescing multiple variable-length UTF-16 values into
extended grapheme clusters is going to be more expensive than just ripping
through a buffer of 16-bit values. But what's the cost? One way to test
performance would be to adapt the regular expression matcher above to work
against all of the different string views.

However, this presents a problem. Ideally, you'd write a generic regex matcher
with a placeholder for the view. But this doesn't work — `String` and its views
don't all implement a common "string view" protocol. Also, in our regex matcher,
we need to represent specific character constants like `*` and `^` to compare
against the regex. In the `UTF16View`, these would need to be `UInt16`, but with
the string itself, they'd need to be `Character`. Finally, we want the regex
matcher initializer itself to still take a `String`. How would it know which
method to call to get the appropriate view out?

One technique is to bundle up all the variable logic into a single type and then
parameterize the regex matcher on that type. First, we define a protocol that
has all the necessary information:

*/

protocol StringViewSelector {
    associatedtype View: Collection
    
    static var caret: View.Element { get }
    static var asterisk: View.Element { get }
    static var period: View.Element { get }
    static var dollar: View.Element { get }
    
    static func view(from s: String) -> View
}

/*:
This information includes an associated type for the view we're going to use,
getters for the four constants needed, and a function to extract the relevant
view from a string.

Given this, you can implement concrete versions like so:

*/

struct UTF8ViewSelector: StringViewSelector {
    static var caret: UInt8 { return UInt8(ascii: "^") }
    static var asterisk: UInt8 { return UInt8(ascii: "*") }
    static var period: UInt8 { return UInt8(ascii: ".") }
    static var dollar: UInt8 { return UInt8(ascii: "$") }
    
    static func view(from s: String) -> String.UTF8View { return s.utf8 }
}

struct CharacterViewSelector: StringViewSelector {
    static var caret: Character { return "^" }
    static var asterisk: Character { return "*" }
    static var period: Character { return "." }
    static var dollar: Character { return "$" }
    
    static func view(from s: String) -> String { return s }
}

/*:
You can probably guess what `UTF16ViewSelector` and `UnicodeScalarViewSelector`
look like.

*/

// --- (Hidden code block) ---
struct UTF16ViewSelector: StringViewSelector {
    static var caret: UInt16 { return "^".utf16.first! }
    static var asterisk: UInt16 { return "*".utf16.first! }
    static var period: UInt16 { return ".".utf16.first! }
    static var dollar: UInt16 { return "$".utf16.first! }
    
    static func view(from s: String) -> String.UTF16View { return s.utf16 }
}

struct UnicodeScalarViewSelector: StringViewSelector {
    static var caret: Unicode.Scalar { return Unicode.Scalar("^") }
    static var asterisk: Unicode.Scalar { return Unicode.Scalar("*") }
    static var period: Unicode.Scalar { return Unicode.Scalar(".") }
    static var dollar: Unicode.Scalar { return Unicode.Scalar("$") }
    
    static func view(from s: String) -> String.UnicodeScalarView { return s.unicodeScalars }
}
// ---------------------------
/*:
These are what some people call "phantom types" — types that only exist at
compile time and don't actually hold any data. Try calling
`MemoryLayout<CharacterViewSelector>.size` — it'll return zero because it
contains no data. All we're using these types for is to parameterize behavior of
another type: the regex matcher. It'll use them like so:

``` swift-example
struct Regex<V: StringViewSelector>
    where V.View.Element: Equatable,
    V.View.SubSequence: Collection
{
    let regexp: String
    /// Construct from a regular expression String.
    init(_ regexp: String) {
        self.regexp = regexp
    }
}

extension Regex {
    /// Returns true if the string argument matches the expression.
    func match(_ text: String) -> Bool {
        let text = V.view(from: text)
        let regexp = V.view(from: self.regexp)

        // If the regex starts with ^, then it can only match the start
        // of the input.
        if regexp.first == V.caret {
            return Regex.matchHere(regexp: regexp.dropFirst(), text: text[...])
        }

        // Otherwise, search for a match at every point in the input until
        // one is found.
        var idx = text.startIndex
        while true {
            if Regex.matchHere(regexp: regexp[...], text: text.suffix(from: idx)) {
                return true
            }
            guard idx != text.endIndex else { break }
            text.formIndex(after: &idx)
        }
        return false
    }

    /// Match a regular expression string at the beginning of text.
    private static func matchHere(
        regexp: V.View.SubSequence, text: V.View.SubSequence) -> Bool
    {
        // ...
    }
    // ...
}
```

Once the code is rewritten like this, we can write some benchmarking code that
measures the time taken to process some arbitrary regular expression across a
very large input:

``` swift-example
func benchmark<V: StringViewSelector>(_: V.Type, pattern: String, text: String)
    -> TimeInterval
    where V.View.Element: Equatable, V.View.SubSequence: Collection
{
    let r = Regex<V>(pattern)
    let lines = text.split(separator: "\n").map(String.init)
    var count = 0

    let startTime = CFAbsoluteTimeGetCurrent()
    for line in lines {
        if r.match(line) { count = count &+ 1 }
    }
    let totalTime = CFAbsoluteTimeGetCurrent() - startTime
    return totalTime
}

let timeCharacter = benchmark(CharacterViewSelector.self,
    pattern: pattern, text: input)
let timeUnicodeScalar = benchmark(UnicodeScalarViewSelector.self,
    pattern: pattern, text: input)
let timeUTF16 = benchmark(UTF8ViewSelector.self,
    pattern: pattern, text: input)
let timeUTF8 = benchmark(UTF16ViewSelector.self,
    let pattern: pattern, text: input)
```

The results show the following speeds for the different views in processing the
regex on a large corpus of English (128,000 lines, 6.5 million characters) and
Chinese (43,000 lines, 1.5 million characters) text:

``` table
View              ASCII text    Chinese text
----------------  ------------  -------------
Characters        1.4 seconds   3.5 seconds
Unicode.Scalars   1.6 seconds   1.1 seconds
UTF-16            0.7 seconds   0.5 seconds
UTF-8             1.1 seconds   n/a
```

(Benchmarking the UTF-8 view for Chinese text doesn't make sense because it can
deliver incorrect results.)

As you can see, the UTF-16 view is consistently the fastest in this test. But
how much faster it is depends on the input. It's also worth noting that
processing of `Character`s [got](https://github.com/apple/swift/pull/6850)
[much](https://github.com/apple/swift/pull/9252)
[faster](https://github.com/apple/swift/pull/9252) in Swift 4.0. When we ran the
ASCII benchmark with Swift 3.0 for the previous edition of this book, the
character view was more than 10 times slower than any of the other three. The
penalty for Unicode correctness is no longer as big in Swift 4.0.

Only you can know if your use case justifies choosing your view type based on
performance. It's almost certainly the case that these performance
characteristics only matter when you're doing extremely heavy string
manipulation, but if you're certain that what you're doing would be correct when
operating on UTF-16, Unicode scalar, or UTF-8 data, this can still give you a
decent speedup.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
