/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Hashable Requirement

Dictionaries are [hash tables](https://en.wikipedia.org/wiki/Hash_table). The
dictionary assigns each key a position in its underlying storage array based on
the key's `hashValue`. This is why `Dictionary` requires its `Key` type to
conform to the `Hashable` protocol. All the basic data types in the standard
library already do, including strings, integers, floating-point, and Boolean
values. Enumerations without associated values also get automatic `Hashable`
conformance for free.

If you want to use your own custom types as dictionary keys, you must add
`Hashable` conformance manually. This requires an implementation of the
`hashValue` property and, because `Hashable` extends `Equatable`, an overload of
the `==` operator function for your type. Your implementation must hold an
important invariant: two instances that are equal (as defined by your `==`
implementation) *must* have the same hash value. The reverse isn't true: two
instances with the same hash value don't necessarily compare equally. This makes
sense, considering that there's only a finite number of distinct hash values,
while many hashable types (like strings) have essentially infinite cardinality.

The potential for duplicate hash values means that `Dictionary` must be able to
handle collisions. Nevertheless, a good hash function should strive for a
minimal number of collisions in order to preserve the collection's performance
characteristics, i.e. the hash function should produce a uniform distribution
over the full integer range. In the extreme case where your implementation
returns the same hash value (e.g. zero) for every instance, a dictionary's
lookup performance degrades to `O(n)`.

The second characteristic of a good hash function is that it's fast. Keep in
mind that the hash value is computed every time a key is inserted, removed, or
looked up. If your `hashValue` implementation takes too much time, it might eat
up any gains you got from the `O(1)` complexity.

Writing a good hash function that meets these requirements isn't easy.
Fortunately, soon we won't have to do this ourselves in most situations, as
there's an accepted proposal for [synthesizing `Equatable` and `Hashable`
conformance](https://github.com/apple/swift-evolution/blob/master/proposals/0185-synthesize-equatable-hashable.md).
Once this feature is fully implemented and merged, we can instruct the compiler
to automatically generate both `Equatable` and `Hashable` conformance for our
custom types.

Finally, be extra careful when you use types that don't have value semantics
(e.g. mutable objects) as dictionary keys. If you mutate an object after using
it as a dictionary key in a way that changes its hash value and/or equality,
you'll not be able to find it again in the dictionary. The dictionary now stores
the object in the wrong slot, effectively corrupting its internal storage. This
isn't a problem with value types because the key in the dictionary doesn't share
your copy's storage and therefore can't be mutated from the outside.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
