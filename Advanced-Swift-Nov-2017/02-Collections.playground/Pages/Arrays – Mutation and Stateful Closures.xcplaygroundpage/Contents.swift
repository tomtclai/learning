/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### Mutation and Stateful Closures

When iterating over an array, you could use `map` to perform side effects (e.g.
inserting the elements into some lookup table). We don't recommend doing this.
Take a look at the following:

``` swift-example
array.map { item in
    table.insert(item)
}
```

This hides the side effect (the mutation of the lookup table) in a construct
that looks like a transformation of the array. If you ever see something like
the above, then it's a clear case for using a plain `for` loop instead of a
function like `map`. The `forEach` method would also be more appropriate than
`map` in this case, but it has its own issues. We'll look at `forEach` in a bit.

Performing side effects is different than deliberately giving the closure
*local* state, which is a particularly useful technique, and it's what makes
closures — functions that can capture and mutate variables outside their scope —
so powerful a tool when combined with higher-order functions. For example, the
`accumulate` function described above could be implemented with `map` and a
stateful closure, like this:

*/

extension Array {
    func accumulate<Result>(_ initialResult: Result, 
        _ nextPartialResult: (Result, Element) -> Result) -> [Result] 
    {
        var running = initialResult
        return map { next in
            running = nextPartialResult(running, next)
            return running
        }
    }
}

/*:
This creates a temporary variable to store the running value and then uses `map`
to create an array of the running values as the computation progresses:

*/

[1,2,3,4].accumulate(0, +)

/*:
Note that this code assumes that `map` performs its transformation in order over
the sequence. In the case of our `map` above, it does. But there are possible
implementations that could transform the sequence out of order — for example,
one that performs the transformation of the elements concurrently. The official
standard library version of `map` doesn't specify whether or not it transforms
the sequence in order, though it seems like a safe bet.

*/


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
