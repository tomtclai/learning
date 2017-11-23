/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Function Pointers

Let's look at a concrete example of a C API that uses pointers. Our goal is to
write a Swift wrapper for the `qsort` sorting function in the C standard
library. The type as it's imported in Swift's Darwin module (or if you're on
Linux, Glibc) is given below:

*/

// --- (Hidden code block) ---
import Darwin
// ---------------------------
/*:
``` swift-example
public func qsort(
    _ __base: UnsafeMutableRawPointer!,
    _ __nel: Int,
    _ __width: Int,
    _ __compar: @escaping @convention(c) (UnsafeRawPointer?, 
        UnsafeRawPointer?)
    -> Int32)
```

The man page (`man qsort`) describes how to use the `qsort` function:

> The `qsort()` and `heapsort()` functions sort an array of `nel` objects, the
> initial member of which is pointed to by `base`. The size of each object is
> specified by `width`.
> 
> The contents of the array `base` are sorted in ascending order according to a
> comparison function pointed to by `compar`, which requires two arguments
> pointing to the objects being compared.

And here's a wrapper function that uses `qsort` to sort an array of Swift
strings:

*/

func qsortStrings(array: inout [String]) {
    qsort(&array, array.count, MemoryLayout<String>.stride) { a, b in
        let l = a!.assumingMemoryBound(to: String.self).pointee
        let r = b!.assumingMemoryBound(to: String.self).pointee
        if r > l { return -1 }
        else if r == l { return 0 }
        else { return 1 }
    }
}

/*:
Let's look at each of the arguments being passed to `qsort`:

  - The first argument is a pointer to the base of the array. Swift arrays
    automatically convert to C-style base pointers when you pass them into a
    function that takes an `UnsafePointer`. We have to use the `&` prefix
    because it's an `UnsafeMutableRawPointer` (a `void *base` in the C
    declaration). If the function didn't need to mutate its input and were
    declared in C as `const void *base`, the ampersand wouldn't be needed. This
    matches the difference with `inout` arguments in Swift functions.

  - Second, we have to provide the number of elements. This one is easy; we can
    use the count property of the array.

  - Third, to get the width of each element, we use `MemoryLayout.stride`, *not*
    `MemoryLayout.size`. In Swift, `MemoryLayout.size` returns the true size of
    a type, but when locating elements in memory, platform alignment rules may
    lead to gaps between adjacent elements. The stride is the size of the type,
    plus some padding (which may be zero) to account for this gap. For strings,
    size and stride are currently the same on Apple's platforms, but this won't
    be the case for all types — for example, `MemoryLayout<(Int32, Bool)>.size`
    is `5` and `MemoryLayout<(Int32, Bool)>.stride` is `8`. When translating
    code from C to Swift, you probably want to write `MemoryLayout.stride` in
    cases where you would've used `sizeof` in C.

  - The last parameter is a pointer to a C function that's used to compare two
    elements from the array. Swift automatically bridges a Swift function type
    to a C function pointer, so we can pass any function that has a matching
    signature. However, there's one big caveat: C function pointers are just
    pointers; they can't capture any values. For that reason, the compiler will
    only allow you to provide functions that don't capture any external state
    (for example, no local variables and no generics). It signifies this with
    the `@convention(c)` attribute.

*/


/*:
The `compar` function accepts two raw pointers. Such an `UnsafeRawPointer` can
be a pointer to anything. The reason we have to deal with `UnsafeRawPointer`
(and not `UnsafePointer<String>`) is because C doesn't have generics. However,
we know that we get passed in a `String`, so we can interpret it as a pointer to
a `String`. We also know the pointers are never `nil` here, so we can safely
force-unwrap them. Finally, the function needs to return an `Int32`: a positive
number if the first element is greater than the second, zero if they're equal,
and a negative number if the first is less than the second.

### Making It Generic

It's easy enough to create another wrapper that works for a different type of
elements; we can copy and paste the code and change `String` to a different type
and we're done. But we should really make the code generic. This is where we hit
the limit of C function pointers. The code below fails to compile because it
captures things from outside the closure. More specifically, it captures the
comparison and equality operators, which are different for each generic
parameter. There's nothing we can do about this — we simply encountered an
inherent limitation of C:

``` swift-example
extension Array where Element: Comparable {
    mutating func quicksort() {
        // Error: a C function pointer cannot be formed 
        // from a closure that captures generic parameters
        qsort(&self, self.count, MemoryLayout<Element>.stride) { a, b in
            let l = a!.assumingMemoryBound(to: Element.self).pointee
            let r = b!.assumingMemoryBound(to: Element.self).pointee
            if r > l { return -1 }
            else if r == l { return 0 }
            else { return 1 }
        }
    }
}
```

> One way to think about this limitation is by thinking like the compiler. A C
> function pointer is just an address in memory that points to a block of code.
> For functions that don't have any context, this address will be static and
> known at compile time. However, in case of a generic function, an extra
> parameter (the generic type) is passed in. Therefore, there are no addresses
> for specialized generic functions. This is the same for closures. Even if the
> compiler could rewrite a closure in such a way that it'd be possible to pass
> it as a function pointer, the memory management couldn't be done automatically
> — there's no way to know when to release the closure.

In practice, this is a problem for many C programmers as well. On macOS, there's
a variant of `qsort` called `qsort_b`, which takes a block — a closure — instead
of a function pointer as the last parameter. If we replace `qsort` with
`qsort_b` in the code above, it'll compile and run fine.

However, `qsort_b` isn't available on most platforms since [blocks aren't part
of the C
standard](https://en.wikipedia.org/wiki/Blocks_%28C_language_extension%29). And
other functions aside from `qsort` might not have a block-based variant either.
Most C APIs that work with callbacks offer a different solution. They take an
extra `UnsafeRawPointer` as a parameter and pass that pointer on to the callback
function. The user of the API can then use this to pass an arbitrary piece of
data to each invocation of the callback function. `qsort` also has a variant,
`qsort_r`, which does exactly this. Its type signature includes an extra
parameter, `thunk`, which is an `UnsafeRawPointer`. Note that this parameter has
also been added to the type of the comparison function pointer because `qsort_r`
passes the value to that function on every invocation:

    public func qsort_r(
        _ __base: UnsafeMutableRawPointer!,
        _ __nel: Int,
        _ __width: Int,
        _ __thunk: UnsafeMutableRawPointer!,
        _ __compar: @escaping @convention(c) 
        (UnsafeMutableRawPointer?, UnsafeRawPointer?, UnsafeRawPointer?) 
            -> Int32
    )

If `qsort_b` isn't available on our platform, we can reconstruct it in Swift
using `qsort_r`. We can pass anything we want as the `thunk` parameter, as long
as we cast it to an `UnsafeRawPointer`. In our case, we want to pass the
comparison closure. We can automatically create an `UnsafeRawPointer` out of a
variable defined with `var` by using an in-out expression. So all we need to do
is store the comparison closure that's passed as an argument to our `qsort_b`
variant in a variable named `thunk`. Then we can pass the reference to the
`thunk` variable into `qsort_r`. Inside the callback, we cast the void pointer
back to its real type, `Block`, and then simply call the closure:

*/

typealias Block = (UnsafeRawPointer?, UnsafeRawPointer?) -> Int32
func qsort_block(_ array: UnsafeMutableRawPointer, _ count: Int,
                 _ width: Int, f: @escaping Block)
{
    var thunk = f
    qsort_r(array, count, width, &thunk) { (ctx, p1, p2) -> Int32 in
        let comp = ctx!.assumingMemoryBound(to: Block.self).pointee
        return comp(p1, p2)
    }
}

/*:
Using `qsort_block`, we can redefine our `qsortWrapper` function and provide a
nice generic interface to the `qsort` algorithm that's in the C standard
library:

*/

extension Array where Element: Comparable {
    mutating func quicksort() {
        qsort_block(&self, self.count, MemoryLayout<Element>.stride) { a, b in
            let l = a!.assumingMemoryBound(to: Element.self).pointee
            let r = b!.assumingMemoryBound(to: Element.self).pointee
            if r > l { return -1 }
            else if r == l { return 0 }
            else { return 1 }
        }
    }
}

var x = [3,1,2]
x.quicksort()
x


/*:
It might seem like a lot of work to use a sorting algorithm from the C standard
library. After all, Swift's built-in `sort` function is much easier to use, and
it's faster in most cases. However, there are many other interesting C APIs out
there that we can wrap with a type-safe and generic interface using the same
technique.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
