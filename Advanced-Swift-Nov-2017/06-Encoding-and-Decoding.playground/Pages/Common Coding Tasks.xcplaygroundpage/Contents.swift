/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Common Coding Tasks

In this section, we'd like to discuss some common tasks you might want to solve
with the `Codable` system, along with potential problems you might run into.

### Making Types You Don't Own Codable

Suppose we want to replace our `Coordinate` type with `CLLocationCoordinate2D`
from the Core Location framework. `CLLocationCoordinate2D` has the exact same
structure as `Coordinate`, so it makes sense not to reinvent the wheel.

The problem is that `CLLocationCoordinate2D` doesn't conform to `Codable`. As a
result, the compiler will now (correctly) complain that it can't synthesize the
`Codable` conformance for `Placemark5` any longer because one of its properties
isn't `Codable` itself:

*/

import CoreLocation

struct Placemark5: Codable {
    var name: String
    var coordinate: CLLocationCoordinate2D
}
// error: cannot automatically synthesize 'Decodable'/'Encodable'
// because 'CLLocationCoordinate2D' does not conform

/*:
Can we make `CLLocationCoordinate2D` codable despite the fact that the type is
defined in another module? Adding the missing conformance in an extension
produces an error:

``` swift-example
extension CLLocationCoordinate2D: Codable { }
// error: implementation of 'Decodable'/'Encodable' cannot be
// automatically synthesized in an extension yet
```

Swift 4.0 will only generate code for conformances that are specified on the
type definition itself — we'd have to implement the protocols manually. But even
if that limitation didn't exist (the Swift team plans to lift it, at least for
extensions in the same file or module), retroactively adding `Codable`
conformance to a type we don't own is probably not a good idea. What if Apple
decides to provide the conformance itself in a future SDK version? It's likely
that Apple's implementation won't be compatible with ours, which means values
encoded with our version wouldn't decode with Apple's code, and vice versa. This
is a problem because a decoder can't know which implementation it should use —
it only sees that it's supposed to decode a value of type
`CLLocationCoordinate2D`.

Itai Ferber, a developer at Apple who wrote large chunks of the `Codable`
system, [gives this
advice](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20170731/038566.html):

> I would actually take this a step further and recommend that any time you
> intend to extend someone else’s type with `Encodable` or `Decodable`, you
> should almost certainly write a wrapper struct for it instead, unless you have
> reasonable guarantees that the type will never attempt to conform to these
> protocols on its own.

We'll see an example of this in the next section. As for our current problem,
let's go with a slightly different (but equally safe) solution: we'll provide
our own `Codable` implementation for `Placemark5`, where we encode the latitude
and longitude values directly. This effectively hides the existence of the
`CLLocationCoordinate2D` type from the encoders and decoders; from their
perspective, it looks as if the latitude and longitude properties were defined
directly on `Placemark5`:

*/

extension Placemark5 {
    private enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        // Encode latitude and longitude separately
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        // Reconstruct CLLocationCoordinate2D from lat/lon
        self.coordinate = CLLocationCoordinate2D(
            latitude: try container.decode(Double.self, forKey: .latitude),
            longitude: try container.decode(Double.self, forKey: .longitude)
        )
    }
}

/*:
This example provides a good idea of the boilerplate code we'd have to write for
every type if the compiler didn't generate it for us (and the synthesized
implementation for the `CodingKey` protocol is still missing here).

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
