/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Protocol-Oriented Programming

*/

// --- (Hidden code block) ---
import UIKit
// ---------------------------
// --- (Hidden code block) ---
struct XMLNode {
    var tag: String
    var attributes: [String:String]
    var children: [XMLNode] = []

    init(tag: String, attributes: [String:String] = [:], children: [XMLNode] = []) {
        self.tag = tag
        self.attributes = attributes
        self.children = children
    }
}

#if os(macOS)
import Cocoa
typealias UIColor = NSColor
#endif

extension XMLNode {
    var rendered: String {
        let attributesDescription = attributes.isEmpty ? "" : " " + attributes.map { key, value in
            "\(key)=\"\(value)\""
            }.joined(separator: " ")


        if children.count == 0 {
            return "<\(tag)\(attributesDescription)/>"
        } else {
            let childrenDescription = children.map { $0.rendered }.joined(separator: "\n")
            return "<\(tag)\(attributesDescription)>\n\(childrenDescription)\n</\(tag)>"
        }
    }
}

extension CGRect {
    var svgAttributes: [String:String] {
        return [
            "cx": "\(origin.x)",
            "cy": "\(origin.y)",
            "rx": "\(size.width)",
            "ry": "\(size.height)"
        ]
    }
}

extension String {
    init(hexColor: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        hexColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        self.init(format: "#%02x%02x%02x", Int(red), Int(green), Int(blue))
    }
}
// ---------------------------
/*:
In a graphical application, we might want different render targets: for example,
we can either render graphics in a Core Graphics `CGContext` or create an SVG
file. To start, we'll define a protocol that describes the minimum functionality
of our drawing API:

*/

protocol Drawing {
    mutating func addEllipse(rect: CGRect, fill: UIColor)
    mutating func addRectangle(rect: CGRect, fill: UIColor)
}

/*:
One of the most powerful features of protocols is that we can retroactively
modify any type to add conformance to a protocol. For `CGContext`, we can add an
extension that makes it conform to the `Drawing` protocol:

*/

extension CGContext: Drawing {
    func addEllipse(rect: CGRect, fill: UIColor) {
        setFillColor(fill.cgColor)
        fillEllipse(in: rect)
    }

    func addRectangle(rect: CGRect, fill fillColor: UIColor) {
        setFillColor(fillColor.cgColor)
        fill(rect)
    }
}

/*:
To represent an SVG file, we create an `SVG` struct. It contains an `XMLNode`
with children and has a single method, `append`, which appends a child node to
the root node. (We've left out the definition of `XMLNode` here.)

*/

struct SVG {
    var rootNode = XMLNode(tag: "svg")
    mutating func append(node: XMLNode) {
        rootNode.children.append(node)
    }
}

// --- (Hidden code block) ---
extension SVG: CustomDebugStringConvertible {
    var debugDescription: String {
        return rootNode.rendered
    }
}
// ---------------------------
/*:
Rendering into an SVG means we have to append a node for each element. We use a
few simple extensions: the `svgAttributes` property on `CGRect` creates a
dictionary that matches the SVG specification. `String.init(hexColor:)` takes a
`UIColor` and turns it into a hexadecimal string (such as `"#010100"`). With
these helpers, adding `Drawing` conformance is straightforward:

*/

extension SVG: Drawing {
    mutating func addEllipse(rect: CGRect, fill: UIColor) {
        var attributes: [String:String] = rect.svgAttributes
        attributes["fill"] = String(hexColor: fill)
        append(node: XMLNode(tag: "ellipse", attributes: attributes))
    }

    mutating func addRectangle(rect: CGRect, fill: UIColor) {
        var attributes: [String:String] = rect.svgAttributes
        attributes["fill"] = String(hexColor: fill)
        append(node: XMLNode(tag: "rect", attributes: attributes))
    }
}

/*:
We can now write drawing code that's independent of the rendering target; the
following code only assumes that our `context` variable conforms to the
`Drawing` protocol. If we initialized `context` with a `CGContext` instead, we
wouldn't need to change any of the code:

*/

var context: Drawing = SVG()
let rect1 = CGRect(x: 0, y: 0, width: 100, height: 100)
let rect2 = CGRect(x: 0, y: 0, width: 50, height: 50)
context.addRectangle(rect: rect1, fill: .yellow)
context.addEllipse(rect: rect2, fill: .blue)
context

/*:
### Protocol Extensions

Another powerful feature of Swift protocols is the possibility to extend a
protocol with full method implementations; you can do this to both your own
protocols and existing protocols. For example, we could add a method to
`Drawing` that, given a center point and a radius, renders a circle:

*/

extension Drawing {
    mutating func addCircle(center: CGPoint, radius: CGFloat, fill: UIColor) {
        let diameter = radius * 2
        let origin = CGPoint(x: center.x - radius, y: center.y - radius)
        let size = CGSize(width: diameter, height: diameter)
        let rect = CGRect(origin: origin, size: size)
        addEllipse(rect: rect, fill: fill)
    }
}

/*:
By adding `addCircle` in an extension, we can use it both with `CGContext` and
our `SVG` type.

Note that code sharing using protocols has several advantages over code sharing
using inheritance:

  - We're not forced to use a specific superclass.

  - We can conform existing types to a protocol (e.g. we made `CGContext`
    conform to `Drawing`). Subclassing isn't as flexible; if `CGContext` were a
    class, we couldn't retroactively change its superclass.

  - Protocols work with both structs and classes, but structs can't have
    superclasses.

  - Finally, when dealing with protocols, we don't have to worry about
    overriding methods or calling `super` at the right moment.

### Overriding Methods in Protocol Extensions

As the author of a protocol, you have two options when you add a protocol method
in an extension. First, you can choose to only add it in an extension, as we did
above with `addCircle`. Or, you could also add the method declaration to the
protocol definition itself, making the method a *protocol requirement*. Protocol
requirements are dispatched dynamically, whereas methods that are only defined
in an extension use static dispatch. The difference is subtle but important,
both as a protocol author and as a user of conforming types.

Let's look at an example. In the previous section, we added `addCircle` as an
extension of the `Drawing` protocol, but we didn't make it a requirement. If we
want to provide a more specific version of `addCircle` for the `SVG` type, we
can just "override" the method:

*/

extension SVG {
    mutating func addCircle(center: CGPoint, radius: CGFloat, fill: UIColor) {
        var attributes: [String:String] = [
          "cx": "\(center.x)",
          "cy": "\(center.y)",
          "r": "\(radius)",
        ]
        attributes["fill"] = String(hexColor: fill)
        append(node: XMLNode(tag: "circle", attributes: attributes))
    }
}

/*:
If we now create an instance of `SVG` and call `addCircle` on it, it behaves as
you'd expect: the compiler will pick the most specific version of `addCircle`,
which is the version that's defined in the extension on `SVG`. We can see that
it correctly uses the `circle` tag:

*/

var sample = SVG()
sample.addCircle(center: .zero, radius: 20, fill: .red)
print(sample)

/*:
Now, just like above, we create another `SVG` instance; the only difference is
that we explicitly cast the variable to the `Drawing` type. What'll happen if we
call `addCircle` on this `Drawing`-that's-really-an-`SVG`? Most people would
probably expect that this call would be dispatched to the same implementation on
`SVG`, but that's not the case:

*/

var otherSample: Drawing = SVG()
otherSample.addCircle(center: .zero, radius: 20, fill: .red)
print(otherSample)

/*:
It returned an `ellipse` element, and not the `circle` we were expecting. It
turns out it used the `addCircle` method from the protocol extension and not the
method from the `SVG` extension. When we defined `otherSample` as a variable of
type `Drawing`, the compiler automatically boxed the `SVG` value in a type that
represents the protocol. This box is called an *existential container*, the
details of which we'll look into later in this chapter. For now, let's consider
the behavior: when we call `addCircle` on our existential container, the method
is statically dispatched, i.e. it always uses the extension on `Drawing`. If it
were dynamically dispatched, it would've taken the type of the receiver (`SVG`)
into account.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
