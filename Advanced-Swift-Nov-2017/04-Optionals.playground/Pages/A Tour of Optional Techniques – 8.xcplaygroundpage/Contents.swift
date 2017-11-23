/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
Coalescing can also be chained — so if you have multiple possible optionals and
you want to choose the first non-`nil` value, you can write them in sequence:

*/

let i: Int? = nil
let j: Int? = nil
let k: Int? = 42
i ?? j ?? k ?? 0

/*:
Sometimes, you might have multiple optional values and you want to choose
between them in an order, but you don't have a reasonable default if they're all
`nil`. You can still use `??` for this, but if the final value is also optional,
the full result will be optional:

*/

let m = i ?? j ?? k
type(of: m)

/*:
This is often useful in conjunction with `if let`. You can think of this like an
"or" equivalent of `if let`:

*/

if let n = i ?? j { // similar to if i != nil || j != nil
    print(n)
}

/*:
If you think of the `??` operator as similar to an "or" statement, you can think
of an `if let` with multiple clauses as an "and" statement:

*/

if let n = i, let m = j { }
// similar to if i != nil && j != nil

/*:
Because of this chaining, if you're ever presented with a doubly nested optional
and want to use the `??` operator, you must take care to distinguish between `a
?? b ?? c` (chaining) and `(a ?? b) ?? c` (unwrapping the inner and then outer
layers):

*/

let s1: String?? = nil
(s1 ?? "inner") ?? "outer"
let s2: String?? = .some(nil)
(s2 ?? "inner") ?? "outer"

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
