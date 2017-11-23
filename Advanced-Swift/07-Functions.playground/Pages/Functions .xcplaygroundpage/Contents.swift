/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
# Functions 

To open this chapter, let's recap some main points regarding functions. If
you're already very familiar with first-class functions, feel free to skip ahead
to the next section. But if you're even slightly hazy, skim through what's
below.

To understand functions and closures in Swift, you really need to understand
three things, in roughly this order of importance:

1.  Functions can be assigned to variables and passed in and out of other
    functions as arguments, just as an `Int` or a `String` can be.

2.  Functions can *capture* variables that exist outside of their local scope.

3.  There are two ways of creating functions — either with the `func` keyword,
    or with `{ }`. Swift calls the latter *closure expressions*.

Sometimes people new to the topic of closures come at it in reverse order and
maybe miss one of these points, or conflate the terms *closure* and *closure
expression* — and this can cause a lot of confusion. It's a three-legged stool,
and if you miss one of the three points above, you'll fall over when you try to
sit
down.

#### 1\. Functions can be assigned to variables and passed in and out of other functions as arguments.

In Swift, as in many modern languages, functions are referred to as "first-class
objects." You can assign functions to variables, and you can pass them in and
out of other functions to be called later.

This is *the most important thing* to understand. "Getting" this for functional
programming is akin to "getting" pointers in C. If you don't quite grasp this
part, everything else will just be noise.

Let's start with a function that simply prints an integer:

*/

func printInt(i: Int) {
    print("you passed \(i)")
}

/*:
To assign the function to a variable, `funVar`, we just use the function name as
the value. Note the absence of parentheses after the function name:

*/

let funVar = printInt

/*:
Now we can call the `printInt` function using the `funVar` variable. Note the
use of parentheses after the variable name:

*/

funVar(2)

/*:
It's also noteworthy that we *must not* include an argument label in the
`funVar` call, whereas `printInt` calls *require* the argument label, as in
`printInt(i: 2)`. Swift [only allows argument
labels](https://github.com/apple/swift-evolution/blob/master/proposals/0111-remove-arg-label-type-significance.md)
in function *declarations*; the labels aren't included in a function's *type*.
This means that you currently can't assign argument labels to a variable of a
function type, though this will [likely change in a future Swift
version](https://lists.swift.org/pipermail/swift-evolution-announce/2016-July/000233.html).

We can also write a function that takes a function as an argument:

*/

func useFunction(function: (Int) -> () ) {
    function(3)
}

useFunction(function: printInt)
useFunction(function: funVar)

/*:
Why is being able to treat functions like this such a big deal? Because it
allows you to easily write "higher-order" functions, which take functions as
arguments and apply them in useful ways, as we saw in the chapter on built-in
collections.

Functions can also return other functions:

*/

func returnFunc() -> (Int) -> String {
    func innerFunc(i: Int) -> String {
        return "you passed \(i)"
    }
    return innerFunc
}
let myFunc = returnFunc()
myFunc(3)


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
