/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Introducing Enumerations

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
/*:
When creating a string, it's important to know its character encoding. In
Objective-C, an `NSString` object can have several possible encodings:

``` objc
NS_ENUM(NSStringEncoding) {
    NSASCIIStringEncoding = 1,
    NSNEXTSTEPStringEncoding = 2,
    NSJapaneseEUCStringEncoding = 3,
    NSUTF8StringEncoding = 4,
    // ...
};
```

Each of these encodings is represented by a number; the `NS_ENUM` allows
programmers to assign meaningful names to the integer constants associated with
particular character encodings.

There are some drawbacks to the enumeration declarations in Objective-C and
other C dialects. Most notably, the type `NSStringEncoding` isn't precise enough
— there are integer values, such as 16, that don't correspond to a valid
encoding. Furthermore, because all enumerated types are represented by integers,
it's possible to compute with them *as if they are numbers*, which is also a
disadvantage:

*/


/*:
    NSAssert(NSASCIIStringEncoding + NSNEXTSTEPStringEncoding
             == NSJapaneseEUCStringEncoding, @"Adds up...");

Who would've thought that `NSASCIIStringEncoding + NSNEXTSTEPStringEncoding` is
equal to `NSJapaneseEUCStringEncoding`? Such expressions are clearly nonsense,
yet they're happily accepted by the Objective-C compiler.

Throughout the previous chapters, we've used Swift's *type system* to catch such
errors. Simply identifying enumerated types with integers is at odds with one of
the core tenets of functional programming in Swift: using types effectively to
rule out invalid programs.

Swift also has an `enum` construct, but it behaves very differently from the one
you may be familiar with from Objective-C. We can declare our own enumerated
type for string encodings as follows:

*/

enum Encoding {
    case ascii
    case nextstep
    case japaneseEUC
    case utf8
}

/*:
We've chosen to restrict ourselves to the first four possibilities defined in
the `NSStringEncoding` enumeration listed above. There are many common encodings
we haven't incorporated in this definition; this Swift enumeration declaration
is for the purpose of illustration only. The `Encoding` type is inhabited by
four possible values: `ascii`, `nextstep`, `japaneseEUC`, and `utf8`. We'll
refer to the possible values of an enumeration as *cases*. In a great deal of
literature, such enumerations are sometimes called *sum types*. Throughout this
book, however, we'll use Apple's terminology.

In contrast to Objective-C, the following code is *not* accepted by the
compiler:

``` swift-example
let myEncoding = Encoding.ascii + Encoding.utf8
```

Unlike Objective-C, enumerations in Swift create new types, distinct from
integers or other existing types.

We can define functions that calculate with encodings using `switch` statements.
For example, we may want to compute the `NSStringEncoding` (imported in Swift as
`String.Encoding`) corresponding to our encoding enumeration:

*/

extension Encoding {
    var nsStringEncoding: String.Encoding {
        switch self {
            case .ascii: return String.Encoding.ascii
            case .nextstep: return String.Encoding.nextstep
            case .japaneseEUC: return String.Encoding.japaneseEUC
            case .utf8: return String.Encoding.utf8
        }
    }
}

/*:
This `nsStringEncoding` property maps each of the `Encoding` cases to the
appropriate `NSStringEncoding` value. Note that we have one branch for each of
our four different encoding schemes. If we leave any of these branches out, the
Swift compiler warns us that the computed property's switch statement isn't
exhaustive.

Of course, we can also define a function that works in the opposite direction,
creating an `Encoding` from an `NSStringEncoding`. We'll implement this as an
initializer on the `Encoding` enum:

*/

extension Encoding {
    init?(encoding: String.Encoding) {
        switch encoding {
            case String.Encoding.ascii: self = .ascii
            case String.Encoding.nextstep: self = .nextstep
            case String.Encoding.japaneseEUC: self = .japaneseEUC
            case String.Encoding.utf8: self = .utf8
            default: return nil
        }
    }
}

/*:
As we haven't modeled all possible `NSStringEncoding` values in our little
`Encoding` enumeration, the [initializer is
failable](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html#//apple_ref/doc/uid/TP40014097-CH18-ID224).
If none of the first four cases succeed, the `default` branch is selected, which
returns `nil`.

Of course, we don't need to use switch statements to work with our `Encoding`
enumeration. For example, if we want the localized name of an encoding, we can
compute it as follows:

*/

extension Encoding {
    var localizedName: String {
        return String.localizedName(of: nsStringEncoding)
    }
}

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
