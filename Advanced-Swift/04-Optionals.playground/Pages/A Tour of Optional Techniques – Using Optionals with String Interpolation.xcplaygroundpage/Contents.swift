/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Using Optionals with String Interpolation

You may have noticed that the compiler emits a warning when you print an
optional value or use one in a string interpolation expression:

*/

let bodyTemperature: Double? = 37.0
let bloodGlucose: Double? = nil
print(bodyTemperature)
// Warning: Expression implicitly coerced from 'Double?' to Any
print("Blood glucose level: \(bloodGlucose)")
// Warning: String interpolation produces a debug description
// for an optional value; did you mean to make this explicit?

/*:
This is generally helpful because it's all too easy for a stray
`"Optional(...)"` or `"nil"` to accidentally creep into a text displayed to the
user. You should never use optionals directly in user-facing strings and always
unwrap them first. Since string interpolation is defined for all types
(including `Optional`), the compiler can't make this a hard error, though — a
warning is really the best it can do.

Sometimes you may *want* to use an optional in a string interpolation — to log
its value for debugging, for example — and in that case, the warnings can become
annoying. The compiler offers several fix-its to silence the warning: add an
explicit cast with `as Any`, force-unwrap the value with `!` (if you're certain
it can't be `nil`), wrap it in `String(describing: …)`, or provide a default
value with the `nil`-coalescing operator.

The latter is often a quick and pretty solution, but it has one drawback: the
types on both sides of the `??` expression must match, so the default value you
provide for a `Double?` must be of type `Double`. Since the ultimate goal is to
turn the expression into a string, it'd be convenient if you could provide a
string as a default value in the first place.

Swift's `??` operator doesn't support this kind of type mismatch — after all,
what would the type of the expression be if the two sides didn't have a common
base type? But it's easy to add your own operator, especially for the purpose of
working with optionals in string interpolation. Let's name it `???`:

*/

infix operator ???: NilCoalescingPrecedence

public func ???<T>(optional: T?, defaultValue: @autoclosure () -> String) 
    -> String 
{
    switch optional {
    case let value?: return String(describing: value)
    case nil: return defaultValue()
    }
}

/*:
This takes any optional `T?` on the left side and a string on the right. If the
optional is non-`nil`, we unwrap it and return its string description.
Otherwise, we return the default string that was passed in. The `@autoclosure`
annotation makes sure that we only evaluate the second operand when needed. In
the chapter on functions, we'll go into this in more detail.

Now we can write the following and we won't get any compiler warnings:

*/

print("Body temperature: \(bodyTemperature ??? "n/a")")
print("Blood glucose level: \(bloodGlucose ??? "n/a")")

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
