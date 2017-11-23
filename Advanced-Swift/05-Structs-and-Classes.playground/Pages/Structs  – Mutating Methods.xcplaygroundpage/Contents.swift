/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Mutating Methods

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
var screen = Rectangle(width: 320, height: 480) {
    didSet {
        print("Screen changed: \(screen)")
    }
}
// ---------------------------
/*:
Assume we want to add a `translate` method to `Rectangle`, which moves the
rectangle by a given offset. We'll need to add the offset to the rectangle's
current origin, so let's start by adding an overload for the `+` operator that
adds two `Point`s together and returns a new `Point`:

*/

func +(lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
screen.origin + Point(x: 10, y: 10)

/*:
We now have everything we need to implement `translate`, yet our first attempt
doesn't work:

``` swift-example
extension Rectangle {
    func translate(by offset: Point) {
        // Error: Cannot assign to property: 'self' is immutable
        origin = origin + offset
    }
}
```

The compiler complains that we can't assign to the `origin` property because
`self` is immutable (writing `origin =` is shorthand for `self.origin =`). We
can think of `self` as an extra, implicit parameter that gets passed to each
method. You never have to pass the parameter, but it's always there inside the
method body, and it's immutable so that value semantics can be guaranteed. If we
want to mutate `self`, or any property of `self`, or even nested properties
(e.g. `self.origin.x`), we need to mark the method as `mutating`:

*/

extension Rectangle {
    mutating func translate(by offset: Point) {
        origin = origin + offset
    }
}
screen.translate(by: Point(x: 10, y: 10))
screen

/*:
The compiler enforces the `mutating` keyword. Unless we use it, we're not
allowed to mutate any part of `self` inside the method. By marking the method as
`mutating`, we change the behavior of `self` inside that method. Instead of it
being a `let`, it now works like a `var`: we can freely change any of its
mutable properties. (To be precise, it's not even a `var`, but we'll get to that
in a little bit).

The `mutating` keyword also determines which methods can be called on variables
declared with `let`. Anything that's marked as `mutating` may only be called on
instances declared with `var`:

``` swift-example
let otherScreen = screen
// Error: Cannot use mutating member on immutable value
otherScreen.translate(by: Point(x: 10, y: 10))
```

Thinking back to the built-in collections chapter, we can now see how the
difference between `let` and `var` applies to collections as well. The `append`
method on arrays is defined as `mutating`, and therefore, we're not allowed to
call it on an array declared with `let`.

Property setters are implicitly `mutating`; that's why you can't call a setter
on a `let` variable:

``` swift-example
let point = Point.zero
// Error: Cannot assign to property: 'point' is a 'let' constant
point.x = 10 
```

> `mutating` is also how `willSet` and `didSet` "know" when to fire: any
> invocation of a `mutating` method or an implicitly mutating setter will
> trigger the observers.

In many cases, it makes sense to have both a mutable and an immutable variant of
the same method. For example, arrays have both a `sort()` method (which is
`mutating` and sorts in place) and a `sorted()` method (which returns a new
array). We can also add a non-`mutating` variant of our `translate(by:_)`
method. Instead of mutating `self`, we create a copy, mutate that, and return a
new `Rectangle`:

*/

extension Rectangle {
    func translated(by offset: Point) -> Rectangle {
        var copy = self
        copy.translate(by: offset)
        return copy
    }
}
screen.translated(by: Point(x: 20, y: 20))

/*:
> The names `sort` and `sorted` aren't chosen at random — they conform to the
> Swift [API Design
> Guidelines](https://swift.org/documentation/api-design-guidelines/). Methods
> that have a side effect should read as an imperative verb phrase, such as
> `sort`. Non-mutating variants of those methods should have an -ed or -ing
> suffix. We applied the same guidelines to `translate` and `translated`.

As we saw earlier, it's easy to introduce bugs when working with mutable
objects. Swift structs with mutable properties and `mutating` methods don't have
this problem. The mutation of the struct is a local side effect, and it only
applies to the variable being modified. Because every struct variable is unique
(or in other words: every struct value has exactly one owner), it's almost
impossible to introduce bugs this way — that is, unless you're accessing a
global or captured struct variable from multiple threads (closures capture by
reference by default).

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
