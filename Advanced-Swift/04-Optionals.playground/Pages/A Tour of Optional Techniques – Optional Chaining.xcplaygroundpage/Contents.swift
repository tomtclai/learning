/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Optional Chaining

In Objective-C, sending a message to `nil` is a no-op. In Swift, the same effect
can be achieved via "optional chaining":

``` swift-example
delegate?.callback()
```

Unlike with Objective-C, though, the Swift compiler will force you to
acknowledge that the receiver could be `nil`. The question mark is a clear
signal to the reader that the method might not be called.

When the method you call via optional chaining returns a result, that result
will also be optional. Consider the following code to see why this must be the
case:

*/

let str: String? = "Never say never"
// We want upper to be the uppercase string
let upper: String
if str != nil {
    upper = str!.uppercased()
} else {
    // No reasonable action to take at this point
    fatalError("No idea what to do now...")
}

/*:
If `str` is non-`nil`, `upper` will have the desired value. But if `str` is
`nil`, then `upper` can't be set to a value. So in the optional chaining case,
`result` *must* be optional, in order to account for the possibility that `str`
could've been `nil`:

*/

let result = str?.uppercased()

/*:
As the name implies, you can chain calls on optional values:

*/

let lower = str?.uppercased().lowercased()

/*:
This might look a bit surprising. Didn't we just say that the result of optional
chaining is an optional? So why don't you need a `?.` after `uppercased()`? This
is because optional chaining is a "flattening" operation. If `str?.uppercased()`
returned an optional and you called `?.lowercased()` on it, then logically you'd
get an optional optional. But you just want a regular optional, so instead we
write the second chained call without the question mark to represent the fact
that the optionality is already captured.

On the other hand, if the `uppercased` method itself returned an optional, then
you *would* need to add a second `?` to express that you were chaining *that*
optional. For example, let's extend the `Int` type with a computed property
named `half`. This property returns the result of dividing the integer by two,
but only if the number is big enough to be divided. When the number is smaller
than two, it returns `nil`:

*/

extension Int {
    var half: Int? {
        guard self < -1 || self > 1 else { return nil }
        return self / 2
    }
}

/*:
Because calling `half` returns an optional result, we need to keep putting in
`?` when calling it repeatedly. After all, at every step, the function might
return `nil`:

*/

20.half?.half?.half

/*:
Notice that the compiler is still smart enough to flatten the result type for
us. The type of the expression above is `Int?` and not `Int???`, as you might
expect. The latter would give you more information — namely, which part of the
chain failed — but it would also make it a lot more cumbersome to deal with the
result, destroying the convenience optional chaining adds in the first place.

Optional chaining also applies to subscripts — for example:

*/

let dictOfArrays = ["nine": [0, 1, 2, 3]]
dictOfArrays["nine"]?[3]

/*:
Additionally, you can use optional chaining to call optional functions:

*/

let dictOfFunctions: [String: (Int, Int) -> Int] = [
    "add": (+),
    "subtract": (-)
]
dictOfFunctions["add"]?(1, 1)

/*:
This is handy in typical callback situations where a class stores a callback
function in order to inform its owner when an event occurs. Consider a
`TextField` class:

*/

class TextField {
    private(set) var text = ""
    var didChange: ((String) -> ())?

    private func textDidChange(newText: String) {
        text = newText
        // Trigger callback if non-nil
        didChange?(text)
    }
}

/*:
The `didChange` property stores a callback function, which the text field calls
every time the user edits the text. Because the text field's owner doesn't have
to register a callback, the property is optional; its initial value is `nil`.
When the time comes to invoke the callback (in the `textDidChange` method
above), optional chaining lets us do so in a very compact way.

You can even assign *through* an optional chain. Suppose you have an optional
variable, and if it's non-`nil`, you wish to update one of its properties:

*/

struct Person {
    var name: String
    var age: Int
}

var optionalLisa: Person? = Person(name: "Lisa Simpson", age: 8)
// Increment age if non-nil
if optionalLisa != nil {
    optionalLisa!.age += 1
}

/*:
This is rather verbose and ugly. Note that you can't use optional binding in
this case. Since `Person` is a struct and thus a value type, the bound variable
is a local copy of the original value; mutating the former won't change the
latter:

*/

if var lisa = optionalLisa {
    // Mutating lisa doesn't change optionalLisa
    lisa.age += 1
}

/*:
This *would* work if `Person` were a class. We'll talk more about the
differences between value and reference types in the structs and classes
chapter. Regardless, it's still too verbose. Instead, you can assign to the
chained optional value, and if it isn't `nil`, the assignment will go through:

*/

optionalLisa?.age += 1

/*:
A weird (but logical) edge case of this feature is that it works for direct
assignment to optional values. This is perfectly valid:

*/

var a: Int? = 5
a? = 10
a

var b: Int? = nil
b? = 10
b

/*:
Notice the subtle difference between `a = 10` and `a? = 10`. The former assigns
a new value unconditionally, whereas the latter only performs the assignment if
the value of `a` is non-`nil` *before* the assignment.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
