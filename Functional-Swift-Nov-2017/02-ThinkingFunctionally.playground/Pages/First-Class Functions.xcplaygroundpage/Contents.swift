/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## First-Class Functions

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
/*:
In the current incarnation of the `canSafelyEngage(ship:friendly)` method, its
behavior is encoded in the combination of boolean conditions the return value is
comprised of. While it's not too hard to figure out what this method does in
this simple case, we want to have a solution that's more modular.

We already introduced helper methods on `Position` to clean up the code for the
geometric calculations. In a similar fashion, we'll now add functions to test
whether a region contains a point in a more declarative manner.

The original problem boiled down to defining a function that determined when a
point was in range or not. The type of such a function would be something like
this:

    func pointInRange(point: Position) -> Bool {
        // Implement method here
    }

The type of this function is going to be so important that we're going to give
it a separate name:

*/

// --- (Hidden code block) ---
typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
}

extension Position {
    func minus(_ p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    var length: Double {
        return sqrt(x * x + y * y)
    }
}
// ---------------------------
typealias Region = (Position) -> Bool

/*:
From now on, the `Region` type will refer to functions transforming a `Position`
to a `Bool`. This isn't strictly necessary, but it can make some of the type
signatures that we'll see below a bit easier to digest.

Instead of defining an object or struct to represent regions, we represent a
region by a *function* that determines if a given point is in the region or not.
If you're not used to functional programming, this may seem strange, but
remember: functions in Swift are first-class values\! We consciously chose the
name `Region` for this type, rather than something like `CheckInRegion` or
`RegionBlock`. These names suggest that they denote a function type, yet the key
philosophy underlying *functional programming* is that functions are values, no
different from structs, integers, or booleans — using a separate naming
convention for functions would violate this philosophy.

We'll now write several functions that create, manipulate, and combine regions.

The first region we define is a `circle`, centered around the origin:

*/

func circle(radius: Distance) -> Region {
    return { point in point.length <= radius }
}

/*:
Note that, given a radius `r`, the call `circle(radius: r)` *returns a
function*. Here we use Swift's [notation for
closures](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Closures.html)
to construct the function we wish to return. Given an argument position,
`point`, we check that the `point` is in the region delimited by a circle of the
given radius centered around the origin.

Of course, not all circles are centered around the origin. We could add more
arguments to the `circle` function to account for this. To compute a circle
that's centered around a certain position, we just add another argument
representing the circle's center and make sure to account for this value when
computing the new region:

*/

func circle2(radius: Distance, center: Position) -> Region {
    return { point in point.minus(center).length <= radius }
}

/*:
However, if we we want to make the same change to more primitives (for example,
imagine we not only had circles, but also rectangles or other shapes), we might
need to duplicate this code. A more functional approach is to write a *region
transformer* instead. This function shifts a region by a certain offset:

*/

func shift(_ region: @escaping Region, by offset: Position) -> Region {
    return { point in region(point.minus(offset)) }
}

/*:
> Whenever a function parameter (for example, `region`) is used after the
> function returns, it needs to be marked as `@escaping`. The compiler tells us
> when we forget to add this. For more information, see the section on
> ["Escaping
> Closures"](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Closures.html#//apple_ref/doc/uid/TP40014097-CH11-ID546)
> in Apple's book, *The Swift Programming Language*.

The call `shift(region, by: offset)` moves the region to the right and up by
`offset.x` and `offset.y`, respectively. We need to return a `Region`, which is
a function from a point to a boolean value. To do this, we start writing another
closure, introducing the point we need to check. From this point, we compute a
new point by subtracting the offset. Finally, we check that this new point is in
the *original* region by passing it as an argument to the `region` function.

This is one of the core concepts of functional programming: rather than creating
increasingly complicated functions such as `circle2`, we've written a function,
`shift(_:by:)`, that modifies another function. For example, a circle that's
centered at `(5, 5)` and has a radius of `10` can now be expressed like this:

*/

let shifted = shift(circle(radius: 10), by: Position(x: 5, y: 5))

/*:
There are lots of other ways to transform existing regions. For instance, we may
want to define a new region by inverting a region. The resulting region consists
of all the points outside the original region:

*/

func invert(_ region: @escaping Region) -> Region {
    return { point in !region(point) }
}

/*:
We can also write functions that combine existing regions into larger, complex
regions. For instance, these two functions take the points that are in *both*
argument regions or *either* argument region, respectively:

*/

func intersect(_ region: @escaping Region, with other: @escaping Region)
    -> Region {
    return { point in region(point) && other(point) }
}

func union(_ region: @escaping Region, with other: @escaping Region)
    -> Region {
    return { point in region(point) || other(point) }
}

/*:
Of course, we can use these functions to define even richer regions. The
`difference` function takes two regions as argument — the original region and
the region to be subtracted — and constructs a new region function for all
points that are in the first, but not in the second, region:

*/

func subtract(_ region: @escaping Region, from original: @escaping Region)
    -> Region {
    return intersect(original, with: invert(region))
}

/*:
This example shows how Swift lets you compute and pass around functions no
differently than you would integers or booleans. This enables us to write small
primitives (such as `circle`) and to build a series of functions on top of these
primitives. Each of these functions modifies or combines regions into new
regions. Instead of writing complex functions to solve a very specific problem,
we can now use many small functions that can be assembled to solve a wide
variety of problems.

Now let's turn our attention back to our original example. With this small
library in place, we can refactor the complicated
`canSafelyEngage(ship:friendly:)` method as follows:

*/

// --- (Hidden code block) ---
struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}
// ---------------------------
extension Ship {
    func canSafelyEngageShip(target: Ship, friendly: Ship) -> Bool {
        let rangeRegion = subtract(circle(radius: unsafeRange),
            from: circle(radius: firingRange))
        let firingRegion = shift(rangeRegion, by: position)
        let friendlyRegion = shift(circle(radius: unsafeRange),
            by: friendly.position)
        let resultRegion = subtract(friendlyRegion, from: firingRegion)
        return resultRegion(target.position)
    }
}

/*:
This code defines two regions: `firingRegion` and `friendlyRegion`. The region
that we're interested in is computed by taking the difference between these
regions. By applying this region to the target ship's position, we can compute
the desired boolean.

Compared to the original `canSafelyEngage(ship:friendly:)` method, the
refactored method provides a more *declarative* solution to the same problem by
using the `Region` functions. We argue that the latter version is easier to
understand because the solution is *compositional*. You can study each of its
constituent regions, such as `firingRegion` and `friendlyRegion`, and see how
these are assembled to solve the original problem. The original, monolithic
method, on the other hand, mixes the description of the constituent regions and
the calculations needed to describe them. Separating these concerns by defining
the helper functions we presented previously increases the compositionality and
legibility of complex regions.

Having first-class functions is essential for this to work. Objective-C also
supports first-class functions, or *blocks*. It can, unfortunately, be quite
cumbersome to work with blocks. Part of this is a syntax issue: both the
declaration of a block and the type of a block aren't as straightforward as
their Swift counterparts. In later chapters, we'll also see how generics make
first-class functions even more powerful, going beyond what is easy to achieve
with blocks in Objective-C.

The way we've defined the `Region` type does have its disadvantages. Here we've
chosen to define the `Region` type as a simple type alias for `(Position) ->
Bool` functions. Instead, we could've chosen to define a struct containing a
single function:

``` highlight-swift
struct Region {
    let lookup: Position -> Bool
}
```

Instead of the free functions operating on our original `Region` type, we could
then define similar methods as extensions to this struct. And instead of
assembling complex regions by passing them to functions, we could then
repeatedly transform a region by calling these methods:

``` highlight-swift
rangeRegion.shift(ownPosition).difference(friendlyRegion)
```

The latter approach has the advantage of requiring fewer parentheses.
Furthermore, Xcode's autocompletion can be invaluable when assembling complex
regions in this fashion. For the sake of presentation, however, we've chosen to
use a simple `typealias` to highlight how higher-order functions can be used in
Swift.

Furthermore, it's worth pointing out that we can't inspect *how* a region was
constructed: is it composed of smaller regions? Or is it simply a circle around
the origin? The only thing we can do is to check whether a given point is within
a region or not. If we want to visualize a region, we'd have to sample enough
points to generate a (black and white) bitmap.

In a later chapter, we'll sketch an alternative design that will allow you to
answer these questions.

> The naming we've used in this chapter, and throughout this book, goes slightly
> against the [Swift API design
> guidelines](https://swift.org/documentation/api-design-guidelines/). Swift's
> guidelines are designed with method names in mind. For example, if `intersect`
> were defined as a method, it would need to be called `intersecting` or
> `intersected`, because it returns a new value rather than mutating the
> existing region. However, we decided to use basic forms like `intersect` when
> writing top-level functions.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
