/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Encoding

Swift ships with two built-in encoders, `JSONEncoder` and `PropertyListEncoder`
(these are defined in Foundation and not in the standard library). In addition,
codable types are compatible with Cocoa's `NSKeyedArchiver`. We'll focus on
`JSONEncoder` because JSON is the most common format.

Here's how we can encode an array of `Placemark` values to JSON:

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

import Foundation
// ---------------------------
let places = [
	Placemark(name: "Berlin", coordinate: 
        Coordinate(latitude: 52, longitude: 13)),
	Placemark(name: "Cape Town", coordinate: 
        Coordinate(latitude: -34, longitude: 18))
]

do {
    let encoder = JSONEncoder()
    let jsonData = try encoder.encode(places)
    let jsonString = String(decoding: jsonData, as: UTF8.self)
} catch {
    print(error.localizedDescription)
}

/*:
The actual encoding step is exceedingly simple: create and (optionally)
configure the encoder, and pass it the value to encode. The JSON encoder returns
a collection of bytes in the form of a `Data` instance, which we then convert
into a string for display.

In addition to a property for configuring the output formatting (pretty-printed
and/or keys sorted lexicographically), `JSONEncoder` provides customization
options for formatting dates (including ISO 8601 or Unix epoch timestamp) and
`Data` values (e.g. Base64), as well as how exceptional floating-point values
(infinity and *not a number*) should be treated. These options always apply to
the entire hierarchy of values being encoded, i.e. you can't use them to specify
that a `Date` in one type should follow a different encoding scheme than one in
another type. If you need that kind of granularity, you have to write custom
`Codable` implementations for the affected types.

It's worth noting that all of these configuration options are specific to
`JSONEncoder`. Other encoders will have different options (or none at all). Even
the `encode(_:)` method is encoder-specific and not defined in any of the
protocols. Other encoders might decide to return a `String` or even a `URL` to
the encoded file instead of a `Data` value.

In fact, `JSONEncoder` doesn't even conform to the `Encoder` protocol. Instead,
it's a wrapper around a private class named `_JSONEncoder` that implements the
protocol and does the actual encoding work. It was designed in this way because
the top-level encoder should provide an entirely different API (namely, a single
method to start the encoding process) than the `Encoder` object that's being
passed to codable types during the encoding process. Separating these tasks
cleanly means clients can only access the APIs that are appropriate in any given
situation — for example, a codable type can't reconfigure the encoder in the
middle of the encoding process because the public configuration API is only
exposed by the top-level encoder.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
