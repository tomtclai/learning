/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## `ExpressibleByStringLiteral`

Throughout this chapter, we've been using `String("blah")` and `"blah"` pretty
much interchangeably, but they're different. `""` is a string literal, just like
the array literals covered in the collection protocols chapter. You can make
your types initializable from a string literal by conforming to
`ExpressibleByStringLiteral`.

String literals are slightly more complicated than array literals because
they're part of a hierarchy of three protocols: `ExpressibleByStringLiteral`,
`ExpressibleByExtendedGraphemeClusterLiteral`, and
`ExpressibleByUnicodeScalarLiteral`. Each defines an `init` for creating a type
from each kind of literal, but unless you really need fine-grained logic based
on whether or not the value is being created from a single scalar/cluster, you
only need to implement the string version; the others are covered by default
implementations that refer to the string literal initializer:

*/

// --- (Hidden code block) ---
/// A simple regular expression type, supporting ^ and $ anchors,
/// and matching with . and *
public struct Regex {
    private let regexp: String
    
    /// Construct from a regular expression String
    public init(_ regexp: String) {
        self.regexp = regexp
    }
}

extension Regex {
    /// Returns true if the string argument matches the expression.
    public func match(_ text: String) -> Bool {

        // If the regex starts with ^, then it can only match the
        // start of the input
        if regexp.first == "^" {
            return Regex.matchHere(regexp: regexp.dropFirst(),
                text: text[...])
        }

        // Otherwise, search for a match at every point in the input
        // until one is found
        var idx = text.startIndex
        while true {
            if Regex.matchHere(regexp: regexp[...],
                text: text.suffix(from: idx))
            {
                return true
            }
            guard idx != text.endIndex else { break }
            text.formIndex(after: &idx)
        }

        return false
    }
}

extension Regex {
    /// Match a regular expression string at the beginning of text.
    private static func matchHere(
        regexp: Substring, text: Substring) -> Bool
    {
        // Empty regexprs match everything
        if regexp.isEmpty {
            return true
        }

        // Any character followed by * requires a call to matchStar
        if let c = regexp.first, regexp.dropFirst().first == "*" {
            return matchStar(character: c, regexp: regexp.dropFirst(2), text: text)
        }

        // If this is the last regex character and it's $, then it's a match iff the
        // remaining text is also empty
        if regexp.first == "$" && regexp.dropFirst().isEmpty {
            return text.isEmpty
        }

        // If one character matches, drop one from the input and the regex
        // and keep matching
        if let tc = text.first, let rc = regexp.first, rc == "." || tc == rc {
            return matchHere(regexp: regexp.dropFirst(), text: text.dropFirst())
        }

        // If none of the above, no match
        return false
    }

    /// Search for zero or more `c`'s at beginning of text, followed by the
    /// remainder of the regular expression.
    private static func matchStar
        (character c: Character, regexp: Substring, text: Substring) -> Bool
    {
        var idx = text.startIndex
        while true {   // a * matches zero or more instances
            if matchHere(regexp: regexp, text: text.suffix(from: idx)) {
                return true
            }
            if idx == text.endIndex || (text[idx] != c && c != ".") {
                return false
            }
            text.formIndex(after: &idx)
        }
    }
}
// ---------------------------
extension Regex: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        regexp = value
    }
}

/*:
Once defined, you can begin using string literals to create the regex matcher by
explicitly naming the type:

*/

let r: Regex = "^h..lo*!$"

/*:
Or even better is when the type is already named for you, because the compiler
can then infer it:

*/

func findMatches(in strings: [String], regex: Regex) -> [String] {
    return strings.filter { regex.match($0) }
}
findMatches(in: ["foo","bar","baz"], regex: "^b..")

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
