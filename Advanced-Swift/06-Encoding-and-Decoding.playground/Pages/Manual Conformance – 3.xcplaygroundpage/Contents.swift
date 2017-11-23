/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
To make this work, we can override the `Decodable` initializer and explicitly
catch the error we expect:

*/

// --- (Hidden code block) ---
struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
    // Nothing to implement here
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "(lat: \(latitude), lon: \(longitude))"
    }
}
// ---------------------------
struct Placemark4: Codable {
    var name: String
    var coordinate: Coordinate?

    // encode(to:) is still synthesized by compiler

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        do {
            self.coordinate = try container.decodeIfPresent(Coordinate.self,
                forKey: .coordinate)
        } catch DecodingError.keyNotFound {
            self.coordinate = nil
        }
    }
}

// --- (Hidden code block) ---
extension Placemark4: CustomStringConvertible {
    var description: String {
        return "\(name) \(coordinate.map { String(describing: $0) } ?? "(nil)")"
    }
}
// ---------------------------
/*:
Now the decoder can successfully decode the faulty JSON:

*/

// --- (Hidden code block) ---
let invalidJSONInput = """
    [
      {
        "name" : "Berlin",
        "coordinate": {}
      }
    ]
    """

import Foundation
// ---------------------------
do {
    let inputData = invalidJSONInput.data(using: .utf8)!
    let decoder = JSONDecoder()
    let decoded = try decoder.decode([Placemark4].self, from: inputData)
    decoded
} catch {
    print(error.localizedDescription)
}

/*:
Note that other errors, such as fully corrupted input data or any problem with
the `name` field, will still throw.

This sort of customization is a nice option if only one or two types are
affected, but it doesn't scale well. If a type has dozens of properties, you'll
have to write manual code for each field, even if you only need to customize a
single one. You might also want to read Dave Lyon's [article on the
topic](http://davelyon.net/2017/08/16/jsondecoder-in-the-real-world). Dave came
up with a generic protocol-based solution for exactly this issue. And if you
have control over the input, it's always better to fix the problem at the source
(make the server send valid JSON) rather than doctor with malformed data at a
later stage.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
