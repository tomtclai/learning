/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### 2\. Functions can *capture* variables that exist outside of their local scope.

When a function references variables outside the function's scope, those
variables are *captured* and stick around after they would otherwise fall out of
scope and be destroyed.

To see this, let's revisit our `returnFunc` function but add a counter that
increases each time we call it:

*/

func counterFunc() -> (Int) -> String {
    var counter = 0
    func innerFunc(i: Int) -> String {
        counter += i   // counter is captured
        return "running total: \(counter)"
    }
    return innerFunc
}

/*:
Normally `counter`, being a local variable of `counterFunc`, would go out of
scope just after the `return` statement, and it'd be destroyed. Instead, because
it's captured by `innerFunc`, the Swift runtime will keep it alive until the
function that captured it gets destroyed. As we discussed in structs and
classes, `counter` will exist on the heap rather than on the stack. We can call
the inner function multiple times, and we see that the running total increases:

*/

let f = counterFunc()
f(3)
f(4)

/*:
If we call `counterFunc()` again, a fresh counter variable will be created and
captured:

*/

let g = counterFunc()
g(2)
g(2)

/*:
This doesn't affect our first function, which still has its own captured version
of `counter`:

*/

f(2)

/*:
Think of these functions combined with their captured variables as similar to
instances of classes with a single method (the function) and some member
variables (the captured variables).

In programming terminology, a combination of a function and an environment of
captured variables is called a *closure*. So `f` and `g` above are examples of
closures, because they capture and use a non-local variable (`counter`) that was
declared outside of them.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
