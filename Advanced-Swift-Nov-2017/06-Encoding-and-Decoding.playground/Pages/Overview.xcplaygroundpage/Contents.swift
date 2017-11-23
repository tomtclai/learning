/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Overview

The `Codable` system (named after its base "protocol," which is really a type
alias) is designed around three central goals:

  - **Universality** — It should work with structs, enums, and classes.

  - **Type safety** — Interchange formats such as JSON are often weakly typed,
    whereas your code should work with strongly typed data structures.

  - **Reducing boilerplate** — Developers should have to write as little
    repetitive “adapter code” as possible to let custom types participate in the
    system. The compiler should generate this code for you automatically.

Types declare their ability to be (de-)serialized by conforming to the
`Encodable` and/or `Decodable` protocols. Each of these protocols has just one
requirement — `Encodable` defines an `encode(to:)` method in which a value
encodes itself, and `Decodable` specifies an initializer for creating an
instance from serialized data:

``` swift-example
/// A type that can encode itself to an external representation.
public protocol Encodable {
    /// Encodes this value into the given encoder.
    public func encode(to encoder: Encoder) throws
}

/// A type that can decode itself from an external representation.
public protocol Decodable {
    /// Creates a new instance by decoding from the given decoder.
    public init(from decoder: Decoder) throws
}
```

Because most types that adopt one will also adopt the other, the standard
library provides the `Codable` typealias as a shorthand for both:

``` swift-example
public typealias Codable = Decodable & Encodable
```

All basic standard library types — including `Bool`, the number types, and
`String` — are codable out of the box, as are optionals, arrays, dictionaries,
and sets containing codable elements. Lastly, many common data types used by
Apple's frameworks have already adopted `Codable`, including `Data`, `Date`,
`URL`, `CGPoint`, and `CGRect`.

Once you have a value of a codable type, you can create an *encoder* and tell it
to serialize the value into the target format, such as JSON. In the reverse
direction, a *decoder* takes serialized data and turns it back into an instance
of the originating type. On the surface, the corresponding `Encoder` and
`Decoder` protocols aren't much more complex than `Encodable` and `Decodable`.
The central task of an encoder or decoder is to manage a hierarchy of
*containers* that store the serialized data. While you rarely have to interact
with the `Encoder` and `Decoder` protocols directly unless you're writing your
own coders, understanding this structure and the three kinds of containers is
necessary when you want to customize how your own types encode themselves. We'll
see many examples of this below.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
