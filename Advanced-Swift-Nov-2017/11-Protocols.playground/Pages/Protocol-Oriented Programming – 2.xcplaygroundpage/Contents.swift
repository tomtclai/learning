/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
To make `addCircle` dynamically dispatched, we add it as a protocol requirement:

*/

// --- (Hidden code block) ---
#if os(macOS)
import Cocoa
typealias UIColor = NSColor
#else
import UIKit
#endif
// ---------------------------
protocol Drawing {
    mutating func addEllipse(rect: CGRect, fill: UIColor)
    mutating func addRectangle(rect: CGRect, fill: UIColor)
    mutating func addCircle(center: CGPoint, radius: CGFloat, fill: UIColor)
}

/*:
We can still provide a default implementation, just like before. And also like
before, types are free to override `addCircle`. Because it's now part of the
protocol definition, it'll be dynamically dispatched — at runtime, depending on
the dynamic type of the receiver, the existential container will call the custom
implementation if one exists. If it doesn't exist, it'll use the default
implementation from the protocol extension. The `addCircle` method has become a
*customization point* for the protocol.

The Swift standard library uses this technique a lot. A protocol like `Sequence`
has dozens of requirements, yet almost all have default implementations. A
conforming type can customize the default implementations because the methods
are dynamically dispatched, but it doesn't have to.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
