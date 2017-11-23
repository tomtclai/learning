/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### Iteration using `forEach`

The final operation we'd like to discuss is `forEach`. It works almost like a
`for` loop: the passed-in function is executed once for each element in the
sequence. And unlike `map`, `forEach` doesn't return anything. Let's start by
mechanically replacing a loop with `forEach`:

*/

for element in [1,2,3] {
    print(element)
}

[1,2,3].forEach { element in
    print(element)
}

/*:
This isn't a big win, but it can be handy if the action you want to perform is a
single function call on each element in a collection. Passing a function name to
`forEach` instead of a closure expression can lead to clear and concise code.
For example, if you're inside a view controller and want to add an array of
subviews to the main view, you can just do `theViews.forEach(view.addSubview)`.

However, there are some subtle differences between `for` loops and `forEach`.
For instance, if a `for` loop has a `return` statement in it, rewriting it with
`forEach` can significantly change the code's behavior. Consider the following
example, which is written using a `for` loop with a `where` condition:

*/

extension Array where Element: Equatable {
    func index_sample_impl(of element: Element) -> Int? {
        for idx in self.indices where self[idx] == element {
            return idx
        }
        return nil
    }
}

/*:
We can't directly replicate the `where` clause in the `forEach` construct, so we
might (incorrectly) rewrite this using `filter`:

``` swift-example
extension Array where Element: Equatable {
    func index_foreach(of element: Element) -> Int? {
        self.indices.filter { idx in
            self[idx] == element
        }.forEach { idx in
            return idx
        }
        return nil
    }
}
```

The `return` inside the `forEach` closure doesn't return out of the outer
function; it only returns from the closure itself. In this particular case, we'd
probably have found the bug because the compiler generates a warning that the
argument to the `return` statement is unused, but you shouldn't rely on it
finding every such issue.

Also, consider the following simple example:

*/

(1..<10).forEach { number in
    print(number)
    if number > 2 { return }
}

/*:
It's not immediately obvious that this prints out all the numbers in the input
range. The `return` statement isn't breaking the loop, rather it's returning
from the closure.

In some situations, such as the `addSubview` example above, `forEach` can be
nicer than a `for` loop. However, because of the non-obvious behavior with
`return`, we recommend against most other uses of `forEach`. Just use a regular
`for` loop instead.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
