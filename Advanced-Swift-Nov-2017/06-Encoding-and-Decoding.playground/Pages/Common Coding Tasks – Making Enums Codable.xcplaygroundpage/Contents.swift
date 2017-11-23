/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Making Enums Codable

The compiler can synthesize `Codable` conformance for `RawRepresentable` enums
whose `RawValue` type is one of the "native" codable types, namely `Bool`,
`String`, `Float`, `Double`, or one of the integer types. For other enums, such
as those with associated values, you need to implement the requirements
manually.

Let's conform the `Either` enum to `Codable`. `Either` is a very common type for
modeling a value that can be *either* some value of a generic type `A` *or* some
value of another type `B`. Here's the full implementation:

*/

enum Either<A: Codable, B: Codable>: Codable {
    case left(A)
    case right(B)
    
    private enum CodingKeys: CodingKey {
        case left
        case right
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .left(let value):
            try container.encode(value, forKey: .left)
        case .right(let value):
            try container.encode(value, forKey: .right)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let leftValue = try container.decodeIfPresent(A.self, forKey: .left) {
            self = .left(leftValue)
        } else {
            let rightValue = try container.decode(B.self, forKey: .right)
            self = .right(rightValue)
        }
    }
}

/*:
In `encode(to:)`, we check whether we have a *left* or *right* value and encode
it under the corresponding key. Similarly, the `init(from:)` initializer uses
the container's `decodeIfPresent` method to check if the container has a value
for the *left* key. If not, it unconditionally decodes the *right* key, because
one of the two keys must be present.

Ideally, we'd define the type as `enum Either<A, B>` — without any constraints
on the generic type parameters — and then conditionally add the `Codable`
conformance when both generic types are codable themselves, i.e. add `extension
Either: Codable where A: Codable, B: Codable`. Unfortunately, the compiler
doesn't support conditional conformances yet. We went for the easiest
workaround, and that's to add the constraint directly to the type definition.
This is good enough for an example; in production code, however, you probably
can't afford to make `Either` incompatible with all non-codable payloads, so
you'd have to resort to runtime checks. `Array` and other standard library types
[do this
too](https://github.com/apple/swift/blob/e0974640ab9d3cc9237773b96d45b7e1db6a5ab5/stdlib/public/core/Codable.swift#L4033-L4043).

Encoding and decoding a collection of values should be familiar by now. Let's
use `PropertyListEncoder` and `PropertyListDecoder` for a change:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
let values: [Either<String, Int>] = [
    .left("Forty-two"),
    .right(42)
]

do {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    let xmlData = try encoder.encode(values)
    let xmlString = String(decoding: xmlData, as: UTF8.self)

    let decoder = PropertyListDecoder()
    let decoded = try decoder.decode([Either<String, Int>].self, from: xmlData)
} catch {
    print(error.localizedDescription)
}


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
