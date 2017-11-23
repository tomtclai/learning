/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## The Core Data Structures

*/

// --- (Hidden code block) ---
#if os(macOS)
import Cocoa
typealias UIColor = NSColor
typealias UIFont = NSFont
#else
import UIKit
#endif

extension Sequence where Iterator.Element == CGFloat {
    var normalized: [CGFloat] {
        let maxVal = reduce(0, Swift.max)
        return map { $0 / maxVal }
    }
}
// ---------------------------
/*:
In our library, we'll draw three kinds of things: ellipses, rectangles, and
text. Using enums, we can define a data type for these three possibilities:

*/

enum Primitive {
    case ellipse
    case rectangle
    case text(String)
}

/*:
Diagrams are defined using an enum as well. First, a diagram could be a
primitive, which has a size and is either an ellipse, a rectangle, or text:

``` swift-example
case primitive(CGSize, Primitive)
```

Then, we have cases for diagrams that are beside each other (horizontally) or
below each other (vertically). Note how both cases are defined recursively —
they consist of two diagrams next to each other:

``` swift-example
case beside(Diagram, Diagram)
case below(Diagram, Diagram)
```

To style diagrams, we'll add a case for attributed diagrams. This allows us to
set the fill color (for example, for ellipses and rectangles). We'll define the
`Attribute` type later:

``` swift-example
case attributed(Attribute, Diagram)
```

The last case is for alignment. Suppose we have a small rectangle and a large
rectangle that are next to each other. By default, the small rectangle gets
centered vertically, as seen in Figure {@fig:diagram4}:

![Vertical centering](artwork/example4.png){\#fig:diagram4}

But by adding a case for alignment, we can control the alignment of smaller
parts of the diagram:

``` swift-example
case align(CGPoint, Diagram)
```

For example, Figure {@fig:diagram5} shows a diagram that's top aligned. It's
drawn using the following code:

![Vertical alignment](artwork/example5.png){\#fig:diagram5}

``` swift-example
.align(CGPoint(x: 0.5, y: 0), blueSquare) ||| redSquare
```

We can define `Diagram` as a recursive enum using the `indirect` keyword:

*/

indirect enum Diagram {
    case primitive(CGSize, Primitive)
    case beside(Diagram, Diagram)
    case below(Diagram, Diagram)
    case attributed(Attribute, Diagram)
    case align(CGPoint, Diagram)
}

/*:
The `Attribute` enum is a data type for describing different attributes of
diagrams. Currently, it only supports `fillColor`, but it could easily be
extended to support attributes for stroking, gradients, text attributes, etc.:

*/

enum Attribute {
    case fillColor(UIColor)
}

/*:
### Calculating and Drawing

Calculating the size for the `Diagram` data type is easy. The only cases that
aren't straightforward are for `beside` and `below`. In the case of `beside`,
the width is equal to the sum of the widths, and the height is equal to the
maximum height of the left and right diagram. For `below`, it's a similar
pattern. For all the other cases, we just call size recursively:

*/

extension Diagram {
    var size: CGSize {
        switch self {
        case .primitive(let size, _):
            return size
        case .attributed(_, let x):
            return x.size
        case let .beside(l, r):
            let sizeL = l.size
            let sizeR = r.size
            return CGSize(width: sizeL.width + sizeR.width,
                height: max(sizeL.height, sizeR.height))
        case let .below(l, r):
            return CGSize(width: max(l.size.width, r.size.width),
                height: l.size.height + r.size.height)
        case .align(_, let r):
            return r.size
        }
    }
}

/*:
Before we start drawing, we'll first define one more method. The `fit` method
scales up an input size (e.g. the size of a diagram) to fit into a given
rectangle while maintaining the size's aspect ratio. The scaled up size gets
positioned within the target rectangle according to the `alignment` parameter of
type `CGPoint`: an `x` component of `0` means left aligned, and `1` means right
aligned. Similarly, a `y` component of `0` means top aligned, and `1` means
bottom aligned:

*/

extension CGSize {
    func fit(into rect: CGRect, alignment: CGPoint) -> CGRect {
        let scale = min(rect.width / width, rect.height / height)
        let targetSize = scale * self
        let spacerSize = alignment.size * (rect.size - targetSize)
        return CGRect(origin: rect.origin + spacerSize.point, size: targetSize)
    }
}

/*:
In order to be able to write the calculations in the `fit` method in an
expressive way, we've defined the following operators and helper functions on
`CGSize` and `CGPoint`:

*/

func *(l: CGFloat, r: CGSize) -> CGSize {
    return CGSize(width: l * r.width, height: l * r.height)
}
func *(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width * r.width, height: l.height * r.height)
}
func -(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width - r.width, height: l.height - r.height)
}
func +(l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x + r.x, y: l.y + r.y)
}

extension CGSize {
    var point: CGPoint {
        return CGPoint(x: self.width, y: self.height)
    }
}

extension CGPoint {
    var size: CGSize { return CGSize(width: x, height: y) }
}

/*:
Let's try out the `fit` method. For example, if we fit and center a square
of 1x1 into a rectangle of 200x100, we get the following result:

*/

let center = CGPoint(x: 0.5, y: 0.5)
let target = CGRect(x: 0, y: 0, width: 200, height: 100)
CGSize(width: 1, height: 1).fit(into: target, alignment: center)

/*:
To align the rectangle to the top left, we'd do the following:

*/

let topLeft = CGPoint(x: 0, y: 0)
CGSize(width: 1, height: 1).fit(into: target, alignment: topLeft)

/*:
Now that we can represent diagrams and calculate their sizes, we're ready to
draw them. Because we'll always draw in the same context, we define `draw` as an
extension on `CGContext`. First, we'll handle drawing of primitives. To draw a
primitive in a frame, we can just call the corresponding methods on `CGContext`
by switching on the primitive. In the current version of our library, all text
is set in the system font with a fixed size. It's very possible to make this an
attribute or change the `text` primitive to make this configurable:

*/

extension CGContext {
    func draw(_ primitive: Primitive, in frame: CGRect) {
        switch primitive {
        case .rectangle:
            fill(frame)
        case .ellipse:
            fillEllipse(in: frame)
        case .text(let text):
            let font = UIFont.systemFont(ofSize: 12)
            let attributes = [NSAttributedStringKey.font: font]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.draw(in: frame)
        }
    }
}

/*:
We can add another overload for the `draw(_:in:)` method. This version takes two
parameters: the diagram, and the bounds to draw in.

``` swift-example
extension CGContext {
    func draw(_ diagram: Diagram, in bounds: CGRect) {
        // ...
    }
}
```

Given the bounds, the diagram will fit itself into the bounds using the `fit`
method on `CGSize` that we defined before. To draw a diagram, we have to handle
all of the `Diagram` cases.

The first case is `.primitive`. Here we just fit the size of the primitive into
the bounds in a centered way:

``` swift-example
case let .primitive(size, primitive):
    let bounds = size.fit(into: bounds, alignment: .center)
    draw(primitive, in: bounds)
```

The second case is `.align`. Here we just use the associated value of the case
when calling the `fit` method:

``` swift-example
case .align(let alignment, let diagram):
    let bounds = diagram.size.fit(into: bounds, alignment: alignment)
    draw(diagram, in: bounds)
```

If two diagrams are positioned horizontally next to each other, i.e. the
`.beside` case, we have to split the bounds according to the ratio between the
width of the left diagram and the width of the combined diagram:

``` swift-example
case let .beside(left, right):
    let (lBounds, rBounds) = bounds.split(
        ratio: left.size.width/diagram.size.width, edge: .minXEdge)
    draw(left, in: lBounds)
    draw(right, in: rBounds)
```

Here we use a helper method on `CGRect` to split a rectangle parallel to a
certain edge using a specified ratio:

*/

extension CGRect {
    func split(ratio: CGFloat, edge: CGRectEdge) -> (CGRect, CGRect) {
        let length = edge.isHorizontal ? width : height
        return divided(atDistance: length * ratio, from: edge)
    }
}

extension CGRectEdge {
    var isHorizontal: Bool {
        return self == .maxXEdge || self == .minXEdge;
    }
}

/*:
The `.below` case works analogous to `.beside`:

``` swift-example
case .below(let top, let bottom):
    let (tBounds, bBounds) = bounds.split(
        ratio: top.size.height/diagram.size.height, edge: .minYEdge)
    draw(top, in: tBounds)
    draw(bottom, in: bBounds)
```

Lastly, we have to handle the `.attributed` case. Currently, we only support a
fill color, but it'd be very easy to add support for other attributes. To draw a
diagram with a `fillColor` attribute, we save the current graphics state, set
the fill color, draw the diagram, and finally, restore the graphics state.

The full code of the `draw(_:in:)` method for diagrams now looks like this:

*/

extension CGContext {
    func draw(_ diagram: Diagram, in bounds: CGRect) {
        switch diagram {
        case let .primitive(size, primitive):
            let bounds = size.fit(into: bounds, alignment: .center)
            draw(primitive, in: bounds)
        case .align(let alignment, let diagram):
            let bounds = diagram.size.fit(into: bounds, alignment: alignment)
            draw(diagram, in: bounds)
        case let .beside(left, right):
            let (lBounds, rBounds) = bounds.split(
                ratio: left.size.width/diagram.size.width, edge: .minXEdge)
            draw(left, in: lBounds)
            draw(right, in: rBounds)
        case .below(let top, let bottom):
            let (tBounds, bBounds) = bounds.split(
                ratio: top.size.height/diagram.size.height, edge: .minYEdge)
            draw(top, in: tBounds)
            draw(bottom, in: bBounds)
        case let .attributed(.fillColor(color), diagram):
            saveGState()
            color.set()
            draw(diagram, in: bounds)
            restoreGState()
        }
    }
}


// --- (Hidden code block) ---
import PlaygroundSupport

extension Diagram: CustomPlaygroundQuickLookable {
    var customPlaygroundQuickLook: PlaygroundQuickLook {
        let bounds = CGRect(origin: .zero, size: CGSize(width: 300, height: 200))
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return .image(renderer.image {
          $0.cgContext.draw(self, in: bounds)
        })
    }
}
// ---------------------------
/*:
### Extra Combinators

To make the construction of diagrams easier, it's nice to add some extra
functions (also called combinators). This is a common pattern in functional
libraries: have a small set of core data types and functions and then build
convenience functions on top of them. For example, for rectangles, circles,
text, and squares, we can define convenience functions like so:

*/

func rect(width: CGFloat, height: CGFloat) -> Diagram {
    return .primitive(CGSize(width: width, height: height), .rectangle)
}

func circle(diameter: CGFloat) -> Diagram {
    return .primitive(CGSize(width: diameter, height: diameter), .ellipse)
}

func text(_ theText: String, width: CGFloat, height: CGFloat) -> Diagram {
    return .primitive(CGSize(width: width, height: height), .text(theText))
}

func square(side: CGFloat) -> Diagram {
    return rect(width: side, height: side)
}

/*:
Note that we defined our combinators as free functions. Alternatively, we
could've defined them in an extension on `Diagram` or as initializers on
`Diagram`. Any of these approaches work; it's just the call site that differs.

Also, it turns out it's very convenient to have operators for combining diagrams
horizontally and vertically, thereby making the code more readable. The
operators are just wrappers around `beside` and `below`, and by defining
precedence groups, we can combine the operators without too many parentheses:

*/

precedencegroup HorizontalCombination {
    higherThan: VerticalCombination
    associativity: left
}
infix operator |||: HorizontalCombination
func |||(l: Diagram, r: Diagram) -> Diagram {
    return .beside(l, r)
}

precedencegroup VerticalCombination {
    associativity: left
}
infix operator --- : VerticalCombination
func ---(l: Diagram, r: Diagram) -> Diagram {
    return .below(l, r)
}

/*:
We can also extend the `Diagram` type and add methods for filling and alignment.
We also could've defined these methods as top-level functions instead. This is a
matter of style; one is not more powerful than the other:

*/

extension Diagram {
    func filled(_ color: UIColor) -> Diagram {
        return .attributed(.fillColor(color), self)
    }

    func aligned(to position: CGPoint) -> Diagram {
        return .align(position, self)
    }
}

/*:
To make working with `.aligned(to:)` easier, we can define the following
extension on `CGPoint`:

*/

extension CGPoint {
    static let bottom = CGPoint(x: 0.5, y: 1)
    static let top = CGPoint(x: 0.5, y: 1)
    static let center = CGPoint(x: 0.5, y: 0.5)
}

/*:
Finally, we can define an empty diagram and a way to horizontally concatenate a
list of diagrams. We can just use the `reduce` method to do this:

*/

extension Diagram {
    init() {
        self = rect(width: 0, height: 0)
    }
}

extension Sequence where Iterator.Element == Diagram {
    var hcat: Diagram {
        return reduce(Diagram(), |||)
    }
}

/*:
By adding these small helper functions, we have a powerful library for drawing
diagrams.

*/

// --- (Hidden code block) ---
// Playground-Only: here are some sample diagrams to play with.

let blueSquare = square(side: 1).filled(.blue)
let redSquare = square(side: 2).filled(.red)
let greenCircle = circle(diameter: 1).filled(.green)
let example1 = blueSquare ||| redSquare ||| greenCircle

let cyanCircle = circle(diameter: 1).filled(.cyan)
let example2 = [blueSquare, cyanCircle, redSquare, greenCircle].hcat

func barGraph(_ input: [(String, Double)]) -> Diagram {
    let values: [CGFloat] = input.map { CGFloat($0.1) }
    let bars = values.normalized.map { x in
        return rect(width: 1, height: 3 * x).filled(.black).aligned(to: .bottom)
    }.hcat
    let labels = input.map { label, _ in
        return text(label, width: 1, height: 0.3).aligned(to: .top)
    }.hcat
    return bars --- labels
}

let cities = [
    "Shanghai": 14.01,
    "Istanbul": 13.3,
    "Moscow": 10.56,
    "New York": 8.33,
    "Berlin": 3.43
]

let example3 = barGraph(Array(cities))
// ---------------------------
/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
