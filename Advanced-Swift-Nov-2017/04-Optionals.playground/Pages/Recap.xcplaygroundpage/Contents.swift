/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Recap

Optionals are touted as one of Swift's biggest features for writing safer code,
and we certainly agree. If you think about it though, the real breakthrough
isn't optionals — it's *non-optionals*. Almost every mainstream language has the
concept of "null" or "nil"; what most of them don't have is the ability to
declare a value as "never nil." Or, alternatively, some types (like non-class
types in Objective-C or Java) are "always non-nil," forcing developers to come
up with magic values to represent the absence of a value.

APIs whose inputs and outputs are carefully designed with optionals in mind are
more expressive and easier to use; there's less need to refer to the
documentation because the types carry more information.

All the unwrapping techniques we demonstrated in this chapter are Swift's
attempt to make bridging the two worlds of optional and non-optional values as
painless as possible. Which method you should use is often a matter of personal
preference.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
