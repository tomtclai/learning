/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### The Computed Property Workaround

As you can see, the amount of code we have to write for both alternatives is
significant. For this particular example, we recommend a different approach, and
that's to stick with our custom `Coordinate` struct for storage and `Codable`
conformance, and expose the `CLLocationCoordinate2D` to clients as a computed
property. Because the private `_coordinate` property is codable, we get the
`Codable` conformance for free; all we have to do is rename its key in the
`CodingKeys` enum. And the client-facing `coordinate` property has the type our
clients require, but the `Codable` system will ignore it because it's a computed
property:

*/

// --- (Hidden code block) ---
struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
    // Nothing to implement here
}

import CoreLocation
// ---------------------------
struct Placemark7: Codable {
    var name: String
    private var _coordinate: Coordinate
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: _coordinate.latitude, 
                longitude: _coordinate.longitude)
        }
        set {
            _coordinate = Coordinate(latitude: newValue.latitude, 
                longitude: newValue.longitude)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case _coordinate = "coordinate"
    }
}

/*:
This approach works well in this case because `CLLocationCoordinate2D` is such a
simple type, and translating between it and our custom type is easy.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
