/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Example: Battleship

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
/*:
We'll introduce first-class functions using a small example: a non-trivial
function that you might need to implement if you were writing a Battleship-like
game. The problem we'll look at boils down to determining whether or not a given
point is in range, without being too close to friendly ships or to us.

As a first approximation, you might write a very simple function that checks
whether or not a point is in range. For the sake of simplicity, we'll assume
that our ship is located at the origin. We can visualize the region we want to
describe in Figure {@fig:battleship1}:

![The points in range of a ship located at the
origin](artwork/battleship-1.png){\#fig:battleship1}

First, we'll define two types, `Distance` and `Position`:

*/

typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
}

/*:
Note that we're using Swift's `typealias` construct, which allows us to
introduce a new name for an existing type. We define `Distance` to be an alias
of `Double`. This will make our API more expressive.

Now we add a method to `Position`, `within(range:)`, which checks that a point
is in the grey area in Figure {@fig:battleship1}. Using some basic geometry, we
can write this method as follows:

*/

extension Position {
    func within(range: Distance) -> Bool {
        return sqrt(x * x + y * y) <= range
    }
}

/*:
This works fine, if you assume that we're always located at the origin. But
suppose the ship may be at a location other than the origin. We can update our
visualization in Figure {@fig:battleship2}:

![Allowing the ship to have its own
position](artwork/battleship-2.png){\#fig:battleship2}

To account for this, we introduce a `Ship` struct that has a `position`
property:

*/

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}

/*:
For now, just ignore the additional property, `unsafeRange`. We'll come back to
this in a bit.

We extend the `Ship` struct with a method, `canEngage(ship:)`, which allows us
to test if another ship is in range, irrespective of whether we're located at
the origin or at any other position:

*/

extension Ship {
    func canEngage(ship target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange
    }
}

/*:
But now you realize that you also want to avoid targeting ships if they're too
close to you. We can update our visualization to illustrate the new situation in
Figure {@fig:battleship-3}, where we want to target only those enemies that are
at least `unsafeRange` away from our current position:

![Avoiding engaging enemies too close to the
ship](artwork/battleship-3.png){\#fig:battleship-3}

As a result, we need to modify our code again, making use of the `unsafeRange`
property:

*/

extension Ship {
    func canSafelyEngage(ship target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange && targetDistance > unsafeRange
    }
}

/*:
Finally, you also need to avoid targeting ships that are too close to one of
your other ships. Once again, we can visualize this in Figure
{@fig:battleship-4}:

![Avoiding engaging targets too close to friendly
ships](artwork/battleship-4.png){\#fig:battleship-4}

Correspondingly, we can add a further argument that represents the location of a
friendly ship to our `canSafelyEngage(ship:)` method:

*/

extension Ship {
    func canSafelyEngage(ship target: Ship, friendly: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        let friendlyDx = friendly.position.x - target.position.x
        let friendlyDy = friendly.position.y - target.position.y
        let friendlyDistance = sqrt(friendlyDx * friendlyDx +
            friendlyDy * friendlyDy)
        return targetDistance <= firingRange
            && targetDistance > unsafeRange
            && (friendlyDistance > unsafeRange)
    }
}

/*:
As this code evolves, it becomes harder and harder to maintain. This method
expresses a complicated calculation in one big lump of code, but we can clean
this code up a bit by adding a helper method and a computed property on
`Position` for the geometric calculations:

*/

extension Position {
    func minus(_ p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    var length: Double {
        return sqrt(x * x + y * y)
    }
}

/*:
Using those helpers, the method becomes the following:

*/

extension Ship {
    func canSafelyEngageShip2(target: Ship, friendly: Ship) -> Bool {
        let targetDistance = target.position.minus(position).length
        let friendlyDistance = friendly.position.minus(target.position).length
        return targetDistance <= firingRange
            && targetDistance > unsafeRange
            && (friendlyDistance > unsafeRange)
    }
}

/*:
This is already much more readable, but we want to go one step further and take
a more declarative route to specifying the problem at hand.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
