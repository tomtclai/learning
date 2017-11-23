/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Manual Conformance

If your type has special requirements, you can always implement the `Encodable`
and `Decodable` requirements yourself. What's nice is that the automatic code
synthesis isn't an all-or-nothing thing — you can pick and choose what to
override and take the rest from the compiler.

### Custom Coding Keys

The easiest way to control how a type encodes itself is to write a custom
`CodingKeys` enum (which doesn't have to be an enum, by the way, although only
enums get synthesized implementations for the `CodingKey` protocol). Providing
custom coding keys is a very simple and declarative way of changing how a type
is encoded. We can:

  - **rename fields** in the encoded output by giving them an explicit string
    value, or

  - **skip fields altogether** by omitting their keys from the enum.

To assign different names, we also have to give the enum an explicit raw value
type of `String`. For example, this will map `name` to `"label"` in the JSON
output while leaving the `coordinate` mapping unchanged:

*/

// --- (Hidden code block) ---
struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
    // Nothing to implement here
}
// ---------------------------
struct Placemark2: Codable {
    var name: String
    var coordinate: Coordinate

    private enum CodingKeys: String, CodingKey {
        case name = "label"
        case coordinate
    }

    // Compiler-synthesized encode and decode methods
    // will use overridden CodingKeys
}

/*:
And this will skip the placemark's name and only encode the GPS coordinates
because we didn't include the `name` key in the enum:

*/

struct Placemark3: Codable {
    var name: String = "(Unknown)"
    var coordinate: Coordinate

    private enum CodingKeys: CodingKey {
        case coordinate
    }
}

/*:
Notice the default value we had to assign to the `name` property. Without it,
code generation for `Decodable` will fail when the compiler detects that it
can't assign a value to `name` in the initializer.

Skipping properties during encoding can be useful for transient values that can
easily be recomputed or aren't important to store, such as caches or memoized
expensive computations. The compiler is smart enough to filter out `lazy`
properties on its own, but if you use normal stored properties for transient
values, this is how you can do it yourself.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
