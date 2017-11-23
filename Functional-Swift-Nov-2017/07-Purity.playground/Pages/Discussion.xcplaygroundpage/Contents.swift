/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Discussion

In this chapter, we've seen how Swift distinguishes between mutable and
immutable values, and between value types and reference types. In this final
section, we want to explain *why* these are important distinctions.

When studying a piece of software, *coupling* measures the degree to which
individual units of code depend on one another. Coupling is one of the single
most important factors that determines how well software is structured. In the
worst case, all classes and methods refer to one another, sharing numerous
mutable variables, or even relying on exact implementation details. Such code
can be very hard to maintain or update: instead of understanding or modifying a
small code fragment in isolation, you constantly need to consider the system in
its totality.

In Objective-C and many other object-oriented languages, it's common for methods
to be coupled through shared instance variables. As a result, however, mutating
the variable may change the behavior of the class's methods. Typically, this is
a good thing — once you change the data stored in an object, all its methods may
refer to its new value. At the same time, however, such shared instance
variables introduce coupling between all the class's methods. If any of these
methods or some external function invalidates the shared state, all the class's
methods may exhibit buggy behavior. It's much harder to test any of these
methods in isolation, as they're now coupled to one another.

Now compare this to the functions that we tested in the QuickCheck chapter. Each
of these functions computed an output value that *only* depended on the input
values. Such functions that compute the same output for equal inputs are
sometimes called *referentially transparent*. By definition, referentially
transparent methods are loosely coupled from their environments: there are no
implicit dependencies on any state or variables, aside from the function's
arguments. Consequently, referentially transparent functions are easier to test
and understand in isolation. Furthermore, we can compose, call, and assemble
functions that are referentially transparent without losing this property.
Referential transparency is a guarantee of modularity and reusability.

Referential transparency increases modularity on all levels. Imagine reading
through an API, trying to figure out how it works. The documentation may be
sparse or out of date. But if you know the API is free of mutable state — all
variables are declared using `let` rather than `var` — this is incredibly
valuable information. You never need to worry about initializing objects or
processing commands in exactly the right order. Instead, you can just look at
types of the functions and constants that the API defines and how these can be
assembled to produce the desired value.

Swift's distinction between `var` and `let` enables programmers not only to
distinguish between mutable and immutable data, but also to have the compiler
enforce this distinction. Favoring `let` over `var` reduces the complexity of
the program — you no longer have to worry about what the current value of
mutable variables is, but can simply refer to their immutable definitions.
Favoring immutability makes it easier to write referentially transparent
functions, and ultimately, it reduces coupling.

Similarly, Swift's distinction between value types and reference types
encourages you to distinguish between mutable objects that may change and
immutable data that your program manipulates. Functions are free to copy,
change, or share values — any modifications will only ever affect their local
copies. Once again, this helps write code that's more loosely coupled, as any
dependencies resulting from shared state or objects can be eliminated.

Can we do without mutable variables entirely? Pure programming languages, such
as Haskell, encourage programmers to avoid using mutable state altogether. There
are certainly large Haskell programs that don't use any mutable state. In Swift,
however, dogmatically avoiding `var` at all costs won't necessarily make your
code better. There are plenty of situations where a function uses some mutable
state internally. Consider the following example function that sums the elements
of an array:

*/

func sum(integers: [Int]) -> Int {
    var result = 0
    for x in integers {
        result += x
    }
    return result
}

/*:
The `sum` function uses a mutable variable, `result`, that's repeatedly updated.
Yet the *interface* exposed to the user hides this fact. The `sum` function is
still referentially transparent, and it's arguably easier to understand than a
convoluted definition avoiding mutable variables at all costs. This example
illustrates a *benign* usage of mutable state.

Such benign mutable variables have many applications. Consider the `qsort`
method defined in the QuickCheck chapter:

``` swift-example
func qsort(_ input: [Int]) -> [Int] {
    if input.isEmpty { return [] }
    var array = input
    let pivot = array.removeLast()
    let lesser = array.filter { $0 < pivot }
    let greater = array.filter { $0 >= pivot }
    return qsort(lesser) + [pivot] + qsort(greater)
}
```

Although this method mostly avoids using mutable references, it doesn't run in
constant memory. It allocates new arrays, `lesser` and `greater`, which are
combined to produce the final result. Of course, by using a mutable array, we
can define a version of Quicksort that runs in constant memory and is still
referentially transparent. Clever usage of mutable variables can sometimes
improve performance or memory usage.

In summary, Swift offers several language features specifically designed to
control the usage of mutable state in your program. It's almost impossible to
avoid mutable state altogether, but mutation is used excessively and
unnecessarily in many programs. Learning to avoid mutable state and objects
whenever possible can help reduce coupling, thereby improving the structure of
your code.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
