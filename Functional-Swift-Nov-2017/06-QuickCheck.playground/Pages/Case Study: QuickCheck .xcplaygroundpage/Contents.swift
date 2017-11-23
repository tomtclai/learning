/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
# Case Study: QuickCheck 

*/

// --- (Hidden code block) ---
import Foundation

let numberOfIterations = 10
// ---------------------------
/*:
In recent years, testing has become much more prevalent in Objective-C. Many
popular libraries are now tested automatically with continuous integration
tools. The standard framework for writing unit tests is
[XCTest](https://developer.apple.com/library/ios/documentation/ToolsLanguages/Conceptual/Xcode_Overview/UnitTestYourApp.html).
Additionally, a lot of third-party frameworks (such as Specta, Kiwi, and
FBSnapshotTestCase) are already available, and a number of new frameworks are
currently being developed in Swift.

All of these frameworks follow a similar pattern: tests typically consist of
some fragment of code, together with an expected result. The code is then
executed, and its result is compared to the expected result defined in the test.
Different libraries test at different levels — some test individual methods,
some test classes, and some perform integration testing (running the entire
app). In this chapter, we'll build a small library for property-based testing of
Swift functions. We'll build this library in an iterative fashion, improving it
step by step.

When writing unit tests, the input data is static and defined by the programmer.
For example, when unit testing an addition method, we might write a test that
verifies that `1 + 1` is equal to `2`. If the implementation of addition changes
in such a way that this property is broken, the test will fail. More generally,
however, we could choose to test that the addition is commutative — in other
words, that `a + b` is equal to `b + a`. To test this, we could write a test
case that verifies that `42 + 7` is equal to `7 + 42`.

QuickCheck \[@claessen-quickcheck\] is a Haskell library for random testing.
Instead of writing individual unit tests, each of which tests that a function is
correct for some particular input, QuickCheck allows you to describe abstract
*properties* of your functions and *generate* tests to verify these properties.
When a property passes, it doesn't necessarily prove that the property is
correct. Rather, QuickCheck aims to find boundary conditions that invalidate the
property. In this chapter, we'll build a (partial) Swift port of QuickCheck.

This is best illustrated with an example. Suppose we want to verify that
addition is a commutative operation. To do so, we start by writing a function
that checks whether `x + y` is equal to `y + x` for the two integers `x` and
`y`:

*/

// --- (Hidden code block) ---
protocol Smaller {
    func smaller() -> Self?
}

protocol Arbitrary: Smaller {
    static func arbitrary() -> Self
}

extension Int: Smaller {
    func smaller() -> Int? {
        return self == 0 ? nil : self / 2
    }
}

extension Int: Arbitrary {
    static func arbitrary() -> Int {
        return Int(arc4random())
    }
}

func iterate<A>(while condition: (A) -> Bool, initial: A, next: (A) -> A?) -> A {
    guard let x = next(initial), condition(x) else {
        return initial
    }
    return iterate(while: condition, initial: x, next: next)
}

func check<X: Arbitrary>(_ message: String, property: (X) -> Bool) -> () {
    let instance = ArbitraryInstance(arbitrary: X.arbitrary,
        smaller: { $0.smaller() })
    checkHelper(instance, property, message)
}

func checkHelper<A>(_ arbitraryInstance: ArbitraryInstance<A>,
    _ property: (A) -> Bool, _ message: String) -> ()
{
    for _ in 0..<numberOfIterations {
        let value = arbitraryInstance.arbitrary()
        guard property(value) else {
            let smallerValue = iterate(while: { !property($0) },
                initial: value, next: arbitraryInstance.smaller)
            print("\"\(message)\" doesn't hold: \(smallerValue)")
            return
        }
    }
    print("\"\(message)\" passed \(numberOfIterations) tests.")
}

struct ArbitraryInstance<T> {
    let arbitrary: () -> T
    let smaller: (T) -> T?
}

func check<X: Arbitrary, Y: Arbitrary>(_ message: String, _ property: (X, Y) -> Bool) -> () {
    let arbitraryTuple = { (X.arbitrary(), Y.arbitrary()) }
    let smaller: (X, Y) -> (X, Y)? = { (x, y) in
        guard let newX = x.smaller(), let newY = y.smaller() else { return nil }
        return (newX, newY)
    }
    let instance = ArbitraryInstance(arbitrary: arbitraryTuple, smaller: smaller)
    checkHelper(instance, property, message)
}
// ---------------------------
func plusIsCommutative(x: Int, y: Int) -> Bool {
    return x + y == y + x
}

/*:
Checking this statement with QuickCheck is as simple as calling the `check`
function:

*/

check("Plus should be commutative", plusIsCommutative)

/*:
The `check` function works by calling the `plusIsCommutative` function with two
random integers, over and over again. If the statement isn't true, it'll print
out the input that caused the test to fail. The key insight here is that we can
describe abstract *properties* of our code (like commutativity) using
*functions* that return a `Bool` (like `plusIsCommutative`). The `check`
function now uses this property to *generate* unit tests, giving much better
code coverage than you could achieve using handwritten unit tests.

Of course, not all tests pass. For example, we can define a statement that
describes that subtraction is commutative:

*/

func minusIsCommutative(x: Int, y: Int) -> Bool {
    return x - y == y - x
}

/*:
Now, if we run QuickCheck on this function, we'll get a failing test case:

*/

check("Minus should be commutative", minusIsCommutative)

/*:
Using Swift's syntax for [trailing
closures](https://developer.apple.com/library/prerelease/ios/documentation/swift/conceptual/swift_programming_language/Closures.html),
we can also write tests directly, without defining the property (such as
`plusIsCommutative` or `minusIsCommutative`) separately:

*/

check("Additive identity") { (x: Int) in x + 0 == x }

/*:
Of course, there are many other similar properties of standard arithmetic that
we can test. We'll cover more interesting tests and properties shortly. Before
we do so, however, we'll provide some more details about how QuickCheck is
implemented.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
