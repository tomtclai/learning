/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## The `@escaping` Annotation

As we saw in the previous chapter, we need to be careful about memory when
dealing with functions. Recall the capture list example, where we needed to mark
`view` as `weak` in order to prevent a reference cycle:

``` swift-example
window?.onRotate = { [weak view] in
    print("We now also need to update the view: \(view)")
}
```

However, we never marked anything as `weak` when we used functions like `map`.
This isn't necessary because the compiler knows that `map` will never create a
reference cycle: it's executed synchronously and the closure never leaves
`map`'s scope. The difference between the closure we store in `onRotate` and the
closure we pass to `map` is that the first closure *escapes*.

A closure that's stored somewhere to be called later (for example, after a
function returns) is said to be *escaping*. The closure that gets passed to
`map` only gets used directly within `map`. This means that the compiler doesn't
need to change the reference count of the captured variables.

Closures are non-escaping by default. If you want to store a closure for later
use, you need to mark the closure argument as `@escaping`. The compiler will
verify this: unless you mark the closure argument as `@escaping`, it won't allow
you to store the closure (or return it to the caller, for example). In the sort
descriptors example, there were multiple function parameters that required the
`@escaping` attribute:

``` swift-example
func sortDescriptor<Value, Key>(
    key: @escaping (Value) -> Key,
    by areInIncreasingOrder: @escaping (Key, Key) -> Bool)
    -> SortDescriptor<Value>
{
    return { areInIncreasingOrder(key($0), key($1)) }
}
```

> Before Swift 3, it was the other way around: escaping was the default, and you
> had the option to mark a closure as `@noescape`. The current behavior is
> better because it's safe by default: a function argument now needs to be
> explicitly annotated to signal the potential for reference cycles. The
> `@escaping` annotation serves as a warning to the developer using the
> function. This is also the reason why the compiler enforces the use of `self.`
> for accessing members in escaping closures — the developer must explicitly opt
> into capturing a strong reference. Lastly, non-escaping closures can be
> optimized much better by the compiler, making the fast path the norm you have
> to explicitly deviate from if necessary.

Note that the non-escaping-by-default rule only applies to function parameters,
and then only for function types in *immediate parameter position*. This means
stored properties that have a function type are always escaping (which makes
sense). Surprisingly, the same is true for functions that *are* used as
parameters, but are wrapped in some other type, such as a tuple or an optional.
Since the closure is no longer an *immediate* parameter in this case, it
automatically becomes escaping. As a consequence, you can't write a function
that takes a function argument where the parameter is both optional and
non-escaping. In many situations, you can avoid making the argument optional by
providing a default value for the closure. If that's not possible, a workaround
is to use overloading to write two variants of the function — one with an
optional (escaping) function parameter, and one with a non-optional,
non-escaping parameter:

*/

func transform(_ input: Int, with f: ((Int) -> Int)?) -> Int {
    print("Using optional overload")
    guard let f = f else { return input }
    return f(input)
}

func transform(_ input: Int, with f: (Int) -> Int) -> Int {
    print("Using non-optional overload")
    return f(input)
}

/*:
This way, calling the function with a `nil` argument (or a variable of optional
type) will use the optional variant, whereas passing a literal closure
expression will invoke the non-escaping, non-optional overload.

*/

transform(10, with: nil)
transform(10) { $0 * $0 }

/*:
### `withoutActuallyEscaping`

You may run into a situation where you *know* that a closure doesn't escape but
the compiler can't *prove* it, forcing you to add an `@escaping` annotation. In
this example, we extend `Array` with a method that returns `true` if and only if
all elements satisfy the given predicate. We already defined this method in the
chapter on built-in collections.

Let's try a different implementation here: we first create a *lazy view* of the
array (not to be confused with the lazy properties we discussed above) before
applying a filter and checking whether any element got through the filter (i.e.
whether at least one element didn't satisfy the predicate). The purpose of doing
the operations lazily is that evaluation can stop as soon as the first mismatch
is found. Our first attempt at implementing this fails to compile because the
`filter` method on a lazy collection view takes an escaping closure:

``` swift-example
extension Array {
    func all(matching predicate: (Element) -> Bool) -> Bool {
        // Error: parameter 'predicate' is implicitly non-escaping
        return self.lazy.filter({ !predicate($0) }).isEmpty
    }
}
```

We could fix this by annotating the parameter with `@escaping`, but in this case
we *know* the closure won't escape because the lifetime of the lazy collection
view is bound to the lifetime of the function. Swift provides an escape hatch
for situations like this in the form of the `withoutActuallyEscaping` function.
It allows you to pass a non-escaping closure to a function that expects an
escaping one. This compiles and works correctly:

*/

extension Array {
    func all(matching predicate: (Element) -> Bool) -> Bool {
        return withoutActuallyEscaping(predicate) { escapablePredicate in
            self.lazy.filter { !escapablePredicate($0) }.isEmpty
        }
    }
}
let areAllEven = [1,2,3,4].all { $0 % 2 == 0 }
let areAllOneDigit = [1,2,3,4].all { $0 < 10 }

/*:
Be aware that you're entering unsafe territory by using
`withoutActuallyEscaping`. Allowing the copy of the closure to escape from the
call to `withoutActuallyEscaping` results in undefined behavior.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
