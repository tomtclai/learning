/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Decoding

The decoding counterpart for `JSONEncoder` is `JSONDecoder`. Decoding follows
the same pattern as encoding: create a decoder and pass it something to decode.
`JSONDecoder` expects a `Data` instance containing UTF-8-encoded JSON text, but
as we just saw with encoders, other decoders may have different interfaces:

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

extension Coordinate: Equatable {
    static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension Placemark: Equatable {
    static func ==(lhs: Placemark, rhs: Placemark) -> Bool {
        return lhs.name == rhs.name && lhs.coordinate == rhs.coordinate
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
let jsonData = try! encoder.encode(places)
// ---------------------------
do {
    let decoder = JSONDecoder()
    let decoded = try decoder.decode([Placemark].self, from: jsonData)
    type(of: decoded)
    decoded == places
} catch {
    print(error.localizedDescription)
}


/*:
Notice that `decoder.decode(_:from:)` takes two arguments. In addition to the
input data, we also have to specify the type we expect to get back (here it's
`[Placemark].self`). This allows for full compile-time type safety. The tedious
conversion from weakly typed JSON data to the concrete data types we use in our
code happens behind the scenes.

Making the decoded type an explicit argument of the decoding method is a
deliberate design choice. This wasn't strictly necessary, as the compiler
would've been able to infer the correct type automatically in many situations,
but the Swift team decided that the increase in clarity and avoidance of
ambiguity was more important than maximum conciseness.

Even more so than during encoding, error handling is extremely important during
decoding. There are so many things that can go wrong — from missing data (a
required field is missing in the JSON input), to type mismatches (the server
unexpectedly encodes numbers as strings), to fully corrupted data. Check out the
documentation for the `DecodingError` type to see what other errors you can
expect.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
