/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Structs 

Value types imply that whenever a variable is assigned to another variable, the
value itself — and not just a reference to the value — is copied. For example,
in almost all programming languages, scalar types are value types. This means
that whenever a value is assigned to a new variable, it's copied rather than
passed by reference:

*/

var a = 42
var b = a
b += 1
b
a

/*:
After the above code executes, the value of `b` will be 43, but `a` will still
be 42. This is so natural that it seems like stating the obvious. However, in
Swift, all structs behave this way — not just scalar types.

Let's start with a simple struct that describes a `Point`. This is similar to
`CGPoint`, except that it contains `Int`s, whereas `CGPoint` contains
`CGFloat`s:

*/

struct Point {
    var x: Int
    var y: Int
}

// --- (Hidden code block) ---
extension Point: CustomStringConvertible {
    var description: String {
        return "(x: \(x), y: \(y))"
    }
}
// ---------------------------
/*:
For structs, Swift automatically adds a memberwise initializer. This means we
can now initialize a new variable:

*/

let origin = Point(x: 0, y: 0)

/*:
Because structs in Swift have value semantics, we can't change any of the
properties of a struct variable that's defined using `let`. For example, the
following code won't work:

``` swift-example
origin.x = 10 // Error
```

Even though we defined `x` within the struct as a `var` property, we can't
change it, because `origin` is declared using `let`. This has some major
advantages. For example, if you read a line like `let point = ...`, and you know
that `point` is a struct variable with value semantics, then you also know that
it'll never, ever, change. This is incredibly helpful when reading through code.

To create a mutable variable, we need to use `var`:

*/

var otherPoint = Point(x: 0, y: 0)
otherPoint.x += 10
otherPoint

/*:
Unlike with objects, every struct variable is unique. For example, we can create
a new variable, `thirdPoint`, and assign the value of `origin` to it. Now we can
change `thirdPoint`, but `origin` (which we defined as an immutable variable
using `let`) won't change:

*/

var thirdPoint = origin
thirdPoint.x += 10
thirdPoint
origin

/*:
When you assign a struct to a new variable, Swift automatically makes a copy.
Even though this sounds very expensive, many of the copies can be optimized away
by the compiler, and Swift tries hard to make the copies very cheap. In fact,
many structs in the standard library are implemented using a technique called
copy-on-write, which we'll look at later.

Structs can also contain other structs. For example, if we define a `Size`
struct, we can create a `Rectangle` struct, which is composed out of a point and
a size:

*/

struct Size {
    var width: Int
    var height: Int
}

struct Rectangle {
    var origin: Point
    var size: Size
}

// --- (Hidden code block) ---
extension Rectangle: CustomStringConvertible {
    var description: String {
        return "\((origin.x, origin.y, size.width, size.height))"
    }
}
// ---------------------------
/*:
Just like before, we get a memberwise initializer for `Rectangle`. Here, we
first define a *type property* on `Point`, i.e. a property that exists on the
type rather than on instances of the type. The type property `Point.zero`
effectively acts like a factory initializer for a commonly used specific `Point`
instance. We then use that value to initialize a `Rectangle`:

*/

extension Point {
    static let zero = Point(x: 0, y: 0)
}

let rect = Rectangle(origin: Point.zero, 
    size: Size(width: 320, height: 480))

/*:
If we want a custom initializer for our struct, we can add it directly inside
the struct definition. However, if the struct definition contains a custom
initializer, Swift doesn't generate a memberwise initializer. By defining our
custom initializer in an extension, we also get to keep the memberwise
initializer:

*/

extension Rectangle {
    init(x: Int = 0, y: Int = 0, width: Int, height: Int) {
        origin = Point(x: x, y: y)
        size = Size(width: width, height: height)
    }
}

/*:
Instead of setting `origin` and `size` directly, we could've also called
`self.init(origin:size:)`.

### Mutation Semantics

If we define a mutable variable `screen`, we can add a `didSet` block that gets
executed whenever `screen` is changed. This `didSet` works for every definition
of a struct, be it in a playground, as a member of a class or other struct, or
as a global variable:

*/

var screen = Rectangle(width: 320, height: 480) {
    didSet {
        print("Screen changed: \(screen)")
    }
}

/*:
Maybe somewhat surprisingly, even if we change something deep inside the struct,
the `didSet` handler will get triggered:

*/

screen.origin.x = 10

/*:
Understanding why this works is key to understanding value types. Mutating a
struct variable is semantically the same as assigning a new value to it. And
even if only one property of a larger struct gets mutated, it's the equivalent
of replacing the entire struct with a new value. A mutation deep inside a tree
of nested structs trickles all the way up the tree to the outermost instance,
triggering any `willSet` and `didSet` handlers it encounters along the way.

Although, semantically, the entire struct is replaced with a new one, this is
usually no less efficient; the compiler can still mutate the value in place.
Since the struct has no other owner, it doesn't actually need to make a copy.
With copy-on-write structs (which we'll discuss later), this works differently.

Since the collection types in the standard library are structs, they naturally
behave the same way. Appending an item to an array will trigger the array's
`didSet` handler, as will mutating one of the array's elements directly through
a subscript:

*/

var screens: [Rectangle] = [] {
    didSet {
        print("Screens array changed: \(screens)")
    }
}
screens.append(Rectangle(width: 320, height: 480))
screens[0].origin.x += 100

/*:
The `didSet` trigger wouldn't fire if `Rectangle` were a class, because in that
case, the reference the array stores doesn't change — only the object it's
referring to does.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
