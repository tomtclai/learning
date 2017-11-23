/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Functors

Thus far, we've seen a couple of methods named `map`, with the following types:

``` swift-example
extension Array {
    func map<R>(transform: (Element) -> R) -> [R]
}
extension Optional {
    func map<R>(transform: (Wrapped) -> R) -> R?
}

extension Parser {
    func map<T>(_ transform: @escaping (Result) -> T) -> Parser<T> 
}
```

Why have three such different functions with the same name? To answer that
question, let's investigate how these functions are related. To begin with, it
helps to expand some of the shorthand notation Swift uses. Optional types, such
as `Int?`, can also be written out explicitly as `Optional<Int>` in the same way
we can write `Array<T>` rather than `[T]`. If we now state the types of the
`map` function on arrays and optionals, the similarity becomes more apparent:

``` swift-example
extension Array {
    func map<R>(transform: (Element) -> R) -> Array<R>
}
extension Optional {
    func map<R>(transform: (Wrapped) -> R) -> Optional<R>
}

extension Parser {
    func map<T>(_ transform: @escaping (Result) -> T) -> Parser<T> 
}

```

Both `Optional` and `Array` are *type constructors* that expect a generic type
argument. For instance, `Array<T>` and `Optional<Int>` are valid types, but
`Array` by itself is not. Both of these `map` functions take two arguments: the
structure being mapped, and a function `transform` of type `(T) -> U`. The `map`
functions use a function argument to transform all the values of type `T` to
values of type `U` in the argument array or optional. Type constructors — such
as optionals or arrays — that support a `map` operation are sometimes referred
to as *functors*.

In fact, there are many other types we've defined that are indeed functors. For
example, we can implement a `map` function on the `Result` type from Chapter 8:

``` swift-example
extension Result {
    func map<U>(f: (T) -> U) -> Result<U> {
        switch self {
        case let .success(value): return .success(f(value))
        case let .error(error): return .error(error)
        }
    }
}
```

Similarly, the types we've seen for binary search trees, tries, and parser
combinators are all functors. Functors are sometimes described as 'containers'
storing values of some type. The `map` functions transform the stored values
stored in a container. This can be a useful intuition, but it can be too
restrictive. Remember the `Region` type we saw in Chapter 2?

*/

struct Position {
    var x: Double
    var y: Double
}

/*:
``` swift-example
typealias Region = (Position) -> Bool
```

Using this definition of regions, we can only generate black and white bitmaps.
We can generalize this to abstract over the kind of information we associate
with every position:

*/

struct Region<T> {
    let value: (Position) -> T
}

/*:
Using this definition, we can associate booleans, RGB values, or any other
information with every position. We can also define a `map` function on these
generic regions. Essentially, this definition boils down to function
composition:

*/

extension Region {
    func map<U>(transform: @escaping (T) -> U) -> Region<U> {
        return Region<U> { pos in transform(self.value(pos)) }
    }
}

/*:
Such regions are a good example of a functor that doesn't fit well with the
intuition of functors being containers. Here, we've represented regions as
*functions*, which seem very different from containers.

Almost every generic enumeration you can define in Swift will be a functor.
Providing a `map` function gives fellow developers a powerful yet familiar
function for working with such enumerations.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
