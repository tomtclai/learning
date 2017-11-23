/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Making Classes Codable

We saw in the previous section that it's possible (if not advisable) to
retroactively conform any value type to `Codable`. However, this isn't the case
for non-final classes.

As a general rule, the `Codable` system works just fine with classes, but the
potential existence of subclasses adds another level of complexity. What happens
if we try to conform, say, `UIColor` to `Decodable`? (We're ignoring `Encodable`
for the moment because it's not relevant for this discussion; we can add it
later.) We got this example from [a message by Jordan
Rose](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20170731/038522.html)
on the swift-evolution mailing list.

A custom `Decodable` implementation for `UIColor` might look like this:

``` swift-example
extension UIColor: Decodable {
    private enum CodingKeys: CodingKey {
        case red
        case green
        case blue
        case alpha
    }

    // Error: initializer requirement 'init(from:)' can only be satisfied
    // by a `required` initializer in the definition of non-final class 'UIColor'
    // etc.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(CGFloat.self, forKey: .red)
        let green = try container.decode(CGFloat.self, forKey: .green)
        let blue = try container.decode(CGFloat.self, forKey: .blue)
        let alpha = try container.decode(CGFloat.self, forKey: .alpha)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
```

This code fails to compile, with several errors that ultimately boil down to one
unsolvable conflict: only *required initializers* can satisfy protocol
requirements, and required initializers may not be added in extensions; they
must be declared directly in the class definition.

A required initializer (marked with the `required` keyword) indicates an
initializer that every subclass must implement. The rule that initializers
defined in protocols must be `required` ensures that they, like all protocol
requirements, can be invoked dynamically on subclasses. The compiler must
guarantee that code like this works:

``` swift-example
func decodeDynamic(_ colorType: UIColor.Type,
    from decoder: Decoder) throws -> UIColor {
    return try colorType.init(from: decoder)
}
let color = decodeDynamic(SomeUIColorSubclass.self, from: someDecoder)
```

For this dynamic dispatch to work, the compiler must create an entry for the
initializer in the class's dispatch table. This table of the class's non-final
methods is created with a fixed size when the class definition is compiled;
extensions can't add entries retroactively. This is why the required initializer
is only allowed in the class definition.

Long story short: it's impossible to retroactively conform a non-final class to
`Codable` in Swift 4. In the mailing list message we referenced above, Jordan
Rose discusses a number of scenarios detailing how Swift could make this work in
the future — from allowing a required initializer to be final (then it wouldn't
need an entry in the dispatch table), to adding runtime checks that would trap
if a subclass didn't provide the *designated initializer* that the required
initializer calls.

But even then, we'd still have to deal with the fact that adding `Codable`
conformance to types you don't own is problematic. As in the previous section,
the recommended approach is to write a wrapper struct for `UIColor` and make
that codable.

Let's start by writing a small extension that makes it easier to extract the
red, green, blue, and alpha components from a `UIColor` value. The existing
`getRed(_:green:blue:alpha:)` method uses pointers to pass the results back to
the caller because Objective-C doesn't support tuples as return types. We can do
better in Swift:

*/

// --- (Hidden code block) ---
#if os(macOS)
    import AppKit
    typealias UIColor = NSColor
    extension NSColor {
        func getRed(_ red: UnsafeMutablePointer<CGFloat>?,
            green: UnsafeMutablePointer<CGFloat>?,
            blue: UnsafeMutablePointer<CGFloat>?,
            alpha: UnsafeMutablePointer<CGFloat>?) -> Bool
        {
            // Force Void return type to select the correct overload
            let _: Void = getRed(red, green: green, blue: blue, alpha: alpha)
            return true
        }
    }
#else
    import UIKit
#endif
// ---------------------------
extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
    }
}

/*:
We'll use the `rgba` property in our `encode(to:)` implementation. Notice that
the type of `rgba` is an optional tuple because not all `UIColor` instances can
be represented as RGBA components. If someone tries to encode a color that isn't
convertible to RGBA (e.g. a color based on a pattern image), we'll throw an
encoding error.

Here's the complete implementation for our `UIColor.CodableWrapper` struct (we
namespaced the struct inside `UIColor` to make the relationship between the two
clear):

*/

extension UIColor {
    struct CodableWrapper: Codable {
        var value: UIColor

        init(_ value: UIColor) {
            self.value = value
        }

        enum CodingKeys: CodingKey {
            case red
            case green
            case blue
            case alpha
        }

        func encode(to encoder: Encoder) throws {
            // Throw error if color isn't convertible to RGBA
            guard let (red, green, blue, alpha) = value.rgba else {
                let errorContext = EncodingError.Context(
                    codingPath: encoder.codingPath,
                    debugDescription: 
                        "Unsupported color format: \(value)"
                )
                throw EncodingError.invalidValue(value, errorContext)
            }
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(red, forKey: .red)
            try container.encode(green, forKey: .green)
            try container.encode(blue, forKey: .blue)
            try container.encode(alpha, forKey: .alpha)
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let red = try container.decode(CGFloat.self, forKey: .red)
            let green = try container.decode(CGFloat.self, forKey: .green)
            let blue = try container.decode(CGFloat.self, forKey: .blue)
            let alpha = try container.decode(CGFloat.self, forKey: .alpha)
            self.value = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}

/*:
We should note that this implementation is somewhat imperfect because it
converts all colors to an RGB color space during encoding. When you later decode
such a value, you'll always get back an RGB color, even if the color you
originally encoded was in a grayscale color space, for example. Since there's no
public `UIColor` API to identify the color space a color is in, a better
implementation would have to drop down to the underlying `CGColor` to identify
the color's color space model (e.g. RGB or grayscale) and then encode both the
color space model and the components that make sense for the color space in
question. On decoding, you'd then have to decode the color space model first
before you'd know what other keys you could expect to find in the decoding
container.

The big downside of the wrapper struct approach is that you'll have to manually
convert between `UIColor` and the wrapper before encoding and after decoding.
Suppose you want to encode an array of `UIColor` values:

*/

let colors: [UIColor] = [
    .red,
    .white,
    .init(displayP3Red: 0.5, green: 0.4, blue: 1.0, alpha: 0.8),
    .init(hue: 0.6, saturation: 1.0, brightness: 0.8, alpha: 0.9),
]

/*:
You'll have to map the array to `UIColor.CodableWrapper` before you can pass it
to an encoder:

*/

let codableColors = colors.map(UIColor.CodableWrapper.init)

/*:
Moreover, any type that stores a `UIColor` will no longer participate in
automatic code synthesis. Defining a type like the following produces an error
because `UIColor` isn't `Codable`:

``` swift-example
// error: cannot automatically synthesize 'Encodable'/'Decodable'
struct ColoredRect: Codable {
    var rect: CGRect
    var color: UIColor
}
```

How do we fix this with the least amount of code? As in the previous section,
we'll add a private property of type `UIColor.CodableWrapper` that acts as
storage for the color value, and we'll make `color` a computed property that
forwards to `_color` in its accessors. We'll also need to add an initializer.
Lastly, we'll provide our own coding keys enum to change the key used to encode
the color value from the default `"_color"` to `"color"` (this step is
optional):

*/

struct ColoredRect: Codable {
    var rect: CGRect
    // Storage for color
    private var _color: UIColor.CodableWrapper
    var color: UIColor {
        get { return _color.value }
        set { _color.value = newValue }
    }

    init(rect: CGRect, color: UIColor) {
        self.rect = rect
        self._color = UIColor.CodableWrapper(color)
    }

    private enum CodingKeys: String, CodingKey {
        case rect
        case _color = "color"
    }
}

/*:
Encoding an array of `ColoredRect` values produces this JSON output:

*/

let rects = [ColoredRect(rect: CGRect(x: 10, y: 20, width: 100, height: 200), 
    color: .yellow)]
do {
    let encoder = JSONEncoder()
    let jsonData = try encoder.encode(rects)
    let jsonString = String(decoding: jsonData, as: UTF8.self)
} catch {
    print(error.localizedDescription)
}


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
