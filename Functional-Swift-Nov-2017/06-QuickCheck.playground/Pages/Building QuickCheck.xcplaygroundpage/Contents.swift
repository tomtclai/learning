/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Building QuickCheck

In order to build our Swift implementation of QuickCheck, we'll need to do a
couple of things.

  - First, we need a way to generate random values for different types.

  - Using these random value generators, we need to implement the `check`
    function, which passes random values to its argument property.

  - If a test fails, we'd like to make the test input as small as possible. For
    example, if our test fails on an array with 100 elements, we'll try to make
    it smaller and see if the test still fails.

  - Finally, we'll need to do some extra work to make sure our check function
    works on types that have generics.

### Generating Random Values

*/

// --- (Hidden code block) ---
import Foundation

typealias CGFloat = Double
struct CGSize {
    var width: CGFloat
    var height: CGFloat
}

let numberOfIterations = 10

extension CGFloat: Arbitrary {
    static func arbitrary() -> CGFloat {
        let random: CGFloat = CGFloat(arc4random())
        let maxUint = CGFloat(UInt32.max)
        return 10000 * ((random - maxUint/2) / maxUint)
    }
}

// ---------------------------
/*:
First, let's define a
[protocol](https://developer.apple.com/library/prerelease/ios/documentation/swift/conceptual/swift_programming_language/Protocols.html)
that knows how to generate arbitrary values. This protocol contains only one
function, `arbitrary`, which returns a value of type `Self`, i.e. an instance of
the class or struct that implements the `Arbitrary` protocol:

*/

protocol Arbitrary {
    static func arbitrary() -> Self
}

/*:
So let's write an instance for `Int`. We use the `arc4random` function from the
standard library and convert it into an `Int`. Note that this only generates
positive integers. A real implementation of the library would generate negative
integers as well, but we'll try to keep things simple in this chapter:

*/

extension Int: Arbitrary {
    static func arbitrary() -> Int {
        return Int(arc4random())
    }
}

/*:
Now we can generate random integers, like this:

*/

Int.arbitrary()

/*:
We'll also add a variant that takes a range and constrains the random integer to
the bounds of that range:

*/

extension Int {
    static func arbitrary(in range: CountableRange<Int>) -> Int {
        let diff = range.upperBound - range.lowerBound
        return range.lowerBound + (Int.arbitrary() % diff)
    }
}

/*:
To generate random strings, we need to do a little bit more work. We start off
by generating random Unicode scalars:

*/

extension UnicodeScalar: Arbitrary {
    static func arbitrary() -> UnicodeScalar {
        return UnicodeScalar(Int.arbitrary(in: 65..<90))!
    }
}

/*:
Next we generate a random length between 0 and 40. Then we generate
`randomLength` random scalars and turn them into a string. Note that we
currently only generate capital letters as random characters: the reason we
restrict ourselves is because we want readable output in this book. In a
production library, we should generate both longer strings and strings that
contain arbitrary characters:

*/

extension String: Arbitrary {
    static func arbitrary() -> String {
        let randomLength = Int.arbitrary(in: 0..<40)
        let randomScalars = (0..<randomLength).map { _ in
            UnicodeScalar.arbitrary()
        }
        return String(UnicodeScalarView(randomScalars))
    }
}

/*:
We can call it in the same way that we generate random `Int`s, except that we
call it on the `String` type:

*/

String.arbitrary()

/*:
### Implementing the `check` Function

Now we're ready to implement a first version of our check function. The `check1`
function consists of a simple loop that generates random input for the argument
property in every iteration. If a counterexample is found, it's printed and the
function returns; if no counterexample is found, the `check1` function reports
the number of successful tests that have passed. (Note that we called the
function `check1` because we'll write the final version a bit later.)

*/

func check1<A: Arbitrary>(_ message: String, _ property: (A) -> Bool) -> () {
    for _ in 0..<numberOfIterations {
        let value = A.arbitrary()
        guard property(value) else {
            print("\"\(message)\" doesn't hold: \(value)")
            return
        }
    }
    print("\"\(message)\" passed \(numberOfIterations) tests.")
}


/*:
We could've chosen to use a more functional style by writing this function using
`reduce` or `map` rather than a `for` loop. In this example, however, `for`
loops make perfect sense: we want to iterate an operation a fixed number of
times, stopping execution once a counterexample has been found — and `for` loops
are perfect for that.

Here's how we can use this function to test properties:

*/

extension CGSize {
    var area: CGFloat {
        return width * height
    }
}

extension CGSize: Arbitrary {
    static func arbitrary() -> CGSize {
        return CGSize(width: .arbitrary(), height: .arbitrary())
    }
}

check1("Area should be at least 0") { (size: CGSize) in size.area >= 0 }

/*:
Here we can see a good example of when QuickCheck can be very useful: it finds
an edge case for us. If a size has exactly one negative component, our `area`
function will return a negative number. When used as part of a `CGRect`, a
`CGSize` can have negative values. When writing ordinary unit tests, it's easy
to oversee this case, because sizes usually only have positive components.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
