/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## The Synthesized Code

This brings us to the code the compiler synthesizes for the `Placemark` struct
when we add `Codable` conformance. Let's walk through it step by step.

*/

// --- (Hidden code block) ---
struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
    // Nothing to implement here
}

struct Placemark: Codable {
    var name: String
    var coordinate: Coordinate
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "(lat: \(latitude), lon: \(longitude))"
    }
}

extension Placemark: CustomStringConvertible {
    var description: String {
        return "\(name) \(coordinate)"
    }
}
// ---------------------------
/*:
### Coding Keys

The first thing the compiler generates is a private nested enum named
`CodingKeys`:

``` swift-example
struct Placemark {
    // ...

    private enum CodingKeys: CodingKey {
        case name
        case coordinate
    }
}
```

The enum contains one case for every stored property of the struct. The enum
values are the keys for a keyed encoding container. Compared to string keys,
these strongly typed keys are much safer and more convenient to use because the
compiler will find typos. However, encoders must eventually be able to convert
keys to strings or integers for storage. Handling these translations is the task
of the `CodingKey` protocol:

``` swift-example
/// A type that can be used as a key for encoding and decoding.
public protocol CodingKey {
    /// The string to use in a named collection (e.g. a string-keyed dictionary).
    var stringValue: String { get }
    /// The value to use in an integer-indexed collection
    /// (e.g. an int-keyed dictionary).
    var intValue: Int? { get }
    init?(stringValue: String)
    init?(intValue: Int)
}
```

All keys must provide a string representation. Optionally, a key type can also
provide a conversion to and from integers. Encoders can choose to use integer
keys if that's more efficient, but they are also free to ignore them and stick
with string keys (as `JSONEncoder` does). The default compiler-synthesized code
only produces string keys.

### The `encode(to:)` Method

This is the code the compiler generates for the `Placemark` struct's
`encode(to:)` method:

``` swift-example
struct Placemark: Codable {
    // ...
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(coordinate, forKey: .coordinate)
    }
}
```

The main difference to the array version is that `Placemark` encodes itself into
a *keyed* container. A keyed container is the correct choice for all composite
data types (structs and classes) with more than one property. Notice how the
code passes `CodingKeys.self` to the encoder when it requests the keyed
container. All subsequent encode commands into this container must specify a key
of the same type. Since the key type is usually private to the type that's being
encoded, this design makes it nearly impossible to accidentally use another
type's coding keys when implementing this method manually.

The end result of the encoding process is a tree of nested containers which the
JSON encoder can translate into its target format: keyed containers become JSON
objects (`{ … }`), unkeyed containers become JSON arrays (`[ … ]`), and single
value containers get converted to numbers, booleans, strings, or `null`,
depending on their data type.

### The `init(from:)` Initializer

When we call `try decoder.decode([Placemark].self, from: jsonData)`, the decoder
creates an instance of the type we passed in (here it's `[Placemark]`) using the
initializer defined in `Decodable`. Like encoders, decoders manage a tree of
*decoding containers*, which can be any of the three familiar kinds: keyed,
unkeyed, or single value containers.

Each value being decoded then walks recursively down the container hierarchy and
initializes its properties with the values it decodes from its container. If at
any step an error is thrown (e.g. because of a type mismatch or missing value),
the entire process fails with an error.

A typical decoding initializer implementation should look familiar to you.
Here's the one the compiler generates for `Placemark`:

``` swift-example
struct Placemark: Codable {
    // ...

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
    }
}
```

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
