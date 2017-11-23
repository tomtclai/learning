/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## A Minimal Example

Let's begin with a minimal example of how you'd use the `Codable` system to
encode an instance of a custom type to JSON.

### Automatic Conformance

Making one of your own types codable can be as easy as conforming it to
`Codable`. If all of the type's stored properties are themselves codable, the
Swift compiler will automatically generate code that implements the `Encodable`
and `Decodable` protocols. This `Coordinate` struct stores a GPS location:

*/

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
    // Nothing to implement here
}

/*:
Because both stored properties are already codable, adopting the `Codable`
protocol is enough to satisfy the compiler. Similarly, we can now write a
`Placemark` struct that takes advantage of `Coordinate`'s `Codable` conformance:

*/

struct Placemark: Codable {
    var name: String
    var coordinate: Coordinate
}

// --- (Hidden code block) ---
extension Coordinate: Equatable {
    static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
// ---------------------------
// --- (Hidden code block) ---
extension Placemark: Equatable {
    static func ==(lhs: Placemark, rhs: Placemark) -> Bool {
        return lhs.name == rhs.name && lhs.coordinate == rhs.coordinate
    }
}
// ---------------------------
// --- (Hidden code block) ---
extension Coordinate: CustomStringConvertible {
    var description: String {
        return "(lat: \(latitude), lon: \(longitude))"
    }
}
// ---------------------------
// --- (Hidden code block) ---
extension Placemark: CustomStringConvertible {
    var description: String {
        return "\(name) \(coordinate)"
    }
}
// ---------------------------
/*:
The code the compiler synthesizes isn't visible, but we'll dissect it piece by
piece a little later in this chapter. For now, treat the generated code like you
would a default implementation for a protocol in the standard library, such as
`Sequence.drop(while:)` — you get the default behavior for free, but you have
the option of providing your own implementation.

The only material difference between code generation and "normal" default
implementations is that the latter are part of the standard library, whereas the
logic for the `Codable` code synthesis lives in the compiler. Moving the code
into the standard library would require more capable reflection APIs than Swift
currently has, and even if those existed, runtime reflection would bring its own
tradeoffs (e.g. reflection is typically slower).

Nonetheless, shifting as much of the language definition as possible out of the
compiler and into libraries remains a stated goal for Swift. Some day we'll
probably get a macro system that's powerful enough to move the entire `Codable`
system into the standard library, but that's at least several years off. Until
then, compiler code synthesis is a pragmatic solution to this problem. We're
already seeing more applications of it for the upcoming [automatic `Equatable`
and `Hashable`
conformance](https://github.com/apple/swift-evolution/blob/master/proposals/0185-synthesize-equatable-hashable.md).

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
