/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Decoding Polymorphic Collections

We've seen that decoders require us to pass in the *concrete type* of the value
that's being decoded. This makes intuitive sense: the decoder needs a concrete
type to figure out which initializer to call, and since the encoded data
typically doesn't contain type information, the type must be provided by the
caller. A consequence of this focus on strong typing is that there's no
polymorphism in the decode step.

Suppose we want to encode an array of views, where the actual instances are
`UIView` subclasses such as `UILabel` or `UIImageView`:

``` swift-example
let views: [UIView] = [label, imageView, button]
```

(Let's assume for a moment that `UIView` and all its subclasses conform to
`Codable`, which they currently don't.)

If we'd encode this array and then decode it again, it wouldn't come out in
identical form — the concrete types of the array elements wouldn't survive. The
decoder would only produce plain `UIView` objects because all it knows is that
the type of the decoded data must be `[UIView].self`.

So how can we encode such a collection of polymorphic objects? The best option
is to define an enum with one case per subclass we want to support. The payloads
of the enum cases store the actual objects:

``` swift-example
enum View {
    case view(UIView)
    case label(UILabel)
    case imageView(UIImageView)
    // ...
}
```

We then have to manually write a `Codable` implementation that follows a pattern
similar to the `Either` enum in the previous section:

  - During encoding, switch over all cases to figure out which type of object we
    need to encode. Then encode the object's type and the object itself under
    separate keys.

  - During decoding, decode the type information first and select the concrete
    type to initialize based on that.

Finally, we should write two convenience functions for wrapping a `UIView` in a
`View` value, and vice versa. That way, passing the source array to the encoder
and getting it from the decoder only takes a single `map`.

Observe that this isn't a dynamic solution; we'll have to manually update the
`View` enum every time we want to support another subclass. This is
inconvenient, but it does make sense that we're forced to explicitly name every
type our code can accept from a decoder. Anything else would be a potential
security risk, because an attacker could use a manipulated archive to
instantiate unknown objects in our program.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
