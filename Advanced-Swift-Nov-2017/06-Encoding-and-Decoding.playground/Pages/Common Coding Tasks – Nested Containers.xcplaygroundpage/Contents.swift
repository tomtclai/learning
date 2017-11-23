/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### Nested Containers

Alternatively, we could've used a *nested container* to encode the coordinates.
`KeyedDecodingContainer` has a method named `nestedContainer(keyedBy:forKey:)`
that creates a separate keyed container (with a separate coding key type) and
stores it under the provided key. We'd add a second enum for the nested keys and
encode the latitude and longitude values into the nested container (we're only
showing the `Encodable` implementation here; `Decodable` follows the same
pattern):

*/

// --- (Hidden code block) ---
import CoreLocation
// ---------------------------
struct Placemark6: Encodable {
    var name: String
    var coordinate: CLLocationCoordinate2D

    private enum CodingKeys: CodingKey {
        case name
        case coordinate
    }

    // The coding keys for the nested container
    private enum CoordinateCodingKeys: CodingKey {
        case latitude
        case longitude
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        var coordinateContainer = container.nestedContainer(
            keyedBy: CoordinateCodingKeys.self, forKey: .coordinate)
        try coordinateContainer.encode(coordinate.latitude, forKey: .latitude)
        try coordinateContainer.encode(coordinate.longitude, forKey: .longitude)
    }
}

/*:
With this approach, we would have effectively recreated the way the `Coordinate`
type encodes itself inside our original `Placemark` struct, but without exposing
the nested type to the `Codable` system at all. The resulting JSON is identical
in both cases.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
