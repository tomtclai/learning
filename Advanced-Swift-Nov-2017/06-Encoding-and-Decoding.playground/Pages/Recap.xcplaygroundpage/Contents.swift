/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Recap

The ability to seamlessly convert between your program's native types and common
data formats with minimal code — at least for the common case — is a very
welcome addition to Swift. The `Codable` system becomes even more powerful if
you can use Swift on both client and server: using the same types everywhere
ensures all platforms will produce compatible encoding formats. Overriding the
default behavior is always possible, if sometimes inconvenient when you need to
handle non-`Codable` types you haven't defined yourself. The Swift team is
already [exploring more customization
options](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20171016/040589.html),
such as the ability to rewrite keys from `camelCase` to `snake_case` without
having to touch every single type.

The system shines when you use it for the task it was designed for — working
with uniform data in a known format in a fully type-safe manner. Swift does
everything it can to hide the loosely typed dictionary-like data you'd get from
a traditional JSON parser. In the rare cases where you'd rather work with a
`[String: Any]` dictionary (maybe because you don't know the exact data format),
don't try to intertwine the two worlds unnecessarily. The old-school method via
`JSONSerialization` still exists.

We only discussed traditional archiving tasks in this chapter, but it's worth
thinking outside the box to find other applications that can profit from a
standardized way to reduce values to primitive data and vice versa. For example,
you could write [an encoder that computes a hash
value](https://gist.github.com/phausler/6c61343a609aeeb9a8f890f1fe2acc17) from
the encoded data and use that to automatically conform codable types to
`Hashable`. This effectively uses the `Codable` system as a replacement for
reflection. Or you could write [a decoder that can produce random
values](https://github.com/pointfreeco/swift-quickcheck/pull/2) for each of the
primitive data types and use that to generate randomized test data for your unit
tests.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
