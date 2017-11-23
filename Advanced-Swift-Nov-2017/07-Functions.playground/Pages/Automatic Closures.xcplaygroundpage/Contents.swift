/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Automatic Closures

We're all familiar with how the logical AND operator `&&` evaluates its
arguments. It first evaluates its left operand and immediately returns if that
evaluation yields `false`. Only if the left operand evaluates to `true` is the
right operand evaluated. After all, if the left operand evaluates to `false`,
there's no way the entire expression can evaluate to `true`. This behavior is
called *short-circuiting*. For example, if we want to check if a condition holds
for the first element of an array, we could write the following code:

*/

let evens = [2,4,6]
if !evens.isEmpty && evens[0] > 10 {
    // Perform some work
}

/*:
In the snippet above, we rely on short-circuiting: the array lookup happens only
if the first condition holds. Without short-circuiting, this code would crash on
an empty array.

> A better way to write this particular example is to use an `if let` binding:
> 
> ``` swift
> if let first = evens.first, first > 10 {
>     // Perform some work
> }
> ```
> 
> This is another form of short-circuiting: the second condition is only
> evaluated if the first one succeeds.

In almost all languages, short-circuiting for the `&&` and `||` operators is
built into the language. However, it's often not possible to define your own
operators or functions that have the same behavior. If a language supports
first-class functions, we can fake short-circuiting by providing an anonymous
function instead of a value. For example, let's say we wanted to define an `and`
function in Swift with the same behavior as the `&&` operator:

*/

func and(_ l: Bool, _ r: () -> Bool) -> Bool {
    guard l else { return false }
    return r()
}

/*:
The function above first checks the value of `l` and returns `false` if `l`
evaluates to `false`. Only if `l` is `true` does it return the value that comes
out of the closure `r`. Using it is a little bit uglier than using the `&&`
operator, though, because the right operand now has to be a function:

*/

if and(!evens.isEmpty, { evens[0] > 10 }) {
    // Perform some work
}

/*:
Swift has a nice feature to make this prettier. We can use the `@autoclosure`
attribute to tell the compiler that it should wrap a particular argument in a
closure expression. The definition of `and` is almost the same as above, except
for the added `@autoclosure` annotation:

*/

func and(_ l: Bool, _ r: @autoclosure () -> Bool) -> Bool {
    guard l else { return false }
    return r()
}


/*:
However, the usage of `and` is now much simpler, as we don't need to wrap the
second parameter in a closure. We can just call it as if it took a regular
`Bool` argument, and the compiler transparently wraps the argument in a closure
expression:

*/

if and(!evens.isEmpty, evens[0] > 10) {
    // Perform some work
}

/*:
This allows us to define our own functions and operators with short-circuiting
behavior. For example, operators like `??` and `!?` (as defined in the chapter
on optionals) are now straightforward to write. In the standard library,
functions like `assert` and `fatalError` also use autoclosures in order to only
evaluate the arguments when really needed. By deferring the evaluation of
assertion conditions from the call sites to the body of the `assert` function,
these potentially expensive operations can be stripped completely in optimized
builds where they're not needed.

Autoclosures can also come in handy when writing logging functions. For example,
here's how you could write your own `log` function, which only evaluates the log
message if the condition is `true`:

*/

func log(ifFalse condition: Bool,
    message: @autoclosure () -> (String),
    file: String = #file, function: String = #function, line: Int = #line)
{
    guard !condition else { return }
    print("Assertion failed: \(message()), \(file):\(function) (line \(line))")
}

/*:
This means you can perform expensive computations in the expression you pass as
the message argument without incurring the evaluation cost if the value isn't
used. The `log` function also uses the debugging identifiers `#file`,
`#function`, and `#line`. They're especially useful when used as a default
argument to a function, because they'll receive the values of the filename,
function name, and line number at the call site.

Use autoclosures sparingly, though. Their behavior violates normal expectations
— for example, if a side effect of an expression isn't executed because the
expression is wrapped in an autoclosure. To quote Apple's Swift book:

> Overusing autoclosures can make your code hard to understand. The context and
> function name should make it clear that evaluation is being deferred.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
