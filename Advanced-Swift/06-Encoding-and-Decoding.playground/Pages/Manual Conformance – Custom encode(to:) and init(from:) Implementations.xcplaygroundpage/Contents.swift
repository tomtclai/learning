/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Custom `encode(to:)` and `init(from:)` Implementations

If you need more control, there's always the option to implement `encode(to:)`
and/or `init(from:)` yourself. As an example, consider how the decoder deals
with optional values. `JSONEncoder` and `JSONDecoder` can handle optionals out
of the box. That is, if a property of the target type is optional, the decoder
will correctly skip it if no corresponding value exists in the input data.

Here's an alternative definition of the `Placemark` type where the `coordinate`
property is optional:

*/

// --- (Hidden code block) ---
struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
    // Nothing to implement here
}
// ---------------------------
struct Placemark4: Codable {
    var name: String
    var coordinate: Coordinate?
}

/*:
Now our server can send us JSON data where the `"coordinate"` field is missing:

*/

let validJSONInput = """
    [
      { "name" : "Berlin" },
      { "name" : "Cape Town" }
    ]
    """

/*:
When we ask `JSONDecoder` to decode this input into an array of `Placemark4`
values, it'll automatically set the `coordinate` values to `nil`. So far so
good.

However, `JSONDecoder` can be quite picky about the structure of the input data,
and even small deviations from the expected format can trigger a decoding error.
Now suppose the server is configured to send an empty JSON object to signify a
missing optional value, so it sends this piece of JSON:

*/

let invalidJSONInput = """
    [
      {
        "name" : "Berlin",
        "coordinate": {}
      }
    ]
    """

/*:
When we try to decode this, the decoder, expecting the `"latitude"` and
`"longitude"` fields inside the coordinate object, trips over the empty object
and fails with a `.keyNotFound` error:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
do {
    let inputData = invalidJSONInput.data(using: .utf8)!
    let decoder = JSONDecoder()
    let decoded = try decoder.decode([Placemark4].self, from: inputData)
} catch {
    print(error.localizedDescription)
}

// --- (Hidden code block) ---
extension Coordinate: Equatable {
    static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
// ---------------------------

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
