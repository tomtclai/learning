/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### 3\. Functions can be declared using the `{ }` syntax for closure expressions.

In Swift, you can define functions in two ways. One is with the `func` keyword.
The other way is to use a *closure expression*. Consider this simple function to
double a number:

*/

func doubler(i: Int) -> Int { 
  return i * 2 
}
[1, 2, 3, 4].map(doubler)

/*:
And here's the same function written using the closure expression syntax. Just
like before, we can pass it to `map`:

*/

let doublerAlt = { (i: Int) -> Int in return i*2 }
[1, 2, 3, 4].map(doublerAlt)

/*:
Functions declared as closure expressions can be thought of as *function
literals* in the same way that `1` and `"hello"` are integer and string
literals. They're also anonymous — they aren't named, unlike with the `func`
keyword. The only way they can be used is to assign them to a variable when
they're created (as we do here with `doubler`), or to pass them to another
function or method.

> There's a third way anonymous functions can be used: you can call a function
> directly in line as part of the same expression that defines it. This can be
> useful for defining properties whose initialization requires more than one
> line. We'll see an example of this below in the section on lazy properties.

The doubler declared using the closure expression, and the one declared earlier
using the `func` keyword, are completely equivalent, apart from the differences
in their handling of argument labels we mentioned above. They even exist in the
same "namespace," unlike in some languages.

Why is the `{ }` syntax useful then? Why not just use `func` every time? Well,
it can be a lot more compact, especially when writing quick functions to pass
into other functions, such as `map`. Here's our doubler map example written in a
much shorter form:

*/

[1, 2, 3].map { $0 * 2 }

/*:
This looks very different because we've leveraged several features of Swift to
make code more concise. Here they are one by one:

1.  If you're passing the closure in as an argument and that's all you need it
    for, there's no need to store it in a local variable first. Think of this
    like passing in a numeric expression, such as `5*i`, to a function that
    takes an `Int` as a parameter.

2.  If the compiler can infer a type from the context, you don't need to specify
    it. In our example, the function passed to `map` takes an `Int` (inferred
    from the type of the array elements) and returns an `Int` (inferred from the
    type of the multiplication expression).

3.  If the closure expression's body contains just a single expression, it'll
    automatically return the value of the expression, and you can leave off the
    `return`.

4.  Swift automatically provides shorthand names for the arguments to the
    function — `$0` for the first, `$1` for the second, etc.

5.  If the last argument to a function is a closure expression, you can move the
    expression outside the parentheses of the function call. This *trailing
    closure syntax* is nice if you have a multi-line closure expression, as it
    more closely resembles a regular function definition or other block
    statement such as `if expr { }`.

6.  Finally, if a function has no arguments other than a closure expression, you
    can leave off the parentheses after the function name altogether.

Using each of these rules, we can boil down the expression below to the form
shown above:

*/

[1, 2, 3].map( { (i: Int) -> Int in return i * 2 } )
[1, 2, 3].map( { i in return i * 2 } )
[1, 2, 3].map( { i in i * 2 } )
[1, 2, 3].map( { $0 * 2 } )
[1, 2, 3].map() { $0 * 2 }
[1, 2, 3].map { $0 * 2 }

/*:
If you're new to Swift's syntax, and to functional programming in general, these
compact function declarations might seem daunting at first. But as you get more
comfortable with the syntax and the functional programming style, they'll start
to feel more natural, and you'll be grateful for the ability to remove the
clutter so you can see more clearly what the code is doing. Once you get used to
reading code written like this, it'll be much clearer to you at a glance than
the equivalent code written with a conventional `for` loop.

Sometimes, Swift needs a helping hand with inferring the types. And sometimes,
you may get something wrong and the types aren't what you think they should be.
If ever you get a mysterious error when trying to supply a closure expression,
it's a good idea to write out the full form (first version above), complete with
types. In many cases, that will help clear up where things are going wrong. Once
you have the long form compiling, take the types out again one by one until the
compiler complains. And if the error was yours, you'll have fixed your code in
the process.

Swift will also insist you be more explicit sometimes. For example, you can't
completely ignore input parameters. Suppose you wanted an array of random
numbers. A quick way to do this is to map a range with a function that just
generates random numbers. But you must supply an argument nonetheless. You can
use `_` in such a case to indicate to the compiler that you acknowledge there's
an argument but that you don't care what it is:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
(0..<3).map { _ in arc4random() }

/*:
When you need to explicitly type the variables, you don't have to do it inside
the closure expression. For example, try defining `isEven` without any types:

*/

let isEven = { $0 % 2 == 0 }

/*:
Above, the type of `isEven` is inferred to be `(Int) -> Bool` in the same way
that `let i = 1` is inferred to be `Int` — because `Int` is the default type for
integer literals.

> This is because of a typealias, `IntegerLiteralType`, in the standard library:
> 
> ``` swift-example
> protocol ExpressibleByIntegerLiteral {
>     associatedtype IntegerLiteralType
>     /// Create an instance initialized to `value`.
>     init(integerLiteral value: Self.IntegerLiteralType)
> }
> 
> /// The default type for an otherwise unconstrained integer literal.
> typealias IntegerLiteralType = Int
> ```
> 
> If you were to define your own typealias, it would override the default one
> and change this behavior:
> 
> ``` swift-example
> typealias IntegerLiteralType = UInt32
> let i = 1  // i will be of type UInt32.
> ```
> 
> This is almost certainly a bad idea.

If, however, you needed a version of `isEven` for a different type, you could
type the argument and return value inside the closure expression:

*/

let isEvenAlt = { (i: Int8) -> Bool in i % 2 == 0 }

/*:
But you could also supply the context from *outside* the closure:

*/

let isEvenAlt2: (Int8) -> Bool = { $0 % 2 == 0 }
let isEvenAlt3 = { $0 % 2 == 0 } as (Int8) -> Bool

/*:
Since closure expressions are most commonly used in some context of existing
input or output types, adding an explicit type isn't often necessary, but it's
useful to know.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
