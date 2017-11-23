/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### Parameterizing Behavior with Functions

Even if you're already familiar with `map`, take a moment and consider the `map`
code. What makes it so general yet so useful?

`map` manages to separate out the boilerplate — which doesn't vary from call to
call — from the functionality that always varies: the logic of how exactly to
transform each element. It does this through a parameter the caller supplies:
the transformation function.

This pattern of parameterizing behavior is found throughout the standard
library. There are more than a dozen separate functions that take a function
that allows the caller to customize the key step:

  - **`map`** and **`flatMap`** — how to transform an element

  - **`filter`** — should an element be included?

  - **`reduce`** — how to fold an element into an aggregate value

  - **`sequence`** — what should the next element of the sequence be?

  - **`forEach`** — what side effect to perform with an element

  - **`sort`**, **`lexicographicallyPrecedes`**, and **`partition`** — in what
    order should two elements come?

  - **`index`**, **`first`**, and **`contains`** — does this element match?

  - **`min`** and **`max`** — which is the min/max of two elements?

  - **`elementsEqual`** and **`starts`** — are two elements equivalent?

  - **`split`** — is this element a separator?

  - **`prefix`** — filter elements while a predicate returns true, then drop the
    rest (similar to `filter`, but with an early exit, and useful for infinite
    or lazily computed sequences)

  - **`drop`** — drop elements until the predicate ceases to be true, and then
    return the rest (similar to `prefix`, but this returns the inverse)

The goal of all these functions is to get rid of the clutter of the
uninteresting parts of the code, such as the creation of a new array, the `for`
loop over the source data, and the like. Instead, the clutter is replaced with a
single word that describes what's being done. This brings the important code –
the logic the programmer wants to express – to the forefront.

Several of these functions have a default behavior. `sort` sorts elements in
ascending order when they're comparable, unless you specify otherwise.
`contains` can take a value to check for, so long as the elements are equatable.
These defaults help make the code even more readable. Ascending order sort is
natural, so the meaning of `array.sort()` is intuitive. `array.index(of: "foo")`
is clearer than `array.index { $0 == "foo" }`.

But in every instance, these are just shorthand for the common cases. Elements
don't have to be comparable or equatable, and you don't have to compare the
whole element — you can sort an array of people by their ages (`people.sort {
$0.age < $1.age }`) or check if the array contains anyone underage
(`people.contains { $0.age < 18 }`). You can also compare some transformation of
the element. For example, an admittedly inefficient case-insensitive sort could
be performed via `people.sort { $0.name.uppercased() < $1.name.uppercased() }`.

There are other functions of similar usefulness that would also take a function
to specify their behaviors but aren't in the standard library. You could easily
define them yourself (and might like to try):

  - **`accumulate`** — combine elements into an array of running values (like
    `reduce`, but returning an array of each interim combination)

  - **`all(matching:)`** and **`none(matching:)`** — test if all or no elements
    in a sequence match a criterion (can be built with `contains`, with some
    carefully placed negation)

  - **`count(where:)`** — count the number of elements that match (similar to
    `filter`, but without constructing an array)

  - **`indices(where:)`** — return a list of indices matching a criteria
    (similar to `index(where:)`, but doesn't stop on the first one)

Some of these we define elsewhere in the book.

You might find yourself writing something that fits a pattern more than a couple
of times — something like this, where you search an array in reverse order for
the first element that matches a certain condition:

*/

let names = ["Paula", "Elena", "Zoe"]

var lastNameEndingInA: String?
for name in names.reversed() where name.hasSuffix("a") {
    lastNameEndingInA = name
    break
}
lastNameEndingInA

/*:
If that's the case, consider writing a short extension to `Sequence`. The method
`last(where:)` wraps this logic — we use a function argument to abstract over
the part of our `for` loop that varies:

*/

extension Sequence {
    func last(where predicate: (Element) -> Bool) -> Element? {
        for element in reversed() where predicate(element) {
            return element
        }
        return nil
    }
}

/*:
This then allows you to replace your `for` loop with the following:

*/

let match = names.last { $0.hasSuffix("a") }
match

/*:
This has all the same benefits we described for `map`. The example with
`last(where:)` is more readable than the example with the `for` loop; even
though the `for` loop is simple, you still have to run the loop through in your
head, which is a small mental tax. Using `last(where:)` introduces less chance
of error (such as accidentally forgetting to reverse the array), and it allows
you to declare the result variable with `let` instead of `var`.

It also works nicely with `guard` — in all likelihood, you're going to terminate
a flow early if the element isn't found:

``` swift-example
guard let match = someSequence.last(where: { $0.passesTest() })
    else { return }
// Do something with match
```

We'll say more about extending collections and using functions later in the
book.

*/


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
