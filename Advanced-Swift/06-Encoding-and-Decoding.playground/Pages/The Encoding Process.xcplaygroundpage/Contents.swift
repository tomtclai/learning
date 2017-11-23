/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## The Encoding Process

If *using* the `Codable` system is all you're interested in and the default
behavior works for you, you can stop reading now. But to understand how to
customize the way types get encoded, we need to dig a little deeper. How does
the encoding process work? What code does the compiler actually synthesize when
we conform a type to `Codable`?

When you initiate the encoding process, the encoder will call the `encode(to:
Encoder)` method of the value that's being encoded, passing itself as the
argument. It's then the value's responsibility to encode itself into the encoder
in any format it sees fit.

In our example above, we pass an array of `Placemark` values to the JSON
encoder:

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

let places = [
	Placemark(name: "Berlin", coordinate: 
        Coordinate(latitude: 52, longitude: 13)),
	Placemark(name: "Cape Town", coordinate: 
        Coordinate(latitude: -34, longitude: 18))
]

import Foundation

let encoder = JSONEncoder()
// ---------------------------
let jsonData = try encoder.encode(places)

/*:
The encoder (or rather its private workhorse, `_JSONEncoder`) will now call
`places.encode(to: self)`. How does the array know how to encode itself in a
format the encoder understands?

### Containers

Let's take a look at the `Encoder` protocol to see the interface an encoder
presents to the value being
encoded:

``` swift-example
/// A type that can encode values into a native format for external representation.
public protocol Encoder {
    /// The path of coding keys taken to get to this point in encoding.
    var codingPath: [CodingKey] { get }
    /// Any contextual information set by the user for encoding.
    var userInfo: [CodingUserInfoKey : Any] { get }
    /// Returns an encoding container appropriate for holding
    /// multiple values keyed by the given key type.
    func container<Key: CodingKey>(keyedBy type: Key.Type)
        -> KeyedEncodingContainer<Key>
    /// Returns an encoding container appropriate for holding
    /// multiple unkeyed values.
    func unkeyedContainer() -> UnkeyedEncodingContainer
    /// Returns an encoding container appropriate for holding
    /// a single primitive value.
    func singleValueContainer() -> SingleValueEncodingContainer
}
```

Ignoring `codingPath` and `userInfo` for a moment, it's apparent that an
`Encoder` is essentially a provider of *encoding containers*. A container is a
sandboxed view into the encoder's storage. By creating a new container for each
value that's being encoded, the encoder can make sure the values don't overwrite
each other's data.

There are three types of containers:

  - **Keyed containers** encode key-value pairs. Think of a keyed container as a
    special kind of dictionary. Keyed containers are by far the most prevalent.
    
    The keys in a keyed encoding container are strongly typed, providing type
    safety and autocompletion. The encoder will eventually convert the keys to
    strings (or integers) when it writes its target format (such as JSON), but
    that's hidden from client code. Changing the keys your type provides is the
    easiest way to customize how it encodes itself. We'll see an example of this
    below.

  - **Unkeyed containers** encode multiple values sequentially, omitting keys.
    Think of an array of encoded values. Because there are no keys to identify a
    value, decoding containers must take care to decode values in the same order
    they were encoded.

  - **Single value containers** encode a single value. You'd use this for types
    that are wholly defined by a single property. Examples include primitive
    types like `Int` or enums that are `RawRepresentable` as primitive values.

For each of the three container types, there's a protocol that defines the
interface through which the container receives values to encode. Here's the
definition of `SingleValueEncodingContainer`:

``` swift-example
/// A container that can support the storage and direct encoding of a single
/// non-keyed value.
public protocol SingleValueEncodingContainer {
    /// The path of coding keys taken to get to this point in encoding.
    var codingPath: [CodingKey] { get }

    /// Encodes a null value.
    mutating func encodeNil() throws

    /// Base types
    mutating func encode(_ value: Bool) throws
    mutating func encode(_ value: Int) throws
    mutating func encode(_ value: Int8) throws
    mutating func encode(_ value: Int16) throws
    mutating func encode(_ value: Int32) throws
    mutating func encode(_ value: Int64) throws
    mutating func encode(_ value: UInt) throws
    mutating func encode(_ value: UInt8) throws
    mutating func encode(_ value: UInt16) throws
    mutating func encode(_ value: UInt32) throws
    mutating func encode(_ value: UInt64) throws
    mutating func encode(_ value: Float) throws
    mutating func encode(_ value: Double) throws
    mutating func encode(_ value: String) throws

    mutating func encode<T: Encodable>(_ value: T) throws
}
```

As you can see, the protocol mainly declares a bunch of `encode(_:)` overloads
for various types: `Bool`, `String`, and the integer and floating-point types.
There's also a variant for encoding a null value. Every encoder and decoder must
support these primitive types, and all `Encodable` types must ultimately be
reducible to one of these types. [The Swift Evolution
proposal](https://github.com/apple/swift-evolution/blob/master/proposals/0166-swift-archival-serialization.md)
that introduced the `Codable` system says:

> These … overloads give strong, static type guarantees about what is encodable
> (preventing accidental attempts to encode an invalid type), and provide a list
> of primitive types that are common to all encoders and decoders that users can
> rely on.

Any value that isn't one of the base types ends up in the generic `encode<T:
Encodable>` overload. In it, the container will eventually call the argument's
`encode(to: Encoder)` method, and the entire process will start over one level
down until only primitive types are left. But the container is free to treat
types with special requirements differently. For instance, [it's at this
point](https://github.com/apple/swift/blob/997fe0180966f0894288bee97efd25f16d4cc322/stdlib/public/SDK/Foundation/JSONEncoder.swift#L665-L691)
that `_JSONEncoder` checks if it's encoding a `Data` value that must observe the
configured encoding strategy, such as Base64 (the [default
behavior](https://github.com/apple/swift/blob/c8bbce6ef1dc9eed45af660b388dbf1cc3f5be0c/stdlib/public/SDK/Foundation/Data.swift#L1950-L1967)
for `Data` is to encode itself as an unkeyed container of `UInt8` bytes).

`UnkeyedEncodingContainer` and `KeyedEncodingContainerProtocol` have the same
structure as `SingleValueEncodingContainer`, but they expose a few additional
capabilities, such as creating nested containers. If you want to write an
encoder and decoder for another data format, implementing these containers is
most of the work.

### How a Value Encodes Itself

Going back to our example, the top-level type we're encoding is
`Array<Placemark>`. An unkeyed container is a perfect match for an array (which
is, after all, a sequential list of values), so the array asks the encoder for
one. The array then iterates over its elements and tells the container to encode
each one. Here's how this process looks in code:

``` swift-example
extension Array: Encodable where Element: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self {
            try container.encode(element)
        }
    }
}
```

([The actual code in the standard
library](https://github.com/apple/swift/blob/e0974640ab9d3cc9237773b96d45b7e1db6a5ab5/stdlib/public/core/Codable.swift#L4033-L4043)
is slightly longer and less elegant than this. The `where Element: Encodable`
part doesn't compile in Swift 4 because the compiler doesn't support conditional
protocol conformance yet. Runtime assertions and forced casts have to take its
place.)

The array elements are `Placemark` instances. We've seen that for non-primitive
types, the container will continue calling each value's `encode(to:)` method.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
