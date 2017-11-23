/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Ranges 

A range is an interval of values, defined by its lower and upper bounds. You
create ranges with the two range operators: `..<` for half-open ranges that
don't include their upper bound, and `...` for closed ranges that include both
bounds:

*/

// 0 to 9, 10 is not included
let singleDigitNumbers = 0..<10
Array(singleDigitNumbers)
// "z" is included
let lowercaseLetters = Character("a")...Character("z")

/*:
There are also prefix and postfix variants of these operators, used to express
one-sided ranges:

*/

let fromZero = 0...
let upToZ = ..<Character("z")

/*:
There are eight distinct concrete types that represent ranges, and each type
captures different constraints on the value. The two most essential types are
`Range` (a half-open range, created using `..<`) and `ClosedRange` (created
using `...`). Both have a generic `Bound` parameter: the only requirement is
that `Bound` must be `Comparable`. For example, the `lowercaseLetters`
expression above is of type `ClosedRange<Character>`. Somewhat surprisingly, we
can't iterate over `Range` and `ClosedRange`, but we can check whether elements
are contained within the range:

*/

singleDigitNumbers.contains(9)
lowercaseLetters.overlaps("c"..<"f")

/*:
(The answer why iterating over characters isn't as straightforward as it would
seem has to do with Unicode, and we'll cover it at length in the chapter on
strings.)

Half-open and closed ranges both have a place:

  - Only a **half-open range** can represent an **empty interval** (when the
    lower and upper bounds are equal, as in `5..<5`).

  - Only a **closed range** can contain the **maximum value** its element type
    can represent (e.g. `0...Int.max`). A half-open range always requires at
    least one representable value that's greater than the highest value in the
    range.

### Countable Ranges

Ranges seem like a natural fit to be sequences or collections, so it may
surprise you that `Range` and `ClosedRange` are neither. Some ranges *are*
sequences, however, otherwise iterating over a range of integers in a `for` loop
wouldn't work:

*/

for i in 0..<10 {
    print("\(i)", terminator: " ")
}

/*:
What's going on here? If you inspect the type of the expression `0..<10`, you'll
discover it's `CountableRange<Int>`. A `CountableRange` is just like a `Range`,
with the additional constraint that its element type conforms to `Strideable`
(with integer steps). Swift calls these more capable ranges *countable* because
only they can be iterated over. Valid bounds for countable ranges include
integer and pointer types — but not floating-point types, because of the integer
constraint on the type's `Stride`. If you need to iterate over consecutive
floating-point values, you can use the `stride(from:to:by)` and
`stride(from:through:by)` functions to create such a sequence. The `Strideable`
constraint enables `CountableRange` and `CountableClosedRange` to conform to
`RandomAccessCollection`, so we can iterate over them.

The four basic range types we've discussed thus far can be classified in a
two-by-two matrix, as follows:

``` table
|                            | Half-open range  | Closed range           |
|:---------------------------|:-----------------|:-----------------------|
| Elements are `Comparable`  | `Range`          | `ClosedRange`          |
| Elements are `Strideable`  | `CountableRange` | `CountableClosedRange` |
| (with integer steps)       |                  |                        |
```

The columns of the matrix correspond to the two range operators we saw above,
which create a `[Countable]Range` (half-open) or a `[Countable]ClosedRange`
(closed), respectively.

The rows in the table distinguish between "normal" ranges with an element type
that only conforms to the `Comparable` protocol (which is the minimum
requirement), and ranges over types that are `Strideable` *and* use integer
steps between elements. Only the latter ranges are collections, inheriting all
the powerful functionality we'll see in the next chapter.

### Partial Ranges

Partial ranges are constructed by using `...` or `..<` as a prefix or a postfix
operator. For example, `0...` means the range starting at zero. These ranges are
called partial because they're still missing one of their bounds. There are four
different kinds:

*/

let fromA: PartialRangeFrom<Character> = Character("a")...
let throughZ: PartialRangeThrough<Character> = ...Character("z")
let upto10: PartialRangeUpTo<Int> = ..<10
let fromFive: CountablePartialRangeFrom<Int> = 5...

/*:
There's only one countable variant: `CountablePartialRangeFrom`. It's the only
partial range we can iterate over. Iteration works by starting with the
`lowerBound` and repeatedly calling `advanced(by: 1)`. If you use such a range
in a `for` loop, you must take care to add a break condition lest you end up in
an infinite loop (or crash when the counter overflows). `PartialRangeFrom` can't
be iterated over because its `Bound` is not `Strideable`, and both
`PartialRangeThrough` and `PartialRangeUpTo` are missing a lower bound.

### Range Expressions

All eight range types conform to the `RangeExpression` protocol. The protocol
itself is small enough to print in this book. First of all, it allows you to ask
whether an element is contained within the range. Second, given a collection, it
can compute a fully specified `Range` for you:

*/

public protocol RangeExpression {
    associatedtype Bound: Comparable
    func contains(_ element: Bound) -> Bool
    func relative<C: _Indexable>(to collection: C) -> Range<Bound> 
        where C.Index == Bound
}

/*:
For partial ranges with a missing lower bound, the `relative(to:)` method adds
the collection's `startIndex` as the lower bound. For partial ranges with a
missing upper bound, it'll use the collection's `endIndex`. Partial ranges
enable a very compact syntax for slicing collections:

*/

let arr = [1,2,3,4]
arr[2...]
arr[..<1]
arr[1...2]

/*:
This works because the corresponding subscript declaration in the `Collection`
protocol takes a `RangeExpression` rather than one of the eight concrete range
types. You can even omit both bounds to get a slice of the entire collection:

*/

arr[...]
type(of: arr)

/*:
(This is implemented as [a special
case](https://tonisuter.com/blog/2017/08/unbounded-ranges-swift-4/) in the
standard library in Swift 4.0. Such an *unbounded range* isn't a valid
`RangeExpression` yet, but it should become one eventually.)

### Ranges and Conditional Conformance

The standard library currently has to have separate types for countable ranges:
`CountableRange`, `CountableClosedRange`, and `CountablePartialRangeFrom`.
Ideally, these wouldn't be distinct types, but rather extensions on `Range`,
`ClosedRange`, and `PartialRangeFrom` that declare `Collection` conformance on
the condition that the generic parameters meet the required constraints. We'll
talk a lot more about this in the next chapter, but the code might look like
this:

``` swift-example
// Invalid in Swift 4
extension Range: RandomAccessCollection
    where Bound: Strideable, Bound.Stride: SignedInteger
{
    // Implement RandomAccessCollection
}
```

Alas, Swift 4's type system can't express this idea, so separate types are
needed. Support for conditional conformance is expected for Swift 5, and
`CountableRange`, `CountableClosedRange`, and `CountablePartialRangeFrom` will
then be deprecated or removed from the standard library.

The distinction between the half-open `Range` and the closed `ClosedRange` will
likely remain, and it can sometimes make working with ranges harder than it
should intuitively be. Say you have a function that takes a `Range<Character>`
and you want to pass it the closed character range we created above. You may be
surprised to find out it's not possible\! Inexplicably, there appears to be no
way to convert a `ClosedRange` into a `Range`. But why? Well, to turn a closed
range into an equivalent half-open range, you'd have to find the element that
comes after the original range's upper bound. And that's simply not possible
unless the element is `Strideable`, which is only guaranteed for countable
ranges.

This means the caller of such a function will have to provide the correct type.
If the function expects a `Range`, you can't use the `...` operator to create
it. We're not certain how big of a limitation this is in practice, since most
ranges are likely integer based, but it's definitely unintuitive.

If possible, try copying the standard library's approach and make your own
functions take a `RangeExpression` rather than a concrete type. It's not always
possible because the protocol doesn't give you access to the range's bounds
unless you're in the context of a collection, but if it is, you'll give
consumers of your APIs much more freedom to pass in any kind of range expression
they like.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
