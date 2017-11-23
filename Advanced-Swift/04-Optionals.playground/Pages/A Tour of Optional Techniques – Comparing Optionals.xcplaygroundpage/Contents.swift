/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Comparing Optionals

Similar to `==`, there used to be implementations of `<`, `>`, `<=`, and `>=`
for optionals. For Swift 3.0, these comparison operators were [removed for
optionals](https://github.com/apple/swift-evolution/blob/master/proposals/0121-remove-optional-comparison-operators.md)
because they can easily yield unexpected results.

For example, `nil < .some(_)` would return `true`. In combination with
higher-order functions or optional chaining, this can be very surprising.
Consider the following example:

``` swift-example
let temps = ["-459.67", "98.6", "0", "warm"]
let belowFreezing = temps.filter { Double($0) < 0 }
```

Because `Double("warm")` will return `nil` and `nil` is less than `0`, it'll be
included in the `belowFreezing` temperatures. This is unexpected indeed.

If you need inequality relations between optionals, you now have to unwrap the
values first and thereby explicitly state how `nil` values should be handled.
We'll show an example of this in the chapter on functions, where we define a
generic function that "lifts" a regular comparison function into the domain of
optionals.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
