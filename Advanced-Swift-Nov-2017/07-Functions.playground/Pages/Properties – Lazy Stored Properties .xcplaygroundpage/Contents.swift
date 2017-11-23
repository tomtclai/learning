/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Lazy Stored Properties 

Initializing a value lazily is such a common pattern that Swift has a special
keyword, `lazy`, for defining lazy properties. Note that a lazy property must
always be declared as `var` because its initial value might not be set until
after initialization completes. Swift has a strict rule that `let` constants
must have a value *before* an instance's initialization completes. The lazy
modifier is a very specific form of
[memoization](https://en.wikipedia.org/wiki/Memoization).

For example, if we have a view controller that displays a `GPSTrack`, we might
want to have a preview image of the track. By making the property for that lazy,
we can defer the expensive generation of the image until the property is
accessed for the first time:

*/

// --- (Hidden code block) ---
import UIKit
// ---------------------------
class GPSTrackViewController: UIViewController {
    var track: GPSTrack = GPSTrack()

    lazy var preview: UIImage = {
        for point in track.record {
            // Do some expensive computation
        }
        return UIImage(/* ... */)
    }()
}

/*:
Notice how we defined the lazy property: it's a closure expression that returns
the value we want to store — in our case, an image. When the property is first
accessed, the closure is executed (note the parentheses at the end), and its
return value is stored in the property. This is a common pattern for lazy
properties that require more than a one-liner to be initialized.

Because a lazy variable needs storage, we're required to define the lazy
property in the definition of `GPSTrackViewController`. Unlike computed
properties, stored properties and stored lazy properties can't be defined in an
extension.

If the `track` property changes, the `preview` won't automatically get
invalidated. Let's look at an even simpler example to see what's going on. We
have a `Point` struct, and we store `distanceFromOrigin` as a lazy computed
property:

*/

struct Point {
    var x: Double
    var y: Double
    private(set) lazy var distanceFromOrigin: Double
        = (x*x + y*y).squareRoot()

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

/*:
When we create a point, we can access the `distanceFromOrigin` property, and
it'll compute the value and store it for reuse. However, if we then change the
`x` value, this won't be reflected in `distanceFromOrigin`:

*/

var point = Point(x: 3, y: 4)
point.distanceFromOrigin
point.x += 10
point.distanceFromOrigin

/*:
It's important to be aware of this. One way around it would be to recompute
`distanceFromOrigin` in the `didSet` property observers of `x` and `y`, but then
`distanceFromOrigin` isn't really lazy anymore: it'll get computed each time `x`
or `y` changes. Of course, in this example, the solution is easy: we should have
made `distanceFromOrigin` a regular (non-lazy) computed property from the
beginning.

Accessing a lazy property is a mutating operation because the property's initial
value is set on the first access. When a struct contains a lazy property, any
owner of the struct that accesses the lazy property must therefore declare the
struct as a variable too, because accessing the property means potentially
mutating its container. So this isn't allowed:

``` swift-example
let immutablePoint = Point(x: 3, y: 4)
immutablePoint.distanceFromOrigin
// Error: Cannot use mutating getter on immutable value
```

Forcing all users of the `Point` type who want to access the lazy property to
use `var` is a huge inconvenience, which often makes lazy properties a bad fit
for structs.

Also be aware that the `lazy` keyword doesn't perform any thread
synchronization. If multiple threads access a lazy property at the same time
before the value has been computed, it's possible the computation could be
performed more than once, including any side effects the computation may have.

Early in Swift's open-source era, the Swift team proposed a general mechanism
for annotating properties with
"[behaviors](https://github.com/apple/swift-evolution/blob/master/proposals/0030-property-behavior-decls.md)."
If implemented, current primitive language features like property observers and
lazy properties could be moved from the compiler into the standard library,
making the compiler less complex and allowing all developers to add their own
behaviors. The proposal was widely welcomed by the community but ultimately
deferred due to time constraints. Something like property behaviors could still
come in a future version of Swift.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
