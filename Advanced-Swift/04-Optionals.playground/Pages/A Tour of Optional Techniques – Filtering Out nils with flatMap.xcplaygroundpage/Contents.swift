/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Filtering Out `nil`s with `flatMap`

If you have a sequence and it contains optionals, you might not care about the
`nil` values. In fact, you might just want to ignore them.

Suppose you wanted to process only the numbers in an array of strings. This is
easily done in a `for` loop using optional pattern matching:

*/

let numbers = ["1", "2", "3", "foo"]
var sum = 0
for case let i? in numbers.map({ Int($0) }) {
    sum += i
}
sum

/*:
You might also want to use `??` to replace the `nil`s with zeros:

*/

numbers.map { Int($0) }.reduce(0) { $0 + ($1 ?? 0) }

/*:
But really, you just want a version of `map` that filters out `nil` and unwraps
the non-`nil` values. Enter the standard library's overload of `flatMap` on
sequences, which does exactly that:

*/

numbers.flatMap { Int($0) }.reduce(0, +)

/*:
We've already seen two flattening maps: flattening a sequence mapped to arrays,
and flattening an optional mapped to an optional. This is a hybrid of the two:
flattening a sequence mapped to an optional.

This makes sense if we return to our analogy of an optional being a collection
of zero or one thing(s). If that collection were an array, `flatMap` would be
exactly what we want.

To implement our own version of this operation, let's first define a `flatten`
that filters out `nil` values and returns an array of non-optionals:

*/

func flatten_sample_impl<S: Sequence, T>
    (source: S) -> [T] where S.Element == T? {
    let filtered = source.lazy.filter { $0 != nil }
    return filtered.map { $0! }
}

/*:
Ewww, a free function? Why no protocol extension? Unfortunately, there's no way
to constrain an extension on `Sequence` to only apply to sequences of optionals.
You'd need a two-placeholder clause (one for `S`, and one for `T`, as given
here), and protocol extensions currently don't support this.

Nonetheless, it does make `flatMap` simple to write:

*/

extension Sequence {
    func flatMap_sample_impl<U>(transform: (Element) -> U?) -> [U] {
        return flatten_sample_impl(source: self.lazy.map(transform))
    }
}

/*:
In both these functions, we used `lazy` to defer actual creation of the array
until the last moment. This is possibly a micro-optimization, but it might be
worthwhile for larger arrays. Using `lazy` saves the allocation of multiple
buffers that would otherwise be needed to write the intermediary results into.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
