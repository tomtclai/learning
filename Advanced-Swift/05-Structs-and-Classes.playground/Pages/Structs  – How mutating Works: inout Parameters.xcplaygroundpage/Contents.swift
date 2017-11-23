/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### How `mutating` Works: `inout` Parameters

*/

// --- (Hidden code block) ---
struct Point {
    var x: Int
    var y: Int
}
extension Point: CustomStringConvertible {
    var description: String {
        return "(x: \(x), y: \(y))"
    }
}
extension Point {
    static let zero = Point(x: 0, y: 0)
}
func +(lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
struct Size {
    var width: Int
    var height: Int
}
struct Rectangle {
    var origin: Point
    var size: Size
}
extension Rectangle {
    init(x: Int = 0, y: Int = 0, width: Int, height: Int) {
        origin = Point(x: x, y: y)
        size = Size(width: width, height: height)
    }
}
extension Rectangle: CustomStringConvertible {
    var description: String {
        return "\((origin.x, origin.y, size.width, size.height))"
    }
}
extension Rectangle {
    mutating func translate(by offset: Point) {
        origin = origin + offset
    }
}
extension Rectangle {
    func translated(by offset: Point) -> Rectangle {
        var copy = self
        copy.translate(by: offset)
        return copy
    }
}
var screen = Rectangle(width: 320, height: 480) {
    didSet {
        print("Screen changed: \(screen)")
    }
}
// ---------------------------
/*:
To understand how the `mutating` keyword works, we need to take a look at the
`inout` keyword. Before we do that, let's define a free function that moves a
rectangle by 10 points on both axes. We can't simply call `translate` directly
on the `rectangle` parameter, because all function parameters are immutable by
default and get passed in as copies. Instead, we need to use `translated(by:)`
and return the translated rectangle as a new value. Callers that want to use the
function to mutate an existing value have to reassign the result manually:

*/

func translatedByTenTen(rectangle: Rectangle) -> Rectangle {
    return rectangle.translated(by: Point(x: 10, y: 10))
}
screen = translatedByTenTen(rectangle: screen)
screen

/*:
How could we write a function (not a method) that changes a `Rectangle` in
place? We've seen that the `mutating` keyword does exactly that for methods: it
makes the implicit `self` parameter mutable.

Free functions can achieve the same effect by marking one or more parameters as
`inout`. Just like with a regular parameter, a copy of the value gets passed in
to the function. However, inside the function body the argument becomes mutable
— it's as if it were defined as a `var`. And once the function returns, Swift
copies the (possibly mutated) value from the function back to the caller,
overwriting the original value.

Using `inout`, we can write a translate function that mutates the rectangle that
gets passed in. Notice that we're now allowed to use `translate(by:)` in the
function body because `rectangle` is mutable:

*/

func translateByTwentyTwenty(rectangle: inout Rectangle) {
    rectangle.translate(by: Point(x: 20, y: 20))
}
translateByTwentyTwenty(rectangle: &screen)
screen

/*:
The `translateByTwentyTwenty` function takes the `screen` rectangle, changes it
locally, and copies the new value back (overriding the previous value of
`screen`). This behavior is exactly the same as that of a `mutating` method. In
fact, `mutating` methods are just like regular methods on the struct, except the
implicit `self` parameter is marked as `inout`.

Accordingly, we can't call `translateByTwentyTwenty` on a rectangle that's
defined using `let`. We can only use it with mutable values:

``` swift-example
let immutableScreen = screen
// Error: Cannot pass immutable value as inout argument
translateByTwentyTwenty(rectangle: &immutableScreen)
```

We'll go into more detail about `inout` in the functions chapter. For now, it
suffices to say that `inout` is in lots of places. For example, it's now easy to
understand how mutating a value through a subscript works:

*/

// --- (Hidden code block) ---
func +=(lhs: inout Point, rhs: Point) {
    lhs = lhs + rhs
}
// ---------------------------
var array = [Point(x: 0, y: 0), Point(x: 10, y: 10)]
array[0] += Point(x: 100, y: 100)
array

/*:
The expression `array[0]` is automatically passed in as an `inout` variable. In
the functions chapter, we'll see why we can use some expressions (like
`array[0]`) as `inout` parameters and not others.

Operators that mutate their left-hand side, such as `+=`, also require that
parameter to be `inout`. Here's an implementation of `+=` for `Point`. The
compiler wouldn't allow the assignment to `lhs` if we omitted the `inout`:

``` swift-example
func +=(lhs: inout Point, rhs: Point) {
    lhs = lhs + rhs
}
```

*/

var myPoint = Point.zero
myPoint += Point(x: 10, y: 10)
myPoint

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
