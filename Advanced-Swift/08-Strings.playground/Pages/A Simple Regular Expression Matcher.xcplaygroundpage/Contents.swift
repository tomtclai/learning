/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## A Simple Regular Expression Matcher

To demonstrate some string processing techniques in the contex of a larger
example, we'll implement a simple regular expression matcher based on a similar
matcher written in C in Brian W. Kernighan and Rob Pike's *The Practice of
Programming*. The original code, while beautifully compact, made extensive use
of C pointers, so it often doesn't translate well to other languages. But with
Swift, through use of optionals and slicing, you can almost match the C version
in simplicity.

First, let's define a basic regular expression type:

*/

/// A simple regular expression type, supporting ^ and $ anchors,
/// and matching with . and *
public struct Regex {
    private let regexp: String
    
    /// Construct from a regular expression String
    public init(_ regexp: String) {
        self.regexp = regexp
    }
}

/*:
Since this regular expression's functionality is going to be so simple, it's not
really possible to create an "invalid" regular expression with its initializer.
If the expression support were more complex (for example, supporting
multi-character matching with `[]`), you'd possibly want to give it a failable
initializer.

Next, we extend `Regex` to add a `match` function, which takes a string and
returns true if it matches the expression:

*/

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

/*:
The matching function doesn't do much except iterate over every possible
substring of the input, from the start to the end, checking if it matches the
regular expression from that point on. But if the regular expression starts with
a `^`, then it need only match from the start of the text.

`matchHere` is where most of the regular expression-processing logic lies:

*/

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

/*:
The matcher is very simple to use:

*/

Regex("^h..lo*!$").match("hellooooo!")

/*:
This code makes extensive use of slicing (both with range-based subscripts and
with the `dropFirst` method) and optionals — especially the ability to equate an
optional with a non-optional value. So, for example, `if regexp.first == "^"`
will work, even with an empty string, because `"".first` returns `nil`. However,
you can still equate that to the non-optional `"^"`, and when it's `nil`, it'll
return `false`.

The ugliest part of the code is probably the `while true` loop. The requirement
is that this loops over every possible substring, *including* an empty string at
the end. This is to ensure that expressions like `Regex("$").match("abc")`
return true. If strings worked similarly to arrays, with an integer index, we
could write something like this:

``` swift-example
// ... means up to _and including_ the endIndex
for idx in text.startIndex...text.endIndex {
    // Slice string between idx and the end
    if Regex.matchHere(regexp: _regexp, text: text[idx...]) {
        return true
    }
}
```

The final time around the `for`, `idx` would equal `text.endIndex`, so
`text[idx...]` would be an empty string.

So why doesn't the `for` loop work? We mentioned in the built-in collection
chapter that ranges are neither sequences nor collections by default. So we
can't iterate over a range of string indices because the range isn't a sequence.
And we can't use the character view's `indices` collection either, because it
doesn't include its `endIndex`. As a result, we're stuck with using the C-style
`while` loop.

*/


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
